import 'package:app_bienestar/component/formulario.component.dart';
import 'package:flutter/material.dart';

class RegistroButton extends StatefulWidget {
  const RegistroButton({super.key});

  @override
  State<RegistroButton> createState() => _RegistroButtonState();
}

class _RegistroButtonState extends State<RegistroButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar la animación de escala al presionar
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.9,
      upperBound: 1.0,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTapDown: (_) =>
            _controller.reverse(), // Disminuye tamaño al presionar
        onTapUp: (_) {
          _controller.forward(); // Vuelve al tamaño original
          Future.delayed(const Duration(milliseconds: 100), () {
            Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => FormularioComponent()),
            );
          });
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent, // Color vibrante
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.blueAccent.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nuevo Ícono animado
                  Icon(Icons.app_registration, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  // Texto atractivo
                  Text(
                    "Registrarse Ahora",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

