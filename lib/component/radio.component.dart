import 'dart:async';
import 'package:app_bienestar/class/preferences.theme.dart';
import 'package:app_bienestar/component/pageview.component.dart';
import 'package:app_bienestar/services/z_service.dart';

import 'package:async_button_builder/async_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  void initState() {
    super.initState();
    _playPauseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _checkInitialState();
    ReproductorMusic().obtenerVolumen().then((volumen) => {_volume = volumen});
  }

  @override
  void didUpdateWidget(MusicPlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (!_isPlaying) {
      _playPauseController.dispose();
      
    }else{
      _colorChangeTimer.cancel();
    }
    super.dispose();
  }

  Future<void> _checkInitialState() async {
    bool isPlaying = await ReproductorMusic().validarReproductor();
    if (isPlaying) {
      _startColorChangeAnimation();
      _playPauseController.forward();
    } else {
      _playPauseController.reverse();
    }

    setState(() {
      _isPlaying = isPlaying;
    });
  }

  Future<void> playMusic() async {
    final res = await ReproductorMusic().playMusic();
    if(res == "success"){
      _startColorChangeAnimation();
      setState(() {
        _isPlaying = true;
      });
      _playPauseController.forward();
    }
  }

  Future<void> stopMusic() async {
    await ReproductorMusic().stopMusic();
    _colorChangeTimer.cancel();
    setState(() {
      _isPlaying = false;
    });
    _playPauseController.reverse();
  }

  Future<void> pauseMusic() async {
    await ReproductorMusic().pauseMusic();
    _colorChangeTimer.cancel();
    setState(() {
      _isPlaying = false;
    });
    _playPauseController.reverse();
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

    return Column(
      children: [
        SizedBox(
            height: screenHeight * 0.35,
            child: PageViewExample(
              lstTitulos: [
                "Ahorros el Bienestar",
                "Prestamos el Bienestar",
                "Seguros Columna",
                "Remesas el Bienestar",
              ],
              lstImagenes: [
                "assets/Productos-Ahorro.png",
                "assets/Prestamos-El-Bienestar.png",
                "assets/Seguros-Columna.png",
                "assets/Remesas.png",
              ],
            )),
        SizedBox(height: 10),
        Expanded(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: Preferences.isDarkmode
                        ? [
                            const Color.fromARGB(255, 35, 35, 35),
                            Color.fromARGB(255, 31, 31, 31)
                          ]
                        : [Color(0xFF2196F3), Color(0xFF64B5F6)],
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: _isPlaying ? 120 : 100,
                      width: _isPlaying ? 120 : 100,
                      child: Icon(
                        Icons.radio,
                        size: 100,
                        // ignore: deprecated_member_use
                        color: _currentColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                              icon: AnimatedIcons.play_pause,
                              progress: _playPauseController,
                            ),
                            onPressed: callback,
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(buttonColor),
                              shape: WidgetStateProperty.all(CircleBorder()),
                            ),
                          );
                        },
                        child: const Text(''),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.stop, size: 40),
                        onPressed: _isPlaying  ? stopMusic : null,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        valueIndicatorTextStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        valueIndicatorColor: Colors.blueAccent,
                      ),
                      child: Slider(
                        value: _volume,
                        min: 0.0,
                        max: 1.0,
                        onChanged: _isPlaying ? changeVolume : null,
                        onChangeEnd: changeVolume,
                        divisions: 10,
                        label: '${(_volume * 100).toInt()}%',
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon(FontAwesomeIcons.instagram),
                      _socialIcon(FontAwesomeIcons.twitter),
                      _socialIcon(FontAwesomeIcons.facebook),
                      _socialIcon(FontAwesomeIcons.globe),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
