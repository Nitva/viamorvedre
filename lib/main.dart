import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/export.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ViaMorvedre',
      theme: AppTheme.lightTheme, // Tema claro
      darkTheme: AppTheme.darkTheme, // Tema oscuro
      themeMode: ThemeMode.system, // Usa el del sistema
      home: const MyHomePage(),
    );
  }
}
