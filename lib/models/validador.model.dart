import 'dart:convert';

class Validar {
  final String? type;
  final int maxLength;
  final int minLength;
  final int max;
  final int min;

  Validar({
    this.type,
    this.maxLength = 10,
    this.minLength = 1,
    this.max = 5,
    this.min = 1,
  });

  factory Validar.fromRawJson(String str) => Validar.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Validar.fromJson(Map<String, dynamic> json) => Validar(
        type: json["type"],
        maxLength: json["maxLength"],
        minLength: json["minLength"],
        max: json["max"],
        min: json["min"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "maxLength": maxLength,
        "minLength": minLength,
        "max": max,
        "min": min,
      };
}
