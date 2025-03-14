import 'dart:convert';
import 'package:app_bienestar/component/z_component.dart';
import 'package:app_bienestar/models/z_model.dart';
import 'package:app_bienestar/providers/guardar_usuario.dart';
import 'package:app_bienestar/providers/registro_user.dart';
import 'package:app_bienestar/screen/login.screen.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

Future<void> validarCUIngresado(BuildContext context, value) async {
  final datUserPro = Provider.of<DatosUsuarioProvider>(context, listen: false);
  final rsdpi =
      await showLoadingDialog(context, UsuarioAsociadoN().validarDPI(value));
      
  if (rsdpi.respuesta == "success") {
    final datosAsociado = CargarInfoPre.fromJson(rsdpi.datos![0]);
    datUserPro.lastFunctionCalled = "ninguna";
    if (datosAsociado.dpi.isEmpty) {
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => FormularioComponent(
                    infoIni: CargarInfoPre.fromJson({
                      ...datosAsociado.toJson(),
                      ...{'dpi': value}
                    }),
                  )));
    } else {
      Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => BankLoginScreen(
                    dpiI: value,
                  )));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ya tiene usuario ingrese su contraseña")),
      );
    }
  } else {
    datUserPro.limpiarDatos();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(rsdpi.mensaje)),
    );
  }
}
