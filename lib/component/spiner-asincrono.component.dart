import 'package:app_bienestar/models/respuesta.model.dart';
import 'package:flutter/material.dart';

Future<Respuesta> showLoadingDialog(BuildContext context, Future future, {bool guardarForm = true}) async {
  Respuesta resultado =
      Respuesta(respuesta: "info", mensaje: "Información verifique");

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor:
              Colors.transparent, // ✅ Fondo del diálogo transparente
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/LOGO_BLANCO.png"),
              SizedBox(height: 10),
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white, // ✅ Spinner visible en modo oscuro
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Cargando...",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      );
    },
  );

  Future<Respuesta> manejarFutureAsync(BuildContext context) async {
    try {
      resultado = await future;
    } catch (error) {
      resultado = Respuesta(respuesta: "error", mensaje: error.toString());
    } finally {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
    return resultado;
  }

  return await manejarFutureAsync(context);

}
