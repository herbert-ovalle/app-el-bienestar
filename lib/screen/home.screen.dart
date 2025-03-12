import 'package:app_bienestar/class/preferences.theme.dart';
import 'package:app_bienestar/component/formulario.component.dart';
import 'package:app_bienestar/component/menu_perfil.component.dart';
import 'package:app_bienestar/component/radio.component.dart';
import 'package:app_bienestar/component/spiner-asincrono.component.dart';
import 'package:app_bienestar/screen/config.screen.dart';
import 'package:app_bienestar/screen/homebien.screen.dart';
import 'package:app_bienestar/screen/login.screen.dart';
import 'package:app_bienestar/services/qExterno.service.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<SalomonBottomBarItem> navBarItems;

  @override
  void initState() {
    super.initState();
    PeticionesExternas().catalogoIncial().then((_) => {});
    _updateNavBarItems(); // Llamar función para inicializar
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _updateNavBarItems();
    });
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _updateNavBarItems();
    });
  }

  void _updateNavBarItems() {
    navBarItems = [
      SalomonBottomBarItem(
        icon: const Icon(Icons.home),
        title: const Text("Inicio", style: TextStyle(fontSize: 20)),
        selectedColor: Preferences.isDarkmode
            ? Colors.white
            : const Color.fromARGB(255, 2, 1, 99),
      ),
      SalomonBottomBarItem(
        icon: const Icon(Icons.radio),
        title: const Text("Radio", style: TextStyle(fontSize: 20)),
        selectedColor: Colors.green[500],
      ),
      /*SalomonBottomBarItem(
        icon: const Icon(Icons.account_balance),
        title: const Text("Productos", style: TextStyle(fontSize: 20)),
        selectedColor: Colors.orange,
      ),*/
      SalomonBottomBarItem(
        icon: const Icon(Icons.settings),
        title: const Text("Ajustes", style: TextStyle(fontSize: 20)),
        selectedColor: Colors.teal,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: navBarItems[_selectedIndex].title,
        backgroundColor: Preferences.isDarkmode
            ? null
            : navBarItems[_selectedIndex].selectedColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
                child: ProfileIcon(
              items: [
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
              ],
            )),
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
            _selectedIndex = index;
            setState(() {
              _updateNavBarItems();
            });
          },
          items: navBarItems),
      floatingActionButton: FloatingActionButton.small(onPressed: () async {
        await showLoadingDialog(context, PeticionesExternas().catalogoIncial(soloPeticion: true));
      }, child: Icon(Icons.update),),
    );
  }

  Widget bodyForm() {
    switch (_selectedIndex) {
      case 0:
        return HomeBienestar();
      case 1:
        return MusicPlayerScreen();
      /*case 2:
        return const Center(
          child: Text("Productos de Bienestar"),
        );*/
      case 2:
        return ConfigScreen();
      default:
        return const Center(
          child: Text("Inicio"),
        );
    }
  }
}
