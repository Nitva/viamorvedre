import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:viamorvedre/core/database/app_database.dart';
import 'package:viamorvedre/core/utils/language_formater.dart'; // Ajusta la ruta si es necesario

class PantallaBuses extends StatefulWidget {
  final AppDatabase db;

  const PantallaBuses({super.key, required this.db});

  @override
  State<PantallaBuses> createState() => _PantallaBusesState();
}

class _PantallaBusesState extends State<PantallaBuses> {
  IdiomaApp _idiomaActual = IdiomaApp.castellano;

  // NUEVAS VARIABLES: Guardamos la fecha/hora seleccionada
  DateTime _fechaSeleccionada = DateTime.now();
  bool _esFechaPersonalizada = false;

  // FUNCIÓN PARA ABRIR EL SELECTOR DE FECHA Y HORA
  Future<void> _seleccionarFechaYHora() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime.now().subtract(
        const Duration(days: 1),
      ), // Permite ver desde ayer
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ), // Hasta un año en el futuro
      helpText: 'Selecciona el día',
    );

    if (fecha != null) {
      if (!mounted) return;
      final TimeOfDay? hora = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_fechaSeleccionada),
        helpText: 'Selecciona la hora',
      );

      if (hora != null) {
        setState(() {
          _fechaSeleccionada = DateTime(
            fecha.year,
            fecha.month,
            fecha.day,
            hora.hour,
            hora.minute,
          );
          _esFechaPersonalizada =
              true; // Activamos el aviso de fecha modificada
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Líneas en Sagunto/Puerto',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          // BOTÓN DEL CALENDARIO
          IconButton(
            icon: const Icon(Icons.edit_calendar),
            tooltip: 'Elegir fecha y hora',
            onPressed: _seleccionarFechaYHora,
          ),
          // SELECTOR DE IDIOMA
          PopupMenuButton<IdiomaApp>(
            onSelected: (IdiomaApp nuevoIdioma) {
              setState(() {
                _idiomaActual = nuevoIdioma;
              });
            },
            icon: const Icon(Icons.language),
            tooltip: 'Cambiar idioma',
            itemBuilder: (BuildContext context) => <PopupMenuEntry<IdiomaApp>>[
              const PopupMenuItem<IdiomaApp>(
                value: IdiomaApp.castellano,
                child: Text('🇪🇸 Castellano'),
              ),
              const PopupMenuItem<IdiomaApp>(
                value: IdiomaApp.valenciano,
                child: Text('🦇 Valencià'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // BANNER AVISO: Muestra la fecha si no es "Ahora"
          if (_esFechaPersonalizada)
            Container(
              color: Colors.orange.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🗓️ Viendo: ${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year} a las ${_fechaSeleccionada.hour.toString().padLeft(2, '0')}:${_fechaSeleccionada.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _fechaSeleccionada = DateTime.now();
                        _esFechaPersonalizada = false;
                      });
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Volver a Ahora'),
                  ),
                ],
              ),
            ),

          // EL RESTO DE LA PANTALLA
          Expanded(
            child: FutureBuilder<List<List<drift.TypedResult>>>(
              // Usamos _fechaSeleccionada en lugar de DateTime.now()
              future: Future.wait([
                widget.db.getBusesPorSaguntoParaFecha(_fechaSeleccionada),
                widget.db.getBusesPorSaguntoParaFecha(
                  _fechaSeleccionada.add(const Duration(days: 1)),
                ),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData ||
                    (snapshot.data![0].isEmpty && snapshot.data![1].isEmpty)) {
                  return const Center(
                    child: Text(
                      'No hay autobuses programados para esta fecha.',
                    ),
                  );
                }

                final resultadosHoy = snapshot.data![0];
                final resultadosManana = snapshot.data![1];

                // --- AGRUPAR LOS DE HOY ---
                final tripsPorRutaHoy =
                    <String, List<List<drift.TypedResult>>>{};
                final viajesPorTripHoy = <String, List<drift.TypedResult>>{};

                for (final fila in resultadosHoy) {
                  final tripId = fila.readTable(widget.db.trips).id;
                  if (!viajesPorTripHoy.containsKey(tripId)) {
                    viajesPorTripHoy[tripId] = [];
                  }
                  viajesPorTripHoy[tripId]!.add(fila);
                }

                for (final trip in viajesPorTripHoy.values) {
                  trip.sort(
                    (a, b) => a
                        .readTable(widget.db.stopTimes)
                        .stopSequence
                        .compareTo(
                          b.readTable(widget.db.stopTimes).stopSequence,
                        ),
                  );
                  final infoRuta = trip.first.readTable(widget.db.routes);
                  if (!tripsPorRutaHoy.containsKey(infoRuta.id)) {
                    tripsPorRutaHoy[infoRuta.id] = [];
                  }
                  tripsPorRutaHoy[infoRuta.id]!.add(trip);
                }

                // --- AGRUPAR LOS DE MAÑANA ---
                final tripsPorRutaManana =
                    <String, List<List<drift.TypedResult>>>{};
                final viajesPorTripManana = <String, List<drift.TypedResult>>{};

                for (final fila in resultadosManana) {
                  final tripId = fila.readTable(widget.db.trips).id;
                  if (!viajesPorTripManana.containsKey(tripId)) {
                    viajesPorTripManana[tripId] = [];
                  }
                  viajesPorTripManana[tripId]!.add(fila);
                }
                for (final trip in viajesPorTripManana.values) {
                  trip.sort(
                    (a, b) => a
                        .readTable(widget.db.stopTimes)
                        .stopSequence
                        .compareTo(
                          b.readTable(widget.db.stopTimes).stopSequence,
                        ),
                  );
                  final infoRuta = trip.first.readTable(widget.db.routes);
                  if (!tripsPorRutaManana.containsKey(infoRuta.id)) {
                    tripsPorRutaManana[infoRuta.id] = [];
                  }
                  tripsPorRutaManana[infoRuta.id]!.add(trip);
                }

                final listaIdsRutas = tripsPorRutaHoy.keys.toList();

                // Usamos la hora SELECCIONADA para calcular qué buses han pasado ya
                final minutosActuales =
                    _fechaSeleccionada.hour * 60 + _fechaSeleccionada.minute;

                int obtenerMinutos(String horaGtfs) {
                  final partes = horaGtfs.split(':');
                  return int.parse(partes[0]) * 60 + int.parse(partes[1]);
                }

                return ListView.builder(
                  itemCount: listaIdsRutas.length,
                  itemBuilder: (context, index) {
                    final idRuta = listaIdsRutas[index];
                    final tripsRutaHoy = tripsPorRutaHoy[idRuta]!;
                    final tripsRutaManana = tripsPorRutaManana[idRuta] ?? [];

                    final infoRuta = tripsRutaHoy.first.first.readTable(
                      widget.db.routes,
                    );

                    final tripsPorDestinoHoy =
                        <String, List<List<drift.TypedResult>>>{};
                    for (final trip in tripsRutaHoy) {
                      final destino = trip.last.readTable(widget.db.stops).name;
                      if (!tripsPorDestinoHoy.containsKey(destino)) {
                        tripsPorDestinoHoy[destino] = [];
                      }
                      tripsPorDestinoHoy[destino]!.add(trip);
                    }

                    final contenidoExpandido = <Widget>[];
                    int contadorSentidos = 0;

                    for (final destino in tripsPorDestinoHoy.keys) {
                      final tripsEsteSentidoHoy = tripsPorDestinoHoy[destino]!;

                      // Arregladas las traducciones (Valenciano y Castellano correctos)
                      final String tituloIda =
                          _idiomaActual == IdiomaApp.valenciano
                          ? "ANADA"
                          : "IDA";
                      final String tituloVuelta =
                          _idiomaActual == IdiomaApp.valenciano
                          ? "TORNADA"
                          : "VUELTA";
                      final String prefijoHacia =
                          _idiomaActual == IdiomaApp.valenciano
                          ? "Cap a"
                          : "Hacia";

                      final tituloSentido = contadorSentidos == 0
                          ? tituloIda
                          : tituloVuelta;
                      contadorSentidos++;

                      contenidoExpandido.add(
                        Container(
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Text(
                            '$tituloSentido: $prefijoHacia $destino',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade700,
                            ),
                          ),
                        ),
                      );

                      final viajePlantilla = tripsEsteSentidoHoy.reduce(
                        (a, b) => a.length > b.length ? a : b,
                      );
                      final nombresParadas = <String>{};

                      for (final parada in viajePlantilla) {
                        final paradaInfo = parada.readTable(widget.db.stops);
                        if (nombresParadas.contains(paradaInfo.name)) continue;
                        nombresParadas.add(paradaInfo.name);

                        String horaBus = _idiomaActual == IdiomaApp.valenciano
                            ? "Passà"
                            : "Pasó";
                        int minDif = 999999;

                        for (final trip in tripsEsteSentidoHoy) {
                          final matches = trip
                              .where(
                                (p) =>
                                    p.readTable(widget.db.stops).name ==
                                    paradaInfo.name,
                              )
                              .toList();
                          if (matches.isNotEmpty) {
                            final horario = matches.first.readTable(
                              widget.db.stopTimes,
                            );
                            final minBus = obtenerMinutos(horario.arrivalTime);
                            if (minBus >= minutosActuales &&
                                (minBus - minutosActuales) < minDif) {
                              minDif = minBus - minutosActuales;
                              horaBus = horario.arrivalTime
                                  .split(':')
                                  .sublist(0, 2)
                                  .join(':');
                            }
                          }
                        }

                        contenidoExpandido.add(
                          Column(
                            children: [
                              const Divider(height: 1, thickness: 1),
                              ListTile(
                                contentPadding: const EdgeInsets.only(
                                  left: 32,
                                  right: 16,
                                ),
                                title: Text(
                                  paradaInfo.name,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                trailing: Text(
                                  horaBus,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color:
                                        (horaBus == "Pasó" ||
                                            horaBus == "Passà")
                                        ? Colors.grey.shade400
                                        : Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      String textoManana = _idiomaActual == IdiomaApp.valenciano
                          ? "No hi ha servei demà"
                          : "No hay servicio mañana";

                      final tripsEsteSentidoManana = tripsRutaManana
                          .where(
                            (trip) =>
                                trip.last.readTable(widget.db.stops).name ==
                                destino,
                          )
                          .toList();

                      if (tripsEsteSentidoManana.isNotEmpty) {
                        final primerTripManana = tripsEsteSentidoManana.reduce((
                          a,
                          b,
                        ) {
                          final minA = obtenerMinutos(
                            a.first.readTable(widget.db.stopTimes).arrivalTime,
                          );
                          final minB = obtenerMinutos(
                            b.first.readTable(widget.db.stopTimes).arrivalTime,
                          );
                          return minA < minB ? a : b;
                        });
                        textoManana = primerTripManana.first
                            .readTable(widget.db.stopTimes)
                            .arrivalTime
                            .split(':')
                            .sublist(0, 2)
                            .join(':');
                      }

                      contenidoExpandido.add(
                        const Divider(height: 1, thickness: 1),
                      );
                      contenidoExpandido.add(
                        ListTile(
                          contentPadding: const EdgeInsets.only(
                            left: 32,
                            right: 16,
                          ),
                          leading: const Icon(
                            Icons.wb_sunny_outlined,
                            color: Colors.orange,
                          ),
                          title: Text(
                            _idiomaActual == IdiomaApp.valenciano
                                ? 'Primer bus de demà'
                                : 'Primer bus de mañana',
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          trailing: Text(
                            textoManana,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                      contenidoExpandido.add(const SizedBox(height: 12));
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          child: Text(
                            infoRuta.shortName ?? 'Bus',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(
                          formatearNombreRuta(infoRuta.longName, _idiomaActual),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        children: contenidoExpandido,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
