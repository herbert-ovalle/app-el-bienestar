import 'package:flutter/material.dart';
import 'screen/screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación del Bienestar',
      theme: ThemeData(
        primarySwatch: Colors.red, 
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 1, 2, 58),
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      initialRoute: "/home",
      routes: {
        "/home": (BuildContext context) => const HomeScreen(),
        "/config": (BuildContext context) => const ConfigScreen(),
      },
    );
  }
}
