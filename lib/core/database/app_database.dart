import 'package:drift/drift.dart';
import 'connection/native.dart';

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

class StopTimes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tripId => text().named('trip_id')();
  TextColumn get arrivalTime => text().named('arrival_time')();
  TextColumn get stopId => text().named('stop_id')();
  IntColumn get stopSequence => integer().named('stop_sequence')();

  @override
  List<Set<Column>> get uniqueKeys => [];
}

@DriftDatabase(tables: [Stops, Routes, StopTimes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Stop>> getSaguntoStops() {
    return (select(
      stops,
    )..where((t) => t.name.like('%Sagunto%') | t.name.like('%Sagunt%'))).get();
  }

  Future<List<StopTime>> getNextBuses(String stopId) {
    return (select(stopTimes)
          ..where((t) => t.stopId.equals(stopId))
          ..orderBy([(t) => OrderingTerm(expression: t.arrivalTime)])
          ..limit(10))
        .get();
  }
}
