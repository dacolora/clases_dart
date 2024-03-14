import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:travel_app_colombia/ui/widgets/informacion_principal.dart';
import 'package:travel_app_colombia/wonder/detail_wonder/principal_widgets/nota_historica.dart';

import '../../../../atraccion/atraccion_model.dart';
import '../../../../departamento/departamentos_data/wonder_data.dart';

class SeccionLugaresPopulares extends StatelessWidget {
  final WonderData data;
  const SeccionLugaresPopulares(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: data.lugares != null ? _buildCards(data).toList() : [],
    );
  }

  Iterable<Widget> _buildCards(WonderData data) sync* {
    yield const SizedBox(
      height: 16,
    );
    for (int i = 0; i < (data.lugares!.length); i++) {
      // Alterna el lado de la tarjeta según el índice
      bool left = i.isEven;

      yield placeSlidable(left, data.lugares![i]);
      yield const SizedBox(
        height: 12,
      );
    }
  }

  Widget placeSlidable(bool left, AtraccionModel lugar) {
    return Slidable(
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {},
            icon: Icons.zoom_out_rounded,
            backgroundColor: Color.fromARGB(255, 241, 225, 209),
          ),
          if (!left)
            SlidableAction(
              onPressed: (_) {},
              icon: Icons.contact_emergency,
              backgroundColor: Color.fromARGB(255, 220, 194, 168),
            ),
        ],
      ),
      startActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {},
            icon: Icons.zoom_out_rounded,
            backgroundColor: Color.fromARGB(255, 241, 225, 209),
          ),
          if (left)
            SlidableAction(
              onPressed: (_) {},
              icon: Icons.contact_emergency,
              backgroundColor: Color.fromARGB(255, 220, 194, 168),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (left) Icon(Icons.keyboard_double_arrow_right),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(children: [
              Text(
                lugar.nombre ?? '',
                style: const TextStyle(
                  color: Color.fromARGB(255, 205, 97, 25),
                  fontFamily: 'Cinzel',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment:
                    left ? MainAxisAlignment.start : MainAxisAlignment.end,
                children: [
                  Text(
                    'Categoria : ',
                    style: secondTitle(),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    lugar.categoria ?? '-',
                    style: subTitles(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Ecosistema : ',
                    style: secondTitle(),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    lugar.ecosistema ?? '-',
                    style: subTitles(),
                  ),
                ],
              ),
            ]),
          ),
          if (!left) Icon(Icons.keyboard_double_arrow_left),
        ],
      ),
    );
  }

  TextStyle titles() => const TextStyle(
        color: Color.fromARGB(255, 209, 121, 62),
        fontFamily: 'Cinzel',
        fontWeight: FontWeight.w600,
      );

  TextStyle subTitles() => const TextStyle(
        fontFamily: 'Raleway',
        fontSize: 13.5,
        height: 1.4,
        color: Colors.black,
        fontWeight: FontWeight.w900,
      ).copyWith(fontStyle: FontStyle.italic);

  TextStyle secondTitle() => const TextStyle(
        fontFamily: 'Raleway',
        fontSize: 13.5,
        height: 1.4,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ).copyWith(fontStyle: FontStyle.italic);
}
