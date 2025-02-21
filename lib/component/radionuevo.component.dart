import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RadioPlayerScreen extends StatelessWidget {
  const RadioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
            ),
          ),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            
            const SizedBox(height: 20),

            const Text(
              "Radio cooperativa el bienestar",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const Text(
              "Estamos en linea...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Slider(
                value: 0.5,
                onChanged: (value) {}, // Función para cambiar volumen
                activeColor: Colors.white,
                inactiveColor: Colors.white30,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_down, color: Colors.white),
                  onPressed: () {}, // Baja el volumen
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.white),
                  onPressed: () {}, // Sube el volumen
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Iconos de redes sociales
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon(FontAwesomeIcons.instagram),
                _socialIcon(FontAwesomeIcons.twitter),
                _socialIcon(FontAwesomeIcons.facebook),
                _socialIcon(FontAwesomeIcons.globe),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Botón de reproducción
            FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              child:
                  const Icon(Icons.play_arrow, size: 30, color: Colors.white),
              onPressed: () {}, // Acción de reproducción
            ),
          ],
        ),
      ],
    );
  }

  // Widget para crear botones de redes sociales
  Widget _socialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
