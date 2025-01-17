import 'package:flutter/material.dart';

class ProductosScreen extends StatelessWidget {
  
  final String tituloAppBar;
  const ProductosScreen({super.key, required this.tituloAppBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tituloAppBar, style: TextStyle(fontSize: 20)),
      ),
      body: Center(
        child: Column(
          children: [
            Image(image: AssetImage("assets/LOGO_AZUL.png"), height: 70,)
          ],
        ),
      ),
    );
  }
}
