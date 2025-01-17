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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image(image: AssetImage("assets/LOGO_AZUL.png"), height: 50,),
            TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.link, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text('Solicite su ahorro', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Ahorro Disponible", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(
                      "Ofrece un manejo seguro y fácil sobre tus ahorros, excelente tasa de interés y acceso a tu dinero en cualquier momento. Incluye tarjeta de débito VISA internacional sin costo de membresía, seguro contra fraudes y muchos beneficios más.",
                      textAlign: TextAlign.justify,
                    ),
                    Image(
                      image: AssetImage("assets/productos/disponible.png"),
                    ),
                    SizedBox(height: 10),
                     Text("Ahorro Programado",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(
                      "Ofrece un manejo seguro y fácil sobre tus ahorros, excelente tasa de interés y acceso a tu dinero en cualquier momento. Incluye tarjeta de débito VISA internacional sin costo de membresía, seguro contra fraudes y muchos beneficios más.",
                      textAlign: TextAlign.justify,
                    ),
                    Image(
                      image: AssetImage("assets/productos/programado.png"),
                    ),
                    SizedBox(height: 10),
                     Text("Ahorro a Plazo Fijo",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(
                      "Disfruta de una inversión confiable que maximiza tus ahorros sin riesgos y con grandes beneficios totalmente gratis; elige el plazo que mejor se adapte a tus metas: 90, 180, 365, 540 o 730 días. Respaldado por nuestra solidez financiera de 63 años.",
                      textAlign: TextAlign.justify,
                    ),
                    Image(
                      image: AssetImage("assets/productos/plazo_fijo.png"),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
