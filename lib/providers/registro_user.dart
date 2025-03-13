import 'package:flutter/material.dart';

class DatosUsuarioProvider extends ChangeNotifier {
    
  final Map<String,dynamic> _datosUsuario;

  DatosUsuarioProvider({Map<String, dynamic>? datosIniciales})
      : _datosUsuario = datosIniciales ?? {};

  Map<String, dynamic> get datosUsuario => _datosUsuario;

  void limpiarDatos() {
    _datosUsuario.clear();
    notifyListeners();
  }

  void setDato(String key, dynamic value) {
    _datosUsuario[key] = value;
    notifyListeners(); // Notifica a los widgets que usan este provider
  }

  void removeDato(String key) {
    if (_datosUsuario.containsKey(key)) {
      _datosUsuario.remove(key);
      notifyListeners();
    }
  }

  void clearDatos() {
    _datosUsuario.clear();
    notifyListeners();
  }
  
}
