// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RoutesTable extends Routes with TableInfo<$RoutesTable, Route> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'route_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shortNameMeta = const VerificationMeta(
    'shortName',
  );
  @override
  late final GeneratedColumn<String> shortName = GeneratedColumn<String>(
    'route_short_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longNameMeta = const VerificationMeta(
    'longName',
  );
  @override
  late final GeneratedColumn<String> longName = GeneratedColumn<String>(
    'route_long_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, shortName, longName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Route> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('route_id')) {
      context.handle(
        _idMeta,
        id.isAcceptableOrUnknown(data['route_id']!, _idMeta),
      );
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('route_short_name')) {
      context.handle(
        _shortNameMeta,
        shortName.isAcceptableOrUnknown(
          data['route_short_name']!,
          _shortNameMeta,
        ),
      );
    }
    if (data.containsKey('route_long_name')) {
      context.handle(
        _longNameMeta,
        longName.isAcceptableOrUnknown(data['route_long_name']!, _longNameMeta),
      );
    } else if (isInserting) {
      context.missing(_longNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Route map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Route(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_id'],
      )!,
      shortName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_short_name'],
      ),
      longName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_long_name'],
      )!,
    );
  }

  @override
  $RoutesTable createAlias(String alias) {
    return $RoutesTable(attachedDatabase, alias);
  }
}

class Route extends DataClass implements Insertable<Route> {
  final String id;
  final String? shortName;
  final String longName;
  const Route({required this.id, this.shortName, required this.longName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['route_id'] = Variable<String>(id);
    if (!nullToAbsent || shortName != null) {
      map['route_short_name'] = Variable<String>(shortName);
    }
    map['route_long_name'] = Variable<String>(longName);
    return map;
  }

  RoutesCompanion toCompanion(bool nullToAbsent) {
    return RoutesCompanion(
      id: Value(id),
      shortName: shortName == null && nullToAbsent
          ? const Value.absent()
          : Value(shortName),
      longName: Value(longName),
    );
  }

  factory Route.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Route(
      id: serializer.fromJson<String>(json['id']),
      shortName: serializer.fromJson<String?>(json['shortName']),
      longName: serializer.fromJson<String>(json['longName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shortName': serializer.toJson<String?>(shortName),
      'longName': serializer.toJson<String>(longName),
    };
  }

  Route copyWith({
    String? id,
    Value<String?> shortName = const Value.absent(),
    String? longName,
  }) => Route(
    id: id ?? this.id,
    shortName: shortName.present ? shortName.value : this.shortName,
    longName: longName ?? this.longName,
  );
  Route copyWithCompanion(RoutesCompanion data) {
    return Route(
      id: data.id.present ? data.id.value : this.id,
      shortName: data.shortName.present ? data.shortName.value : this.shortName,
      longName: data.longName.present ? data.longName.value : this.longName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Route(')
          ..write('id: $id, ')
          ..write('shortName: $shortName, ')
          ..write('longName: $longName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shortName, longName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Route &&
          other.id == this.id &&
          other.shortName == this.shortName &&
          other.longName == this.longName);
}

class RoutesCompanion extends UpdateCompanion<Route> {
  final Value<String> id;
  final Value<String?> shortName;
  final Value<String> longName;
  final Value<int> rowid;
  const RoutesCompanion({
    this.id = const Value.absent(),
    this.shortName = const Value.absent(),
    this.longName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutesCompanion.insert({
    required String id,
    this.shortName = const Value.absent(),
    required String longName,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       longName = Value(longName);
  static Insertable<Route> custom({
    Expression<String>? id,
    Expression<String>? shortName,
    Expression<String>? longName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'route_id': id,
      if (shortName != null) 'route_short_name': shortName,
      if (longName != null) 'route_long_name': longName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutesCompanion copyWith({
    Value<String>? id,
    Value<String?>? shortName,
    Value<String>? longName,
    Value<int>? rowid,
  }) {
    return RoutesCompanion(
      id: id ?? this.id,
      shortName: shortName ?? this.shortName,
      longName: longName ?? this.longName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['route_id'] = Variable<String>(id.value);
    }
    if (shortName.present) {
      map['route_short_name'] = Variable<String>(shortName.value);
    }
    if (longName.present) {
      map['route_long_name'] = Variable<String>(longName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutesCompanion(')
          ..write('id: $id, ')
          ..write('shortName: $shortName, ')
          ..write('longName: $longName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StopsTable extends Stops with TableInfo<$StopsTable, Stop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'stop_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'stop_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'stop_lat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lonMeta = const VerificationMeta('lon');
  @override
  late final GeneratedColumn<double> lon = GeneratedColumn<double>(
    'stop_lon',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, lat, lon];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stops';
  @override
  VerificationContext validateIntegrity(
    Insertable<Stop> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('stop_id')) {
      context.handle(
        _idMeta,
        id.isAcceptableOrUnknown(data['stop_id']!, _idMeta),
      );
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('stop_name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['stop_name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('stop_lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['stop_lat']!, _latMeta),
      );
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('stop_lon')) {
      context.handle(
        _lonMeta,
        lon.isAcceptableOrUnknown(data['stop_lon']!, _lonMeta),
      );
    } else if (isInserting) {
      context.missing(_lonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Stop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Stop(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stop_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stop_name'],
      )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stop_lat'],
      )!,
      lon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stop_lon'],
      )!,
    );
  }

  @override
  $StopsTable createAlias(String alias) {
    return $StopsTable(attachedDatabase, alias);
  }
}

class Stop extends DataClass implements Insertable<Stop> {
  final String id;
  final String name;
  final double lat;
  final double lon;
  const Stop({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['stop_id'] = Variable<String>(id);
    map['stop_name'] = Variable<String>(name);
    map['stop_lat'] = Variable<double>(lat);
    map['stop_lon'] = Variable<double>(lon);
    return map;
  }

  StopsCompanion toCompanion(bool nullToAbsent) {
    return StopsCompanion(
      id: Value(id),
      name: Value(name),
      lat: Value(lat),
      lon: Value(lon),
    );
  }

  factory Stop.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Stop(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lat: serializer.fromJson<double>(json['lat']),
      lon: serializer.fromJson<double>(json['lon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'lat': serializer.toJson<double>(lat),
      'lon': serializer.toJson<double>(lon),
    };
  }

  Stop copyWith({String? id, String? name, double? lat, double? lon}) => Stop(
    id: id ?? this.id,
    name: name ?? this.name,
    lat: lat ?? this.lat,
    lon: lon ?? this.lon,
  );
  Stop copyWithCompanion(StopsCompanion data) {
    return Stop(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lat: data.lat.present ? data.lat.value : this.lat,
      lon: data.lon.present ? data.lon.value : this.lon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Stop(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, lat, lon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stop &&
          other.id == this.id &&
          other.name == this.name &&
          other.lat == this.lat &&
          other.lon == this.lon);
}

class StopsCompanion extends UpdateCompanion<Stop> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> lat;
  final Value<double> lon;
  final Value<int> rowid;
  const StopsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lat = const Value.absent(),
    this.lon = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StopsCompanion.insert({
    required String id,
    required String name,
    required double lat,
    required double lon,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       lat = Value(lat),
       lon = Value(lon);
  static Insertable<Stop> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? lat,
    Expression<double>? lon,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'stop_id': id,
      if (name != null) 'stop_name': name,
      if (lat != null) 'stop_lat': lat,
      if (lon != null) 'stop_lon': lon,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StopsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? lat,
    Value<double>? lon,
    Value<int>? rowid,
  }) {
    return StopsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['stop_id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['stop_name'] = Variable<String>(name.value);
    }
    if (lat.present) {
      map['stop_lat'] = Variable<double>(lat.value);
    }
    if (lon.present) {
      map['stop_lon'] = Variable<double>(lon.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StopsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lon: $lon, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StopTimesTable extends StopTimes
    with TableInfo<$StopTimesTable, StopTime> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StopTimesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tripIdMeta = const VerificationMeta('tripId');
  @override
  late final GeneratedColumn<String> tripId = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arrivalTimeMeta = const VerificationMeta(
    'arrivalTime',
  );
  @override
  late final GeneratedColumn<String> arrivalTime = GeneratedColumn<String>(
    'arrival_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stopIdMeta = const VerificationMeta('stopId');
  @override
  late final GeneratedColumn<String> stopId = GeneratedColumn<String>(
    'stop_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stopSequenceMeta = const VerificationMeta(
    'stopSequence',
  );
  @override
  late final GeneratedColumn<int> stopSequence = GeneratedColumn<int>(
    'stop_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tripId,
    arrivalTime,
    stopId,
    stopSequence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stop_times';
  @override
  VerificationContext validateIntegrity(
    Insertable<StopTime> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('trip_id')) {
      context.handle(
        _tripIdMeta,
        tripId.isAcceptableOrUnknown(data['trip_id']!, _tripIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tripIdMeta);
    }
    if (data.containsKey('arrival_time')) {
      context.handle(
        _arrivalTimeMeta,
        arrivalTime.isAcceptableOrUnknown(
          data['arrival_time']!,
          _arrivalTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_arrivalTimeMeta);
    }
    if (data.containsKey('stop_id')) {
      context.handle(
        _stopIdMeta,
        stopId.isAcceptableOrUnknown(data['stop_id']!, _stopIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stopIdMeta);
    }
    if (data.containsKey('stop_sequence')) {
      context.handle(
        _stopSequenceMeta,
        stopSequence.isAcceptableOrUnknown(
          data['stop_sequence']!,
          _stopSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stopSequenceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StopTime map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StopTime(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tripId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      arrivalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arrival_time'],
      )!,
      stopId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stop_id'],
      )!,
      stopSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stop_sequence'],
      )!,
    );
  }

  @override
  $StopTimesTable createAlias(String alias) {
    return $StopTimesTable(attachedDatabase, alias);
  }
}

class StopTime extends DataClass implements Insertable<StopTime> {
  final int id;
  final String tripId;
  final String arrivalTime;
  final String stopId;
  final int stopSequence;
  const StopTime({
    required this.id,
    required this.tripId,
    required this.arrivalTime,
    required this.stopId,
    required this.stopSequence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['trip_id'] = Variable<String>(tripId);
    map['arrival_time'] = Variable<String>(arrivalTime);
    map['stop_id'] = Variable<String>(stopId);
    map['stop_sequence'] = Variable<int>(stopSequence);
    return map;
  }

  StopTimesCompanion toCompanion(bool nullToAbsent) {
    return StopTimesCompanion(
      id: Value(id),
      tripId: Value(tripId),
      arrivalTime: Value(arrivalTime),
      stopId: Value(stopId),
      stopSequence: Value(stopSequence),
    );
  }

  factory StopTime.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StopTime(
      id: serializer.fromJson<int>(json['id']),
      tripId: serializer.fromJson<String>(json['tripId']),
      arrivalTime: serializer.fromJson<String>(json['arrivalTime']),
      stopId: serializer.fromJson<String>(json['stopId']),
      stopSequence: serializer.fromJson<int>(json['stopSequence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tripId': serializer.toJson<String>(tripId),
      'arrivalTime': serializer.toJson<String>(arrivalTime),
      'stopId': serializer.toJson<String>(stopId),
      'stopSequence': serializer.toJson<int>(stopSequence),
    };
  }

  StopTime copyWith({
    int? id,
    String? tripId,
    String? arrivalTime,
    String? stopId,
    int? stopSequence,
  }) => StopTime(
    id: id ?? this.id,
    tripId: tripId ?? this.tripId,
    arrivalTime: arrivalTime ?? this.arrivalTime,
    stopId: stopId ?? this.stopId,
    stopSequence: stopSequence ?? this.stopSequence,
  );
  StopTime copyWithCompanion(StopTimesCompanion data) {
    return StopTime(
      id: data.id.present ? data.id.value : this.id,
      tripId: data.tripId.present ? data.tripId.value : this.tripId,
      arrivalTime: data.arrivalTime.present
          ? data.arrivalTime.value
          : this.arrivalTime,
      stopId: data.stopId.present ? data.stopId.value : this.stopId,
      stopSequence: data.stopSequence.present
          ? data.stopSequence.value
          : this.stopSequence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StopTime(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('arrivalTime: $arrivalTime, ')
          ..write('stopId: $stopId, ')
          ..write('stopSequence: $stopSequence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tripId, arrivalTime, stopId, stopSequence);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StopTime &&
          other.id == this.id &&
          other.tripId == this.tripId &&
          other.arrivalTime == this.arrivalTime &&
          other.stopId == this.stopId &&
          other.stopSequence == this.stopSequence);
}

class StopTimesCompanion extends UpdateCompanion<StopTime> {
  final Value<int> id;
  final Value<String> tripId;
  final Value<String> arrivalTime;
  final Value<String> stopId;
  final Value<int> stopSequence;
  const StopTimesCompanion({
    this.id = const Value.absent(),
    this.tripId = const Value.absent(),
    this.arrivalTime = const Value.absent(),
    this.stopId = const Value.absent(),
    this.stopSequence = const Value.absent(),
  });
  StopTimesCompanion.insert({
    this.id = const Value.absent(),
    required String tripId,
    required String arrivalTime,
    required String stopId,
    required int stopSequence,
  }) : tripId = Value(tripId),
       arrivalTime = Value(arrivalTime),
       stopId = Value(stopId),
       stopSequence = Value(stopSequence);
  static Insertable<StopTime> custom({
    Expression<int>? id,
    Expression<String>? tripId,
    Expression<String>? arrivalTime,
    Expression<String>? stopId,
    Expression<int>? stopSequence,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tripId != null) 'trip_id': tripId,
      if (arrivalTime != null) 'arrival_time': arrivalTime,
      if (stopId != null) 'stop_id': stopId,
      if (stopSequence != null) 'stop_sequence': stopSequence,
    });
  }

  StopTimesCompanion copyWith({
    Value<int>? id,
    Value<String>? tripId,
    Value<String>? arrivalTime,
    Value<String>? stopId,
    Value<int>? stopSequence,
  }) {
    return StopTimesCompanion(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      stopId: stopId ?? this.stopId,
      stopSequence: stopSequence ?? this.stopSequence,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tripId.present) {
      map['trip_id'] = Variable<String>(tripId.value);
    }
    if (arrivalTime.present) {
      map['arrival_time'] = Variable<String>(arrivalTime.value);
    }
    if (stopId.present) {
      map['stop_id'] = Variable<String>(stopId.value);
    }
    if (stopSequence.present) {
      map['stop_sequence'] = Variable<int>(stopSequence.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StopTimesCompanion(')
          ..write('id: $id, ')
          ..write('tripId: $tripId, ')
          ..write('arrivalTime: $arrivalTime, ')
          ..write('stopId: $stopId, ')
          ..write('stopSequence: $stopSequence')
          ..write(')'))
        .toString();
  }
}

class $TripsTable extends Trips with TableInfo<$TripsTable, Trip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'trip_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routeIdMeta = const VerificationMeta(
    'routeId',
  );
  @override
  late final GeneratedColumn<String> routeId = GeneratedColumn<String>(
    'route_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<String> serviceId = GeneratedColumn<String>(
    'service_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shapeIdMeta = const VerificationMeta(
    'shapeId',
  );
  @override
  late final GeneratedColumn<String> shapeId = GeneratedColumn<String>(
    'shape_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, routeId, serviceId, shapeId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('trip_id')) {
      context.handle(
        _idMeta,
        id.isAcceptableOrUnknown(data['trip_id']!, _idMeta),
      );
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('route_id')) {
      context.handle(
        _routeIdMeta,
        routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routeIdMeta);
    }
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('shape_id')) {
      context.handle(
        _shapeIdMeta,
        shapeId.isAcceptableOrUnknown(data['shape_id']!, _shapeIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trip_id'],
      )!,
      routeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_id'],
      )!,
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_id'],
      )!,
      shapeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shape_id'],
      ),
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }
}

class Trip extends DataClass implements Insertable<Trip> {
  final String id;
  final String routeId;
  final String serviceId;
  final String? shapeId;
  const Trip({
    required this.id,
    required this.routeId,
    required this.serviceId,
    this.shapeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['trip_id'] = Variable<String>(id);
    map['route_id'] = Variable<String>(routeId);
    map['service_id'] = Variable<String>(serviceId);
    if (!nullToAbsent || shapeId != null) {
      map['shape_id'] = Variable<String>(shapeId);
    }
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      routeId: Value(routeId),
      serviceId: Value(serviceId),
      shapeId: shapeId == null && nullToAbsent
          ? const Value.absent()
          : Value(shapeId),
    );
  }

  factory Trip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trip(
      id: serializer.fromJson<String>(json['id']),
      routeId: serializer.fromJson<String>(json['routeId']),
      serviceId: serializer.fromJson<String>(json['serviceId']),
      shapeId: serializer.fromJson<String?>(json['shapeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routeId': serializer.toJson<String>(routeId),
      'serviceId': serializer.toJson<String>(serviceId),
      'shapeId': serializer.toJson<String?>(shapeId),
    };
  }

  Trip copyWith({
    String? id,
    String? routeId,
    String? serviceId,
    Value<String?> shapeId = const Value.absent(),
  }) => Trip(
    id: id ?? this.id,
    routeId: routeId ?? this.routeId,
    serviceId: serviceId ?? this.serviceId,
    shapeId: shapeId.present ? shapeId.value : this.shapeId,
  );
  Trip copyWithCompanion(TripsCompanion data) {
    return Trip(
      id: data.id.present ? data.id.value : this.id,
      routeId: data.routeId.present ? data.routeId.value : this.routeId,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      shapeId: data.shapeId.present ? data.shapeId.value : this.shapeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trip(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('serviceId: $serviceId, ')
          ..write('shapeId: $shapeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routeId, serviceId, shapeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trip &&
          other.id == this.id &&
          other.routeId == this.routeId &&
          other.serviceId == this.serviceId &&
          other.shapeId == this.shapeId);
}

class TripsCompanion extends UpdateCompanion<Trip> {
  final Value<String> id;
  final Value<String> routeId;
  final Value<String> serviceId;
  final Value<String?> shapeId;
  final Value<int> rowid;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.routeId = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.shapeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TripsCompanion.insert({
    required String id,
    required String routeId,
    required String serviceId,
    this.shapeId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       routeId = Value(routeId),
       serviceId = Value(serviceId);
  static Insertable<Trip> custom({
    Expression<String>? id,
    Expression<String>? routeId,
    Expression<String>? serviceId,
    Expression<String>? shapeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'trip_id': id,
      if (routeId != null) 'route_id': routeId,
      if (serviceId != null) 'service_id': serviceId,
      if (shapeId != null) 'shape_id': shapeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TripsCompanion copyWith({
    Value<String>? id,
    Value<String>? routeId,
    Value<String>? serviceId,
    Value<String?>? shapeId,
    Value<int>? rowid,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      serviceId: serviceId ?? this.serviceId,
      shapeId: shapeId ?? this.shapeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['trip_id'] = Variable<String>(id.value);
    }
    if (routeId.present) {
      map['route_id'] = Variable<String>(routeId.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<String>(serviceId.value);
    }
    if (shapeId.present) {
      map['shape_id'] = Variable<String>(shapeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('serviceId: $serviceId, ')
          ..write('shapeId: $shapeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalendarDatesTable extends CalendarDates
    with TableInfo<$CalendarDatesTable, CalendarDate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarDatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<String> serviceId = GeneratedColumn<String>(
    'service_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exceptionTypeMeta = const VerificationMeta(
    'exceptionType',
  );
  @override
  late final GeneratedColumn<int> exceptionType = GeneratedColumn<int>(
    'exception_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [serviceId, date, exceptionType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_dates';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarDate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('exception_type')) {
      context.handle(
        _exceptionTypeMeta,
        exceptionType.isAcceptableOrUnknown(
          data['exception_type']!,
          _exceptionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exceptionTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {serviceId, date};
  @override
  CalendarDate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarDate(
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      exceptionType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exception_type'],
      )!,
    );
  }

  @override
  $CalendarDatesTable createAlias(String alias) {
    return $CalendarDatesTable(attachedDatabase, alias);
  }
}

class CalendarDate extends DataClass implements Insertable<CalendarDate> {
  final String serviceId;
  final String date;
  final int exceptionType;
  const CalendarDate({
    required this.serviceId,
    required this.date,
    required this.exceptionType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['service_id'] = Variable<String>(serviceId);
    map['date'] = Variable<String>(date);
    map['exception_type'] = Variable<int>(exceptionType);
    return map;
  }

  CalendarDatesCompanion toCompanion(bool nullToAbsent) {
    return CalendarDatesCompanion(
      serviceId: Value(serviceId),
      date: Value(date),
      exceptionType: Value(exceptionType),
    );
  }

  factory CalendarDate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarDate(
      serviceId: serializer.fromJson<String>(json['serviceId']),
      date: serializer.fromJson<String>(json['date']),
      exceptionType: serializer.fromJson<int>(json['exceptionType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'serviceId': serializer.toJson<String>(serviceId),
      'date': serializer.toJson<String>(date),
      'exceptionType': serializer.toJson<int>(exceptionType),
    };
  }

  CalendarDate copyWith({
    String? serviceId,
    String? date,
    int? exceptionType,
  }) => CalendarDate(
    serviceId: serviceId ?? this.serviceId,
    date: date ?? this.date,
    exceptionType: exceptionType ?? this.exceptionType,
  );
  CalendarDate copyWithCompanion(CalendarDatesCompanion data) {
    return CalendarDate(
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      date: data.date.present ? data.date.value : this.date,
      exceptionType: data.exceptionType.present
          ? data.exceptionType.value
          : this.exceptionType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarDate(')
          ..write('serviceId: $serviceId, ')
          ..write('date: $date, ')
          ..write('exceptionType: $exceptionType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(serviceId, date, exceptionType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarDate &&
          other.serviceId == this.serviceId &&
          other.date == this.date &&
          other.exceptionType == this.exceptionType);
}

class CalendarDatesCompanion extends UpdateCompanion<CalendarDate> {
  final Value<String> serviceId;
  final Value<String> date;
  final Value<int> exceptionType;
  final Value<int> rowid;
  const CalendarDatesCompanion({
    this.serviceId = const Value.absent(),
    this.date = const Value.absent(),
    this.exceptionType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalendarDatesCompanion.insert({
    required String serviceId,
    required String date,
    required int exceptionType,
    this.rowid = const Value.absent(),
  }) : serviceId = Value(serviceId),
       date = Value(date),
       exceptionType = Value(exceptionType);
  static Insertable<CalendarDate> custom({
    Expression<String>? serviceId,
    Expression<String>? date,
    Expression<int>? exceptionType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (serviceId != null) 'service_id': serviceId,
      if (date != null) 'date': date,
      if (exceptionType != null) 'exception_type': exceptionType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalendarDatesCompanion copyWith({
    Value<String>? serviceId,
    Value<String>? date,
    Value<int>? exceptionType,
    Value<int>? rowid,
  }) {
    return CalendarDatesCompanion(
      serviceId: serviceId ?? this.serviceId,
      date: date ?? this.date,
      exceptionType: exceptionType ?? this.exceptionType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (serviceId.present) {
      map['service_id'] = Variable<String>(serviceId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (exceptionType.present) {
      map['exception_type'] = Variable<int>(exceptionType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarDatesCompanion(')
          ..write('serviceId: $serviceId, ')
          ..write('date: $date, ')
          ..write('exceptionType: $exceptionType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutesTable routes = $RoutesTable(this);
  late final $StopsTable stops = $StopsTable(this);
  late final $StopTimesTable stopTimes = $StopTimesTable(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $CalendarDatesTable calendarDates = $CalendarDatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routes,
    stops,
    stopTimes,
    trips,
    calendarDates,
  ];
}

typedef $$RoutesTableCreateCompanionBuilder =
    RoutesCompanion Function({
      required String id,
      Value<String?> shortName,
      required String longName,
      Value<int> rowid,
    });
typedef $$RoutesTableUpdateCompanionBuilder =
    RoutesCompanion Function({
      Value<String> id,
      Value<String?> shortName,
      Value<String> longName,
      Value<int> rowid,
    });

class $$RoutesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get longName => $composableBuilder(
    column: $table.longName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoutesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortName => $composableBuilder(
    column: $table.shortName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get longName => $composableBuilder(
    column: $table.longName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutesTable> {
  $$RoutesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get shortName =>
      $composableBuilder(column: $table.shortName, builder: (column) => column);

  GeneratedColumn<String> get longName =>
      $composableBuilder(column: $table.longName, builder: (column) => column);
}

class $$RoutesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutesTable,
          Route,
          $$RoutesTableFilterComposer,
          $$RoutesTableOrderingComposer,
          $$RoutesTableAnnotationComposer,
          $$RoutesTableCreateCompanionBuilder,
          $$RoutesTableUpdateCompanionBuilder,
          (Route, BaseReferences<_$AppDatabase, $RoutesTable, Route>),
          Route,
          PrefetchHooks Function()
        > {
  $$RoutesTableTableManager(_$AppDatabase db, $RoutesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> shortName = const Value.absent(),
                Value<String> longName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutesCompanion(
                id: id,
                shortName: shortName,
                longName: longName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> shortName = const Value.absent(),
                required String longName,
                Value<int> rowid = const Value.absent(),
              }) => RoutesCompanion.insert(
                id: id,
                shortName: shortName,
                longName: longName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoutesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutesTable,
      Route,
      $$RoutesTableFilterComposer,
      $$RoutesTableOrderingComposer,
      $$RoutesTableAnnotationComposer,
      $$RoutesTableCreateCompanionBuilder,
      $$RoutesTableUpdateCompanionBuilder,
      (Route, BaseReferences<_$AppDatabase, $RoutesTable, Route>),
      Route,
      PrefetchHooks Function()
    >;
typedef $$StopsTableCreateCompanionBuilder =
    StopsCompanion Function({
      required String id,
      required String name,
      required double lat,
      required double lon,
      Value<int> rowid,
    });
typedef $$StopsTableUpdateCompanionBuilder =
    StopsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> lat,
      Value<double> lon,
      Value<int> rowid,
    });

class $$StopsTableFilterComposer extends Composer<_$AppDatabase, $StopsTable> {
  $$StopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StopsTableOrderingComposer
    extends Composer<_$AppDatabase, $StopsTable> {
  $$StopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lon => $composableBuilder(
    column: $table.lon,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StopsTable> {
  $$StopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lon =>
      $composableBuilder(column: $table.lon, builder: (column) => column);
}

class $$StopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StopsTable,
          Stop,
          $$StopsTableFilterComposer,
          $$StopsTableOrderingComposer,
          $$StopsTableAnnotationComposer,
          $$StopsTableCreateCompanionBuilder,
          $$StopsTableUpdateCompanionBuilder,
          (Stop, BaseReferences<_$AppDatabase, $StopsTable, Stop>),
          Stop,
          PrefetchHooks Function()
        > {
  $$StopsTableTableManager(_$AppDatabase db, $StopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> lat = const Value.absent(),
                Value<double> lon = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StopsCompanion(
                id: id,
                name: name,
                lat: lat,
                lon: lon,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required double lat,
                required double lon,
                Value<int> rowid = const Value.absent(),
              }) => StopsCompanion.insert(
                id: id,
                name: name,
                lat: lat,
                lon: lon,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StopsTable,
      Stop,
      $$StopsTableFilterComposer,
      $$StopsTableOrderingComposer,
      $$StopsTableAnnotationComposer,
      $$StopsTableCreateCompanionBuilder,
      $$StopsTableUpdateCompanionBuilder,
      (Stop, BaseReferences<_$AppDatabase, $StopsTable, Stop>),
      Stop,
      PrefetchHooks Function()
    >;
typedef $$StopTimesTableCreateCompanionBuilder =
    StopTimesCompanion Function({
      Value<int> id,
      required String tripId,
      required String arrivalTime,
      required String stopId,
      required int stopSequence,
    });
typedef $$StopTimesTableUpdateCompanionBuilder =
    StopTimesCompanion Function({
      Value<int> id,
      Value<String> tripId,
      Value<String> arrivalTime,
      Value<String> stopId,
      Value<int> stopSequence,
    });

class $$StopTimesTableFilterComposer
    extends Composer<_$AppDatabase, $StopTimesTable> {
  $$StopTimesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stopId => $composableBuilder(
    column: $table.stopId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stopSequence => $composableBuilder(
    column: $table.stopSequence,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StopTimesTableOrderingComposer
    extends Composer<_$AppDatabase, $StopTimesTable> {
  $$StopTimesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tripId => $composableBuilder(
    column: $table.tripId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stopId => $composableBuilder(
    column: $table.stopId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stopSequence => $composableBuilder(
    column: $table.stopSequence,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StopTimesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StopTimesTable> {
  $$StopTimesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tripId =>
      $composableBuilder(column: $table.tripId, builder: (column) => column);

  GeneratedColumn<String> get arrivalTime => $composableBuilder(
    column: $table.arrivalTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stopId =>
      $composableBuilder(column: $table.stopId, builder: (column) => column);

  GeneratedColumn<int> get stopSequence => $composableBuilder(
    column: $table.stopSequence,
    builder: (column) => column,
  );
}

class $$StopTimesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StopTimesTable,
          StopTime,
          $$StopTimesTableFilterComposer,
          $$StopTimesTableOrderingComposer,
          $$StopTimesTableAnnotationComposer,
          $$StopTimesTableCreateCompanionBuilder,
          $$StopTimesTableUpdateCompanionBuilder,
          (StopTime, BaseReferences<_$AppDatabase, $StopTimesTable, StopTime>),
          StopTime,
          PrefetchHooks Function()
        > {
  $$StopTimesTableTableManager(_$AppDatabase db, $StopTimesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StopTimesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StopTimesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StopTimesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tripId = const Value.absent(),
                Value<String> arrivalTime = const Value.absent(),
                Value<String> stopId = const Value.absent(),
                Value<int> stopSequence = const Value.absent(),
              }) => StopTimesCompanion(
                id: id,
                tripId: tripId,
                arrivalTime: arrivalTime,
                stopId: stopId,
                stopSequence: stopSequence,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tripId,
                required String arrivalTime,
                required String stopId,
                required int stopSequence,
              }) => StopTimesCompanion.insert(
                id: id,
                tripId: tripId,
                arrivalTime: arrivalTime,
                stopId: stopId,
                stopSequence: stopSequence,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StopTimesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StopTimesTable,
      StopTime,
      $$StopTimesTableFilterComposer,
      $$StopTimesTableOrderingComposer,
      $$StopTimesTableAnnotationComposer,
      $$StopTimesTableCreateCompanionBuilder,
      $$StopTimesTableUpdateCompanionBuilder,
      (StopTime, BaseReferences<_$AppDatabase, $StopTimesTable, StopTime>),
      StopTime,
      PrefetchHooks Function()
    >;
typedef $$TripsTableCreateCompanionBuilder =
    TripsCompanion Function({
      required String id,
      required String routeId,
      required String serviceId,
      Value<String?> shapeId,
      Value<int> rowid,
    });
typedef $$TripsTableUpdateCompanionBuilder =
    TripsCompanion Function({
      Value<String> id,
      Value<String> routeId,
      Value<String> serviceId,
      Value<String?> shapeId,
      Value<int> rowid,
    });

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routeId => $composableBuilder(
    column: $table.routeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceId => $composableBuilder(
    column: $table.serviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shapeId => $composableBuilder(
    column: $table.shapeId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routeId => $composableBuilder(
    column: $table.routeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceId => $composableBuilder(
    column: $table.serviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shapeId => $composableBuilder(
    column: $table.shapeId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get routeId =>
      $composableBuilder(column: $table.routeId, builder: (column) => column);

  GeneratedColumn<String> get serviceId =>
      $composableBuilder(column: $table.serviceId, builder: (column) => column);

  GeneratedColumn<String> get shapeId =>
      $composableBuilder(column: $table.shapeId, builder: (column) => column);
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTable,
          Trip,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
          Trip,
          PrefetchHooks Function()
        > {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> routeId = const Value.absent(),
                Value<String> serviceId = const Value.absent(),
                Value<String?> shapeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion(
                id: id,
                routeId: routeId,
                serviceId: serviceId,
                shapeId: shapeId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String routeId,
                required String serviceId,
                Value<String?> shapeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TripsCompanion.insert(
                id: id,
                routeId: routeId,
                serviceId: serviceId,
                shapeId: shapeId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTable,
      Trip,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (Trip, BaseReferences<_$AppDatabase, $TripsTable, Trip>),
      Trip,
      PrefetchHooks Function()
    >;
typedef $$CalendarDatesTableCreateCompanionBuilder =
    CalendarDatesCompanion Function({
      required String serviceId,
      required String date,
      required int exceptionType,
      Value<int> rowid,
    });
typedef $$CalendarDatesTableUpdateCompanionBuilder =
    CalendarDatesCompanion Function({
      Value<String> serviceId,
      Value<String> date,
      Value<int> exceptionType,
      Value<int> rowid,
    });

class $$CalendarDatesTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarDatesTable> {
  $$CalendarDatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get serviceId => $composableBuilder(
    column: $table.serviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exceptionType => $composableBuilder(
    column: $table.exceptionType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarDatesTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarDatesTable> {
  $$CalendarDatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get serviceId => $composableBuilder(
    column: $table.serviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exceptionType => $composableBuilder(
    column: $table.exceptionType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarDatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarDatesTable> {
  $$CalendarDatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get serviceId =>
      $composableBuilder(column: $table.serviceId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get exceptionType => $composableBuilder(
    column: $table.exceptionType,
    builder: (column) => column,
  );
}

class $$CalendarDatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarDatesTable,
          CalendarDate,
          $$CalendarDatesTableFilterComposer,
          $$CalendarDatesTableOrderingComposer,
          $$CalendarDatesTableAnnotationComposer,
          $$CalendarDatesTableCreateCompanionBuilder,
          $$CalendarDatesTableUpdateCompanionBuilder,
          (
            CalendarDate,
            BaseReferences<_$AppDatabase, $CalendarDatesTable, CalendarDate>,
          ),
          CalendarDate,
          PrefetchHooks Function()
        > {
  $$CalendarDatesTableTableManager(_$AppDatabase db, $CalendarDatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarDatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarDatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarDatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> serviceId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> exceptionType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalendarDatesCompanion(
                serviceId: serviceId,
                date: date,
                exceptionType: exceptionType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String serviceId,
                required String date,
                required int exceptionType,
                Value<int> rowid = const Value.absent(),
              }) => CalendarDatesCompanion.insert(
                serviceId: serviceId,
                date: date,
                exceptionType: exceptionType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarDatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarDatesTable,
      CalendarDate,
      $$CalendarDatesTableFilterComposer,
      $$CalendarDatesTableOrderingComposer,
      $$CalendarDatesTableAnnotationComposer,
      $$CalendarDatesTableCreateCompanionBuilder,
      $$CalendarDatesTableUpdateCompanionBuilder,
      (
        CalendarDate,
        BaseReferences<_$AppDatabase, $CalendarDatesTable, CalendarDate>,
      ),
      CalendarDate,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutesTableTableManager get routes =>
      $$RoutesTableTableManager(_db, _db.routes);
  $$StopsTableTableManager get stops =>
      $$StopsTableTableManager(_db, _db.stops);
  $$StopTimesTableTableManager get stopTimes =>
      $$StopTimesTableTableManager(_db, _db.stopTimes);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$CalendarDatesTableTableManager get calendarDates =>
      $$CalendarDatesTableTableManager(_db, _db.calendarDates);
}
