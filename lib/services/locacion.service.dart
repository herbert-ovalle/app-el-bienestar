import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;


  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {

    return Future.error('Active la ubicación del teléfono.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {

      return Future.error('Permisos denegados de lacalización');
    }
  }

  if (permission == LocationPermission.deniedForever) {

    return Future.error(
        'Localizacion y permisos negados a la aplicación');
  }

  return await Geolocator.getCurrentPosition();
}
