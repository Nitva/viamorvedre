import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// Esto conectará con el código generado (recuerda ejecutar la generación de código)
part 'app_database.g.dart';

class Stops extends Table {
  TextColumn get id => text().named('stop_id')();
  TextColumn get name => text().named('stop_name')();
  RealColumn get lat => real().named('stop_lat')();
  RealColumn get lon => real().named('stop_lon')();

  @override
  Set<Column> get primaryKey => {id};
}

class Routes extends Table {
  TextColumn get id => text().named('route_id')();
  TextColumn get shortName => text().named('route_short_name').nullable()();
  TextColumn get longName => text().named('route_long_name')();

  @override
  Set<Column> get primaryKey => {id};
}

// AÑADIDA: Tabla Trips para hacer de puente entre la ruta y las paradas
class Trips extends Table {
  TextColumn get id => text().named('trip_id')();
  TextColumn get routeId => text().named('route_id')();
  TextColumn get serviceId => text().named('service_id')();
  TextColumn get shapeId => text().named('shape_id').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class StopTimes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tripId => text().named('trip_id')();
  TextColumn get arrivalTime => text().named('arrival_time')();
  TextColumn get stopId => text().named('stop_id')();
  IntColumn get stopSequence => integer().named('stop_sequence')();
}

class CalendarDates extends Table {
  TextColumn get serviceId => text().named('service_id')();
  TextColumn get date => text()();
  IntColumn get exceptionType => integer().named('exception_type')();

  @override
  Set<Column> get primaryKey => {serviceId, date};
}

// Añadimos Trips a la lista de tablas
@DriftDatabase(tables: [Routes, Stops, StopTimes, Trips, CalendarDates])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Consulta corregida usando los nombres generados por Drift (routes, stops, trips, stopTimes)
  Future<List<TypedResult>> getBusesPorSaguntoParaFecha(DateTime fecha) {
    // Convierte la fecha al formato GTFS (Ej: 20260331)
    final dateStr =
        "${fecha.year}${fecha.month.toString().padLeft(2, '0')}${fecha.day.toString().padLeft(2, '0')}";

    final query =
        select(stopTimes).join([
            innerJoin(stops, stops.id.equalsExp(stopTimes.stopId)),
            innerJoin(trips, trips.id.equalsExp(stopTimes.tripId)),
            innerJoin(routes, routes.id.equalsExp(trips.routeId)),
            // Magia pura: Solo unimos los viajes que tienen registro para HOY en calendar_dates
            innerJoin(
              calendarDates,
              calendarDates.serviceId.equalsExp(trips.serviceId) &
                  calendarDates.date.equals(dateStr),
            ),
          ])
          ..where(
            (routes.longName.like('%Sagunt%') |
                    routes.longName.like('%Puerto%')) &
                // exceptionType 1 significa que el servicio OPERA ese día
                calendarDates.exceptionType.equals(1),
          )
          ..orderBy([OrderingTerm.asc(stopTimes.arrivalTime)]);

    return query.get();
  }

  // --- LÓGICA DE IMPORTACIÓN AMPLIADA ---
  // Recibe los datos parseados de tus archivos CSV e inserta todo en bloque
  Future<void> importGtfsData({
    required List<List<dynamic>> routesCsv,
    required List<List<dynamic>> tripsCsv,
    required List<List<dynamic>> stopsCsv,
    required List<List<dynamic>> stopTimesCsv,
    required List<List<dynamic>> calendarDatesCsv,
  }) async {
    await batch((batch) {
      // 1. Importar Routes
      for (var row in routesCsv.skip(1)) {
        batch.insert(
          routes,
          RoutesCompanion.insert(
            id: row[0].toString(),
            shortName: Value(row[2]?.toString()),
            longName: row[3].toString(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 2. Importar Stops
      for (var row in stopsCsv.skip(1)) {
        batch.insert(
          stops,
          StopsCompanion.insert(
            id: row[0].toString(),
            name: row[1].toString(),
            lat: double.parse(row[2].toString()),
            lon: double.parse(row[3].toString()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 3. Importar Trips
      for (var row in tripsCsv.skip(1)) {
        batch.insert(
          trips,
          TripsCompanion.insert(
            routeId: row[0].toString(),
            serviceId: row[1].toString(),
            id: row[2].toString(), // trip_id
            shapeId: Value(row[3]?.toString()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 4. Importar StopTimes
      for (var row in stopTimesCsv.skip(1)) {
        batch.insert(
          stopTimes,
          StopTimesCompanion.insert(
            tripId: row[0].toString(),
            arrivalTime: row[1].toString(),
            // Ignoramos departure_time (row[2]) si no lo necesitas
            stopId: row[3].toString(),
            stopSequence: int.parse(row[4].toString()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 5. Importar CalendarDates
      for (var row in calendarDatesCsv.skip(1)) {
        batch.insert(
          calendarDates,
          CalendarDatesCompanion.insert(
            serviceId: row[0].toString().trim(),
            date: row[1].toString().trim(),
            exceptionType: int.parse(row[2].toString().trim()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}

// Configuración de la conexión al archivo .sqlite
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'buses_valencia.sqlite'));
    return NativeDatabase(file);
  });
}
