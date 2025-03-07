import 'dart:convert';

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

  RequisitosProducto({
    required this.datos,
    required this.titulo,
  });

  factory RequisitosProducto.fromRawJson(String str) =>
      RequisitosProducto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequisitosProducto.fromJson(Map<String, dynamic> json) =>
      RequisitosProducto(
        datos: List<String>.from(json["datos"].map((x) => x)),
        titulo: json["titulo"],
      );

  Map<String, dynamic> toJson() => {
        "datos": List<dynamic>.from(datos.map((x) => x)),
        "titulo": titulo,
      };
}
