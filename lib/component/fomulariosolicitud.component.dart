import 'package:app_bienestar/component/formgeneral.component.dart';
import 'package:app_bienestar/component/spiner-asincrono.component.dart';
import 'package:app_bienestar/models/z_model.dart';
import 'package:app_bienestar/providers/guardar_usuario.dart';
import 'package:app_bienestar/providers/registro_user.dart';
import 'package:app_bienestar/services/z_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class FormularioSolicitud extends StatefulWidget {
  const FormularioSolicitud(
      {super.key,
      required this.titulo,
      required this.lstCatalogo,
      required this.tipo});
  final String titulo;
  final List<ProductosCatalogo> lstCatalogo;
  final int tipo;

  @override
  State<FormularioSolicitud> createState() => _FormularioSolicitudState();
}

class _FormularioSolicitudState extends State<FormularioSolicitud> {
  final TextEditingController _teleAsoController = TextEditingController();
  final TextEditingController _cuiController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _cometarioController = TextEditingController();

  final FocusNode _cuiFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Solicitud de ${widget.titulo}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
                InputForm(
                    name: "telefono",
                    controller: _teleAsoController,
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
                const SizedBox(height: 15),
                DropList(lstCatalogo: widget.lstCatalogo),
                const SizedBox(height: 15),
                InputForm(
                    name: "comentarioAso",
                    controller: _cometarioController,
                    label: "Comentario",
                    maxlines: 4,
                    hint: "Comentario",
                    campoObli: false),
                const SizedBox(height: 15),
                if (widget.tipo == 1)
                  InputForm(
                      name: "montoSolicitado",
                      controller: _montoController,
                      label: "Monto",
                      hint: "Monto Solicitado",
                      keyboardType: TextInputType.number,
                      campoObli: false,
                      formatters: [
                        CurrencyInputFormatter(
                          leadingSymbol: 'Q', // Símbolo de moneda
                          useSymbolPadding:
                              true, // Espacio entre el símbolo y el número
                        ),
                      ],
                      validar: Validar(maxLength: 9, minLength: 9)),
                const SizedBox(height: 15),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll(Colors.red)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.close, color: Colors.red),
                          SizedBox(width: 5,),
                          const Text('Salir'),
                        ],
                      ),
                    ),
                    SizedBox(width: 40),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        FocusScope.of(context).unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
                        final datoUser = Provider.of<DatosUsuarioProvider>(
                            context,
                            listen: false);

                        final res = await showLoadingDialog(
                            context,
                            UsuarioAsociadoN().guardarSolicitud(
                                RegistroSolicitud.fromJson(
                                    datoUser.datosUsuario)));

                        await ReproductorMusic().showBankSnackBar(res.mensaje);

                        if (res.respuesta == 'success') {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.save,color: Colors.white),
                          SizedBox(width: 5,),
                          const Text('Enviar Solicitud', style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DropList extends StatelessWidget {
  const DropList({super.key, required this.lstCatalogo});
  final List<ProductosCatalogo> lstCatalogo;

  @override
  Widget build(BuildContext context) {
    final datoUser = Provider.of<DatosUsuarioProvider>(context);
    String? selectedValue;

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Selecciona su producto",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: selectedValue,
      items:
          lstCatalogo.map<DropdownMenuItem<String>>((ProductosCatalogo value) {
        return DropdownMenuItem<String>(
            value: value.idSubProducto.toString(),
            child: Text(value.subProducto));
      }).toList(),
      onChanged: (String? newValue) {
        selectedValue = newValue;
        datoUser.datosUsuario['idSubProducto'] = selectedValue;
      },
      validator: (value) => value == null ? "Selecciona su producto" : null,
    );
  }
}
