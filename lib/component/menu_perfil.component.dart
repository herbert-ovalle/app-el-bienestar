import 'package:app_bienestar/class/preferences.theme.dart';
import 'package:flutter/material.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({super.key, required this.items});

  final List<PopupMenuItem<Menu>> items;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.person),
        offset: const Offset(0, 40),
        onSelected: (Menu item) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>> [...items]);
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
