import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const TaxiAleApp());
}

class TaxiAleApp extends StatelessWidget {
  const TaxiAleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taxi Ale',
      theme: ThemeData(
        fontFamily: 'sans-serif',
      ),
      home: const SplashScreen(),
    );
  }
}