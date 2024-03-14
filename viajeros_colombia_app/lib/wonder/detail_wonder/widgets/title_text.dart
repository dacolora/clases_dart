import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:travel_app_colombia/wonder/show_wonder/data/wonder_type.dart';

import '../../../departamento/departamentos_data/wonder_data.dart';
import '../../show_wonder/widgets/_animated_arrow_button.dart';
import '../../show_wonder/widgets/context_utils.dart';
import '../../styles/themed_text.dart';
import '../../wonder_illustrations/common/wonder_title_text.dart';
import 'compass_divider.dart';
import 'static_text_scale.dart';

class TitleText extends StatelessWidget {
  const TitleText(this.data, {Key? key, required this.scroller})
      : super(key: key);
  final WonderData data;
  final ScrollController scroller;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: DefaultTextColor(
        color: $styles.colors.offWhite,
        child: StaticTextScale(
          child: Center(
            child: SizedBox(
              width: $styles.sizes.maxContentWidth1,
              child: Column(
                children: [
                  Gap($styles.insets.md),
                  Gap(30),

                  /// Sub-title row
                  SeparatedRow(
                    padding:
                        EdgeInsets.symmetric(horizontal: $styles.insets.sm),
                    separatorBuilder: () => Gap($styles.insets.sm),
                    children: [
                      Expanded(
                        child: Divider(
                          color: data.type.fgColor,
                        ).animate().scale(curve: Curves.easeOut, delay: 500.ms),
                      ),
                      Semantics(
                        header: true,
                        sortKey: OrdinalSortKey(1),
                        child: Text(
                          data.subTitle,
                          style: $styles.text.title2,
                        ).animate().fade(delay: 100.ms),
                      ),
                      Expanded(
                        child: Divider(
                          color: data.type.fgColor,
                        ).animate().scale(curve: Curves.easeOut, delay: 500.ms),
                      ),
                    ],
                  ),
                  Gap($styles.insets.md),

                  /// Wonder title text
                  Semantics(
                    sortKey: OrdinalSortKey(0),
                    child: AnimatedBuilder(
                        animation: scroller,
                        builder: (_, __) {
                          final yPos =
                              ContextUtils.getGlobalPos(context)?.dy ?? 0;
                          bool enableHero = yPos > -100;
                          return WonderTitleText(data, enableHero: enableHero);
                        }),
                  ),
                  Gap($styles.insets.xs),

                  /// Region
                  Text(
                    data.regionTitle, //mamasita
                    style: $styles.text.title1,
                    textAlign: TextAlign.center,
                  ),
                  Gap($styles.insets.md),

                  /// Compass divider
                  ExcludeSemantics(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: $styles.insets.sm),
                      child: AnimatedBuilder(
                        animation: scroller,
                        builder: (_, __) => CompassDivider(
                          isExpanded: scroller.position.pixels <= 0,
                          linesColor: data.type.fgColor,
                          compassColor: $styles.colors.offWhite,
                        ),
                      ),
                    ),
                  ),
                  Gap($styles.insets.sm),

                  /// Date
                  Text(
                    data.artifactCulture,
                    style: $styles.text.h4,
                    textAlign: TextAlign.center,
                  ),
                  Gap($styles.insets.sm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
