import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

bool isTokenExpired(String token) {
  try {
    // 🔹 Decodificar el token sin verificar la firma
    final jwt = JWT.decode(token);

    // 🔹 Obtener el tiempo de expiración (`exp`)
    final exp = jwt.payload['exp']; // 🔹 `exp` está en **segundos UNIX**

    if (exp == null) {
      return true; // ✅ Si no hay `exp`, consideramos que está expirado
    }

    // 🔹 Convertir a `DateTime`
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final now = DateTime.now();

    return now.isAfter(expiryDate); // ✅ Retorna `true` si el token ya expiró
  } catch (e) {
    return true; // ❌ Si hay un error, el token no es válido
  }
}
