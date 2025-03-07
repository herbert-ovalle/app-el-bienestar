import 'dart:async';

import 'package:app_bienestar/class/preferences.theme.dart';
import 'package:app_bienestar/component/menu_perfil.component.dart';
import 'package:app_bienestar/models/datos_asociado.model.dart';
import 'package:app_bienestar/models/respuesta.model.dart';
import 'package:app_bienestar/providers/guardar_usuario.dart';
import 'package:app_bienestar/services/z_service.dart';
import 'package:flutter/material.dart';

class InformacionAsociado extends StatefulWidget {
  const InformacionAsociado({super.key, required this.usuario});
  final String usuario;

  @override
  State<InformacionAsociado> createState() => _InformacionAsociadoState();
}

class _InformacionAsociadoState extends State<InformacionAsociado> {
  late Future<Respuesta> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData =
        UsuarioAsociadoN().datosAsociado(); // 🔹 Cargar datos al iniciar
    InactivityService.startTracking(context);
  }

  @override
  void dispose() {
    _futureData.ignore();
    InactivityService.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();

    return GestureDetector(
      onTap: () => InactivityService.resetTimer(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Información del asociado',
              style: TextStyle(fontSize: 16)),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                  child: ProfileIcon(
                items: [
                  PopupMenuItem<Menu>(
                    value: Menu.itemFour,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, "/home");
                    },
                    child: MenuLista(icono: Icons.exit_to_app, texto: 'Salir'),
                  )
                ],
              )),
            )
          ],
        ),
        body: RefreshIndicator(
            key: refreshIndicatorKey,
            color: Colors.white,
            backgroundColor: Colors.blue,
            strokeWidth: 2.0,
            onRefresh: () async {
              setState(() {
                InactivityService.resetTimer(context);
                _futureData = UsuarioAsociadoN().datosAsociado();
              });
              await _futureData;
            },
            child: Column(
              children: [
                 Image.asset(
                  Preferences.isDarkmode
                      ? "assets/LOGO_BLANCO.png"
                      : "assets/LOGO_AZUL.png",
                  width: 1000,
                  height: 60,
                ),
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FutureBuilder(
                          future: _futureData,
                          builder: (BuildContext context,
                              AsyncSnapshot<Respuesta> snapshot) {
                            List<Widget> children;
                            if (snapshot.hasData) {
                              final res = snapshot.data!;
                              if (res.respuesta != "success") {
                                if (res.eliSess == 1) {
                                  SaveLocal().deleteAll().then((_) => {});
                                }
                
                                return Center(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                            res.respuesta == "info"
                                                ? Icons.info
                                                : Icons.error_outline,
                                            color: res.respuesta == "info"
                                                ? Colors.blue
                                                : Colors.red,
                                            size: 60),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 15),
                                          child: Text(res.mensaje,
                                              style: TextStyle(fontSize: 18)),
                                        ),
                                      ]),
                                );
                              }
                
                              final resDatos =
                                  DatosAsociado.fromJson(res.datos![0]);
                              final datosUser = resDatos.infoAsociado;
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _InfoAsociado(
                                        titulo: "Nombre:",
                                        subtitulo: datosUser.nombres),
                                    _InfoAsociado(
                                        titulo: "CUI:", subtitulo: datosUser.dpi),
                                    _InfoAsociado(
                                        titulo: "Teléfono:",
                                        subtitulo: datosUser.telefono),
                                    _InfoAsociado(
                                        titulo: "Correo:",
                                        subtitulo:
                                            datosUser.correoElectronico.toString()),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4), // Margen exterior
                                      padding: EdgeInsets.all(8), // Espaciado interno
                                      decoration: BoxDecoration(
                                        color: Colors.orange[100], // Fondo amarillo suave
                                        borderRadius: BorderRadius.circular(10), // Bordes redondeados
                                        border: Border.all(color: Colors.orange[700]!, width: 1.5), // Borde llamativo
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.warning_amber_rounded, color: Colors.orange[800], size: 28), // Ícono de advertencia
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              "Nota: los saldos que se muestran a continuación corresponden a la fecha",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.orange[900], // Texto en naranja oscuro
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text("Ahorros",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    ...resDatos.captaciones.map((e) => ProductosAsoS(
                                              info: e,
                                            )),
                                    SizedBox(height: 10),
                                    if (resDatos.colocaciones.isNotEmpty)
                                      Text("Prestamos",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                    ...resDatos.colocaciones
                                        .map((e) => ProductosAsoS(info: e,)),
                                    SizedBox(height: 10),
                                    if (resDatos.solicitudes.isNotEmpty)
                                      Text("Solicitudes:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                    SizedBox(height: 50),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                const Icon(Icons.error_outline,
                                    color: Colors.red, size: 60),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text('Error: ${snapshot.error}'),
                                ),
                              ];
                            } else {
                              children = const <Widget>[
                                SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator()),
                                Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text('Consultado...')),
                              ];
                            }
                            return Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: children),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              InactivityService.resetTimer(context);
              _futureData = UsuarioAsociadoN().datosAsociado();
            });
            await _futureData;
          },
          backgroundColor: Colors.blueAccent, // 🎨 Color más llamativo
          shape: const CircleBorder(),
          elevation: 10,
          child: const Icon(Icons.refresh, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}

class ProductosAsoS extends StatelessWidget {
  const ProductosAsoS({
    super.key, required this.info,
  });
  final Captacione info;

  @override
  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.symmetric(
          vertical: 4, horizontal: 6), // Espaciado externo
      padding: EdgeInsets.all(10), // Espaciado interno
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Sombra suave
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Encabezado con tipo de cuenta y número
          Text(
            info.tipoProducto, // Tipo de cuenta
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900], // Azul corporativo
            ),
          ),
          Text(
            "Cuenta: ${info.numeroCuenta}", // Número de cuenta
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700], // Texto gris sutil
            ),
          ),

          SizedBox(height: 3), // Espacio entre textos

          // Monto Disponible con icono
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Disponible:",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.green[700], size: 20), // Ícono de billetera
                  SizedBox(width: 4),
                  Text(
                    formatoMoneda(info.montoDisponible), // Monto formateado
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700], // Verde para resaltar saldo positivo
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoAsociado extends StatelessWidget {
  const _InfoAsociado({
    required this.titulo,
    required this.subtitulo,
  });
  final String subtitulo;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          titulo,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(width: 5),
        Text(subtitulo,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(fontSize: 15.5)),
      ],
    );
  }
}
