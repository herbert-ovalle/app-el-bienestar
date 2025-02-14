import 'package:app_bienestar/models/validador.model.dart';
import 'package:app_bienestar/providers/registro_user.dart';
import 'package:app_bienestar/themes/tema_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FormularioComponent extends StatefulWidget {
  const FormularioComponent({super.key});

  @override
  State<FormularioComponent> createState() => _FormularioComponentState();
}

class _FormularioComponentState extends State<FormularioComponent> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dpiController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  final FocusNode _nombreFocus = FocusNode();
  final FocusNode _correoFocus = FocusNode();

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _nombreFocus.dispose();
    _correoFocus.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  void deactivate() {
    FocusScope.of(context).unfocus();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
      
    return Scaffold(
      appBar: AppBar(title: Text("Registro de Datos")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 5.0,
              runSpacing: 5.0,
              children: [
                // Nombre

                InputForm(
                    name: "nombre",
                    controller: _nombreController,
                    label: "Nombre",
                    hint: "Ingrese su nombre completo",
                    focusNode: _nombreFocus,
                    nextFocus: _correoFocus,
                    autoFocus: true,
                    campoObli: true,
                    validar: Validar(maxLength: 60, minLength: 12)),

                InputForm(
                  name: "correo",
                  controller: _correoController,
                  label: "Correo",
                  hint: "Ingrese un correo válido",
                  focusNode: _correoFocus,
                  autoFocus: true,
                  validator: (value) {
                    /*if (value == null || value.isEmpty) {
                          return "Correo requerido";
                        }*/
                    if (value != null &&
                        value.isNotEmpty &&
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Correo inválido";
                    }
                    return null;
                  },
                  validar: Validar(maxLength: 100),
                ),

                InputForm(
                    name: "dpi",
                    controller: _dpiController,
                    label: "DPI",
                    hint: "Ingrese su CUI",
                    keyboardType: TextInputType.number,
                    campoObli: true,
                    formatters: [
                      MaskTextInputFormatter(
                          mask: '#### ##### ####',
                          type: MaskAutoCompletionType.lazy)
                    ],
                    validar: Validar(maxLength: 15, minLength: 15)),

                InputForm(
                    name: "telefono",
                    controller: _telefonoController,
                    label: "Teléfono",
                    hint: "Ingrese su teléfono",
                    keyboardType: TextInputType.phone,
                    campoObli: true,
                    formatters: [
                      MaskTextInputFormatter(
                          mask: '#### ####',
                          filter: {"#": RegExp(r'[0-9]')},
                          type: MaskAutoCompletionType.lazy)
                    ],
                    validar: Validar(maxLength: 9, minLength: 9)),
                // Dirección
                InputForm(
                    name: "direccion",
                    controller: _direccionController,
                    label: "Dirección",
                    hint: "Ingrese su dirección"),
                // Usuario
                InputForm(
                  name: "usuario",
                  controller: _usuarioController,
                  label: "Usuario",
                  hint: "Ingrese un usuario",
                  campoObli: true,
                  validar: Validar(maxLength: 10, minLength: 5),
                ),
                // Contraseña
                _buildPasswordField(),
                // Botón de envío
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Campo de contraseña con botón de "ver contraseña"
  Widget _buildPasswordField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 300 : double.infinity,
      child: TextFormField(
        controller: _contrasenaController,
        obscureText: !_showPassword,
        style:  AppTheme.textStyleInput(),
        decoration: AppTheme.inputDecoration(label: "Contraseña", hint: "Ingrese su contraseña", suffixIcon: IconButton(
            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "La contraseña es obligatoria";
          }
          if (value.length < 10) return "Debe tener al menos 10 caracteres";
          return null;
        },
      ),
    );
  }

  /// Botón de envío del formulario
  Widget _buildSubmitButton(BuildContext context) {
    final datoUser = Provider.of<DatosUsuarioProvider>(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();
            debugPrint(datoUser.datosUsuario.toString());
            // Aquí podrías enviar los datos a un backend o hacer otra acción
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Registro exitoso")),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, color: Colors.white),
            SizedBox(
              width: 5,
            ),
            Text(
              "Registrar",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  const InputForm({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.name,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.focusNode,
    this.nextFocus,
    this.autoFocus = false,
    this.formatters,
    this.campoObli = false,
    this.validar, 
  });

  final String name;
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final bool autoFocus;
  final List<TextInputFormatter>? formatters;
  final bool campoObli;
  final Validar? validar;

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final datoUser =
          Provider.of<DatosUsuarioProvider>(context, listen: false);
      datoUser.setDato(widget.name, "");
    });
  }

  @override
  Widget build(BuildContext context) {
    final datoUser = Provider.of<DatosUsuarioProvider>(context);
    Validar valida = widget.validar ?? Validar.defaultValues();
    effectiveValidator(value) {
      if (widget.campoObli) {
        if (widget.validator != null) {
          return widget.validator!(value);
        }
        if (value.isEmpty || value.length < valida.minLength) {
          return "El campo ${widget.label} es obligatorio";
        }
      } else {
        return null;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        style: AppTheme.textStyleInput(),
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        autofocus: widget.autoFocus,
        inputFormatters: widget.formatters ?? [], // Evita errores con null
        textInputAction: widget.nextFocus != null
            ? TextInputAction.next
            : TextInputAction.done,
        decoration: AppTheme.inputDecoration(label: widget.label, hint: widget.hint),
        validator: effectiveValidator,
        onFieldSubmitted: (_) {
          if (widget.nextFocus != null) {
            FocusScope.of(context).requestFocus(widget.nextFocus);
          }
        },
        onChanged: (value) {
          datoUser.datosUsuario[widget.name] = value;
        },
      ),
    );
  }
}
