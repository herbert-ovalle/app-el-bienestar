import 'dart:async';

import 'package:app_bienestar/class/preferences.theme.dart';
import 'package:app_bienestar/component/menu_perfil.component.dart';
import 'package:app_bienestar/models/datosUsuario.model.dart';
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
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    Preferences.isDarkmode
                        ? "assets/LOGO_BLANCO.png"
                        : "assets/LOGO_AZUL.png",
                    width: 1000,
                    height: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
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

                          final datosUser =
                              RegistroUsuario.fromJson(res.datos![0]);
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _InfoAsociado(
                                    titulo: "Nombre",
                                    subtitulo: datosUser.nombres),
                                _InfoAsociado(
                                    titulo: "CUI",
                                    subtitulo: datosUser.usuario.toString()),
                                _InfoAsociado(
                                    titulo: "Teléfono",
                                    subtitulo: datosUser.telefono.toString()),
                                _InfoAsociado(
                                    titulo: "Dirección",
                                    subtitulo: datosUser.direccion.toString()),
                                SizedBox(height: 20),
                                Text("Prestamos:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                ...res.datos!.map((e) => Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(e.toString()),
                                    )),
                                Text("Solicitudes:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                SizedBox(height: 50),
                                Text("Ahorros:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                SizedBox(height: 50),
                                Text("Servicios:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20))
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
