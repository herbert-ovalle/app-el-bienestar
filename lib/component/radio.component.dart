import 'dart:async';
import 'package:app_bienestar/component/pageview.component.dart';
import 'package:app_bienestar/services/conectar.services.dart';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreen();
}

class _MusicPlayerScreen extends State<MusicPlayerScreen>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _playPauseController;
  double _volume = 0.5; // Rango entre 0.0 y 1.0
  late Timer _colorChangeTimer;
  final List<Color> _colors = [
    Colors.blue,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.orange
  ];
  int _colorIndex = 0;
  Color _currentColor = Colors.blue;

  @override
  void initState(){
    super.initState();
    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _checkInitialState();
    ReproductorMusic().obtenerVolumen().then(
      (volumen) => {
        _volume = volumen
    });

  }

  @override
  void didUpdateWidget(MusicPlayerScreen oldWidget) async {
    //_volume = await ReproductorMusic().obtenerVolumen();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _playPauseController.dispose();
    if(_isPlaying){
        _colorChangeTimer.cancel(); 
    }
    super.dispose();
  }

  Future<void> _checkInitialState() async {
    bool isPlaying = await ReproductorMusic().validarReproductor();
    if(isPlaying){
       _startColorChangeAnimation();
    }
    setState(() {
      _isPlaying = isPlaying;
    });
  }

  Future<void> playMusic() async {
    await ReproductorMusic().playMusic();
    _startColorChangeAnimation();
    setState(() {
      _isPlaying = true;
      //_playPauseController.forward();
    });
  }

  Future<void> stopMusic() async {
    await ReproductorMusic().stopMusic();
     _colorChangeTimer.cancel();
    setState(() {
      _isPlaying = false;
      _playPauseController.reverse();
    });
  }

  Future<void> pauseMusic() async {
    await ReproductorMusic().pauseMusic();
     _colorChangeTimer.cancel();
    setState(() {
      _isPlaying = false;
      _playPauseController.reverse();
    });
  }

  void changeVolume(double value) async {
    int volMusic = (value * 100).toInt();
    await ReproductorMusic().ajusteVolumen(volMusic);

    setState(() {
      _volume = value;
    });
  }

  void _startColorChangeAnimation() {
    _colorChangeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _colorIndex =
            (_colorIndex + 1) % _colors.length; // Ciclo entre los colores
        _currentColor = _colors[_colorIndex];
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.35, child: PageViewExample(
            lstTitulos: [
              "Ahorros el Bienestar",
              "Prestamos el Bienestar",
              "Seguros Columna",
              "Remesas el Bienestar",
            ], lstImagenes: [
              "assets/Productos-Ahorro.png",
              "assets/Prestamos-El-Bienestar.png",
              "assets/Seguros-Columna.png",
              "assets/Remesas.png",
            ],)),
          SizedBox(height: 20),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: _isPlaying ? 120 : 100,
            width: _isPlaying ? 120 : 100,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: _currentColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.music_note, size: 60, color: Colors.blue),
          ),
          const SizedBox(height: 10),
          Text(
            'Radio Cooperativa el Bienestar en vivo',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AsyncButtonBuilder(
                loadingWidget: Text('Cargando...'),
                onPressed: _isPlaying ? pauseMusic : playMusic,
                builder: (context, child, callback, buttonState) {
                  final buttonColor = buttonState.when(
                    idle: () => Colors.transparent,
                    loading: () => Colors.grey,
                    success: () => Colors.green,
                    error: (err, stack) => Colors.orange,
                  );
                  return IconButton(
                    iconSize: 50,
                    icon: AnimatedIcon(
                      icon: _isPlaying
                          ? AnimatedIcons.pause_play
                          : AnimatedIcons.play_pause,
                      progress: _playPauseController,
                    ),
                    onPressed: callback,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(buttonColor),
                      shape: WidgetStateProperty.all(CircleBorder()),
                    ),
                  );
                },
                child: const Text(''),
              ),
           
              const SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.stop, size: 40),
                onPressed: stopMusic,
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Control de volumen con Slider
          Column(
            children: [
              Text(
                'Volumen',
                style: TextStyle(fontSize: 16),
              ),
              Slider(
                value: _volume,
                min: 0.0,
                max: 1.0,
                onChanged: changeVolume,
                divisions: 10,
                label: '${(_volume * 100).toInt()}%',
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
