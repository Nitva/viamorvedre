import 'package:flutter/material.dart';

import 'package:viamorvedre/core/theme/app_colors.dart';
import 'package:viamorvedre/core/theme/app_text_styles.dart';
import 'package:viamorvedre/core/models/linea_model.dart';
import 'package:viamorvedre/core/models/mock_data.dart';

class LineaDetalleScreen extends StatelessWidget {
  final Linea linea;

  const LineaDetalleScreen({super.key, required this.linea});

  @override
  Widget build(BuildContext context) {
    final busesDeLinea = busesActivosMock
        .where((bus) => bus.lineaId == linea.id)
        .toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información de la línea
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información de la Línea',
                      style: AppTextStyles.headingSmall,
                    ),
                    const SizedBox(height: 16),
                    _infoRow(
                      icon: Icons.route,
                      label: 'Ruta',
                      value: linea.rutaDescripcion,
                    ),
                    const SizedBox(height: 12),
                    _infoRow(
                      icon: Icons.schedule,
                      label: 'Horario',
                      value: '${linea.horarioInicio} - ${linea.horarioFin}',
                    ),
                    const SizedBox(height: 12),
                    _infoRow(
                      icon: Icons.directions_bus,
                      label: 'Buses activos',
                      value: '${busesDeLinea.length}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Paradas
            Text(
              'Paradas (${linea.paradas.length})',
              style: AppTextStyles.headingSmall,
            ),
            const SizedBox(height: 12),
            ...List.generate(linea.paradas.length, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: linea.color, width: 4),
                  ),
                  color: isDark ? AppColors.cardDark : AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: linea.color.withValues(alpha: 0.2),
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: linea.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        linea.paradas[index],
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            // Buses activos
            if (busesDeLinea.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buses en circulación',
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: 12),
                  ...busesDeLinea.map((bus) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: linea.color.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: linea.color,
                            child: const Icon(
                              Icons.directions_bus,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bus.ubicacion,
                                  style: AppTextStyles.bodyMedium,
                                ),
                                Text(
                                  '${bus.pasajeros} pasajeros',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              bus.tiempoEstimado < 1
                                  ? 'Llegando'
                                  : '${bus.tiempoEstimado} min',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
