import 'package:app_bienestar/class/preferences.theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static InputDecoration inputDecoration(
      {Widget? suffixIcon,
      required String label,
      required String hint,
      required bool requerido}) {
    return InputDecoration(
      label: RichText(
        text: TextSpan(
          text: label,
          style: TextStyle(color: Preferences.isDarkmode ? null : Colors.black, fontSize: 18, fontWeight: Preferences.isDarkmode ? FontWeight.bold : null),
          children: [
            if (requerido)
              TextSpan(
                text: ' *',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
      hintText: hint,
      suffixIcon: suffixIcon,
      labelStyle:
          TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
      hintStyle: TextStyle(color: Colors.grey.shade500),
      filled: true,
      fillColor:  Preferences.isDarkmode ? Colors.grey.shade600 : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue.shade300, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue.shade400, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue.shade600, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red.shade600, width: 1),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  static TextStyle textStyleInput({
    double? fontSize,
  }) {
    return TextStyle(fontSize: fontSize ?? 18);
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;

  ThemeProvider({required bool isDarkmode})
      : currentTheme = isDarkmode ? setDarkmode() : setLightMode();

  static ThemeData setLightMode() {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 1, 2, 58),
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
    );
  }

  static ThemeData setDarkmode() {
    return ThemeData(
      brightness: Brightness.dark, // Modo oscuro
      scaffoldBackgroundColor: const Color.fromARGB(211, 27, 27, 27), // Fondo más oscuro
      colorScheme: const ColorScheme.dark(
        //primary: Colors.blueGrey,
        secondary: Colors.teal,
        surface: Colors.black,
      ),
       appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
    /*return ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
    );*/
  }

  void toggleTheme() {
    currentTheme =
        (currentTheme == setDarkmode()) ? setLightMode() : setDarkmode();
    Preferences.isDarkmode = currentTheme == setDarkmode();
    notifyListeners(); // Ahora sí se ejecuta correctamente
  }
}
