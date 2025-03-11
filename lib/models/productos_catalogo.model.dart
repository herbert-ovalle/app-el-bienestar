import 'dart:convert';

import 'package:flutter/widgets.dart';

class ProductosCatalogo {
  final int idSubProducto;
  final int idProducto;
  final String subProducto;
  final String descripcion;
  final String urlFotografia;
  final dynamic requisitos;

  ProductosCatalogo({
    required this.idSubProducto,
    required this.idProducto,
    required this.subProducto,
    required this.descripcion,
    required this.urlFotografia,
    required this.requisitos,
  });

  factory ProductosCatalogo.fromRawJson(String str) =>
      ProductosCatalogo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductosCatalogo.fromJson(Map<String, dynamic> json) =>
      ProductosCatalogo(
        idSubProducto: json["idSubProducto"],
        idProducto: json["idProducto"],
        subProducto: json["subProducto"],
        descripcion: json["descripcion"],
        urlFotografia: json["urlFotografia"] ?? "",
        requisitos: json["requisitos"],
      );

  Map<String, dynamic> toJson() => {
        "idSubProducto": idSubProducto,
        "idProducto": idProducto,
        "subProducto": subProducto,
        "descripcion": descripcion,
        "urlFotografia": urlFotografia,
        "requisitos": requisitos,
      };
}

class RequisitosProducto {
  final List<String> datos;
  final String titulo;
  final IconData icono;
  final String iconIni;

  RequisitosProducto( {
    required this.datos,
    required this.titulo,
    required this.icono,
    required this.iconIni,
  });

  factory RequisitosProducto.fromRawJson(String str) =>
      RequisitosProducto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequisitosProducto.fromJson(Map<String, dynamic> json) =>
      RequisitosProducto(
        datos: List<String>.from(json["datos"].map((x) => x)),
        titulo: json["titulo"], 
        icono: json["icono"], 
        iconIni: json["iconIni"],
      );

  Map<String, dynamic> toJson() => {
        "datos": List<dynamic>.from(datos.map((x) => x)),
        "titulo": titulo,
        "icono":icono,
        "iconIni":iconIni
      };
}
