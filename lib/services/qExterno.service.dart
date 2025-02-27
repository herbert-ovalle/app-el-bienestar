import 'dart:convert';

import 'package:app_bienestar/class/enviroment.dart';
import 'package:app_bienestar/models/generales.model.dart';
import 'package:app_bienestar/services/servilocal.services.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

class PeticionesExternas extends EnvitomentsQuery {
  final serviLocal = SaveLocal();
  Future<String> postTasaCambio() async {
    String tasaCam = await serviLocal.get("tasaC");
    if (tasaCam.isNotEmpty) {
      final gTasa = TasaCambioM.fromRawJson(tasaCam);

      if (compararFechas(DateTime.parse(gTasa.fecha),DateTime.now())) {
        return actualizarTasaCam();
      } else {
        return gTasa.tasaCambio;
      }
    } else {
      return actualizarTasaCam();
    }
  }

  Future<String> actualizarTasaCam() async {
    var client = http.Client();
    final headers = {
      'Content-Type': 'application/soap+xml; charset=utf-8',
    };

    final body = '''<?xml version="1.0" encoding="utf-8"?>
      <soap12:Envelope  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                        xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
                        xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <TipoCambioDiaString xmlns="http://www.banguat.gob.gt/variables/ws/" />
        </soap12:Body>
      </soap12:Envelope>
      ''';

    try {
      var response = await client.post(
          Uri.https(rutaTasaCambioB, rutaTasaCambioR),
          headers: headers,
          body: utf8.encode(body));

      if (response.statusCode == 200) {
        try {
          final xml2json = Xml2Json();
          xml2json.parse(response.body);
          Map<String, dynamic> jsonData = jsonDecode(xml2json.toOpenRally());
          final resJson = jsonData['Envelope']['Body']
              ['TipoCambioDiaStringResponse']['TipoCambioDiaStringResult'];

          String decodedXml = HtmlUnescape().convert(resJson);

          decodedXml = decodedXml.replaceAll(r"\r\\n", "").trim();

          final document = XmlDocument.parse(decodedXml);

          final referenciaElement =
              document.findAllElements('referencia').first;
          // ignore: deprecated_member_use
          String referencia = referenciaElement.text;
          double numero = double.parse(referencia);
          Map<String, dynamic> resTasa = {
            "fecha": DateTime.now().toString(),
            "tasaCambio": numero.toStringAsFixed(2).toString()
          };

          await serviLocal.save("tasaC", jsonEncode(resTasa));

          return numero.toStringAsFixed(2);
        } catch (e) {
          return "0.00";
        }
      } else {
        return "0.00";
      }
    } finally {
      client.close();
    }
  }

  int validarTiempoTranscurrido(String fechaGuardada) {
    DateTime fechaEvento =
        DateTime.parse(fechaGuardada); // Convertir String a DateTime
    Duration diferencia =
        DateTime.now().difference(fechaEvento); // Calcular diferencia

    return diferencia.inDays;
  }

  bool compararFechas(DateTime fecha1, DateTime fecha2) {

    DateTime soloFecha1 = DateTime(fecha1.year, fecha1.month, fecha1.day);
    DateTime soloFecha2 = DateTime(fecha2.year, fecha2.month, fecha2.day);

    return soloFecha1.isBefore(soloFecha2);
  }

}
