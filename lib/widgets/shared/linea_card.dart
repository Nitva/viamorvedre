import 'package:flutter/material.dart';
import 'package:viamorvedre/widgets/shared/glassmorphism_card.dart';

class LineaCard extends StatelessWidget {
  final String numero;
  final String nombre;
  final String descripcion;
  final String? proximoAutobus;
  final bool enServicio;
  final int paradasCount;
  final Color colorLinea;
  final VoidCallback onTap;

  const LineaCard({
    super.key,
    required this.numero,
    required this.nombre,
    required this.descripcion,
    this.proximoAutobus,
    required this.enServicio,
    required this.paradasCount,
    required this.colorLinea,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 16,
      onTap: onTap,
      clickable: true,
      child: Row(
        children: [
          // Avatar con número de línea
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: colorLinea,
                child: Text(
                  numero,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              // Badge verde si está en servicio
              if (enServicio)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.8),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre + Chip de tiempo
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (proximoAutobus != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _getColorForMinutes(proximoAutobus) ??
                              Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color:
                                _getColorForMinutes(proximoAutobus) ==
                                    Colors.green.withOpacity(0.2)
                                ? Colors.green
                                : Colors.blue,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          proximoAutobus!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                _getColorForMinutes(proximoAutobus) ==
                                    Colors.green.withOpacity(0.2)
                                ? Colors.green[700]
                                : Colors.blue[700],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                // Descripción
                Row(
                  children: [
                    const Icon(
                      Icons.directions_bus,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        descripcion,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Tags
                Wrap(
                  spacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 11,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '$paradasCount paradas',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (enServicio)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'En servicio',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Flecha
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  // Helper para obtener color basado en minutos o información del próximo autobús
  static Color? _getColorForMinutes(String? text) {
    if (text == null || text.isEmpty) return null;

    try {
      // Intentar extraer el primer número
      final firstNumber = int.parse(text.split(' ')[0]);
      return firstNumber <= 5
          ? Colors.green.withOpacity(0.2)
          : Colors.blue.withOpacity(0.2);
    } catch (e) {
      // Si no es un número, usar color azul por defecto
      return Colors.blue.withOpacity(0.2);
    }
  }
}
