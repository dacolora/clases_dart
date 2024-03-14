import 'package:flutter/material.dart';

import '../../../../departamento/departamentos_data/wonder_data.dart';
import '../../widgets/sliding_image_stack.dart';
import '../nota_historica.dart';

class SeccionGalery extends StatelessWidget {
  final WonderData data;
  final ValueNotifier<double> scrollPos;
  const SeccionGalery(this.data, {super.key, required this.scrollPos});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NotaHistorica(text: data.notaHistoria2),
        Text(
          data.constructionInfo2,
          style: subTitles(),
        ),
        SlidingImageStack(scrollPos: scrollPos, type: data.type),
      ],
    );
  }

  TextStyle subTitles() => const TextStyle(
        fontFamily: 'Raleway',
        fontSize: 13.5,
        height: 1.4,
        color: Colors.black,
        fontWeight: FontWeight.w900,
      ).copyWith(fontStyle: FontStyle.italic);
}
