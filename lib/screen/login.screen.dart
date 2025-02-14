import 'package:flutter/material.dart';
class BankLoginScreen extends StatefulWidget {
  const BankLoginScreen({super.key});

  @override
  State<BankLoginScreen> createState() => _BankLoginScreenState();
}

class _BankLoginScreenState extends State<BankLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double higth = MediaQuery.of(context).size.height;
     return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromARGB(255, 71, 71, 71),
      ),
      // ignore: deprecated_member_use
      backgroundColor: const Color.fromARGB(255, 71, 71, 71),
      body: Stack(
        children: [

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(right: 24, left: 24, top: (higth * 0.15)),
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
                            return null;
                          },
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
                                  _isPasswordVisible = !_isPasswordVisible;
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
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
                        ),
          
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Estilo de los campos de entrada
  InputDecoration _inputDecoration(String label, IconData icon) {
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
  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inicio de sesión exitoso")),
      );
    }
  }
}
