// Método para mostrar los requisitos en un AlertDialog
import 'package:app_bienestar/class/preferences.theme.dart';
import 'package:app_bienestar/models/z_model.dart';
import 'package:flutter/material.dart';

void mostrarRequisitos(
    BuildContext context, List<dynamic> lstRequisito, String titulo) {
  List<IconData> lstIconos = [Icons.check_circle, Icons.emoji_events];

  List<String> lstIconosIni = ["✅", "💰"];
  List<RequisitosProducto> lstRe = lstRequisito
      .asMap()
      .entries
      .map((valor) => RequisitosProducto.fromJson({
            ...valor.value,
            "icono": lstIconos[valor.key],
            "iconIni": lstIconosIni[valor.key]
          }))
      .toList();

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero, // Espaciado interno,
        child: Container(
          color: Colors.black12,
          width: MediaQuery.of(context).size.width * 0.94,
          child: Card(
            color: Preferences.isDarkmode ? Colors.grey[700] : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4, // Sombra para mejor apariencia
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // 🔹 Se ajusta al contenido
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // Título del diálogo
                  Center(
                    child: Text(
                      titulo,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
        
                  // Contenido dinámico
                  ...lstRe.map((e1) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(e1.icono, color: Colors.green, size: 28),
                              SizedBox(width: 10),
                              Text(
                                e1.titulo,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          ...e1.datos
                              .map((e2) => _requisitoItem("${e1.iconIni} $e2"))
                        ],
                      )),
        
                  SizedBox(height: 20),
        
                  // Botón de Cerrar
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.red),
                        ),
                      ),
                      child: Text("Cerrar", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

// Widget para cada ítem de requisito
Widget _requisitoItem(String texto) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Icon(Icons.arrow_right, color: Colors.blue),
        SizedBox(width: 5),
        Expanded(child: Text(texto, style: TextStyle(fontSize: 14))),
      ],
    ),
  );
}
