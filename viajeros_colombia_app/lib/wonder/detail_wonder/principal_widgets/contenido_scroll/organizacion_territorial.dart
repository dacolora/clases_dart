import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:travel_app_colombia/ui/widgets/informacion_principal.dart';
import 'package:travel_app_colombia/wonder/detail_wonder/principal_widgets/nota_historica.dart';

import '../../../../departamento/departamentos_data/wonder_data.dart';

class SeccionOrganizacionTerritorial extends StatelessWidget {
  final WonderData data;
  const SeccionOrganizacionTerritorial(
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
            Flexible(
              flex: 1,
              child: InstaImageViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/images/colosseum/mapa_subregiones.png', // Reemplaza con la ruta de tu imagen
                    width: 160.0, // Ancho deseado
                    height: 160.0, // Altura deseada
                    fit: BoxFit
                        .contain, // Ajuste de la imagen dentro del espacio especificado
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Text(
                textAlign: TextAlign.center,
                'Antioquia está dividida en 9 subregiones que no son relevantes en términos de gobierno, y que fueron creadas para facilitar la administración del departamento.',
                style: subTitles(),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  //https://geoapps.esri.co/DepartamentoDeAntioquia/StoryMaps/index.html#
                  duplaInfo('Subregiones', '9'),
                  duplaInfo('Municipios', '125'),
                  duplaInfo('Corregimientos', '261'),
                  duplaInfo('Veredas', '4353'),
                  Text(
                    textAlign: TextAlign.center,
                    '',
                    style: subTitles(),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: InstaImageViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/colosseum/mapa_politico.png', // Reemplaza con la ruta de tu imagen
                    width: 160.0, // Ancho deseado
                    height: 160.0, // Altura deseada
                    fit: BoxFit
                        .contain, // Ajuste de la imagen dentro del espacio especificado
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          data.descripcion,
          style: subTitles(),
        ),
        const SizedBox(
          height: 12,
        ),
        NotaHistorica(
          text:
              ' los municipios corresponden al segundo nivel de división administrativa en Colombia, que mediante agrupación conforman los departamentos. Las áreas rurales de los municipios se dividen en corregimientos y estos a su vez se dividen en veredas.​',
        ),
        const SizedBox(
          height: 12,
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
