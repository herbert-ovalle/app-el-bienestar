import 'package:app_bienestar/component/formgeneral.component.dart';
import 'package:app_bienestar/component/spiner-asincrono.component.dart';
import 'package:app_bienestar/models/z_model.dart';
import 'package:app_bienestar/providers/guardar_usuario.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cuiController = TextEditingController();
  final FocusNode _cuiFocus = FocusNode();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final datosCambioC = LoginModel.fromJson({
        "usuario": _cuiController.text,
        "contrasena": _confirmPasswordController.text
      });
      final res = await showLoadingDialog(context, UsuarioAsociadoN().cambioContrasena(datosCambioC));

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.mensaje)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cambiar Contraseña")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputForm(
                  name: "cui",
                  controller: _cuiController,
                  focusNode: _cuiFocus,
                  label: "DPI",
                  hint: "Ingrese su CUI",
                  keyboardType: TextInputType.number,
                  campoObli: true,
                  autoFocus: true,
                  formatters: [
                    MaskTextInputFormatter(
                        mask: '#### ##### ####',
                        type: MaskAutoCompletionType.lazy)
                  ],
                  validar: Validar(maxLength: 15, minLength: 15)),
              SizedBox(height: 16),
              _buildPasswordField(
                controller: _newPasswordController,
                label: "Nueva Contraseña",
                obscureText: _obscureNewPassword,
                toggleObscure: () {
                  setState(() => _obscureNewPassword = !_obscureNewPassword);
                },
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "La nueva contraseña debe tener al menos 6 caracteres";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: "Confirmar Nueva Contraseña",
                obscureText: _obscureConfirmPassword,
                toggleObscure: () {
                  setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword);
                },
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return "Las contraseñas no coinciden";
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _changePassword,
                  child: Text("Guardar Cambios"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggleObscure,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleObscure,
        ),
      ),
      validator: validator,
    );
  }
}
