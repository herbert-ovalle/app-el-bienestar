import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  const MarqueeText({super.key, required this.titulo, required this.maxText});

  final Widget titulo;
  final double maxText;

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double screenWidth = 400;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation =
        Tween<double>(begin: screenWidth, end: -widget.maxText).animate(_controller);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;

      setState(() {
        _animation = Tween<double>(begin: screenWidth, end: -widget.maxText)
            .animate(_controller);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_animation.value, 0),
              child: widget.titulo,
            );
          },
        ),
      ),
    );
  }
}
