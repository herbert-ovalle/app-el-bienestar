import 'package:flutter/material.dart';

class DatosTasaCambio extends ChangeNotifier {
  
  final String _tasaCambio;

  DatosTasaCambio({String tasa = "0.00"})
      : _tasaCambio = tasa;

  String get datosUsuario => _tasaCambio;  

  void limpiarDatos() {
    //_datosUsuario.clear();
    notifyListeners();
  }


}
