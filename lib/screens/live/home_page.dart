import 'package:flutter/material.dart';
import 'package:viamorvedre/core/database/app_database.dart';
import 'package:viamorvedre/core/database/gtfs_parser.dart';
import 'package:viamorvedre/screens/live/pantalla.dart';

class MyHomePage extends StatelessWidget {
  final AppDatabase db;

  const MyHomePage({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ViaMorvedre'), centerTitle: true),
      body: Center(
        // Cambiamos a Column para poder poner varios botones apilados
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await GtfsImporter.cargarDatosGtfs(db);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Buses cargados en la base de datos'),
                  ),
                );
              },
              child: const Text('Cargar datos de Autobuses'),
            ),

            const SizedBox(height: 20), // Un poquito de espacio entre botones
            // --- NUEVO BOTÓN ---
            ElevatedButton(
              onPressed: () {
                // Usamos Navigator.push para ir a la nueva pantalla
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaBuses(db: db),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Ver Buses por Sagunto',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
