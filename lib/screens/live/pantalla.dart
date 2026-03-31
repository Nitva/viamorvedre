import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:viamorvedre/core/database/app_database.dart'; // Ajusta esta ruta a tu proyecto

class PantallaBuses extends StatelessWidget {
  final AppDatabase db;

  const PantallaBuses({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buses en Sagunto/Puerto'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      // FutureBuilder "escucha" a la base de datos
      body: FutureBuilder<List<drift.TypedResult>>(
        future: db.getBusesPorSagunto(),
        builder: (context, snapshot) {
          // 1. Mientras está cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Buscando rutas...'),
                ],
              ),
            );
          }
          // 2. Si ocurre un error
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // 3. Si la consulta termina pero no hay datos
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay buses programados.'));
          }

          // 4. Si tenemos datos, los guardamos en una variable
          final resultados = snapshot.data!;

          // Dibujamos la lista
          return ListView.builder(
            itemCount: resultados.length,
            itemBuilder: (context, index) {
              final fila = resultados[index];

              // Magia de Drift: Así sacamos los datos de las diferentes tablas
              // que unimos en el JOIN de tu método getBusesPorSagunto()
              final parada = fila.readTable(db.stops);
              final horario = fila.readTable(db.stopTimes);
              final ruta = fila.readTable(db.routes);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    // Mostramos el nombre corto de la ruta (ej. L115)
                    child: Text(
                      ruta.shortName ?? 'Bus',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text(
                    parada.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    ruta.longName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        // Quitamos los segundos para que quede más limpio (HH:MM)
                        horario.arrivalTime.substring(0, 5),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
