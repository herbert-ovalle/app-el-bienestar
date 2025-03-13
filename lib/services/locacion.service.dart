import 'package:app_bienestar/models/z_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Respuesta> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;


  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {

    return Respuesta(respuesta: 'info', mensaje: 'Active la ubicación del teléfono.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {

      return Respuesta(respuesta: 'warning', mensaje:'Permisos denegados de lacalización');
    }
  }

  if (permission == LocationPermission.deniedForever) {

    return Respuesta(respuesta: 'warning', mensaje: 
        'Localizacion y permisos negados a la aplicación');
  }

  final position = await Geolocator.getCurrentPosition();
  return Respuesta(respuesta: 'success', mensaje: 'Localización activada', datos: [LatLng(position.latitude, position.longitude) ]);
}
