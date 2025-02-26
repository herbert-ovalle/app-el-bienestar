import 'dart:convert';

class Respuesta {
  final String respuesta;
  final String mensaje;
  final String titulo;
  final List<dynamic>? datos;
  final String detalleError;
  final String? token;

  Respuesta(
  {
    required this.respuesta,
    required this.mensaje,
    this.titulo = '',
    this.datos,
    this.detalleError = '',
    this.token = '', 
  });

  factory Respuesta.fromRawJson(String str) =>
      Respuesta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Respuesta.fromJson(Map<String, dynamic> json) => Respuesta(
        respuesta: json["respuesta"],
        mensaje: json["mensaje"],
        titulo: json["titulo"] ?? "",
        datos:  json["datos"] == null ? [] : List<dynamic>.from(json["datos"].map((x) => x)),
        detalleError: json["detalleError"] ?? "",
        token: json["token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "respuesta": respuesta,
        "mensaje": mensaje,
        "titulo": titulo,
        "datos": datos == null ? [] : List<dynamic>.from(datos!.map((x) => x)),
        "detalleError": detalleError,
        "token": token
      };
}
