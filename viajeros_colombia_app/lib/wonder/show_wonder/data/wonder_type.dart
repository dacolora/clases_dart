import 'package:flutter/material.dart';
import 'package:travel_app_colombia/departamento/departamentos_data/wonder_data.dart';

import 'image_paths.dart';

extension WonderAssetExtensions on WonderType {
  String get assetPath {
    switch (this) {
      case WonderType.pyramidsGiza:
        return '${ImagePaths.root}/pyramids';
      case WonderType.greatWall:
        return '${ImagePaths.root}/great_wall_of_china';
      case WonderType.petra:
        return '${ImagePaths.root}/petra';
      case WonderType.colosseum:
        return '${ImagePaths.root}/colosseum';
      case WonderType.chichenItza:
        return '${ImagePaths.root}/chichen_itza';
      case WonderType.machuPicchu:
        return '${ImagePaths.root}/machu_picchu';
      case WonderType.tajMahal:
        return '${ImagePaths.root}/taj_mahal';
      case WonderType.christRedeemer:
        return '${ImagePaths.root}/christ_the_redeemer';
    }
  }

  Color get bgColor {
    switch (this) {
      case WonderType.pyramidsGiza:
        return const Color(0xFF16184D);
      case WonderType.greatWall:
        return const Color(0xFF642828);
      case WonderType.petra:
        return const Color(0xFF444B9B);
      case WonderType.colosseum:
        return const Color(0xFF1E736D);
      case WonderType.chichenItza:
        return const Color(0xFF164F2A);
      case WonderType.machuPicchu:
        return const Color(0xFF0E4064);
      case WonderType.tajMahal:
        return const Color(0xFFC96454);
      case WonderType.christRedeemer:
        return const Color(0xFF1C4D46);
    }
  }

  Color get fgColor {
    switch (this) {
      case WonderType.pyramidsGiza:
        return const Color(0xFF444B9B);
      case WonderType.greatWall:
        return const Color(0xFF688750);
      case WonderType.petra:
        return const Color(0xFF1B1A65);
      case WonderType.colosseum:
        return const Color(0xFF4AA39D);
      case WonderType.chichenItza:
        return const Color(0xFFE2CFBB);
      case WonderType.machuPicchu:
        return const Color(0xFFC1D9D1);
      case WonderType.tajMahal:
        return const Color(0xFF642828);
      case WonderType.christRedeemer:
        return const Color(0xFFED7967);
    }
  }

  String get homeBtn => '$assetPath/wonder-button.png';
  String get photo1 => '$assetPath/photo-1.jpg';
  String get photo2 => '$assetPath/photo-2.jpg';
  String get photo3 => '$assetPath/photo-3.jpg';
  String get photo4 => '$assetPath/photo-4.jpg';
  String get flattened => '$assetPath/flattened.jpg';
}
