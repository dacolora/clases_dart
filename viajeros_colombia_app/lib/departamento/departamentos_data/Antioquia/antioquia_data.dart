import 'package:travel_app_colombia/atraccion/atraccion_model.dart';
import 'package:travel_app_colombia/departamento/departamentos_data/wonder_data.dart';

import '../../departamento_mapper.dart';
import '../../depatamento_model.dart';

class Antoquia extends WonderData {
  Antoquia()
      : super(
          type: WonderType.colosseum,
          title: Value().model.nombre,
          subTitle: Value().model.slogan,
          regionTitle: Value().model.region,
          artifactCulture: "Viajeros Colombia",
          lat: 41.890242126393495,
          lng: 12.492349361871392,
          pullQuote2: Value().model.fraseTipica,
          pullQuote2Author: 'pullQuote2Author',
          notaHistoria1: Value().model.notaHistorica,
          notaHistoria2: Value().model.segundaNota,
          descripcion: Value().model.descripcion,
          constructionInfo2: 'constructionInfo2',
          locationInfo2: 'locationInfo2',
          informacionGeografica: InformacionGeograficaModel(
              capital: Value().model.informacionGeografica.capital,
              alturaMaxima: Value().model.informacionGeografica.alturaMaxima,
              ecosistemas: Value().model.informacionGeografica.ecosistemas,
              poblacion: Value().model.informacionGeografica.poblacion,
              rios: Value().model.informacionGeografica.rios,
              superficie: Value().model.informacionGeografica.superficie),
          cultura: CulturaModel(
              gruposEtnicos: Value().model.cultura.gruposEtnicos,
              productos: Value().model.cultura.productos,
              tradiciones: Value().model.cultura.tradiciones),
          highlightArtifacts: const [
            '251350',
            '255960',
            '247993',
            '250464',
            '251476',
            '255960',
          ],
          hiddenArtifacts: const [
            '245376',
            '256570',
            '286136',
          ],
          lugares: [
            AtraccionModel(
              nombre: 'Piedra del Peñol',
              categoria: 'Cultural',
              ecosistema: 'Represa',
            ),
            AtraccionModel(
              nombre: 'Mutata',
              categoria: 'Senderismo',
              ecosistema: 'Rio',
            ),
            AtraccionModel(
              nombre: 'Cerro Tusa',
              categoria: 'Senderismo',
              ecosistema: 'Montaña',
            ),
            AtraccionModel(
              nombre: 'Paramo del Sol',
              categoria: 'Senderismo',
              ecosistema: 'Montaña',
            ),
            AtraccionModel(
              nombre: 'Comuna 13',
              categoria: 'Cultural',
              ecosistema: 'Ciudad',
            ),
          ],
        );
}

class Value {
  final DepartamentoModel model = DepartamentoMapper().fromMap(antioquia);
}

final Map<String, dynamic> antioquia = {
  "nombre": "Antioquia",
  "slogan": "Entre Montañas y Progreso Histórico",
  "region": "Region andina",
  "descripcion":
      "Es uno de los departamentos más grandes y poblados de Colombia.limita al norte con Bolívar, al este con Santander, al sur con Caldas y Risaralda, al suroeste con Chocó, y al oeste con Córdoba. La región es famosa por su café, sus paisajes montañosos y sus festivales.",
  "nota_historica":
      "La Feria de las Flores considerado el evento mas grande de antioquia, comenzó en 1957",
  "segunda_nota":
      "Cuenta con el transporte publico mas grande de Colombia, El METRO de Medellin inagurado en 1995",
  "frase_tipica": "¡Hola, parce!",
  "author": "Daniel Colorado",
  "informacion_geografica": {
    "capital": "Medellin",
    "superficie": 63612,
    "altura_maxima": 3820,
    "poblacion": 1,
    "rios": ["Río Cauca", "Río Nechí"],
    "ecosistemas": ["Montañas de los Andes", "Bosques Nubosos"],
  },
  "cultura": {
    "grupos_etnicos": ["Huitoto", "Yagua"],
    "tradiciones": [
      "Feria de las Flores",
      "Festival Internacional de Jazz de Medellín"
    ],
    "productos": ["Café arábica", "Textiles de alta calidad"]
  },
};
