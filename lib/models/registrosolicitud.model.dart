import 'dart:convert';
import 'package:app_bienestar/services/serviciogeneral.services.dart';

class RegistroSolicitud {
  final int idSubProducto;
  final int telefono;
  final int cui;
  final OtrosDatos otrosDatos;

  RegistroSolicitud({
    required this.idSubProducto,
    required this.telefono,
    required this.cui,
    required this.otrosDatos,
  });

  factory RegistroSolicitud.fromRawJson(String str) =>
      RegistroSolicitud.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegistroSolicitud.fromJson(Map<String, dynamic> json) =>
      RegistroSolicitud(
        idSubProducto: valEntero(json["idSubProducto"]),
        telefono: valEntero(json["telefono"]),
        cui: valEntero(json["cui"]),
        otrosDatos: OtrosDatos.fromJson(json),
      );

  Map<String, dynamic> toJson() => {
        "idSubProducto": idSubProducto,
        "telefono": telefono,
        "cui": cui,
        "otrosDatos": otrosDatos.toJson(),
      };
}

class OtrosDatos {
  final String comentarioAso;
  final String montoSolicitado;
  final String comentarioRes;

  OtrosDatos({
    required this.comentarioAso,
    required this.montoSolicitado,
    required this.comentarioRes,
  });

  factory OtrosDatos.fromRawJson(String str) =>
      OtrosDatos.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OtrosDatos.fromJson(Map<String, dynamic> json) => OtrosDatos(
        comentarioAso: json["comentarioAso"] ?? "",
        montoSolicitado: json["montoSolicitado"] ?? "0",
        comentarioRes: json["comentarioRes"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "comentarioAso": comentarioAso,
        "montoSolicitado": montoSolicitado,
        "comentarioRes": comentarioRes,
      };
}
