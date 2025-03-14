import 'dart:convert';

class CargarInfoPre {
  final String nombres;
  final String telefono;
  final String correoElectronico;
  final String dpi;
  final bool esAsociado;

  CargarInfoPre({
    required this.nombres,
    required this.telefono,
    required this.correoElectronico,
    required this.dpi,
    required this.esAsociado
  });

  factory CargarInfoPre.fromRawJson(String str) =>
      CargarInfoPre.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CargarInfoPre.fromJson(Map<String, dynamic> json) => CargarInfoPre(
        nombres: json["nombres"] ?? "",
        telefono: json["telefono"] ?? "",
        correoElectronico: json["correoElectronico"] ?? "",
        dpi: json["dpi"] ?? "",
        esAsociado: json["esAsociado"] ?? true
      );

  Map<String, dynamic> toJson() => {
        "nombres": nombres,
        "telefono": telefono,
        "correoElectronico": correoElectronico,
        "dpi": dpi,
        "esAsociado":esAsociado
      };
}
