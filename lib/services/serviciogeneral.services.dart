import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:intl/intl.dart';

String encriptarContrasena(String valor) {
  var key = utf8.encode('p@ssw0rd_anhs');
  var bytes = utf8.encode(valor);

  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  return hmacSha256.convert(bytes).toString();
}

bool isTokenExpired(String token) {
  try {
    final jwt = JWT.decode(token);

    final exp = jwt.payload['exp']; // 🔹 `exp` está en **segundos UNIX**

    if (exp == null) {
      return true;
    }

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final now = DateTime.now();

    return now.isAfter(expiryDate); // ✅ Retorna `true` si el token ya expiró
  } catch (e) {
    return true; // ❌ Si hay un error, el token no es válido
  }
}

Map<String, dynamic> decodeToken(String token) {
  try {
    final jwt = JWT.decode(token);
    return jwt.payload;
  } catch (e) {
    return {};
  }
}

String formatoMoneda(double cantidad) {

  try {
    final formato = NumberFormat.currency(symbol: 'Q ');
    return formato.format(cantidad);
  } catch (e) {
    return "0.00";
  }
}

int valEntero(tel) {
  if (tel.runtimeType == int) {
    return tel;
  } else {
    return int.parse(tel.replaceAll(" ", ""));
  }
}
