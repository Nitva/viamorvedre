import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:viamorvedre/core/database/app_database.dart';
import 'package:viamorvedre/core/utils/language_formater.dart';
import 'package:viamorvedre/widgets/shared/glassmorphism_card.dart';
import 'dart:ui' as ui;

class EnVivoScreen extends StatefulWidget {
  final AppDatabase db;
  final IdiomaApp idioma;

  const EnVivoScreen({super.key, required this.db, required this.idioma});

  @override
  State<EnVivoScreen> createState() => _EnVivoScreenState();
}

class _EnVivoScreenState extends State<EnVivoScreen>
    with SingleTickerProviderStateMixin {
  late IdiomaApp _idiomaActual;
  DateTime _fechaSeleccionada = DateTime.now();
  bool _esFechaPersonalizada = false;
  bool _isEditingTime = false;
  late TextEditingController _timeController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _idiomaActual = widget.idioma;
    _timeController = TextEditingController(
      text: _formatTime(_fechaSeleccionada),
    );
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _timeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  int obtenerMinutos(String horaGtfs) {
    final partes = horaGtfs.split(':');
    return int.parse(partes[0]) * 60 + int.parse(partes[1]);
  }

  String _formatearHoraGtfs(String horaGtfs) {
    // Convierte "07:00:00" → "07:00"
    return horaGtfs.substring(0, 5);
  }

  Map<String, dynamic> _obtenerProximoBus(
    List<List<drift.TypedResult>> tripsRuta,
  ) {
    final ahora = DateTime.now();
    final minutosAhora = ahora.hour * 60 + ahora.minute;

    int minutosProximo = double.maxFinite.toInt();
    String horaProxima = '--:--';

    for (final trip in tripsRuta) {
      // Obtener el primer stopTime del viaje
      if (trip.isNotEmpty) {
        final primerStopTime = trip.first.readTable(widget.db.stopTimes);
        final minutosStop = obtenerMinutos(primerStopTime.arrivalTime);

        if (minutosStop >= minutosAhora) {
          if (minutosStop < minutosProximo) {
            minutosProximo = minutosStop;
            horaProxima = _formatearHoraGtfs(primerStopTime.arrivalTime);
          }
        }
      }
    }

    if (minutosProximo == double.maxFinite.toInt()) {
      return {'hora': '--:--', 'minutos': '--', 'color': Colors.grey.shade400};
    }

    final minutosRestantes = minutosProximo - minutosAhora;
    final colorFinal = minutosRestantes < 10
        ? Colors.red.shade600
        : Colors.blue.shade600;

    return {
      'hora': horaProxima,
      'minutos': minutosRestantes,
      'color': colorFinal,
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final mapSize = screenSize.width - 48;
    final minMapSize = mapSize < 350.0 ? mapSize : 350.0;

    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          // Fondo decorativo con gradiente mejorado
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenSize.height * 0.4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade400.withValues(alpha: 0.25),
                    Colors.purple.shade400.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Mapa ficticio - FIJO CON GLASSMORPHISM MEJORADO
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    width: minMapSize,
                    height: minMapSize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.purple.shade400],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Grid background
                        Positioned.fill(
                          child: CustomPaint(painter: _GridPainter()),
                        ),
                        // Texto placeholder
                        Center(
                          child: Text(
                            'Mapa Interactivo',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.25),
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        // Marcadores de buses simulados
                        Positioned(
                          top: (minMapSize * 0.3).toDouble(),
                          left: (minMapSize * 0.25).toDouble(),
                          child: _buildMarker(Colors.blue.shade200),
                        ),
                        Positioned(
                          top: (minMapSize * 0.5).toDouble(),
                          right: (minMapSize * 0.3).toDouble(),
                          child: _buildMarker(Colors.purple.shade200),
                        ),
                        Positioned(
                          bottom: (minMapSize * 0.25).toDouble(),
                          left: (minMapSize * 0.6).toDouble(),
                          child: _buildMarker(Colors.green.shade200),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Contenido desplazable que se superpone al mapa
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Altura para que el scroll comience después del mapa
                SizedBox(height: 80 + minMapSize + 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner si fecha personalizada
                      if (_esFechaPersonalizada)
                        GlassmorphismCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          borderRadius: 12,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '🗓️ ${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year} ${_formatTime(_fechaSeleccionada)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _fechaSeleccionada = DateTime.now();
                                    _esFechaPersonalizada = false;
                                    _timeController.text = _formatTime(
                                      _fechaSeleccionada,
                                    );
                                  });
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text(
                                  'Ahora',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_esFechaPersonalizada) const SizedBox(height: 12),

                      // Selector de hora
                      GlassmorphismCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        borderRadius: 12,
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _isEditingTime
                                  ? TextField(
                                      controller: _timeController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      _formatTime(_fechaSeleccionada),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                            IconButton(
                              icon: Icon(
                                _isEditingTime ? Icons.check : Icons.edit,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_isEditingTime) {
                                    try {
                                      final parts = _timeController.text.split(
                                        ':',
                                      );
                                      final hour = int.parse(parts[0]);
                                      final minute = int.parse(parts[1]);
                                      _fechaSeleccionada = DateTime(
                                        _fechaSeleccionada.year,
                                        _fechaSeleccionada.month,
                                        _fechaSeleccionada.day,
                                        hour,
                                        minute,
                                      );
                                    } catch (e) {
                                      _timeController.text = _formatTime(
                                        _fechaSeleccionada,
                                      );
                                    }
                                  }
                                  _isEditingTime = !_isEditingTime;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Título líneas en servicio
                      Text(
                        'Líneas en servicio',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),

                // Lista de líneas con glassmorphism mejorado
                _buildLineasList(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.6),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(Icons.location_on, color: Colors.white, size: 20),
    );
  }

  Widget _buildLineasList() {
    return FutureBuilder<List<List<drift.TypedResult>>>(
      future: Future.wait([
        widget.db.getBusesPorSaguntoParaFecha(_fechaSeleccionada),
        widget.db.getBusesPorSaguntoParaFecha(
          _fechaSeleccionada.add(const Duration(days: 1)),
        ),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData ||
            (snapshot.data![0].isEmpty && snapshot.data![1].isEmpty)) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No hay autobuses programados'),
          );
        }

        final resultadosHoy = snapshot.data![0];

        // Agrupar líneas
        final tripsPorRutaHoy = <String, List<List<drift.TypedResult>>>{};
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
                .compareTo(b.readTable(widget.db.stopTimes).stopSequence),
          );
          final infoRuta = trip.first.readTable(widget.db.routes);
          if (!tripsPorRutaHoy.containsKey(infoRuta.id)) {
            tripsPorRutaHoy[infoRuta.id] = [];
          }
          tripsPorRutaHoy[infoRuta.id]!.add(trip);
        }

        final listaIdsRutas = tripsPorRutaHoy.keys.toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listaIdsRutas.length,
            itemBuilder: (context, index) {
              final idRuta = listaIdsRutas[index];
              final tripsRutaHoy = tripsPorRutaHoy[idRuta]!;
              final infoRuta = tripsRutaHoy.first.first.readTable(
                widget.db.routes,
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassmorphismCard(
                  padding: const EdgeInsets.all(12),
                  borderRadius: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue.shade400,
                            child: Text(
                              infoRuta.shortName ?? 'Bus',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatearNombreRuta(
                                    infoRuta.longName,
                                    _idiomaActual,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  _idiomaActual == IdiomaApp.valenciano
                                      ? '${tripsRutaHoy.length} horaris disponibles'
                                      : '${tripsRutaHoy.length} horarios disponibles',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Próximo bus a la derecha
                          Builder(
                            builder: (context) {
                              final proximoBus = _obtenerProximoBus(
                                tripsRutaHoy,
                              );
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    proximoBus['hora'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${proximoBus['minutos']} min',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: proximoBus['color'],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 20.0;
    const strokeWidth = 0.5;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = strokeWidth;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
