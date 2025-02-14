import 'package:flutter/material.dart';

class AppTheme {
  static InputDecoration inputDecoration({
    Widget? suffixIcon,
    required String label,
    required String hint,
    required bool requerido
  }) {
    return InputDecoration(
      label: RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(color: Colors.black, fontSize: 18),
        children: [
          if (requerido)
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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
      fillColor: Colors.white,
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
