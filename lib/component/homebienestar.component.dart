import 'package:app_bienestar/component/pageview.component.dart';
import 'package:app_bienestar/component/productos.component.dart';
import 'package:flutter/material.dart';

class HomeBienestar extends StatelessWidget {
  const HomeBienestar({super.key});

  @override
  Widget build(BuildContext context) {

    /*List<String> lstSubTitulos = [
      "¡Descubre lo que tus ahorros pueden hacer por ti!",
      "¡Construye tu futuro con confianza y facilidad!",
      "¡Protección en cada momento!",
      "¡Bienestar para tu familia!",
      "¡Llegó la oportunidad para tener casa propia! Invierte ahora en lotificación Miralbosque En Pachaj Cantel, Quetzaltenango"
    ];*/
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
            height: 28,
            width: double.infinity,
            //color: const Color.fromARGB(255, 4, 0, 65),
            color: const Color.fromARGB(255, 67, 148, 70),
            child: Image(image: AssetImage("assets/LOGO_BLANCO.png"))),
        SizedBox(
            height: 240,
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
        SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag, color: Colors.blue.shade700, size: 24), // Icono decorativo
                const SizedBox(width: 8),
                Text(
                  "Mis Productos",
                  style: TextStyle(
                    fontSize: 24, // Tamaño más grande
                    fontWeight: FontWeight.bold, // Negrita para destacar
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: <Color>[
                          Colors.blue.shade600,
                          Colors.blue.shade400,
                        ],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)), // Gradiente en el texto
                  ),
                ),
              ],
            ),
          ],
        ),
        _MisProductosBie(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text("Tasa de Cambio:  7.60"),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _OpcionDos(),
                  _OpcionDos(),
                  _OpcionDos(),
                  _OpcionDos(),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _OpcionDos(),
                  _OpcionDos(),
                  _OpcionDos(),
                  _OpcionDos()
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _OpcionDos(),
                  _OpcionDos(),
                  _OpcionDos(),
                  _OpcionDos()
                ],
              )
            ]),
          ),
        )
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _IconosProducto(titulo: "Ahorros", icono: Icons.savings),
              _IconosProducto(
                  titulo: "Préstamos",
                  icono: Icons.real_estate_agent_outlined),
              _IconosProducto(
                  titulo: "Seguros", icono: Icons.account_balance_outlined),
              _IconosProducto(
                  titulo: "Remesas", icono: Icons.monetization_on_outlined),
              _IconosProducto(
                  titulo: "Propiedades en Venta",
                  icono: Icons.house_outlined),
            ],
          ),
        ),
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
                    Colors.white.withOpacity(0.4)
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 40,
          child: GestureDetector(
            onTap: _scrollToEnd,
            child: Icon(
              Icons.arrow_forward,
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 75,
        width: 70,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monetization_on_outlined, size: 44),
              SizedBox(height: 5),
              Text("Dólares",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 8))
            ]),
      ),
    );
  }
}

class _IconosProducto extends StatelessWidget {
  final String titulo;
  final IconData icono;

  const _IconosProducto({
    required this.titulo,
    required this.icono,
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
                builder: (context) => ProductosScreen(tituloAppBar: titulo)),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 140,
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade600,
                Colors.blue.shade800,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.blue.shade300.withOpacity(0.6),
                blurRadius: 15,
                offset: const Offset(0, 8), // Efecto de sombra
              ),
            ],
          ),
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
                  size: 70,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );

  }
}
