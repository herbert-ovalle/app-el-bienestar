import 'package:app_bienestar/models/z_model.dart';
import 'package:app_bienestar/services/qExterno.service.dart';
import 'package:app_bienestar/services/servilocal.services.dart';
import 'package:flutter/material.dart';

class UsuarioAsociadoN extends ChangeNotifier {
  final peticion = PeticionesExternas();

  Future<Respuesta> guardarAsociado(Map<String,dynamic> datos) async {
    Respuesta res = await peticion.query(url: "crearUsuario", body: datos);
    return res;
  }

  Future<Respuesta> loginAsociado(LoginModel datos) async {
    Respuesta res = await peticion.query(url: "loginAso", body: datos.toJson());
    if(res.respuesta == "success"){
      await SaveLocal().save("token", res.token ?? "");
      await SaveLocal().save("user", datos.usuario);
      await SaveLocal().save("contra", datos.contrasena);
    }
    return res;
  }
}
