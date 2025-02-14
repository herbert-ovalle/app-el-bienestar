import 'package:app_bienestar/component/z_component.dart';
import 'package:app_bienestar/screen/login.screen.dart';
import 'package:app_bienestar/services/qExterno.service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';

class HomeBienestar extends StatelessWidget {
  const HomeBienestar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
            height: 34,
            width: double.infinity,
            color: const Color.fromARGB(255, 67, 148, 70),
            child: Image(image: AssetImage("assets/LOGO_BLANCO.png"))),
        SizedBox(
            height: 210,
            child: PageViewExample(
              lstTitulos: [
                "Ahorros el Bienestar",
                "Préstamos el Bienestar",
                "Seguros Columna",
                "Remesas el Bienestar",
              ],
              lstImagenes: [
                "assets/Productos-Ahorro.png",
                "assets/Prestamos-El-Bienestar.png",
                "assets/Seguros-Columna.png",
                "assets/Remesas.png",
              ],
            )),
        RegistroButton(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag,
                    color: Colors.blue.shade700, size: 24), // Icono decorativo
                const SizedBox(width: 8),
                Text(
                  "Solicite Ahorros y Creditos",
                  style: TextStyle(
                    fontSize: 24, // Tamaño más grande
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: <Color>[
                          Colors.blue.shade600,
                          Colors.blue.shade400,
                        ],
                      ).createShader(Rect.fromLTWH(
                          0.0, 0.0, 200.0, 70.0)), // Gradiente en el texto
                  ),
                ),
              ],
            ),
          ],
        ),
        _MisProductosBie(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100, // Fondo suave para destacar
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.green.shade300.withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(0, 4), // Sombra para destacar
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.monetization_on_outlined,
                              color:
                                  Colors.green.shade700, // Ícono representativo
                              size: 30,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tasa de Cambio:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green
                                        .shade700, // Texto principal llamativo
                                  ),
                                ),
                                Text(
                                  "7.60",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .green.shade900, // Valor destacado
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        _CurrentDateTimeWidget()
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Aplicaciones"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _OpcionDos(
                          assetsvg: "assets/locationAge.svg",
                          titulo: "Agencias",
                          onTap: (value) async {
                            await PeticionesExternas().postTasaCambio();
                          }),
                      _OpcionDos(
                          assetsvg: "assets/loginsvg.svg",
                          titulo: "Ingresar app",
                          onTap: (value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BankLoginScreen()));
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MisProductosBie extends StatefulWidget {
  @override
  State<_MisProductosBie> createState() => _MisProductosBieState();
}

class _MisProductosBieState extends State<_MisProductosBie> {
  final ScrollController _scrollController = ScrollController();
  bool _isAtStart = true; // Indica si estamos al inicio
  bool _isAtEnd = false; // Indica si estamos al final

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener); // Escucha el scroll
  }

  void _scrollListener() {
    setState(() {
      _isAtStart = _scrollController.position.pixels <=
          _scrollController.position.minScrollExtent;
      _isAtEnd = _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent;
    });
  }

  void _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // Posición final
      duration: const Duration(milliseconds: 500), // Duración de la animación
      curve: Curves.easeInOut, // Curva de la animación
    );
  }

  void _scrollToStart() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose(); // Limpiar el controlador

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _IconosProducto(
                titulo: "Ahorros",
                icono: Icons.savings,
                index: 0,
              ),
              _IconosProducto(
                titulo: "Préstamos",
                icono: Icons.real_estate_agent_outlined,
                index: 1,
              ),
              _IconosProducto(
                titulo: "Seguros",
                icono: Icons.account_balance_outlined,
                index: 2,
              ),
              _IconosProducto(
                titulo: "Remesas",
                icono: Icons.monetization_on_outlined,
                index: 3,
              ),
              _IconosProducto(
                titulo: "Propiedades en Venta",
                icono: Icons.house_outlined,
                index: 4,
              ),
            ],
          ),
        ),
        if (!_isAtEnd)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      // ignore: deprecated_member_use
                      Colors.white.withOpacity(0.5)
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (!_isAtEnd)
          Positioned(
            right: 10,
            top: 40,
            child: GestureDetector(
              onTap: _scrollToEnd,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 46,
              ),
            ),
          ),
        if (!_isAtStart)
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.transparent,
                      // ignore: deprecated_member_use
                      Colors.white.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (!_isAtStart)
          Positioned(
            left: 10,
            top: 40,
            child: GestureDetector(
              onTap: _scrollToStart,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
      ],
    );
  }
}

class _OpcionDos extends StatelessWidget {
  final IconData? icono;
  final String titulo;
  final String? assetsvg;
  final Function(TapDownDetails valor) onTap;

  const _OpcionDos(
      {this.icono, required this.titulo, this.assetsvg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: CircleAvatar(
          maxRadius: 40,
          backgroundColor:
              Colors.transparent, // Fondo transparente para gradiente
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (assetsvg != null)
                SvgPicture.asset(assetsvg ?? "", height: 48, width: 48),
              if (icono != null)
                Icon(
                  icono,
                  size: 48,
                  color: Colors.blue.shade700, // Ícono blanco
                ),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700, // Texto blanco
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconosProducto extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final int index;
  const _IconosProducto({
    required this.titulo,
    required this.icono,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductosScreen(
                      tituloAppBar: titulo,
                      tipo: index,
                    )),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 125,
          width: 140,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0), color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: 40,
                child: Icon(
                  icono,
                  size: 72,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                titulo,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentDateTimeWidget extends StatefulWidget {
  @override
  State<_CurrentDateTimeWidget> createState() => _CurrentDateTimeWidgetState();
}

class _CurrentDateTimeWidgetState extends State<_CurrentDateTimeWidget> {
  late Stream<String> _dateTimeStream;

  @override
  void initState() {
    super.initState();
    _dateTimeStream = _generateDateTimeStream();
  }

  Stream<String> _generateDateTimeStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield getCurrentDateTime();
    }
  }

  String getCurrentDateTime() {
    final now = DateTime.now();
    return "${now.day}/${now.month.toString().padLeft(2, "0")}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _dateTimeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                "Fecha y hora actual:",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                snapshot.data!,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          );
        } else {
          return Text("Loading...", style: TextStyle(fontSize: 18));
        }
      },
    );
  }
}
