import 'package:flutter/material.dart';
import 'package:travel_app_colombia/ui/widgets/informacion_principal.dart';
import 'package:travel_app_colombia/wonder/detail_wonder/principal_widgets/nota_historica.dart';

import '../../../../departamento/departamentos_data/wonder_data.dart';

class SeccionInformacion extends StatelessWidget {
  final WonderData data;
  const SeccionInformacion(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/colosseum/photo-1.jpg', // Reemplaza con la ruta de tu imagen
                  width: 70.0, // Ancho deseado
                  height: 70.0, // Altura deseada
                  fit: BoxFit
                      .contain, // Ajuste de la imagen dentro del espacio especificado
                ),
                Text(
                  'Bandera',
                  style: subTitles(),
                ),
              ],
            ),
            Column(
              children: [
                Image.asset(
                  'assets/images/colosseum/photo-3.jpg', // Reemplaza con la ruta de tu imagen
                  width: 70.0, // Ancho deseado
                  height: 70.0, // Altura deseada
                  fit: BoxFit
                      .contain, // Ajuste de la imagen dentro del espacio especificado
                ),
                Text(
                  'Escudo',
                  style: subTitles(),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(
          height: 12,
        ),

        Text(
          data.descripcion,
          style: subTitles(),
        ),
        const SizedBox(
          height: 12,
        ),
        NotaHistorica(text: data.notaHistoria1),
        const SizedBox(
          height: 12,
        ),
        // const Text(
        //   'Informacion Geografica',
        //   style: TextStyle(
        //     color: Color.fromARGB(255, 205, 97, 25),
        //     fontFamily: 'Cinzel',
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                duplaInfo('Capital', data.informacionGeografica.capital),
                const SizedBox(
                  height: 7,
                ),
                duplaInfo('Superficie',
                    '${data.informacionGeografica.superficie.toString()} km2'),
                const SizedBox(
                  height: 7,
                ),
                duplaMultiple(
                    'Rios principales', data.informacionGeografica.rios),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                duplaInfo('Poblacion Aproximada',
                    data.informacionGeografica.poblacion.toString()),
                const SizedBox(
                  height: 7,
                ),
                duplaInfo('Altura Maxima',
                    ' ${data.informacionGeografica.alturaMaxima.toString()} m s.n.m'),
                const SizedBox(
                  height: 7,
                ),
                duplaMultiple('Grupos Etnicos', data.cultura.gruposEtnicos),
              ],
            ),
          ],
        ),
        duplaMultiple('Ecosistemas', data.informacionGeografica.ecosistemas),
        const SizedBox(
          height: 8,
        ),
        duplaMultiple('Tradiciones', data.cultura.tradiciones),
        const SizedBox(
          height: 8,
        ),
        duplaMultiple('Productos principales', data.cultura.productos),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget duplaMultiple(String title, List<String> strings) {
    List<Widget> textWidgets = [];

    for (String text in strings) {
      textWidgets.add(
        Text(
          text,
          style: subTitles(),
        ),
      );
    }
    return Column(
      children: [
        Text(
          title,
          style: titles(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: textWidgets,
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
      ]);

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
}
