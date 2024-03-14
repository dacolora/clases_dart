import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sized_context/sized_context.dart';
import 'package:travel_app_colombia/wonder/show_wonder/widgets/context_utils.dart';

import '../../show_wonder/widgets/_animated_arrow_button.dart';
import 'compass_divider.dart';

class SectionDivider extends StatefulWidget {
  const SectionDivider(this.scrollNotifier, this.sectionNotifier,
      {Key? key, required this.index})
      : super(key: key);
  final int index;
  final ValueNotifier<double> scrollNotifier;
  final ValueNotifier<int> sectionNotifier;

  @override
  State<SectionDivider> createState() => SectionDividerState();
}

class SectionDividerState extends State<SectionDivider>
    with SingleTickerProviderStateMixin {
  final _isActivated = ValueNotifier(false);

  double _getSwitchPt(BuildContext c) => c.heightPx * .5;

  void _checkPosition(BuildContext context) {
    final yPos = ContextUtils.getGlobalPos(context)?.dy;
    if (yPos == null || yPos < 0) return;
    // Only allow headers to switch if it's above the switch pt
    bool activated = yPos < _getSwitchPt(context);
    if (activated != _isActivated.value) {
      scheduleMicrotask(() {
        // When activated, set our index as active. When de-activated, set it to the index before ours (index - 1).
        int newIndex = activated ? widget.index : widget.index - 1;
        widget.sectionNotifier.value = newIndex;
      });
      _isActivated.value = activated;
    }
  }

  @override
  Widget build(BuildContext _) {
    // When scroll position changes, the divider needs to check whether it should mark itself as the active index
    return ValueListenableBuilder<double>(
      valueListenable: widget.scrollNotifier,
      builder: (context, value, _) {
        _checkPosition(context);
        return ValueListenableBuilder<bool>(
          valueListenable: _isActivated,
          builder: (_, value, __) => Padding(
            padding: EdgeInsets.symmetric(vertical: 0),
            child: CompassDivider(isExpanded: value),
          ),
        );
      },
    );
  }
}
