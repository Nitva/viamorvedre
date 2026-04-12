import 'package:flutter/material.dart';
import 'package:viamorvedre/core/database/app_database.dart';
import 'package:viamorvedre/core/providers/idioma_provider.dart';
import 'package:viamorvedre/core/utils/language_formater.dart';
import 'package:viamorvedre/features/en_vivo/en_vivo_screen.dart';
import 'package:viamorvedre/features/lineas/lineas_screen.dart';
import 'package:viamorvedre/features/lineas/linea_detalle_screen.dart';
import 'package:viamorvedre/features/settings/ajustes_screen.dart';

class MainLayout extends StatefulWidget {
  final AppDatabase db;

  const MainLayout({super.key, required this.db});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  String? _selectedLineId;
  IdiomaApp _idiomaActual = IdiomaApp.castellano;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      EnVivoScreen(db: widget.db, idioma: _idiomaActual),
      LineasScreen(
        db: widget.db,
        onLineSelected: _selectLine,
        idioma: _idiomaActual,
      ),
      const AjustesScreen(),
    ];
  }

  void _selectLine(String lineId) {
    setState(() {
      _selectedLineId = lineId;
    });
  }

  void _backFromDetail() {
    setState(() {
      _selectedLineId = null;
    });
  }

  void _cambiarIdioma(IdiomaApp nuevoIdioma) {
    setState(() {
      _idiomaActual = nuevoIdioma;
      IdiomaProvider.setIdioma(nuevoIdioma);
      // Reconstruir screens con nuevo idioma
      _screens[0] = EnVivoScreen(db: widget.db, idioma: _idiomaActual);
      _screens[1] = LineasScreen(
        db: widget.db,
        onLineSelected: _selectLine,
        idioma: _idiomaActual,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Si hay una línea seleccionada, mostrar detalle
    if (_selectedLineId != null) {
      return LineaDetalleScreen(
        routeId: _selectedLineId!,
        db: widget.db,
        onBack: _backFromDetail,
        idioma: _idiomaActual,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ViaMorvedre'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<IdiomaApp>(
            onSelected: _cambiarIdioma,
            icon: const Icon(Icons.language),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<IdiomaApp>>[
              const PopupMenuItem<IdiomaApp>(
                value: IdiomaApp.castellano,
                child: Text('🇪🇸 Castellano'),
              ),
              const PopupMenuItem<IdiomaApp>(
                value: IdiomaApp.valenciano,
                child: Text('🦇 Valencià'),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'En vivo',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Líneas'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}
