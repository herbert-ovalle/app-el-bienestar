import 'package:app_bienestar/component/spiner-asincrono.component.dart';
import 'package:app_bienestar/component/token_verificar.component.dart';
import 'package:app_bienestar/models/z_model.dart';
import 'package:app_bienestar/providers/guardar_usuario.dart';
import 'package:app_bienestar/screen/productosaso.screen.dart';
import 'package:app_bienestar/services/servilocal.services.dart';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class BankLoginScreen extends StatefulWidget {
  const BankLoginScreen({super.key});

  @override
  State<BankLoginScreen> createState() => _BankLoginScreenState();
}

class _BankLoginScreenState extends State<BankLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final LocalAuthentication auth = LocalAuthentication();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String _message = "Coloca tu dedo en el sensor";
  late String token;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: "Escanea tu huella para acceder",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated && !isTokenExpired(token)) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => InformacionAsociado(),
          ),
        );
      }else{
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ingrese su usuario y contraseña")),
        );
        
      }

    } catch (e) {
      setState(() {
        _message = "Error en autenticación: $e";
      });
      return;
    }

    setState(() {
      _message =
          authenticated ? "✅ Autenticación exitosa" : "❌ Autenticación fallida";
    });

    if (authenticated) {
      _animationController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    double higth = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 71, 71, 71),
      ),
      // ignore: deprecated_member_use
      backgroundColor: const Color.fromARGB(255, 71, 71, 71),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children = [Text("Bienvenidos")];
          if (snapshot.hasData) {
            token = snapshot.data!;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: 24, left: 24, top: (higth * 0.10)),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/LOGO_BLANCO.png"),
                          const SizedBox(height: 40),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Campo Usuario
                                TextFormField(
                                  controller: _userController,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration(
                                      "Usuario CUI", Icons.account_circle),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Ingrese su DPI";
                                    }
                                    if (value.length < 13) {
                                      return "El campo CUI es obligatorio con 13 digitos";
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                        mask: '#### ##### ####',
                                        type: MaskAutoCompletionType.lazy)
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Campo Contraseña
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  style: const TextStyle(color: Colors.white),
                                  decoration:
                                      _inputDecoration("Contraseña", Icons.lock)
                                          .copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Ingrese su contraseña";
                                    }
                                    if (value.length < 6) {
                                      return "La contraseña debe tener al menos 6 caracteres";
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 20),

                                // Botón de Login
                                AsyncButtonBuilder(
                                    onPressed: _login,
                                    builder: (context, child, callback,
                                        buttonState) {
                                      final buttonColor = buttonState.when(
                                        idle: () => Colors.greenAccent[700],
                                        loading: () => Colors.grey,
                                        success: () => Colors.green,
                                        error: (err, stack) => Colors.orange,
                                      );

                                      return ElevatedButton(
                                        onPressed: callback,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: buttonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 100, vertical: 16),
                                        ),
                                        child: const Text(
                                          "Ingresar",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      );
                                    },
                                    child: Text("consultar")),

                                const SizedBox(height: 16),

                                // "Olvidaste tu contraseña?"
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Función de recuperación no implementada")),
                                    );
                                  },
                                  child: const Text(
                                    "¿Olvidaste tu contraseña?",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),

                                if (token.isNotEmpty)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // 🔹 Icono de huella con animación
                                      GestureDetector(
                                        onTap: _authenticate,
                                        child: ScaleTransition(
                                          scale: _scaleAnimation,
                                          child: const Icon(
                                            Icons.fingerprint,
                                            size: 100,
                                            color: Colors.lightBlueAccent,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      Text(
                                        _message,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                  width: 60, height: 60, child: CircularProgressIndicator()),
              Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...')),
            ];
          }
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children),
          );
        },
        future: SaveLocal().get("token"),
      ),
    );
  }

  // Estilo de los campos de entrada
  InputDecoration _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      // ignore: deprecated_member_use
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  // Función de Login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final datosLogin = LoginModel.fromJson({
        "usuario": _userController.text,
        "contrasena": _passwordController.text
      });
      Respuesta res;
      token = await SaveLocal().get("token");
      if (token.isNotEmpty && !isTokenExpired(token)) {
        String user = await SaveLocal().get("user");
        String contra = await SaveLocal().get("contra");
        if (user == _userController.text &&
            contra == _passwordController.text) {
          res = Respuesta(respuesta: "success", mensaje: "Login local");
        } else {
          res = Respuesta(respuesta: "warning", mensaje: "Usuario o contraseña incorrecta, verifique");
        }
      } else {
        res = await showLoadingDialog(
            // ignore: use_build_context_synchronously
            context,
            UsuarioAsociadoN().loginAsociado(datosLogin));
      }

      if (res.respuesta == "success") {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => InformacionAsociado()),
        );
      }

      // ignore: use_build_context_synchronously
      FocusScope.of(context).unfocus();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.mensaje)),
      );
    }
  }
}
