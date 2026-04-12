import 'package:flutter/material.dart';
import 'package:viamorvedre/core/database/app_database.dart';
import 'package:viamorvedre/core/database/gtfs_parser.dart';
import 'package:viamorvedre/features/navigation/main_layout.dart';

class MyHomePage extends StatefulWidget {
  final AppDatabase db;

  const MyHomePage({super.key, required this.db});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadDataOnStartup();
  }

  Future<void> _loadDataOnStartup() async {
    try {
      await GtfsImporter.cargarDatosGtfs(widget.db);
      setState(() {
        _dataLoaded = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar datos: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dataLoaded) {
      return MainLayout(db: widget.db);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ViaMorvedre'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando datos de autobuses...'),
                ],
              )
            else
              Column(
                children: [
                  const Text(
                    'Bienvenido a ViaMorvedre',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Transporte público en tiempo real',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await GtfsImporter.cargarDatosGtfs(widget.db);
                      if (mounted) {
                        setState(() {
                          _dataLoaded = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Cargar datos de Autobuses',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
