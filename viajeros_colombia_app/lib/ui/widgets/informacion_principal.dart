import 'package:flutter/material.dart';

import '../../atraccion/atraccion_model.dart';

class InformacionPrincipal extends StatelessWidget {
  final AtraccionModel place;
  const InformacionPrincipal({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 12),
          width: (MediaQuery.of(context).size.width / 3) * 2,
          child: Text(
            place.descripcion ?? '',
            style: const TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 15.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            duplaInfo('Departamento', place.departamento ?? ''),
            duplaInfo('Municipio', place.municipio ?? ''),
            duplaInfo('Ecosistema', place.ecosistema ?? ''),
            duplaInfo('Categoria', place.categoria ?? ''),
            duplaInfo('Altitud', '${place.altitud.toString()} ms.n.m.'),
          ],
        ),
      ],
    );
  }

  Column duplaInfo(String title, String subTitle) => Column(children: [
        Text(
          title,
          style: titles(),
        ),
        Text(
          subTitle,
          style: subTitles(),
        ),
        const SizedBox(
          height: 5,
        )
      ]);

  TextStyle titles() => const TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 17.0,
        height: 1,
        color: Color.fromARGB(255, 11, 11, 186),
        fontWeight: FontWeight.bold,
      );

  TextStyle subTitles() => const TextStyle(
        fontFamily: 'Ubuntu',
        fontSize: 14.0,
        height: 1,
        color: Colors.black,
        fontWeight: FontWeight.w900,
      );
}
