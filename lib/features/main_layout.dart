import 'package:flutter/material.dart';
import 'package:viamorvedre/core/models/linea_model.dart';
import 'package:viamorvedre/features/en_vivo_screen.dart';
import 'package:viamorvedre/features/lineas_screen.dart';
import 'package:viamorvedre/features/linea_detalle_screen.dart';
import 'package:viamorvedre/features/ajustes_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  Linea? _selectedLinea;

  final List<String> _titles = ['En Vivo', 'Líneas', 'Ajustes'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedLinea = null;
    });
  }

  void _selectLinea(Linea linea) {
    setState(() {
      _selectedLinea = linea;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedLinea = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;

    if (_selectedLinea != null) {
      currentScreen = LineaDetalleScreen(linea: _selectedLinea!);
    } else {
      switch (_selectedIndex) {
        case 0:
          currentScreen = const EnVivoScreen();
          break;
        case 1:
          currentScreen = LineasScreenWithNav(onLineaSelected: _selectLinea);
          break;
        case 2:
          currentScreen = const AjustesScreen();
          break;
        default:
          currentScreen = const EnVivoScreen();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        if (_selectedLinea != null) {
          _clearSelection();
          return false;
        }
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _selectedLinea != null
                ? 'Línea ${_selectedLinea!.numero}'
                : _titles[_selectedIndex],
          ),
          automaticallyImplyLeading: _selectedLinea != null,
        ),
        body: currentScreen,
        bottomNavigationBar: _selectedLinea == null
            ? BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.directions_bus),
                    label: 'En vivo',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'Líneas',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Ajustes',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              )
            : null,
      ),
    );
  }
}

class LineasScreenWithNav extends StatelessWidget {
  final Function(Linea) onLineaSelected;

  const LineasScreenWithNav({super.key, required this.onLineaSelected});

  @override
  Widget build(BuildContext context) {
    return LineasScreen(onLineaSelected: onLineaSelected);
  }
}
