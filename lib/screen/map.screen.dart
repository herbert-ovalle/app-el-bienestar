import 'dart:async';
import 'package:app_bienestar/services/locacion.service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Set<Marker> _markers = {};
  late Position res;
  bool _cargando = true;
  MapType _tipoMapa = MapType.terrain;
  final Set<Polyline> _rutas = {};
  late Future<void> _future;
  CameraPosition inicialMapa = CameraPosition(
    target: LatLng(14.844047316052663, -91.52202836401338),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _future = cargarDatos();
  }

  @override
  void dispose() {
    _future.ignore();
    super.dispose();
  }

  Future<void> cargarDatos() async {
    res = await determinePosition();
    _markers.add(
      Marker(
          markerId: const MarkerId("ubicacion_actual"),
          position: LatLng(res.latitude, res.longitude),
          infoWindow: const InfoWindow(title: "Mi Ubicación"),
          draggable: true,
          onTap: () {
            _actualizarZoom(CameraPosition(
                target: LatLng(res.latitude, res.longitude), zoom: 20.00));
          }),
    );

    setState(() {
      _actualizarZoom(CameraPosition(
          target: LatLng(res.latitude, res.longitude), zoom: 17.00));
      _cargando = false;
    });
    // Esperar a que el mapa se inicialice y mostrar InfoWindow
    Future.delayed(const Duration(milliseconds: 500), () async {
      final controller = await _controller.future;
      controller.showMarkerInfoWindow(const MarkerId("ubicacion_actual"));
    });
  }

  @override
  Widget build(BuildContext context) {
    void cambiarTipoMapa() {
      setState(() {
        _tipoMapa = _tipoMapa == MapType.normal
            ? MapType.satellite
            : _tipoMapa == MapType.satellite
                ? MapType.hybrid
                : _tipoMapa == MapType.hybrid
                    ? MapType.terrain
                    : MapType.normal;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Agencias cooperativa el bienestar",
            style: TextStyle(fontSize: 16),
          ),
          bottom: _cargando // Solo muestra la barra si está cargando
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(5.0),
                  child: LinearProgressIndicator(
                    color: Colors.redAccent,
                  ),
                )
              : null,
        ),
        body: Stack(children: [
          GoogleMap(
            mapType: _tipoMapa,
            initialCameraPosition: inicialMapa,
            polylines: _rutas,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 5,
            right: 50,
            child: Row(
              children: [
                FloatingActionButton.small(
                  heroTag: "tipoMapa",
                  onPressed: cambiarTipoMapa,
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.map),
                ),
                const SizedBox(width: 10),
                FloatingActionButton.small(
                  heroTag: "miUbicacion",
                  onPressed: () async {
                    await _actualizarZoom(CameraPosition(
                        target: LatLng(res.latitude, res.longitude),
                        zoom: 16.00));
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          )
        ]));
  }

  Future<void> _actualizarZoom(CameraPosition camera) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(camera));
  }
}
