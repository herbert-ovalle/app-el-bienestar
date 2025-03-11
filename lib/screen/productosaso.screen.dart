import 'dart:async';

import 'package:app_bienestar/class/preferences.theme.dart';
import 'package:app_bienestar/component/menu_perfil.component.dart';
import 'package:app_bienestar/models/datos_asociado.model.dart';
import 'package:app_bienestar/models/respuesta.model.dart';
import 'package:app_bienestar/providers/guardar_usuario.dart';
import 'package:app_bienestar/services/z_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    final servicioUsuario = Provider.of<UsuarioAsociadoN>(context, listen: false);

    return GestureDetector(
      onTap: () => InactivityService.resetTimer(context),
      onDoubleTap: () => InactivityService.resetTimer(context),
      onLongPress: () => InactivityService.resetTimer(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Información',
              style: TextStyle(fontSize: 20)),
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
                _futureData = servicioUsuario.datosAsociado();
              });
              await _futureData;
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context)
                      .size
                      .height, // Altura mínima de la pantalla
                ),
                child: Column(
                  children: [
                    Image.asset(
                      Preferences.isDarkmode
                          ? "assets/LOGO_BLANCO.png"
                          : "assets/LOGO_AZUL.png",
                      width: 1000,
                      height: 60,
                    ),
                    Column(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                            padding:
                                                const EdgeInsets.only(top: 15),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      _InfoAsociado(
                                          titulo: "Nombre:",
                                          subtitulo: datosUser.nombres),
                                      _InfoAsociado(
                                          titulo: "CUI:",
                                          subtitulo: datosUser.dpi),
                                      _InfoAsociado(
                                          titulo: "Teléfono:",
                                          subtitulo: datosUser.telefono),
                                      _InfoAsociado(
                                          titulo: "Correo:",
                                          subtitulo: datosUser.correoElectronico
                                              .toString()),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 4), // Margen exterior
                                        padding: EdgeInsets.all(
                                            8), // Espaciado interno
                                        decoration: BoxDecoration(
                                          color: Colors.orange[
                                              100], // Fondo amarillo suave
                                          borderRadius: BorderRadius.circular(
                                              10), // Bordes redondeados
                                          border: Border.all(
                                              color: Colors.orange[700]!,
                                              width: 1.5), // Borde llamativo
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.warning_amber_rounded,
                                                color: Colors.orange[800],
                                                size:
                                                    28), // Ícono de advertencia
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                "Nota: los saldos que se muestran a continuación corresponden a la fecha",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.orange[
                                                      900], // Texto en naranja oscuro
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
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: resDatos.captaciones.length,
                                        itemBuilder: (context, index) {
                                          return ProductosAsoS(
                                              info:
                                                  resDatos.captaciones[index]);
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      if (resDatos.colocaciones.isNotEmpty)
                                        Text("Prestamos",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                      if (resDatos.colocaciones.isNotEmpty)
                                        ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              resDatos.colocaciones.length,
                                          itemBuilder: (context, index) {
                                            return ProductosAsoS(
                                                info: resDatos
                                                    .colocaciones[index]);
                                          },
                                        ),
                                      SizedBox(height: 10),
                                      if (resDatos.solicitudes.isNotEmpty)
                                        Text("Solicitudes de producto:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20)),
                                      if (resDatos.solicitudes.isNotEmpty)
                                        ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              resDatos.solicitudes.length,
                                          itemBuilder: (context, index) {
                                            return Dismissible(
                                              key: ValueKey(UniqueKey),
                                              direction:
                                                  DismissDirection.endToStart,
                                              background: Container(
                                                color: Colors
                                                    .red, // Fondo rojo al deslizar
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(Icons.delete,
                                                    color: Colors.white,
                                                    size:
                                                        30), // Ícono de eliminar
                                              ),
                                              confirmDismiss:
                                                  (direction) async {
                                                return await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text(
                                                        "Eliminar solicitud"),
                                                    content: Text(
                                                        "¿Estás seguro de que deseas eliminar esta solicitud?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator
                                                                .of(context)
                                                            .pop(
                                                                false), // No eliminar
                                                        child: Text("Cancelar"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () => Navigator
                                                                .of(context)
                                                            .pop(
                                                                true), // Confirmar eliminación
                                                        child: Text("Eliminar",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              onDismissed: (direction) async {
                                                final resS = await servicioUsuario
                                                    .eliminarSolicitud(resDatos
                                                        .solicitudes[index]);
                                                // ignore: use_build_context_synchronously
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(resS.mensaje)),
                                                );
                                              },
                                              child: SolicitudesAsociadoScren(
                                                  e: resDatos
                                                      .solicitudes[index]),
                                            );
                                          },
                                        ),
                                      SizedBox(height: 10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: children),
                              );
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() {
              InactivityService.resetTimer(context);
              _futureData = servicioUsuario.datosAsociado();
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

class SolicitudesAsociadoScren extends StatelessWidget {
  const SolicitudesAsociadoScren({
    super.key,
    required this.e,
  });

  final SolicitudesRegistra e;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Sombra para destacar la tarjeta
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
      ),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e.producto,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getEstadoColor(e.estadoSolicitud), // Color dinámico
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    e.estadoSolicitud,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fecha: ${_formatFecha(e.fechaRegistro)}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                IconButton(onPressed: (){}, icon: Icon(Icons.remove_red_eye_outlined))

              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case "pendiente":
        return Colors.orange;
      case "aprobado":
        return Colors.green;
      case "cancelada":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  // Función para formatear la fecha
  String _formatFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }
}

class ProductosAsoS extends StatelessWidget {
  const ProductosAsoS({
    super.key,
    required this.info,
  });
  final Captacione info;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: 4, horizontal: 6), // Espaciado externo
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

          SizedBox(height: 2), // Espacio entre textos

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
                  Icon(Icons.account_balance_wallet,
                      color: Colors.green[700], size: 20), // Ícono de billetera
                  SizedBox(width: 4),
                  Text(
                    formatoMoneda(info.montoDisponible), // Monto formateado
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors
                          .green[700], // Verde para resaltar saldo positivo
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
