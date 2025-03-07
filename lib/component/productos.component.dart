import 'dart:convert';
import 'package:app_bienestar/class/preferences.theme.dart';
import 'package:app_bienestar/component/fomulariosolicitud.component.dart';
import 'package:app_bienestar/component/inforequisitos.component.dart';
import 'package:app_bienestar/models/z_model.dart';
import 'package:flutter/material.dart';

class ProductosScreen extends StatelessWidget {
  final String tituloAppBar;
  final int tipo;
  final List<ProductosCatalogo> prodCat;

  const ProductosScreen(
      {super.key,
      required this.tituloAppBar,
      required this.tipo,
      required this.prodCat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tituloAppBar, style: TextStyle(fontSize: 20)),
      ),
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(10.0),
        minScale: 0.1,
        maxScale: 1.6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image(
                image: AssetImage(Preferences.isDarkmode
                    ? "assets/LOGO_BLANCO.png"
                    : "assets/LOGO_AZUL.png"),
                height: 50,
              ),
              if (prodCat.isNotEmpty)
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      useSafeArea: false,
                      builder: (BuildContext context) {
                        return FormularioSolicitud(titulo: tituloAppBar,lstCatalogo: prodCat,);
                      }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.link,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Solicite $tituloAppBar',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: Preferences.isDarkmode
                              ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[Colors.orange, Colors.red],
                                  stops: <double>[0.0, 1.0],
                                )
                              : null,
                        ),
                        child: debolverProducto(tipo, prodCat))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget debolverProducto(int tipo, List<ProductosCatalogo> prodCat) {
  if (prodCat.isNotEmpty) {
    return Column(children: [
      ...prodCat.map((e) => InformacionProducto(
            titulo: e.subProducto,
            descripcion: e.descripcion,
            imagen: "assets/productos/${e.urlFotografia}",
            lstRequisitos: e.requisitos,
          ))
    ]);
  }

  switch (tipo) {
    case 0:
      return AhorrosProductos();
    case 1:
      return PrestamosProductos();
    case 2:
      return SegurosProductos();
    case 3:
      return RemesasProductos();
    default:
      return Center(child: Text("No disponible"));
  }
}

class RemesasProductos extends StatelessWidget {
  const RemesasProductos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InformacionProducto(
            titulo: "Cobra tu remesa",
            descripcion:
                "Envía tus remesas a Guatemala y recíbelas por medio de Cooperativa El Bienestar! Sin cobro de comisión y de manera segura.",
            imagen: "assets/productos/remesas/Remesa.png"),
        InformacionProducto(
            titulo: "Tu Remesa Dirigida",
            descripcion:
                "Este servicio facilita el envío de dinero de tus seres queridos desde el extranjero hacia una cuenta de Ahorro Disponible de una manera directa, fácil y segura.",
            imagen: "assets/productos/remesas/Remesa-dirigida.png"),
        SizedBox(height: 20),
        Text("Remesadoras Aliadas",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Image(
            image: AssetImage(
                "assets/productos/remesas/Remesadoras-1280x276.png")),
        SizedBox(height: 40)
      ],
    );
  }
}

class SegurosProductos extends StatelessWidget {
  const SegurosProductos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InformacionProducto(
          titulo: 'Seguro de Vehículos',
          descripcion:
              'Asegura tu tranquilidad con nuestra cobertura completa para vehículos. Nuestro seguro ofrece respaldo contra accidentes, vuelcos, colisiones y robo, además de protección para ocupantes ante cualquier eventualidad.',
          imagen: 'assets/productos/seguros/manejo-seguro.png',
        ),
        InformacionProducto(
          titulo: 'Seguro Infanto Juvenil',
          descripcion:
              'Garantiza el bienestar de los más jóvenes con una cobertura diseñada para brindar tranquilidad a toda la familia. Nuestro seguro protege ante situaciones imprevistas, ofreciendo respaldo financiero en caso de accidentes o enfermedades, para que tus hijos crezcan seguros y protegidos en cada etapa de su desarrollo.',
          imagen: 'assets/productos/seguros/infanto-juvenil.png',
        ),
        InformacionProducto(
          titulo: 'Seguro Individual o Familiar',
          descripcion:
              'Asegura el bienestar y la tranquilidad de tu familia con un respaldo económico completo en caso de pérdida. Este seguro protege tanto al asociado como a sus seres queridos, con beneficio de indemnización por fallecimiento. Además, permite incluir a tu cónyuge e hijos en la misma póliza, con una tarifa más accesible que contratar seguros individuales para cada uno.',
          imagen: 'assets/productos/seguros/familiar.png',
        ),
        InformacionProducto(
          titulo: 'Seguro Vida Saludable',
          descripcion:
              'Seguro de vida colectivo que tiene como fin proveer protección y respaldo económico para cubrir las necesidades básicas del núcleo familiar dependiente ante la pérdida de la vida o inconveniencia del asegurado.',
          imagen: 'assets/productos/seguros/vida-saludable.png',
        ),
        InformacionProducto(
          titulo: 'Seguro de Transporte',
          descripcion:
              'Brinda protección a los propietarios de vehículos destinados al transporte público extraurbano, para garantizar un pago indemnizatorio a los pasajeros que, a consecuencia de un hecho de tránsito, fueran afectados con lesiones, incapacidad e incluso el fallecimiento. Este seguro está diseñado para cumplir con lo estipulado en el art. 29 de la Ley de tránsito. Decreto 132-96 y específicamente a la regulación establecida en los Acuerdos Gubernativos No. 265-001 y 392-2001, referente a la obligatoriedad de seguro en el transporte extraurbano de pasajeros.',
          imagen: 'assets/productos/seguros/transporte.png',
        ),
        InformacionProducto(
          titulo: 'Seguro Mancomunado',
          descripcion:
              'Brinda protección y beneficios a dos personas como cónyuges, padres e hijos, en un mismo plan de seguro de vida con una cobertura más completa.',
          imagen: 'assets/productos/seguros/mancomunado.png',
        ),
        InformacionProducto(
          titulo: 'Seguro de Accidentes Edad de Oro',
          descripcion:
              'Brinda protección y tranquilidad a asegurados de Cooperativa El Bienestar, mayores de 50 años al momento de un accidente, tiene coberturas en muerte accidental, fracturas y quemaduras.',
          imagen: 'assets/productos/seguros/edad-oro.png',
        ),
        InformacionProducto(
          titulo: 'Seguro Cáncer',
          descripcion:
              'Es un mecanismo de apoyo y respaldo económico que se brinda al asociado en caso de que este reciba por primera vez en su vida un diagnóstico de cáncer.',
          imagen: 'assets/productos/seguros/cancer.png',
        ),
      ],
    );
  }
}

class PrestamosProductos extends StatelessWidget {
  const PrestamosProductos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InformacionProducto(
            titulo: 'Micro-Crédito',
            descripcion:
                "Diseñado para fortalecer tu capital de trabajo, ampliación de negocio o emprendimiento. Pocos requisitos, sin fiador y cuotas accesibles.",
            imagen: "assets/productos/creditos/microcreditos.png"),
        InformacionProducto(
            titulo: 'Crédito Mi Consumo',
            descripcion:
                "Perfecto para cubrir gastos personales o adquirir activos como inmuebles y vehículos. Ofrece cuotas niveladas e intereses sobre saldos, con plazos de hasta 60 meses para activos y gastos médicos, y hasta 36 meses para consolidación de deudas.",
            imagen: "assets/productos/creditos/mi-consumo.png"),
        InformacionProducto(
            titulo: 'Crédito Mi Comercio',
            descripcion:
                "Hecho para emprendedores y empresarios. Ideal para capital de trabajo y adquisición de activos, plazos según destino del crédito, baja tasa de interés, asesoría y beneficios gratis.",
            imagen: "assets/productos/creditos/mi-comercio.png"),
        InformacionProducto(
            titulo: 'Crédito Automático',
            descripcion:
                "Una opción flexible y rápida, ideal para necesidades de vivienda, comercio, agricultura, ganadería, industria manufacturera y gastos personales. Ofrece plazos según destino del crédito, con intereses sobre saldos y cuotas fijas.",
            imagen: "assets/productos/creditos/credito-automatico.png"),
        InformacionProducto(
            titulo: 'Crédito Mi Vivienda',
            descripcion:
                "La solución ideal para financiar tus proyectos de construcción, compra de terreno, vivienda, remodelación, ampliación de tu hogar o negocio. Con tasas de interés competitivas, cuotas accesibles, seguro y avalúo gratis. Además, te brindamos asesoría y atención personalizada.",
            imagen: "assets/productos/creditos/mi-vivienda.png"),
        InformacionProducto(
            titulo: 'Crédito Agricultura',
            descripcion:
                "Te brindamos el capital de trabajo para la compra de semillas, insumos y materia prima, así como para la adquisición de activos fijos, incluyendo terrenos productivos, ganado, instalaciones y equipo necesario para el crecimiento de tu negocio agrícola. Con plazos adaptados al uso del crédito, intereses sobre saldos y cuotas fijas.",
            imagen: "assets/productos/creditos/agricultura.png"),
        InformacionProducto(
            titulo: 'Crédito Grupal',
            descripcion:
                "Apoyamos a mujeres emprendedoras ofreciéndoles capital de trabajo para impulsar sus negocios, ya sean formales o informales. Financiamiento hasta Q.30,000.00 con grupos de hasta 5 integrantes, brindando una oportunidad accesible para crecer juntas y alcanzar sus metas.",
            imagen: "assets/productos/creditos/grupal.png"),
      ],
    );
  }
}

class AhorrosProductos extends StatelessWidget {
  const AhorrosProductos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InformacionProducto(
            titulo: 'Ahorro Disponible',
            descripcion:
                "Ofrece un manejo seguro y fácil sobre tus ahorros, excelente tasa de interés y acceso a tu dinero en cualquier momento. Incluye tarjeta de débito VISA internacional sin costo de membresía, seguro contra fraudes y muchos beneficios más.",
            imagen: "assets/productos/ahorros/disponible.png"),
        InformacionProducto(
            titulo: 'Ahorro Programado',
            descripcion:
                "Ideal para mayores de edad que buscan hacer crecer su dinero. Con depósitos mensuales, esta cuenta te ofrece intereses cada mes, ayudándote a alcanzar tus metas en plazos de 1 a 5 años, utiliza el débito automático para mantener tus ahorros al día.",
            imagen: "assets/productos/ahorros/programado.png"),
        InformacionProducto(
            titulo: 'Ahorro a Plazo Fijo',
            descripcion:
                "Disfruta de una inversión confiable que maximiza tus ahorros sin riesgos y con grandes beneficios totalmente gratis; elige el plazo que mejor se adapte a tus metas: 90, 180, 365, 540 o 730 días. Respaldado por nuestra solidez financiera de 63 años.",
            imagen: "assets/productos/ahorros/plazo_fijo.png"),
        InformacionProducto(
            titulo: 'Aportaciones',
            descripcion:
                "Conviértete en asociado y disfruta de los beneficios de la Cooperativa. Las aportaciones te otorgan el derecho de participar en la toma de decisiones en la asamblea anual ordinaria. Obtén una atractiva tasa de interés desde el primer día, con intereses acumulados anualmente.",
            imagen: "assets/productos/ahorros/aportaciones.png"),
        InformacionProducto(
            titulo: 'Cuenta Joven',
            descripcion:
                "Una cuenta para jóvenes de 13 a 17 años, para crear el buen hábito de ahorrar. Los ahorros generan ganancias desde el primer día y se acumulan anualmente. Empieza a construir tu futuro, a organizar tus finanzas y a alcanzar tus metas.",
            imagen: "assets/productos/ahorros/joven.png"),
        InformacionProducto(
            titulo: 'Peque Cuenta',
            descripcion:
                "Una cuenta diseñada para niñas y niños de 0 a 13 años, enséñales a construir un gran futuro descubriendo la mejor manera de ahorrar y obteniendo beneficios exclusivos como la participación en la asamblea infantil, la escuelita del bienestarcito y programas educativos.",
            imagen: "assets/productos/ahorros/peque-cuenta.png"),
      ],
    );
  }
}

class InformacionProducto extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String imagen;
  final dynamic lstRequisitos;

  const InformacionProducto({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    this.lstRequisitos,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> listValores = [];
    if (lstRequisitos != null) {
      Map<String, dynamic> valores = jsonDecode(lstRequisitos);
      listValores = valores.values.toList()[0];
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(),
        Text(titulo.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            )),
        Divider(),
        Text(
          descripcion,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 16),
        ),
        if (listValores.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                mostrarRequisitos(context, listValores, titulo);
              },
              icon: Icon(Icons.info, color: Colors.white),
              label: Text("Requisitos", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600], // Color del botón
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
              ),
            ),
          ),
        Image(
          image: AssetImage(imagen),
        ),
      ],
    );
  }
}
