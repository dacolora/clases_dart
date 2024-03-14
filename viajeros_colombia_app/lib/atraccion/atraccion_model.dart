
class AtraccionModel {
  final String? nombre;
  final double? latitud;
  final double? longitud;
  final String? descripcion;
  final int? altitud;
  final String? municipio;
  final String? departamento;
  final String? categoria;
  final String? ecosistema;
  final String? fotos;

  AtraccionModel(
      {this.latitud,
      this.longitud,
      this.descripcion,
      this.altitud,
      this.municipio,
      this.departamento,
      this.categoria,
      this.ecosistema,
      this.fotos,
      this.nombre});
}

enum Categoria {
  senderismo,
  relax,
  cultural,
  extremo,
  none,
}

enum Ecosistema {
  montana,
  playa,
  rio,
  desierto,
  ciudad,
  none,
}

Categoria? parseCategoria(String categoriaValue) {
  String categoria = categoriaValue.toLowerCase().trim();

  if (categoria.contains('sendero')) {
    return Categoria.senderismo;
  } else if (categoria.contains('relax')) {
    return Categoria.relax;
  } else if (categoria.contains('cultura')) {
    return Categoria.cultural;
  } else if (categoria.contains('extremo')) {
    return Categoria.extremo;
  } else {
    return Categoria.none;
  }
}

Ecosistema? parseEcosistema(String ecosistemaValue) {
  String ecosistema = ecosistemaValue.toLowerCase().trim();

  if (ecosistema.contains('montana')) {
    return Ecosistema.montana;
  } else if (ecosistema.contains('playa')) {
    return Ecosistema.playa;
  } else if (ecosistema.contains('rio')) {
    return Ecosistema.rio;
  } else if (ecosistema.contains('ciudad')) {
    return Ecosistema.ciudad;
  } else if (ecosistema.contains('desierto')) {
    return Ecosistema.desierto;
  } else {
    return Ecosistema.none;
  }
}
