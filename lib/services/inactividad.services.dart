import 'dart:async';
import 'package:app_bienestar/screen/home.screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InactivityService {
  static Timer? _inactivityTimer;
  static const Duration timeoutDuration = Duration(seconds: 58);

  ///inicio de la verificacion
  static void startTracking(BuildContext context) {
    resetTimer(context);

    WidgetsBinding.instance.addObserver(
      _LifecycleEventHandler(
        resumeCallBack: () => resetTimer(context),
        suspendingCallBack: () => stopTracking(),
      ),
    );
  }

  static Future<void> resetTimer(BuildContext context) async {
    stopTracking();
    print(timeoutDuration);
    _inactivityTimer = Timer(timeoutDuration, () => _logout(context));
  }

  /// Detiene el seguimiento de inactividad
  static Future<void> stopTracking() async {
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
  }

  /// Cierra sesión cuando hay inactividad prolongada
  static Future<void> _logout(BuildContext context) async {
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false, // Elimina todas las rutas anteriores
    );
  }
}

/// Maneja los eventos del ciclo de vida de la aplicación (Foreground/Background)
class _LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  _LifecycleEventHandler({
    required this.resumeCallBack,
    required this.suspendingCallBack,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resumeCallBack();
    } else if (state == AppLifecycleState.paused) {
      suspendingCallBack();
    }
  }
}
