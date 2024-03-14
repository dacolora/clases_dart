import 'package:flutter/material.dart';

class BottomCenter extends Align {
  const BottomCenter(
      {Key? key, double? widthFactor, double? heightFactor, Widget? child})
      : super(
            key: key,
            widthFactor: widthFactor,
            heightFactor: heightFactor,
            child: child,
            alignment: Alignment.bottomCenter);
}
