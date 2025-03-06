import 'package:flutter/material.dart';

void showBankSnackBar(BuildContext context, String title, String message) {

  final snackBar = SnackBar(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Colors.blue[900], 
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'X',
      textColor: Colors.white,
      backgroundColor: Colors.black45,
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
    ),
    duration: Duration(seconds: 3), // Se oculta después de 5 segundos
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
