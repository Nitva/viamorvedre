import 'package:flutter/material.dart';

class AppTheme {
  // 1. Eliges tu color de marca
  static const Color _brandColor = Color(0xFF6750A4); // Un violeta clásico de M3

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // 2. Generamos todo el esquema desde la semilla
      colorScheme: ColorScheme.fromSeed(
        seedColor: _brandColor,
        brightness: Brightness.light,
        // Puedes personalizar colores específicos si no te gusta el generado:
        primary: _brandColor, 
        surface: Colors.grey[50], 
      ),
      // Configuración extra para que los componentes se vean modernos
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _brandColor,
        brightness: Brightness.dark,
      ),
    );
  }
}