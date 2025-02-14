import 'dart:convert';

import 'package:app_bienestar/class/enviroment.dart';
import 'package:http/http.dart' as http;

class PeticionesExternas extends EnvitomentsQuery {
  Future<void> postTasaCambio() async {
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
          print('Respuesta: ${response.body}');
        } else {
          print('Error ${response.statusCode}: ${response.body}');
        }
    } finally {
      client.close();
    }
  }
}
