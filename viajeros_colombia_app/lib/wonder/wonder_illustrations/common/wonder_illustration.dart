import 'package:flutter/material.dart';
import 'package:travel_app_colombia/wonder/wonder_illustrations/common/wonder_illustration_config.dart';

import '../../show_wonder/data/wonder_type.dart';
import '../../../departamento/departamentos_data/wonder_data.dart';
import '../chichen_itza_illustration.dart';
import '../christ_redeemer_illustration.dart';
import '../colosseum_illustration.dart';
import '../great_wall_illustration.dart';
import '../machu_picchu_illustration.dart';
import '../petra_illustration.dart';
import '../pyramids_giza_illustration.dart';
import '../taj_mahal_illustration.dart';

/// Convenience class for showing an illustration when all you have is the type.
class WonderIllustration extends StatelessWidget {
  const WonderIllustration(this.type, {Key? key, required this.config})
      : super(key: key);
  final WonderIllustrationConfig config;
  final WonderType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case WonderType.chichenItza:
        return ChichenItzaIllustration(config: config);
      case WonderType.christRedeemer:
        return ChristRedeemerIllustration(config: config);
      case WonderType.colosseum:
        return ColosseumIllustration(config: config);
      case WonderType.greatWall:
        return GreatWallIllustration(config: config);
      case WonderType.machuPicchu:
        return MachuPicchuIllustration(config: config);
      case WonderType.petra:
        return PetraIllustration(config: config);
      case WonderType.pyramidsGiza:
        return PyramidsGizaIllustration(config: config);
      case WonderType.tajMahal:
        return TajMahalIllustration(config: config);
    }
  }
}
