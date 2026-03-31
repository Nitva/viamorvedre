import 'dart:isolate';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'app_database.dart';

List<List<dynamic>> parsearCsv(String csvData) {
  final codec = Csv(fieldDelimiter: ',', lineDelimiter: '\n');
  return codec.decode(csvData);
}

class GtfsImporter {
  static Future<void> cargarDatosGtfs(AppDatabase db) async {
    debugPrint("1. Leyendo archivos de texto...");

    final routesData = await rootBundle.loadString(
      'lib/core/assets/routes.txt',
    );
    final tripsData = await rootBundle.loadString('lib/core/assets/trips.txt');
    final stopsData = await rootBundle.loadString('lib/core/assets/stops.txt');
    final stopTimesData = await rootBundle.loadString(
      'lib/core/assets/stop_times.txt',
    );
    final calendarDatesData = await rootBundle.loadString(
      'lib/core/assets/calendar_dates.txt',
    );

    debugPrint("2. Convirtiendo textos a listas en un hilo secundario...");
    final routesCsv = await Isolate.run(() => parsearCsv(routesData));
    final tripsCsv = await Isolate.run(() => parsearCsv(tripsData));
    final stopsCsv = await Isolate.run(() => parsearCsv(stopsData));
    final stopTimesCsv = await Isolate.run(() => parsearCsv(stopTimesData));
    final calendarDatesCsv = await Isolate.run(
      () => parsearCsv(calendarDatesData),
    );

    debugPrint("3. Insertando en la base de datos...");
    await db.importGtfsData(
      routesCsv: routesCsv,
      tripsCsv: tripsCsv,
      stopsCsv: stopsCsv,
      stopTimesCsv: stopTimesCsv,
      calendarDatesCsv: calendarDatesCsv,
    );

    debugPrint("¡Datos GTFS importados con éxito!");
  }
}
