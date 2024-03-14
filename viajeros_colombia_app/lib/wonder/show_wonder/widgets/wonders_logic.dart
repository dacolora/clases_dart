import 'package:collection/collection.dart';

import '../../../departamento/departamentos_data/chichen_itza_data.dart';
import '../../../departamento/departamentos_data/christ_redeemer_data.dart';
import '../../../departamento/departamentos_data/Antioquia/antioquia_data.dart';
import '../../../departamento/departamentos_data/great_wall_data.dart';
import '../../../departamento/departamentos_data/machu_picchu_data.dart';
import '../../../departamento/departamentos_data/petra_data.dart';
import '../../../departamento/departamentos_data/pyramids_giza_data.dart';
import '../../../departamento/departamentos_data/taj_mahal_data.dart';
import '../../../departamento/departamentos_data/wonder_data.dart';

class WondersLogic {
  List<WonderData> all = [
    GreatWallData(),
    PetraData(),
    Antoquia(),
    ChichenItzaData(),
    MachuPicchuData(),
    TajMahalData(),
    ChristRedeemerData(),
    PyramidsGizaData(),
  ];

  final int timelineStartYear = -3000;
  final int timelineEndYear = 2200;

  WonderData getData(WonderType value) {
    WonderData? result = all.firstWhereOrNull((w) => w.type == value);
    if (result == null) throw ('Could not find data for wonder type $value');
    return result;
  }

  void init() {
    all = [
      GreatWallData(),
      PetraData(),
      Antoquia(),
      ChichenItzaData(),
      MachuPicchuData(),
      TajMahalData(),
      ChristRedeemerData(),
      PyramidsGizaData(),
    ];
  }
}
