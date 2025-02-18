import 'dart:convert';

class TasaCambioM {
  final String fecha;
  final String tasaCambio;

  TasaCambioM({
    required this.fecha,
    required this.tasaCambio,
  });

  factory TasaCambioM.fromRawJson(String str) =>
      TasaCambioM.fromJson(json.decode(str));

  factory TasaCambioM.fromJson(Map<String, dynamic> json) => TasaCambioM(
        fecha: json["fecha"],
        tasaCambio: json["tasaCambio"],
      );
}
