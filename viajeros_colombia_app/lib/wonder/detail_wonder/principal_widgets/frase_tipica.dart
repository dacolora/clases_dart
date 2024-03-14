import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../show_wonder/widgets/_animated_arrow_button.dart';
import '../widgets/centered_box.dart';

class FraseTipica extends StatelessWidget {
  const FraseTipica({Key? key, required this.text, required this.author})
      : super(key: key);
  final String text;
  final String author;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: CenteredBox(
        width: 300,
        padding: EdgeInsets.symmetric(
            horizontal: $styles.insets.lg, vertical: $styles.insets.xl),
        child: Column(
          children: [
            FractionalTranslation(
              translation: Offset(0, .5),
              child: Text(
                text,
                style: $styles.text.quote1.copyWith(
                  color: $styles.colors.accent1,
                  fontSize: 40 * $styles.scale,
                  height: .7,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'tipica frase paisa',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 13.5,
                height: 1.4,
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ).copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            Gap($styles.insets.md),
            Text(
              '- $author',
              style: $styles.text.quote2Sub
                  .copyWith(color: $styles.colors.accent1),
            ),
          ],
        ),
      ),
    );
  }
}
