import 'package:app_bienestar/component/formulario.component.dart';
import 'package:app_bienestar/component/radio.component.dart';
import 'package:app_bienestar/screen/config.screen.dart';
import 'package:app_bienestar/screen/homebien.screen.dart';
import 'package:app_bienestar/screen/login.screen.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<SalomonBottomBarItem> navBarItems = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: const Text("Inicio", style: TextStyle(fontSize: 20)),
      selectedColor: const Color.fromARGB(255, 2, 1, 99),
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.radio),
      title: const Text("Radio", style: TextStyle(fontSize: 20)),
      selectedColor: Colors.green[500],
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.account_balance),
      title: const Text("Productos", style: TextStyle(fontSize: 20)),
      selectedColor: Colors.orange,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.settings),
      title: const Text("Ajustes", style: TextStyle(fontSize: 20)),
      selectedColor: Colors.teal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: navBarItems[_selectedIndex].title,
        backgroundColor: navBarItems[_selectedIndex].selectedColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: _ProfileIcon()),
          )
        ],
      ),
      body: bodyForm(),
      bottomNavigationBar: SalomonBottomBar(
          backgroundColor: const Color.fromARGB(45, 158, 158, 158),
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: navBarItems),
    );
  }

  Widget bodyForm() {
    switch (_selectedIndex) {
      case 0:
        return HomeBienestar();
      case 1:
        return MusicPlayerScreen();
      case 2:
        return const Center(
          child: Text("Busqueda"),
        );
      case 3:
        return ConfigScreen();
      default:
        return const Center(
          child: Text("Inicio"),
        );
    }
  }
}

enum Menu { itemOne, itemTwo, itemThree,itemFour }

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon();

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
                child: MenuLista(icono: Icons.person_add, texto: 'Registro de Datos'),
                onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FormularioComponent()));
                },
              ),
              PopupMenuItem<Menu>(
                value: Menu.itemThree,
                child: MenuLista(icono: Icons.settings, texto: 'Configuración'),
                onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfigScreen()));
                },

              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemFour,
                child: MenuLista(icono: Icons.exit_to_app, texto: 'Salir'),
              ),
            ]);
  }
}

class MenuLista extends StatelessWidget {
  final IconData icono;
  final String texto;
  const MenuLista({
    super.key, required this.icono, required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono),
        SizedBox(
          width: 10,
        ),
        Text(texto),
      ],
    );
  }
}
