
import 'package:flutter/services.dart';


class ReproductorMusic{
 
  final platform = MethodChannel('com.example.musicplayer/channel');

  Future<bool> validarReproductor() async {
    return await platform.invokeMethod<bool>('isMusicPlaying') ?? false;
  }

  Future<void> playMusic() async {
    await platform.invokeMethod('playMusic');
  }

  Future<void> pauseMusic() async {
    await platform.invokeMethod('pauseMusic');
  }

  Future<void> stopMusic() async {
    await platform.invokeMethod('stopMusic');
  }

  Future<void> ajusteVolumen(int volumen) async {
    await platform.invokeMethod('ajusteVolumen',{'ajuste': volumen});
  }

}