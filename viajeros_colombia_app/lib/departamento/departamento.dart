enum Departamento {
  antioquia,
  arauca,
  atlantico,
  bolivar,
  boyaca,
  caldas,
  caqueta,
  casanare,
  cauca,
  cesar,
  choco,
  cordoba,
  cundinamarca,
  guainia,
  guaviare,
  huila,
  laGuajira,
  magdalena,
  meta,
  narino,
  norteDeSantander,
  putumayo,
  quindio,
  risaralda,
  sanAndresYProvidencia,
  santander,
  sucre,
  tolima,
  valleDelCauca,
  vaupes,
  vichada,
  none
}

Departamento? parseDepartamento(String departamentoValue) {
  String departamento = departamentoValue.toLowerCase().trim();

  if (departamento.contains('antioquia')) {
    return Departamento.antioquia;
  } else if (departamento.contains('arauca')) {
    return Departamento.arauca;
  } else if (departamento.contains('atlantico')) {
    return Departamento.atlantico;
  } else if (departamento.contains('bolivar')) {
    return Departamento.bolivar;
  } else if (departamento.contains('boyaca')) {
    return Departamento.boyaca;
  } else if (departamento.contains('caldas')) {
    return Departamento.caldas;
  } else if (departamento.contains('caqueta')) {
    return Departamento.caqueta;
  } else if (departamento.contains('casanare')) {
    return Departamento.casanare;
  } else if (departamento.contains('cauca')) {
    return Departamento.cauca;
  } else if (departamento.contains('cesar')) {
    return Departamento.cesar;
  } else if (departamento.contains('choco')) {
    return Departamento.choco;
  } else if (departamento.contains('cordoba')) {
    return Departamento.cordoba;
  } else if (departamento.contains('cundinamarca')) {
    return Departamento.cundinamarca;
  } else if (departamento.contains('guainia')) {
    return Departamento.guainia;
  } else if (departamento.contains('guaviare')) {
    return Departamento.guaviare;
  } else if (departamento.contains('huila')) {
    return Departamento.huila;
  } else if (departamento.contains('laguajira')) {
    return Departamento.laGuajira;
  } else if (departamento.contains('magdalena')) {
    return Departamento.magdalena;
  } else if (departamento.contains('meta')) {
    return Departamento.meta;
  } else if (departamento.contains('narino')) {
    return Departamento.narino;
  } else if (departamento.contains('norte')) {
    return Departamento.norteDeSantander;
  } else if (departamento.contains('putumayo')) {
    return Departamento.putumayo;
  } else if (departamento.contains('quindio')) {
    return Departamento.quindio;
  } else if (departamento.contains('risaralda')) {
    return Departamento.risaralda;
  } else if (departamento.contains('andres')) {
    return Departamento.sanAndresYProvidencia;
  } else if (departamento.contains('santander')) {
    return Departamento.santander;
  } else if (departamento.contains('sucre')) {
    return Departamento.sucre;
  } else if (departamento.contains('tolima')) {
    return Departamento.tolima;
  } else if (departamento.contains('valledelcauca')) {
    return Departamento.valleDelCauca;
  } else if (departamento.contains('vaupes')) {
    return Departamento.vaupes;
  } else if (departamento.contains('vichada')) {
    return Departamento.vichada;
  } else {
    return Departamento.none;
  }
}
