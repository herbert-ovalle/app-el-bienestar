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
