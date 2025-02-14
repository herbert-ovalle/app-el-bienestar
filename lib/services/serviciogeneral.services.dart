import 'dart:convert';
import 'package:crypto/crypto.dart';


String encriptarContrasena(String valor){
  var key = utf8.encode('p@ssw0rd_anhs');
  var bytes = utf8.encode(valor);

  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  return hmacSha256.convert(bytes).toString();
}