import 'dart:convert';
import 'package:app_bienestar/services/z_service.dart';

class RegistroUsuario {
  final String nombres;
  final String? correo;
  final int dpi;
  final int telefono;
  final String? direccion;
  final String? usuario;
  final String contrasena;

  RegistroUsuario({
    required this.nombres,
    this.correo,
    required this.dpi,
    required this.telefono,
    this.direccion,
    this.usuario,
    required this.contrasena,
  });

  factory RegistroUsuario.fromRawJson(String str) =>
      RegistroUsuario.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegistroUsuario.fromJson(Map<String, dynamic> json) =>
      RegistroUsuario(
        nombres: json["nombres"],
        correo: json["correo"] ?? "",
        dpi: valEntero(json["dpi"]),
        telefono: valEntero(json["telefono"]),
        direccion: json["direccion"] ?? "",
        usuario: json["usuario"] ?? json["dpi"].replaceAll(" ", ""),
        contrasena: encriptarContrasena(json["contrasena"] ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "nombres": nombres,
        "correo": correo,
        "dpi": dpi,
        "telefono": telefono,
        "direccion": direccion,
        "usuario": usuario,
        "contrasena": contrasena,
      };
}


class LoginModel {
  final String usuario;
  final String contrasena;

  LoginModel({
    required this.usuario,
    required this.contrasena,
  });

  factory LoginModel.fromRawJson(String str) =>
      LoginModel.fromJson(json.decode(str));

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        usuario: json["usuario"].replaceAll(" ", ""),
        contrasena: encriptarContrasena(json["contrasena"]),
      );

  Map<String, dynamic> toJson() => {
        "usuario": usuario,
        "contrasena": contrasena,
      };
}
