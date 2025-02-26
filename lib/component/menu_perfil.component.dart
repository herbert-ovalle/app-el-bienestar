import 'package:app_bienestar/class/preferences.theme.dart';
import 'package:app_bienestar/component/formulario.component.dart';
import 'package:app_bienestar/screen/login.screen.dart';
import 'package:flutter/material.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.person),
        offset: const Offset(0, 40),
        onSelected: (Menu item) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              PopupMenuItem<Menu>(
                value: Menu.itemOne,
                child: MenuLista(icono: Icons.login, texto: "Login"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BankLoginScreen()));
                },
              ),
              PopupMenuItem<Menu>(
                value: Menu.itemTwo,
                child: MenuLista(
                    icono: Icons.person_add, texto: 'Registro de Datos'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FormularioComponent()));
                },
              ),
              /*PopupMenuItem<Menu>(
                value: Menu.itemThree,
                child: MenuLista(icono: Icons.settings, texto: 'Configuración'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ConfigScreen()));
                },
              ),*/
              PopupMenuItem<Menu>(
                value: Menu.itemFour,
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/home");
                  
                },
                child: MenuLista(icono: Icons.exit_to_app, texto: 'Salir'),
              ),
            ]);
  }
}

class MenuLista extends StatelessWidget {
  final IconData icono;
  final String texto;
  const MenuLista({
    super.key,
    required this.icono,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, color: Preferences.isDarkmode ? Colors.white : null),
        SizedBox(
          width: 10,
        ),
        Text(texto),
      ],
    );
  }
}
