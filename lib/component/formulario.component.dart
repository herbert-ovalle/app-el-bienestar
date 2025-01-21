import 'package:flutter/material.dart';

class FormularioComponent extends StatelessWidget {

  const FormularioComponent({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registre sus Datos'),
      ),
      body: const Center(
        child: Text('Formulario'),
      ),
    );
  }
}