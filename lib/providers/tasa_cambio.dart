import 'package:flutter/material.dart';

class DatosUsuarioProvider extends ChangeNotifier {
  
  final String _tasaCambio;

  DatosUsuarioProvider({String tasa = "0.00"})
      : _tasaCambio = tasa;

  String get datosUsuario => _tasaCambio;  

}
