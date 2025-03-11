
import 'package:app_bienestar/models/z_model.dart';
import 'package:app_bienestar/services/z_service.dart';

import 'package:flutter/material.dart';

class UsuarioAsociadoN extends ChangeNotifier {
  final peticion = PeticionesExternas();

  Future<Respuesta> guardarAsociado(Map<String, dynamic> datos) async {
    Respuesta res = await peticion.query(url: "crearUsuario", body: datos);
    return res;
  }

  Future<Respuesta> loginAsociado(LoginModel datos) async {
    Respuesta res = await peticion.query(url: "loginAso", body: datos.toJson());
    if (res.respuesta == "success") {
      await SaveLocal().save("token", res.token ?? "");
      await SaveLocal().save("user", datos.usuario);
      await SaveLocal().save("contra", datos.contrasena);
      await SaveLocal().save("idSession", res.idSession.toString());
    }
    return res;
  }

  Future<Respuesta> datosAsociado() async {
    Respuesta res = await peticion.query(url: "datoUser");
    return res;
  }

  Future<Respuesta> validarDPI(String dpi) async {
    Map<String, dynamic> datosTok = decodeToken(await SaveLocal().get("token"));
    if (datosTok.containsKey('usuario') &&
        datosTok["usuario"] == dpi.replaceAll(" ", "")) {
      return Respuesta(respuesta: "success", mensaje: "");
    }

    Respuesta res = await peticion.query(url: "validaDPI", body: {'dpi': dpi});
    return res;
  }

  Future<Respuesta> guardarSolicitud(RegistroSolicitud solicitud) async {
    Respuesta res =
        await peticion.query(url: "guardarSolicitud", body: solicitud.toJson());
    return res;
  }
}
