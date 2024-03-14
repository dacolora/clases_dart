import 'package:travel_app_colombia/atraccion/atraccion_model.dart';

class DepartamentoModel {
  final String nombre;
  final String slogan;
  final String descripcion;
  final String region;
  final String notaHistorica;
  final String segundaNota;
  final String fraseTipica;
  final String author;
  final InformacionGeograficaModel informacionGeografica;
  final List<AtraccionModel>? atracciones;
  final CulturaModel cultura;
  DepartamentoModel({
    required this.fraseTipica,
    required this.notaHistorica,
    required this.author,
    required this.segundaNota,
    required this.region,
    required this.slogan,
    required this.nombre,
    required this.descripcion,
    required this.informacionGeografica,
    this.atracciones,
    required this.cultura,
  });
}

class InformacionGeograficaModel {
  final int superficie;
  final int alturaMaxima;
  final List<String> rios;
  final List<String> ecosistemas;
  final int poblacion;
  final String capital;

  InformacionGeograficaModel({
    required this.superficie,
    required this.alturaMaxima,
    required this.capital,
    required this.rios,
    required this.ecosistemas,
    required this.poblacion,
  });
}

class CulturaModel {
  final List<String> gruposEtnicos;
  final List<String> tradiciones;
  final List<String> productos;

  CulturaModel({
    required this.gruposEtnicos,
    required this.tradiciones,
    required this.productos,
  });
}
