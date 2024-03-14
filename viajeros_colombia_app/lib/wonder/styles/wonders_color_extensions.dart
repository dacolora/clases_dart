import 'package:flutter/material.dart';

import '../../departamento/departamentos_data/wonder_data.dart';

extension ColorFilterOnColor on Color {
  ColorFilter get colorFilter => ColorFilter.mode(this, BlendMode.srcIn);
}
