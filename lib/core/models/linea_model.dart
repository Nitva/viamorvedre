import 'package:flutter/material.dart';

class Linea {
  final String id;
  final String numero;
  final String nombre;
  final String rutaDescripcion;
  final Color color;
  final String horarioInicio;
  final String horarioFin;
  final List<String> paradas;

  Linea({
    required this.id,
    required this.numero,
    required this.nombre,
    required this.rutaDescripcion,
    required this.color,
    required this.horarioInicio,
    required this.horarioFin,
    required this.paradas,
  });
}

class Bus {
  final String id;
  final String lineaId;
  final String numeroLinea;
  final String ubicacion;
  final int tiempoEstimado;
  final double latitud;
  final double longitud;
  final int pasajeros;
  final String estado;

  Bus({
    required this.id,
    required this.lineaId,
    required this.numeroLinea,
    required this.ubicacion,
    required this.tiempoEstimado,
    required this.latitud,
    required this.longitud,
    required this.pasajeros,
    required this.estado,
  });
}

class Parada {
  final String id;
  final String nombre;
  final double latitud;
  final double longitud;
  final List<String> lineasQueParam;

  Parada({
    required this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.lineasQueParam,
  });
}
