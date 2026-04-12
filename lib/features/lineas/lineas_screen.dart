import 'package:flutter/material.dart';
import 'package:viamorvedre/core/database/app_database.dart' hide Route;
import 'package:viamorvedre/core/database/app_database.dart' as db show Route;
import 'package:viamorvedre/core/utils/language_formater.dart';
import 'package:viamorvedre/widgets/shared/glassmorphism_card.dart';
import 'package:viamorvedre/widgets/shared/search_bar.dart' as custom_search;
import 'package:viamorvedre/widgets/shared/linea_card.dart';

class LineasScreen extends StatefulWidget {
  final AppDatabase db;
  final Function(String)? onLineSelected;
  final IdiomaApp idioma;

  const LineasScreen({
    super.key,
    required this.db,
    this.onLineSelected,
    required this.idioma,
  });

  @override
  State<LineasScreen> createState() => _LineasScreenState();
}

class _LineasScreenState extends State<LineasScreen> {
  late IdiomaApp _idiomaActual;
  String _searchQuery = '';
  bool _soloActivas = false; // Filtro para mostrar solo activas
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _idiomaActual = widget.idioma;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Líneas'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Fondo decorativo con gradiente
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade400.withValues(alpha: 0.15),
                    Colors.purple.shade400.withValues(alpha: 0.08),
                    Colors.cyan.shade300.withValues(alpha: 0.08),
                  ],
                ),
              ),
            ),
          ),
          // Contenido
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Barra de búsqueda
                      custom_search.SearchBar(
                        hint: 'Buscar línea, número o ruta...',
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      // Filtro de líneas activas
                      GlassmorphismCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        borderRadius: 12,
                        child: Row(
                          children: [
                            Icon(
                              _soloActivas
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: _soloActivas ? Colors.green : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _soloActivas
                                    ? 'Mostrando solo líneas en servicio'
                                    : 'Mostrando todas las líneas',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                            Transform.scale(
                              scale: 0.85,
                              child: Switch(
                                value: _soloActivas,
                                onChanged: (value) {
                                  setState(() {
                                    _soloActivas = value;
                                  });
                                },
                                activeThumbColor: Colors.green,
                                activeTrackColor: Colors.green.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildLineasList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineasList() {
    return FutureBuilder<Map<String, dynamic>>(
      future: widget.db.getLineasConViajesParaHoy(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No hay líneas disponibles');
        }

        // Obtener todas las líneas con viajes
        final lineasData = snapshot.data!;
        final lineas = lineasData.entries
            .map(
              (e) => (e.value['route'] as db.Route, e.value['viajes'] as int),
            )
            .toList();

        // Filtrar por búsqueda y estado
        final lineasFiltradas = lineas.where((item) {
          final ruta = item.$1;
          final viajes = item.$2;
          final nombreRuta = formatearNombreRuta(
            ruta.longName ?? '',
            _idiomaActual,
          );
          final numeroRuta = ruta.shortName ?? '';
          final descripcion = ruta.longName ?? '';

          final cumpleBusqueda =
              nombreRuta.toLowerCase().contains(_searchQuery) ||
              numeroRuta.contains(_searchQuery) ||
              descripcion.toLowerCase().contains(_searchQuery);

          // Si solo activas, filtrar por viajes > 0
          if (_soloActivas) {
            return cumpleBusqueda && viajes > 0;
          }
          return cumpleBusqueda;
        }).toList();

        if (lineasFiltradas.isEmpty) {
          return GlassmorphismCard(
            padding: const EdgeInsets.all(24),
            borderRadius: 16,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _soloActivas ? Icons.schedule : Icons.search_off,
                    size: 48,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _soloActivas
                        ? 'No hay líneas en servicio hoy'
                        : 'No se encontraron líneas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return GlassmorphismCard(
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con información
              Container(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.directions_bus,
                      color: Colors.blue.shade300,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Líneas disponibles (${lineasFiltradas.length})',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              // Línea divisoria decorativa
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade400.withValues(alpha: 0.5),
                      Colors.blue.shade400.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Lista de líneas
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lineasFiltradas.length,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    height: 0.5,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                itemBuilder: (context, index) {
                  final rutaInfo = lineasFiltradas[index].$1;
                  final viajes = lineasFiltradas[index].$2;
                  final tieneServicioHoy = viajes > 0;
                  final color = tieneServicioHoy ? Colors.green : Colors.red;

                  return LineaCard(
                    numero: rutaInfo.shortName ?? 'Bus',
                    nombre: formatearNombreRuta(
                      rutaInfo.longName,
                      _idiomaActual,
                    ),
                    descripcion: rutaInfo.longName ?? 'Sin descripción',
                    proximoAutobus: tieneServicioHoy ? '$viajes viajes' : null,
                    enServicio: tieneServicioHoy,
                    paradasCount: 0,
                    colorLinea: color,
                    onTap: () {
                      widget.onLineSelected?.call(rutaInfo.id);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
