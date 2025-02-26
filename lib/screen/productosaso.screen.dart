import 'package:app_bienestar/component/menu_perfil.component.dart';
import 'package:flutter/material.dart';

class InformacionAsociado extends StatelessWidget {

  const InformacionAsociado({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del asociado', style: TextStyle(fontSize: 16)),
        actions: [
            Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: ProfileIcon()),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Información del asociado', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Nombre: Juan Pérez'),
            Text('Cédula: 1234567890'),
            Text('Teléfono: 000000000000'),
            Text('Dirección: Calle Principal, Ciudad'),
            Text('Correo electrónico: juan.perez@example.com'),
            Text('Fecha de nacimiento: 01/01/1990'),
            Text('Fecha de ingreso: 01/01/2020'),
            Text('Fecha de retiro: 01/01/2025'),
            Text('Estado: Activo'),
          ],
        ),
      ),
    );
  }
}