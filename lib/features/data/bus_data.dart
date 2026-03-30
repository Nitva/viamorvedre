import 'package:drift/drift.dart';

//Stops
class Stops extends Table {
  TextColumn get id => text().named('stop_id')();
  TextColumn get name => text().named('stop_name')();
  RealColumn get lat => real().named('stop_lat')();
  RealColumn get lon => real().named('stop_lon')();

  @override
  Set<Column> get primaryKey => {id};
}

// Routes
class Routes extends Table {
  TextColumn get id => text().named('route_id')();
  TextColumn get shortName => text().named('route_short_name').nullable()();
  TextColumn get longName => text().named('route_long_name')();

  @override
  Set<Column> get primaryKey => {id};
}

// Schedule
@DataClassName('StopTime')
class StopTimes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tripId => text().named('trip_id')();
  TextColumn get arrivalTime => text().named('arrival_time')();
  TextColumn get stopId =>
      text().named('stop_id').customConstraint('REFERENCES stops(stop_id)')();
  IntColumn get stopSequence => integer().named('stop_sequence')();

  @override
  List<Set<Column>> get uniqueKeys => [];
}
