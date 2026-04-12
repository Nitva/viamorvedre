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

    // Todos los IDs de paradas en Puerto Sagunto y Sagunto
    final puertosagunto = [
      // Puerto de Sagunto
      '5104030105', // Av. camp Morvedre 115 (Correus) – Port de Sagunt
      '5104030215', // Av. Camp de Morvedre front 115 (Correus) – Port de Sagunt
      '5104030216', // Av. Hispanidad, 2
      '5104030104', // Av. Hispanidad, 2 front
      '5104030106', // Av. Camp de Morvedre, 38
      // Sagunto centro
      '5104030102', // Hospital de Sagunto
      '925611410120', // Av. Arquitecto Alfredo Simón [Sagunt]
      '5256150104', // Av. Arquitecto Alfredo Simón front [Sagunt]
      '925631000203', // Polideportivo - IES Jorge Juan [Sagunt]
      '5256150107', // Av. Mediterráneo, 67 - Turismo [Sagunt]
      '5256150223', // Av. Mediterráneo, 36 - Restaurante Lonja [Sagunt]
    ];

    final query =
        select(stopTimes).join([
            innerJoin(stops, stops.id.equalsExp(stopTimes.stopId)),
            innerJoin(trips, trips.id.equalsExp(stopTimes.tripId)),
            innerJoin(routes, routes.id.equalsExp(trips.routeId)),
            innerJoin(
              calendarDates,
              calendarDates.serviceId.equalsExp(trips.serviceId) &
                  calendarDates.date.equals(dateStr),
            ),
          ])
          ..where(
            stops.id.isIn(puertosagunto) &
                calendarDates.exceptionType.equals(1),
          )
          ..orderBy([
            OrderingTerm.asc(stopTimes.arrivalTime),
            OrderingTerm.asc(trips.id),
          ]);

    return query.get();
  }

  // Obtiene todas las líneas (routes) que pasan por Puerto Sagunto/Sagunto
  // SIN filtro de fecha - devuelve todas las líneas disponibles
  Future<List<Route>> getLineasPorSagunto() async {
    final puertosagunto = [
      '5104030105',
      '5104030215',
      '5104030216',
      '5104030104',
      '5104030106',
      '5104030102',
      '925611410120',
      '5256150104',
      '925631000203',
      '5256150107',
      '5256150223',
    ];

    // Obtener todos los trips que pasan por esos stops
    final query = select(routes).join([
      innerJoin(trips, trips.routeId.equalsExp(routes.id)),
      innerJoin(stopTimes, stopTimes.tripId.equalsExp(trips.id)),
      innerJoin(stops, stops.id.equalsExp(stopTimes.stopId)),
    ])..where(stops.id.isIn(puertosagunto));

    final results = await query.get();

    // Extraer routes únicas
    final routesSet = <String, Route>{};
    for (final row in results) {
      final route = row.readTable(routes);
      routesSet[route.id] = route;
    }

    return routesSet.values.toList();
  }

  // Obtiene TODAS las líneas con sus viajes para hoy EN UNA SOLA QUERY
  // Devuelve Map<routeId, {route: Route, viajes: int}>
  Future<Map<String, dynamic>> getLineasConViajesParaHoy() async {
    final hoy = DateTime.now();
    final dateStr =
        "${hoy.year}${hoy.month.toString().padLeft(2, '0')}${hoy.day.toString().padLeft(2, '0')}";

    final puertosagunto = [
      '5104030105',
      '5104030215',
      '5104030216',
      '5104030104',
      '5104030106',
      '5104030102',
      '925611410120',
      '5256150104',
      '925631000203',
      '5256150107',
      '5256150223',
    ];

    // Query que trae TODAS las líneas con sus viajes hoy
    final query = select(routes).join([
      innerJoin(trips, trips.routeId.equalsExp(routes.id)),
      leftOuterJoin(
        calendarDates,
        calendarDates.serviceId.equalsExp(trips.serviceId) &
            calendarDates.date.equals(dateStr) &
            calendarDates.exceptionType.equals(1),
      ),
      innerJoin(stopTimes, stopTimes.tripId.equalsExp(trips.id)),
      innerJoin(stops, stops.id.equalsExp(stopTimes.stopId)),
    ])..where(stops.id.isIn(puertosagunto));

    final results = await query.get();

    // Procesar: agrupar por route y contar viajes con servicio hoy
    final lineasMap = <String, dynamic>{};
    final viajesHoyPorRuta =
        <String, Set<String>>{}; // routeId -> set de tripIds

    for (final row in results) {
      final route = row.readTable(routes);
      final trip = row.readTable(trips);
      final calendarDate = row.readTableOrNull(
        calendarDates,
      ); // Puede ser null si no hay servicio

      if (!lineasMap.containsKey(route.id)) {
        lineasMap[route.id] = {'route': route, 'viajes': 0};
        viajesHoyPorRuta[route.id] = <String>{};
      }

      // Solo contar viajes que tienen servicio hoy
      if (calendarDate != null) {
        viajesHoyPorRuta[route.id]!.add(trip.id);
      }
    }

    // Actualizar conteo de viajes
    for (final entry in lineasMap.entries) {
      entry.value['viajes'] = viajesHoyPorRuta[entry.key]?.length ?? 0;
    }

    return lineasMap;
  }

  // Verifica si una línea tiene servicio en una fecha específica
  Future<bool> hasServiceToday(String routeId, DateTime fecha) async {
    final dateStr =
        "${fecha.year}${fecha.month.toString().padLeft(2, '0')}${fecha.day.toString().padLeft(2, '0')}";

    final query =
        select(trips).join([
            innerJoin(
              calendarDates,
              calendarDates.serviceId.equalsExp(trips.serviceId) &
                  calendarDates.date.equals(dateStr) &
                  calendarDates.exceptionType.equals(1),
            ),
          ])
          ..where(trips.routeId.equals(routeId))
          ..limit(1);

    final results = await query.get();
    return results.isNotEmpty;
  }

  // Obtiene el conteo de viajes de una línea para una fecha específica
  // y filtra solo los que pasan por Puerto Sagunto/Sagunto
  Future<int> getViajesPorLineaYFecha(String routeId, DateTime fecha) async {
    final dateStr =
        "${fecha.year}${fecha.month.toString().padLeft(2, '0')}${fecha.day.toString().padLeft(2, '0')}";

    final puertosagunto = [
      '5104030105',
      '5104030215',
      '5104030216',
      '5104030104',
      '5104030106',
      '5104030102',
      '925611410120',
      '5256150104',
      '925631000203',
      '5256150107',
      '5256150223',
    ];

    final query = select(trips).join([
      innerJoin(
        calendarDates,
        calendarDates.serviceId.equalsExp(trips.serviceId) &
            calendarDates.date.equals(dateStr) &
            calendarDates.exceptionType.equals(1),
      ),
      innerJoin(stopTimes, stopTimes.tripId.equalsExp(trips.id)),
      innerJoin(stops, stops.id.equalsExp(stopTimes.stopId)),
    ])..where(trips.routeId.equals(routeId) & stops.id.isIn(puertosagunto));

    final results = await query.get();

    // Contar trips únicos
    final tripsUnicos = <String>{};
    for (final row in results) {
      final trip = row.readTable(trips);
      tripsUnicos.add(trip.id);
    }

    return tripsUnicos.length;
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
