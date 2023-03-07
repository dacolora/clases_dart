import 'dart:math' as match;

import 'package:flutter/material.dart';

const double _kAspectRatio = 0.56222;

class ResponsiveDesign {
  late double _width, _height, _inch;

  ResponsiveDesign(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Orientation orient = MediaQuery.of(context).orientation;
    final num aspectRatio =
        (MediaQuery.of(context).size.aspectRatio / _kAspectRatio)
            .clamp(0.5, 1.0);

    if (orient == Orientation.portrait) {
      _width = size.width;
      _height = size.height;
    } else {
      _width = size.height;
      _height = size.width;
    }

    _inch = match.sqrt(
      match.pow(_width * aspectRatio, 2) + match.pow(_height * aspectRatio, 2),
    );
  }

  // Ancho
  double widthMultiplier(double pixel) {
    final double tempPercent = (pixel * 100.0) / 375.0;
    return (_width * tempPercent) / 100;
  }

  // Alto
  double heightMultiplier(double pixel) {
    final double tempPercent = pixel / 667.0;
    return _height * tempPercent;
  }

  // Texto
  double textMultiplier(double size) {
    final double tempPercent = size / 9;
    return inchPercent(tempPercent);
  }

  // Diagonal
  double inchPercent(double percent) => (_inch * percent) / 100;

  double space() => widthMultiplier(8);
}
