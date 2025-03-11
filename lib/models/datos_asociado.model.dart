import 'dart:convert';

import 'package:app_bienestar/services/z_service.dart';

class DatosAsociado {
  final InfoAsociado infoAsociado;
  final List<Captacione> captaciones;
  final List<Captacione> colocaciones;
  final List<SolicitudesRegistra> solicitudes;

  DatosAsociado({
    required this.infoAsociado,
    required this.captaciones,
    required this.colocaciones,
    required this.solicitudes,
  });

  factory DatosAsociado.fromRawJson(String str) =>
      DatosAsociado.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatosAsociado.fromJson(Map<String, dynamic> json) => DatosAsociado(
        infoAsociado: InfoAsociado.fromJson(json["info_asociado"]),
        captaciones: List<Captacione>.from(
            json["captaciones"].map((x) => Captacione.fromJson(x))),
        colocaciones: List<Captacione>.from(
            json["colocaciones"].map((x) => Captacione.fromJson(x))),
        solicitudes: List<SolicitudesRegistra>.from(json["solicitudes"].map((x) => SolicitudesRegistra.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "info_asociado": infoAsociado.toJson(),
        "captaciones": List<dynamic>.from(captaciones.map((x) => x.toJson())),
        "colocaciones": List<dynamic>.from(colocaciones.map((x) => x.toJson())),
        "solicitudes" : List<dynamic>.from(solicitudes.map((x) => x)),
      };
}

class Captacione {
  final String producto;
  final String tipoProducto;
  final int numeroCuenta;
  final double montoDisponible;

  Captacione({
    required this.producto,
    required this.tipoProducto,
    required this.numeroCuenta,
    required this.montoDisponible,
  });

  factory Captacione.fromRawJson(String str) =>
      Captacione.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Captacione.fromJson(Map<String, dynamic> json) => Captacione(
        producto: json["producto"],
        tipoProducto: json["tipoProducto"],
        numeroCuenta: valEntero(json["numeroCuenta"]),
        montoDisponible: json["montoDisponible"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "producto": producto,
        "tipoProducto": tipoProducto,
        "numeroCuenta": numeroCuenta,
        "montoDisponible": montoDisponible,
      };
}

class InfoAsociado {
  final String nombres;
  final String telefono;
  final String correoElectronico;
  final String dpi;

  InfoAsociado({
    required this.nombres,
    required this.telefono,
    required this.correoElectronico,
    required this.dpi,
  });

  factory InfoAsociado.fromRawJson(String str) =>
      InfoAsociado.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InfoAsociado.fromJson(Map<String, dynamic> json) => InfoAsociado(
        nombres: json["nombres"],
        telefono: json["telefono"].toString(),
        correoElectronico: json["correoElectronico"],
        dpi: json["dpi"],
      );

  Map<String, dynamic> toJson() => {
        "nombres": nombres,
        "telefono": telefono,
        "correoElectronico": correoElectronico,
        "dpi": dpi,
      };
}

class SolicitudesRegistra {
  final String producto;
  final String descripcion;
  final String estadoSolicitud;
  final DateTime fechaRegistro;

  SolicitudesRegistra({
    required this.producto,
    required this.descripcion,
    required this.estadoSolicitud,
    required this.fechaRegistro,
  });

  factory SolicitudesRegistra.fromRawJson(String str) =>
      SolicitudesRegistra.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SolicitudesRegistra.fromJson(Map<String, dynamic> json) =>
      SolicitudesRegistra(
        producto: json["producto"],
        descripcion: json["descripcion"],
        estadoSolicitud: json["estadoSolicitud"],
        fechaRegistro: DateTime.parse(json["fechaRegistro"]),
      );

  Map<String, dynamic> toJson() => {
        "producto": producto,
        "descripcion": descripcion,
        "estadoSolicitud": estadoSolicitud,
        "fechaRegistro":
            "${fechaRegistro.year.toString().padLeft(4, '0')}-${fechaRegistro.month.toString().padLeft(2, '0')}-${fechaRegistro.day.toString().padLeft(2, '0')}",
      };
}

