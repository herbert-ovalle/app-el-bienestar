import 'package:app_bienestar/models/respuesta.model.dart';
import 'package:app_bienestar/screen/login.screen.dart';
import 'package:app_bienestar/screen/productosaso.screen.dart';
import 'package:app_bienestar/services/z_service.dart';
import 'package:flutter/material.dart';

String errorPeticion = "";
void mostrarDialogoOTP(BuildContext context,
    {required String usuario,
    String mensaje = "Ingrese el código de acceso enviado a su teléfono",
    bool otpSession = true}) {
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  errorPeticion = "";
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return PopScope(
            canPop: !isLoading,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/LOGO_BLANCO.png", height: 80),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      mensaje,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        counterText: "",
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      errorPeticion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (!isLoading) {
                                    await SaveLocal().deleteAll();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(dialogContext);
                                  }
                                },
                                child: Text("Cancelar",
                                    style: TextStyle(color: Colors.red)),
                              ),
                              ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        setState(() => isLoading = true);
                                        if (otpSession) {
                                          final idSession = await SaveLocal()
                                              .get("idSession");
                                          if (idSession.isEmpty) {
                                            setState(() => isLoading = false);
                                            errorPeticion =
                                                "No tienes session ve al login";
                                            return;
                                          }
                                          bool otpValido = await validarOTP(
                                              otpController.text.trim(),
                                              int.parse(idSession),
                                              usuario);

                                          if (otpValido) {
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(dialogContext);

                                            Navigator.push(
                                              // ignore: use_build_context_synchronously
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      InformacionAsociado(
                                                          usuario: usuario)),
                                            );
                                            await ReproductorMusic()
                                                .showBankSnackBar(
                                                    "✅ Bienvenido a la aplicación móvil");
                                          } else {
                                            setState(() => isLoading = false);
                                          }
                                        } else {
                                          bool otpValido = await validarOtpUser(
                                              otpController.text.trim(),
                                              usuario);

                                          if (otpValido) {
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(dialogContext);

                                            Navigator.push(
                                              // ignore: use_build_context_synchronously
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BankLoginScreen(
                                                          dpiI: usuario)),
                                            );
                                          } else {
                                            setState(() => isLoading = false);
                                          }
                                        }
                                      },
                                child: Text("Validar código"),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<bool> validarOTP(String otp, int idSession, String dpi) async {
  if (otp.isEmpty || otp.length != 6) return false;

  Respuesta res = await PeticionesExternas().query(
      url: "validarOtp",
      body: {'otp': otp, 'idSession': idSession, 'usuario': dpi});

  if (res.respuesta == 'success') {
    return true;
  } else {
    errorPeticion = res.mensaje;
  }

  return false;
}

Future<bool> validarOtpUser(String otp, String dpi) async {
  if (otp.isEmpty || otp.length != 6) return false;

  Respuesta res = await PeticionesExternas()
      .query(url: "validarOtpUser", body: {'codigoOtp': otp, 'usuario': dpi});

  if (res.respuesta == 'success') {
    return true;
  } else {
    errorPeticion = res.mensaje;
  }
  return false;
}
