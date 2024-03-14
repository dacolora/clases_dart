import 'dart:math';

import 'package:extra_alignments/extra_alignments.dart' hide BottomCenter;
import 'package:flutter/material.dart' hide AppBar;
import 'package:go_router/go_router.dart';
import 'package:sized_context/sized_context.dart';
import 'package:travel_app_colombia/wonder/show_wonder/data/wonder_type.dart';
import 'package:travel_app_colombia/router.dart';

import 'detail_wonder/widgets/app_bar.dart';
import 'detail_wonder/widgets/circle_buttons.dart';
import 'detail_wonder/principal_widgets/contenido_scroll/contenido_scroll.dart';
import 'detail_wonder/widgets/fullscreen_keyboard_list_scroller.dart';
import 'detail_wonder/widgets/pop_router_on_over_scroll.dart';
import 'detail_wonder/widgets/title_text.dart';
import 'detail_wonder/widgets/top_illustration.dart';
import '../departamento/departamentos_data/wonder_data.dart';
import 'show_wonder/widgets/_animated_arrow_button.dart';
import 'show_wonder/widgets/app_icons.dart';
import 'show_wonder/widgets/app_logic.dart';

class WonderEditorialScreen extends StatefulWidget {
  const WonderEditorialScreen(this.data,
      {Key? key, required this.contentPadding})
      : super(key: key);
  final WonderData data;
  final EdgeInsets contentPadding;

  @override
  State<WonderEditorialScreen> createState() => _WonderEditorialScreenState();
}

class _WonderEditorialScreenState extends State<WonderEditorialScreen> {
  late final ScrollController _scroller = ScrollController()
    ..addListener(_handleScrollChanged);
  final _scrollPos = ValueNotifier(0.0);
  final _sectionIndex = ValueNotifier(0);

  @override
  void dispose() {
    _scroller.dispose();
    super.dispose();
  }

  /// Various [ValueListenableBuilders] are mapped to the _scrollPos and will rebuild when it changes
  void _handleScrollChanged() {
    _scrollPos.value = _scroller.position.pixels;
  }

  void _handleBackPressed() => context.go(ScreenPaths.home);

  @override
  Widget build(BuildContext context) {
    AppLogic appLogic = AppLogic();
    return LayoutBuilder(builder: (_, constraints) {
      bool shortMode = constraints.biggest.height < 700;
      double illustrationHeight = shortMode ? 250 : 280;
      double minAppBarHeight = shortMode ? 80 : 150;

      /// Attempt to maintain a similar aspect ratio for the image within the app-bar
      double maxAppBarHeight =
          min(context.widthPx, $styles.sizes.maxContentWidth1) * 1.2;
      final backBtnAlign =
          appLogic.shouldUseNavRail() ? Alignment.topRight : Alignment.topLeft;
      return PopRouterOnOverScroll(
        controller: _scroller,
        child: ColoredBox(
          color: $styles.colors.offWhite,
          child: Stack(
            children: [
              /// Background
              Positioned.fill(
                child: ColoredBox(color: widget.data.type.bgColor),
              ),

              /// Top Illustration - Sits underneath the scrolling content, fades out as it scrolls
              SizedBox(
                height: illustrationHeight,
                child: ValueListenableBuilder<double>(
                  valueListenable: _scrollPos,
                  builder: (_, value, child) {
                    // get some value between 0 and 1, based on the amt scrolled
                    double opacity = (1 - value / 700).clamp(0, 1);
                    return Opacity(opacity: opacity, child: child);
                  },
                  // This is due to a bug: https://github.com/flutter/flutter/issues/101872
                  child: RepaintBoundary(
                      child: TopIllustration(
                    widget.data.type,
                    // Polish: Inject the content padding into the illustration as an offset, so it can center itself relative to the content
                    // this allows the background to extend underneath the vertical side nav when it has rounded corners.
                    fgOffset: Offset(widget.contentPadding.left / 2, 0),
                  )),
                ),
              ),

              /// Scrolling content - Includes an invisible gap at the top, and then scrolls over the illustration
              TopCenter(
                child: Padding(
                  padding: widget.contentPadding,
                  child: SizedBox(
                    child: FocusTraversalGroup(
                      child: FullscreenKeyboardListScroller(
                        scrollController: _scroller,
                        child: CustomScrollView(
                          controller: _scroller,
                          scrollBehavior:
                              ScrollConfiguration.of(context).copyWith(),
                          key: PageStorageKey('editorial'),
                          slivers: [
                            /// Invisible padding at the top of the list, so the illustration shows through the btm
                            SliverToBoxAdapter(
                              child: SizedBox(height: illustrationHeight),
                            ),

                            /// Text content, animates itself to hide behind the app bar as it scrolls up
                            SliverToBoxAdapter(
                              child: ValueListenableBuilder<double>(
                                valueListenable: _scrollPos,
                                builder: (_, value, child) {
                                  double offsetAmt = max(0, value * .3);
                                  double opacity =
                                      (1 - offsetAmt / 150).clamp(0, 1);
                                  return Transform.translate(
                                    offset: Offset(0, offsetAmt),
                                    child:
                                        Opacity(opacity: opacity, child: child),
                                  );
                                },
                                child:
                                    TitleText(widget.data, scroller: _scroller),
                              ),
                            ),

                            /// Collapsing App bar, pins to the top of the list
                            SliverAppBar(
                              pinned: true,
                              collapsedHeight: minAppBarHeight,
                              toolbarHeight: minAppBarHeight,
                              expandedHeight: maxAppBarHeight,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              leading: SizedBox.shrink(),
                              flexibleSpace: SizedBox.expand(
                                child: AppBar(
                                  widget.data.type,
                                  scrollPos: _scrollPos,
                                  sectionIndex: _sectionIndex,
                                ),
                              ),
                            ),

                            /// Editorial content (text and images)
                            ContenidoScroll(widget.data,
                                scrollPos: _scrollPos,
                                sectionNotifier: _sectionIndex),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// Home Btn
              SafeArea(
                child: AnimatedBuilder(
                  animation: _scroller,
                  builder: (_, child) {
                    return AnimatedOpacity(
                      opacity: _scrollPos.value > 0 ? 0 : 1,
                      duration: $styles.times.med,
                      child: child,
                    );
                  },
                  child: Align(
                    alignment: backBtnAlign,
                    child: Padding(
                      padding: EdgeInsets.all($styles.insets.sm),
                      child: BackBtn(
                          icon: AppIcons.north, onPressed: _handleBackPressed),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
