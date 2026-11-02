import 'package:flutter/material.dart';

void main() {
  runApp(const FitKarmaApp());
}

class FitKarmaApp extends StatelessWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0F12),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF22C55E),
          surface: Color(0xFF16191E),
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'FitKarma Health OS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
