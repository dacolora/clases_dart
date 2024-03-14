import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../show_wonder/widgets/_animated_arrow_button.dart';

class NotaHistorica extends StatelessWidget {
  final String text;

  const NotaHistorica({Key? key, required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(color: $styles.colors.accent1, width: 1),
          Gap($styles.insets.sm),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 13.5,
                height: 1.4,
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ).copyWith(fontStyle: FontStyle.italic),
            ),
          )
        ],
      ),
    );
  }
}
