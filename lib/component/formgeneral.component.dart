import 'package:app_bienestar/models/validador.model.dart';
import 'package:app_bienestar/providers/registro_user.dart';
import 'package:app_bienestar/themes/tema_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/z_service.dart';

class InputForm extends StatefulWidget {
  const InputForm(
      {super.key,
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
      this.maxlines = 1,
      this.suffixIcon});

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
  final int? maxlines;
  final Widget? suffixIcon;

  @override
  State<InputForm> createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  void initState() {
    super.initState();
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
        maxLines: widget.maxlines,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        autofocus: widget.autoFocus,
        inputFormatters: widget.formatters ?? [], // Evita errores con null
        textInputAction: widget.nextFocus != null
            ? TextInputAction.next
            : TextInputAction.done,
        decoration: AppTheme.inputDecoration(
            suffixIcon: widget.suffixIcon,
            label: widget.label,
            hint: widget.hint,
            requerido: widget.campoObli),
        validator: effectiveValidator,
        onFieldSubmitted: (_) {
          if (widget.nextFocus != null) {
            FocusScope.of(context).requestFocus(widget.nextFocus);
          }
        },
        onChanged: (value) async {
          if (widget.name == "dpi" && value.length == 15) {
            await validarCUIngresado(context, value);
          }
          datoUser.datosUsuario[widget.name] = value;
        },
      ),
    );
  }
}
