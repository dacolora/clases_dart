import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';

import '../../../../atraccion/atraccion_model.dart';
import '../../../../departamento/departamentos_data/wonder_data.dart';
import '../../../../ui/widgets/social_media.dart';
import '../../../show_wonder/widgets/_animated_arrow_button.dart';
import '../frase_tipica.dart';
import '../../widgets/section_divider.dart';
import '../galeria_principal.dart';
import 'galery.dart';
import 'informacion_principal.dart';
import 'lugares_populares.dart';
import 'organizacion_territorial.dart';

class ContenidoScroll extends StatefulWidget {
  const ContenidoScroll(this.data,
      {Key? key, required this.scrollPos, required this.sectionNotifier})
      : super(key: key);
  final WonderData data;
  final ValueNotifier<double> scrollPos;
  final ValueNotifier<int> sectionNotifier;

  @override
  State<ContenidoScroll> createState() => _ContenidoScrollState();
}

class _ContenidoScrollState extends State<ContenidoScroll> {
  String _fixNewlines(String text) {
    const nl = '\n';
    final chunks = text.split(nl);
    while (chunks.last == nl) {
      chunks.removeLast();
    }
    chunks.removeWhere((element) => element.trim().isEmpty);
    final result = chunks.join('$nl$nl');
    return result;
  }

  late bool expandedDescription;
  late bool expandedGalery;
  late bool expandedMore;
  late bool expandedPlaces;
  late bool expandedTerritorio;

  @override
  void initState() {
    expandedDescription = false;
    expandedGalery = false;
    expandedMore = false;
    expandedPlaces = false;
    expandedTerritorio = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverBackgroundColor(
      color: $styles.colors.offWhite,
      sliver: SliverPadding(
        padding: EdgeInsets.symmetric(vertical: $styles.insets.md),
        sliver: SliverList(
          delegate: SliverChildListDelegate.fixed([
            Center(
              child: SizedBox(
                width: $styles.sizes.maxContentWidth1,
                child: Column(children: [
                  _gestureTitle(
                      expandedDescription, 'Informacion Principal', 0),
                  if (expandedDescription)
                    ..._contentSection([
                      SeccionInformacion(widget.data),
                    ]),
                  _gestureTitle(expandedPlaces, 'Lugares + Populares', 3),
                  if (expandedPlaces)
                    ..._contentSection([
                      SeccionLugaresPopulares(widget.data),
                    ]),
                  _gestureTitle(expandedGalery, 'Galeria', 1),
                  if (expandedGalery)
                    GaleriaPrincipal(
                        AtraccionModel(fotos: 'assets/images/colosseum/all')),
                  if (expandedGalery)
                    ..._contentSection([
                      SeccionGalery(
                        widget.data,
                        scrollPos: widget.scrollPos,
                      ),
                    ]),
                  _gestureTitle(
                      expandedTerritorio, 'Organizacion Territorial', 4),
                  if (expandedTerritorio)
                    ..._contentSection([
                      SeccionOrganizacionTerritorial(widget.data),
                    ]),
                  _gestureTitle(expandedMore, 'Conoce mas', 2),
                  if (expandedMore)
                    ..._contentSection([
                      /// Location
                      FraseTipica(
                          text: widget.data.pullQuote2,
                          author: widget.data.pullQuote2Author),
                      Text(
                        widget.data.locationInfo2,
                        style: subTitles(),
                      ),

                      Gap($styles.insets.md),
                      //   _MapsThumbnail(data),
                      Gap($styles.insets.md),
                    ]),
                  SectionDivider(widget.scrollPos, widget.sectionNotifier,
                      index: 2),
                  //  const SocialMedia(),
                  const Gap(150),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _gestureTitle(bool expanded, String text, int seccion) {
    return Column(
      children: [
        SectionDivider(widget.scrollPos, widget.sectionNotifier, index: 1),
        GestureDetector(
          onTap: () {
            setState(() {
              expanded = !expanded;

              switch (seccion) {
                case 0:
                  expandedDescription = expanded;
                  break;
                case 1:
                  expandedGalery = expanded;
                  break;
                case 2:
                  expandedMore = expanded;
                  break;
                case 3:
                  expandedPlaces = expanded;
                  break;
                case 4:
                  expandedTerritorio = expanded;
                  break;
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 100),
                      style: TextStyle(
                        fontSize: expanded ? 30 : 15,
                        height: expanded ? 0.8 : null,
                        color: expanded ? $styles.colors.accent1 : Colors.black,
                        fontFamily: 'Cinzel',
                        fontWeight: FontWeight.w800,
                      ),
                      child: Text(
                        text,
                      ),
                    )),
              ),
              Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child:
                        Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  /// Helper widget to provide hz padding to multiple widgets. Keeps the layout of the scrolling content cleaner.
  List<Widget> _contentSection(List<Widget> children) {
    return [
      for (int i = 0; i < children.length - 1; i++) ...[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
          child: children[i],
        ),
        Gap($styles.insets.md)
      ],
      Padding(
        padding: EdgeInsets.symmetric(horizontal: $styles.insets.md),
        child: children.last,
      ),
    ];
  }

  TextStyle subTitles() => const TextStyle(
        fontFamily: 'Raleway',
        fontSize: 13.5,
        height: 1.4,
        color: Colors.black,
        fontWeight: FontWeight.w900,
      ).copyWith(fontStyle: FontStyle.italic);
}

class SliverBackgroundColor extends SingleChildRenderObjectWidget {
  const SliverBackgroundColor({
    Key? key,
    required this.color,
    Widget? sliver,
  }) : super(key: key, child: sliver);

  final Color color;

  @override
  RenderSliverBackgroundColor createRenderObject(BuildContext context) {
    return RenderSliverBackgroundColor(
      color,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSliverBackgroundColor renderObject) {
    renderObject.color = color;
  }
}

class RenderSliverBackgroundColor extends RenderProxySliver {
  RenderSliverBackgroundColor(this._color);

  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (value == color) {
      return;
    }
    _color = color;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && child!.geometry!.visible) {
      final SliverPhysicalParentData childParentData =
          child!.parentData! as SliverPhysicalParentData;
      final Rect childRect = offset + childParentData.paintOffset &
          Size(constraints.crossAxisExtent, child!.geometry!.paintExtent);
      context.canvas.drawRect(
          childRect,
          Paint()
            ..style = PaintingStyle.fill
            ..color = color); //
      context.paintChild(child!, offset + childParentData.paintOffset);
    }
  }
}
