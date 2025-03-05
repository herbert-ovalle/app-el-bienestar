import 'package:app_bienestar/class/preferences.theme.dart';
import 'package:app_bienestar/providers/registro_user.dart';
import 'package:app_bienestar/themes/tema_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screen/screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Preferences.init();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) => ThemeProvider(isDarkmode: Preferences.isDarkmode))
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => DatosUsuarioProvider()),
      ],
      child: MaterialApp(
        title: 'Aplicación del Bienestar',
        theme: Provider.of<ThemeProvider>(context).currentTheme,
        debugShowCheckedModeBanner: false,
        locale: const Locale('es', 'ES'),
        supportedLocales: const [
          Locale('es', 'ES'), // Español
          Locale('en', 'US'), // Inglés (opcional)
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const HomeScreen(),
        initialRoute: "/home",
        routes: {
          "/home": (BuildContext context) => const HomeScreen(),
          "/config": (BuildContext context) => const ConfigScreen(),
        },
      ),
    );
  }
}
