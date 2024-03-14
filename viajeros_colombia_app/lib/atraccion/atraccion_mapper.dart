import 'package:travel_app_colombia/departamento/departamento.dart';

import 'atraccion_model.dart';
import '../core/mapper.dart';

class AtraccionMapper extends Mapper<AtraccionModel> {
  @override
  AtraccionModel fromMap(Map<String, dynamic> json) => AtraccionModel(
      latitud: json['latitud'] ?? 0.0,
      longitud: json['longitud'] ?? 0.0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      altitud: json['altitud'] ?? 0,
      municipio: json['municipio'] ?? '',
      categoria: json['categoria'],
      departamento: json['departamento'],
      fotos: json['fotos'] ?? '',
      ecosistema: json['ecosistema']);
  // categoria: parseCategoria(json['categoria'] ?? ''),
  // departamento: parseDepartamento(json['departamento'] ?? ''),
  // ecosistema: parseEcosistema(json['ecosistema'] ?? ''));
}
