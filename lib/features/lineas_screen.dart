import 'package:flutter/material.dart';

import 'package:viamorvedre/core/theme/app_colors.dart';
import 'package:viamorvedre/core/theme/app_text_styles.dart';
import 'package:viamorvedre/core/models/mock_data.dart';
import 'package:viamorvedre/core/models/linea_model.dart';
import 'package:viamorvedre/widgets/linea_card.dart';
import 'package:viamorvedre/widgets/custom_search_bar.dart';

class LineasScreen extends StatefulWidget {
  final Function(Linea)? onLineaSelected;

  const LineasScreen({super.key, this.onLineaSelected});

  @override
  State<LineasScreen> createState() => _LineasScreenState();
}

class _LineasScreenState extends State<LineasScreen> {
  late String searchQuery;

  @override
  void initState() {
    super.initState();
    searchQuery = '';
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar líneas según búsqueda
    final filteredLineas = lineasMock.where((linea) {
      return linea.nombre.toLowerCase().contains(searchQuery.toLowerCase()) ||
          linea.numero.contains(searchQuery) ||
          linea.rutaDescripcion.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
    }).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fondo decorativo
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.lineaBlue.withValues(alpha: 0.15),
                    AppColors.lineaPurple.withValues(alpha: 0.15),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Barra de búsqueda
            CustomSearchBar(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              hint: 'Buscar línea, número o ruta...',
            ),
            const SizedBox(height: 24),
            // Título y count
            Row(
              children: [
                Text('Todas las líneas', style: AppTextStyles.headingMedium),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${filteredLineas.length}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Lista de líneas
            if (filteredLineas.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron líneas',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filteredLineas.map((linea) {
                final proximoBus = busesActivosMock
                    .where((bus) => bus.lineaId == linea.id)
                    .fold<Bus?>(null, (prev, current) {
                      if (prev == null) return current;
                      return prev.tiempoEstimado < current.tiempoEstimado
                          ? prev
                          : current;
                    });

                final hayBusesActivos = busesActivosMock.any(
                  (bus) => bus.lineaId == linea.id,
                );

                return LineaCard(
                  linea: linea,
                  proximoBus: proximoBus,
                  hayBusesActivos: hayBusesActivos,
                  onTap: () {
                    widget.onLineaSelected?.call(linea);
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}
