import 'package:flutter/material.dart';

class DatosUsuarioProvider extends ChangeNotifier {
  final Map<String, dynamic> _datosUsuario;
  String lastFunctionCalled = "Ninguna";


  DatosUsuarioProvider({Map<String, dynamic>? datosIniciales})
      : _datosUsuario = datosIniciales ?? {};

  Map<String, dynamic> get datosUsuario => _datosUsuario;

  void limpiarDatos() {
    _datosUsuario.clear();
    lastFunctionCalled = "limpiarTodo";
    notifyListeners();
  }

  void setDato(String key, dynamic value) {
    _datosUsuario[key] = value;
    lastFunctionCalled = "Ninguna";
    notifyListeners(); // Notifica a los widgets que usan este provider
  }

  void removeDato(String key) {
    if (_datosUsuario.containsKey(key)) {
      lastFunctionCalled = "Ninguna";
      _datosUsuario.remove(key);
      notifyListeners();
    }
  }
}
