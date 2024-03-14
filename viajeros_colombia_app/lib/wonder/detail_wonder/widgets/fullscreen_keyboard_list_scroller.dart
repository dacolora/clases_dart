import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:travel_app_colombia/wonder/detail_wonder/widgets/throttler.dart';

import '../../show_wonder/widgets/_animated_arrow_button.dart';
import 'fullscreen_keyboard_listener.dart';

class FullscreenKeyboardListScroller extends StatelessWidget {
  FullscreenKeyboardListScroller(
      {super.key, required this.child, required this.scrollController});

  static const int _scrollAmountOnPress = 75;
  static const int _scrollAmountOnHold = 30;
  static final Duration _keyPressAnimationDuration = $styles.times.fast * .5;

  final Widget child;
  final ScrollController scrollController;
  final Throttler _throttler = Throttler(32.milliseconds);

  double clampOffset(px) =>
      px.clamp(0, scrollController.position.maxScrollExtent).toDouble();

  void _handleKeyDown(int px) {
    scrollController.animateTo(
      clampOffset(scrollController.offset + px),
      duration: _keyPressAnimationDuration,
      curve: Curves.easeOut,
    );
  }

  void _handleKeyRepeat(int px) {
    final offset = clampOffset(scrollController.offset + px);
    _throttler.call(() => scrollController.jumpTo(offset));
  }

  @override
  Widget build(BuildContext context) {
    return FullscreenKeyboardListener(
      child: child,
      onKeyRepeat: (event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          _handleKeyRepeat(-_scrollAmountOnHold);
          return true;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          _handleKeyRepeat(_scrollAmountOnHold);
          return true;
        }
        return false;
      },
      onKeyDown: (event) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          _handleKeyDown(-_scrollAmountOnPress);
          return true;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          _handleKeyDown(_scrollAmountOnPress);
          return true;
        }
        if (event.logicalKey == LogicalKeyboardKey.pageUp) {
          _handleKeyDown(-_getViewportSize(context));
          return true;
        }
        if (event.logicalKey == LogicalKeyboardKey.pageDown) {
          _handleKeyDown(_getViewportSize(context));
          return true;
        }
        return false;
      },
    );
  }

  int _getViewportSize(BuildContext context) {
    final rb = context.findRenderObject() as RenderBox?;
    if (rb != null) {
      return rb.size.height.round() - 100;
    }
    return 0;
  }
}
