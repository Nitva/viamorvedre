import 'dart:ui' as ui;

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import 'package:viamorvedre/core/database/app_database.dart';
import 'package:viamorvedre/core/utils/language_formater.dart';
import 'package:viamorvedre/widgets/shared/glassmorphism_card.dart';

class LineaDetalleScreen extends StatefulWidget {
  final String routeId;
  final AppDatabase db;
  final VoidCallback? onBack;
  final IdiomaApp idioma;

  const LineaDetalleScreen({
    super.key,
    required this.routeId,
    required this.db,
    this.onBack,
    required this.idioma,
  });

  @override
  State<LineaDetalleScreen> createState() => _LineaDetalleScreenState();
}

class _LineaDetalleScreenState extends State<LineaDetalleScreen> {
  late IdiomaApp _idiomaActual;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _idiomaActual = widget.idioma;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Color _colorForRoute(String? shortName) {
    if (shortName == null) return Colors.blue.shade400;
    final colors = [
      Colors.blue.shade400,
      Colors.red.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
    ];
    final index = shortName.hashCode % colors.length;
    return colors[index.abs()];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: Future.wait([_getRouteInfo(), _getStopsForRoute()]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cargando...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final routeData = snapshot.data[0];
        final stops = snapshot.data[1] as List<Map<String, String>>;

        if (routeData == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('No encontrada'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(child: Text('Línea no encontrada')),
          );
        }

        final colorLinea = _colorForRoute(routeData['shortName']);
        final nombreLinea = formatearNombreRuta(
          routeData['longName'],
          _idiomaActual,
        );

        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Header sticky con color
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                backgroundColor: colorLinea,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (widget.onBack != null) {
                      widget.onBack!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: colorLinea,
                    child: Stack(
                      children: [
                        // Fondo con gradiente
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorLinea,
                                colorLinea.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                        // Grid background
                        Positioned.fill(
                          child: CustomPaint(painter: _GridPainter()),
                        ),
                        // Contenido
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.25,
                                ),
                                child: BackdropFilter(
                                  filter: ui.ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        routeData['shortName'] ?? 'Bus',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Línea ${routeData['shortName'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      nombreLinea,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Contenido
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mapa de ruta simulado
                      GlassmorphismCard(
                        padding: const EdgeInsets.all(0),
                        borderRadius: 16,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorLinea,
                                  colorLinea.withValues(alpha: 0.6),
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                CustomPaint(
                                  painter: _GridPainter(),
                                  size: Size.infinite,
                                ),
                                Center(
                                  child: Text(
                                    'Vista previa de ruta',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                // Línea de ruta
                                Positioned(
                                  top: 60,
                                  left: 30,
                                  right: 30,
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: Container(
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withValues(
                                                alpha: 0.6,
                                              ),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Marcadores
                                Positioned(
                                  top: 80,
                                  left: 50,
                                  child: _buildStopMarker(colorLinea),
                                ),
                                Positioned(
                                  top: 100,
                                  right: 60,
                                  child: _buildStopMarker(colorLinea),
                                ),
                                Positioned(
                                  bottom: 30,
                                  left: 100,
                                  child: _buildStopMarker(colorLinea),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Recorrido
                      GlassmorphismCard(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recorrido',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 16),
                            if (stops.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: stops.length,
                                itemBuilder: (context, index) {
                                  final isFirst = index == 0;
                                  final isLast = index == stops.length - 1;

                                  return Row(
                                    children: [
                                      // Timeline
                                      Column(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isFirst || isLast
                                                  ? colorLinea
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: colorLinea,
                                                width: 2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                isFirst
                                                    ? Icons.radio_button_checked
                                                    : isLast
                                                    ? Icons.stop_circle
                                                    : Icons.circle,
                                                color: isFirst || isLast
                                                    ? Colors.white
                                                    : colorLinea,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          if (!isLast)
                                            Container(
                                              width: 2,
                                              height: 30,
                                              color: colorLinea.withValues(
                                                alpha: 0.3,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      // Información parada
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      stops[index]['name']!,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            isFirst || isLast
                                                            ? FontWeight.w600
                                                            : FontWeight.w400,
                                                        fontSize: 14,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    stops[index]['hora']!,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 13,
                                                      color:
                                                          Colors.blue.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                isFirst
                                                    ? 'Parada inicial'
                                                    : isLast
                                                    ? 'Parada final'
                                                    : 'Parada ${index + 1}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            else
                              const Text('Sin paradas registradas'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Información general
                      GlassmorphismCard(
                        padding: const EdgeInsets.all(16),
                        borderRadius: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Información',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            _infoRow(
                              'Número de línea:',
                              routeData['shortName'] ?? 'N/A',
                            ),
                            const SizedBox(height: 8),
                            _infoRow('Nombre:', nombreLinea),
                            const SizedBox(height: 8),
                            _infoRow('Paradas:', '${stops.length}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildStopMarker(Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(Icons.location_on, color: color, size: 18),
    );
  }

  Future<Map<String, dynamic>?> _getRouteInfo() async {
    try {
      final query = await (widget.db.select(
        widget.db.routes,
      )..where((tbl) => tbl.id.equals(widget.routeId))).getSingleOrNull();

      return {
        'id': query?.id,
        'shortName': query?.shortName,
        'longName': query?.longName,
      };
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, String>>> _getStopsForRoute() async {
    try {
      // Obtener todos los trips de esta ruta
      final trips = await (widget.db.select(
        widget.db.trips,
      )..where((tbl) => tbl.routeId.equals(widget.routeId))).get();

      if (trips.isEmpty) return [];

      final firstTrip = trips.first; // Usar el primer viaje como referencia
      final tripIds = trips.map((t) => t.id).toList();

      // Obtener todos los stopTimes para estos trips, ordenados
      final stopTimes =
          await (widget.db.select(widget.db.stopTimes)
                ..where((tbl) => tbl.tripId.isIn(tripIds))
                ..orderBy([(u) => OrderingTerm(expression: u.stopSequence)]))
              .get();

      if (stopTimes.isEmpty) return [];

      // Extraer stopIds únicos manteniendo el orden
      final stopIds = stopTimes.map((st) => st.stopId).toSet().toList();

      // Obtener los stops
      final stops = await (widget.db.select(
        widget.db.stops,
      )..where((tbl) => tbl.id.isIn(stopIds))).get();

      // Crear mapa de stopId -> hora (usando primer viaje)
      final stopsTimesFirstTrip = await (widget.db.select(
        widget.db.stopTimes,
      )..where((tbl) => tbl.tripId.equals(firstTrip.id))).get();

      final stopIdToTime = <String, String>{};
      for (final stopTime in stopsTimesFirstTrip) {
        // Formatear a HH:MM (sin segundos)
        stopIdToTime[stopTime.stopId] = stopTime.arrivalTime.substring(0, 5);
      }

      // Ordenar stops según el orden de stopIds con su hora
      // FILTRAR: Solo mostrar paradas que tengan horario (no mostrar --:--)
      final orderedStops = <Map<String, String>>[];
      for (final stopId in stopIds) {
        final hora = stopIdToTime[stopId];

        // Solo agregar si tiene horario válido (no es null/--:--)
        if (hora != null && hora != '--:--') {
          final stop = stops.firstWhere((s) => s.id == stopId);
          if (!orderedStops.any((m) => m['name'] == stop.name)) {
            orderedStops.add({'name': stop.name, 'hora': hora});
          }
        }
      }

      return orderedStops;
    } catch (e) {
      return [];
    }
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
