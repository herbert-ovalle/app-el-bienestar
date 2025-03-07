import 'dart:convert';

class RegistroSolicitud {
  final int idSubProducto;
  final int telefono;
  final int cui;
  final String comentario;
  final String montoSolicitado;

  RegistroSolicitud({
    required this.idSubProducto,
    required this.telefono,
    required this.cui,
    required this.comentario,
    required this.montoSolicitado,
  });

  factory RegistroSolicitud.fromRawJson(String str) =>
      RegistroSolicitud.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegistroSolicitud.fromJson(Map<String, dynamic> json) =>
      RegistroSolicitud(
        idSubProducto: json["idSubProducto"],
        telefono: json["telefono"],
        cui: json["cui"],
        comentario: json["comentario"],
        montoSolicitado: json["montoSolicitado"],
      );

  Map<String, dynamic> toJson() => {
        "idSubProducto": idSubProducto,
        "telefono": telefono,
        "cui": cui,
        "comentario": comentario,
        "montoSolicitado": montoSolicitado,
      };
}
