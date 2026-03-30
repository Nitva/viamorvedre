import 'dart:isolate';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:viamorvedre/core/database/app_database.dart';
import 'package:viamorvedre/features/data/bus_data.dart';

class GtfsImporter {
  final AppDatabase db;
  GtfsImporter(this.db);

  Future<void> importSaguntoData(String stopsCsv, String stopTimesCsv) async {
    // Usamos Isolate para no bloquear la UI
    await Isolate.run(() async {
      final stopRows = const CsvToListConverter().convert(stopsCsv);
      final Set<String> saguntoStopIds = {};

      await db.batch((batch) {
        for (var row in stopRows.skip(1)) {
          final id = row[0].toString();
          final name = row[1].toString();

          if (name.contains('Sagunto') || name.contains('Sagunt')) {
            saguntoStopIds.add(id);
            batch.insert(
              db.stops,
              StopsCompanion.insert(
                id: id,
                name: name,
                lat: double.parse(row[2].toString()),
                lon: double.parse(row[3].toString()),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }
      });

      final timeRows = const CsvToListConverter().convert(stopTimesCsv);
      await db.batch((batch) {
        for (var row in timeRows.skip(1)) {
          final stopId = row[3].toString();

          if (saguntoStopIds.contains(stopId)) {
            batch.insert(
              db.stopTimes,
              StopTimesCompanion.insert(
                tripId: row[0].toString(),
                arrivalTime: row[1].toString(),
                stopId: stopId,
                stopSequence: int.parse(row[4].toString()),
              ),
            );
          }
        }
      });
    });
  }
}
