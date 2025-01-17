import 'package:app_bienestar/component/pageview.component.dart';
import 'package:app_bienestar/component/productos.component.dart';
import 'package:flutter/material.dart';

class HomeBienestar extends StatelessWidget {
  const HomeBienestar({super.key});

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.shopping_bag,
                    color: Colors.blue.shade700, size: 24), // Icono decorativo
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
                      ).createShader(Rect.fromLTWH(
                          0.0, 0.0, 200.0, 70.0)), // Gradiente en el texto
                  ),
                ),
              ],
            ),
          ],
        ),
        _MisProductosBie(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.green.shade700, // Ícono representativo
                  size: 28,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tasa de Cambio",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.green.shade700, // Texto principal llamativo
                      ),
                    ),
                    Text(
                      "7.60",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900, // Valor destacado
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
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

  void _scrollToStart() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // Eliminar el listener
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
              _IconosProducto(titulo: "Ahorros", icono: Icons.savings),
              _IconosProducto(
                  titulo: "Préstamos", icono: Icons.real_estate_agent_outlined),
              _IconosProducto(
                  titulo: "Seguros", icono: Icons.account_balance_outlined),
              _IconosProducto(
                  titulo: "Remesas", icono: Icons.monetization_on_outlined),
              _IconosProducto(
                  titulo: "Propiedades en Venta", icono: Icons.house_outlined),
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
                size: 48,
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

/*class _OpcionDos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: CircleAvatar(
        maxRadius: 40,
        backgroundColor: Colors.white, // Fondo blanco para el círculo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.monetization_on_outlined,
              size: 48,
              color: const Color.fromARGB(255, 2, 4, 114), // Ícono blanco
            ),
            const SizedBox(height: 4),
            Text(
              "Dólares",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Texto blanco
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
class _OpcionDos extends StatefulWidget {
  @override
  State<_OpcionDos> createState() => _OpcionDosState();
}

class _OpcionDosState extends State<_OpcionDos> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        debugPrint("onTapDown");
      }, // Cambia estado al tocar
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          boxShadow:[
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.green.shade200.withOpacity(0.4),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )]
              
        ),
        child: CircleAvatar(
          maxRadius: 40,
          backgroundColor:
              Colors.transparent, // Fondo transparente para gradiente
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.monetization_on_outlined,
                size: 48,
                color: Colors.white, // Ícono blanco
              ),
              Text(
                "Dólares",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto blanco
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
