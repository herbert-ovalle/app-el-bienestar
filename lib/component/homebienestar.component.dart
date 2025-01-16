import 'package:app_bienestar/component/pageview.component.dart';
import 'package:flutter/material.dart';

class HomeBienestar extends StatelessWidget {
  const HomeBienestar({super.key});

  @override
  Widget build(BuildContext context) {

    List<String> lstTitulos = [
      "Ahorros",
      "Préstamos",
      "Seguros",
      "Remesas",
      "Propiedades en Venta"
    ];

    List<String> lstSubTitulos = [
      "¡Descubre lo que tus ahorros pueden hacer por ti!",
      "¡Construye tu futuro con confianza y facilidad!",
      "¡Protección en cada momento!",
      "¡Bienestar para tu familia!",
      "¡Llegó la oportunidad para tener casa propia! Invierte ahora en lotificación Miralbosque En Pachaj Cantel, Quetzaltenango"
    ];
    return Column(
      children: [
        Container(
          height: 28,
          width: double.infinity,
          //color: const Color.fromARGB(255, 4, 0, 65),
          color: const Color.fromARGB(255, 67, 148, 70),
          child: Image(image: AssetImage("assets/LOGO_BLANCO.png"))
        ),
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
          height: 360,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...lstTitulos.asMap().entries.map((e) =>  ExpansionTile(
                    collapsedBackgroundColor:
                        const Color.fromARGB(255, 233, 232, 232),
                    title: Text(e.value,style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(lstSubTitulos[e.key]),
                    children: <Widget>[
                      ListTile(
                        title: Text('Ahorro Disponible',style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Column(
                          children: [
                            Text("Ofrece un manejo seguro y fácil sobre tus ahorros,excelente tasa de interés y acceso a tu dinero en cualquier momento. Incluye tarjeta de débito VISA internacional sin costo de membresía, seguro contra fraudes y muchos beneficios más.",
                            style: TextStyle(),textAlign: TextAlign.justify,),
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: Image(image: AssetImage("assets/productos/disponible.png")))
                          ],
                        )
                      ),
                    ],
                  ),
                ),
               
              ],
            ),
          ),
        ),
      ],
    );
  }
}