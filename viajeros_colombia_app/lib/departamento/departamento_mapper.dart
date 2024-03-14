import 'depatamento_model.dart';
import '../core/mapper.dart';

class DepartamentoMapper extends Mapper<DepartamentoModel> {
  @override
  DepartamentoModel fromMap(Map<String, dynamic> json) => DepartamentoModel(
        nombre: json['nombre'] ?? '',

        descripcion: json['descripcion'] ?? '',
        informacionGeografica: InformacionGeograficaMapper()
            .fromMap(json['informacion_geografica']),
        // atracciones:List<> json['atracciones'] != null
        //     ? AtraccionMapper().fromMap(json['atracciones'])
        //     : null,
        cultura: CulturaMapper().fromMap(json['cultura']),
        author: json['author'] ?? '',
        fraseTipica: json['frase_tipica'] ?? '',
        notaHistorica: json['nota_historica'] ?? '',
        region: json['region'] ?? '',
        segundaNota: json['segunda_nota'] ?? '',
        slogan: json['slogan'] ?? '',
      );
}

class InformacionGeograficaMapper extends Mapper<InformacionGeograficaModel> {
  @override
  InformacionGeograficaModel fromMap(Map<String, dynamic> json) =>
      InformacionGeograficaModel(
          capital: json['capital'] ?? '',
          alturaMaxima: json['altura_maxima'],
          ecosistemas: List<String>.from(json['ecosistemas'].map((x) => x)),
          rios: List<String>.from(json['rios'].map((x) => x)),
          superficie: json['superficie'],
          poblacion: json['poblacion']);
}

class CulturaMapper extends Mapper<CulturaModel> {
  @override
  CulturaModel fromMap(Map<String, dynamic> json) => CulturaModel(
      gruposEtnicos: List<String>.from(json['grupos_etnicos'].map((x) => x)),
      tradiciones: List<String>.from(json['tradiciones'].map((x) => x)),
      productos: List<String>.from(json['productos'].map((x) => x)));
}
