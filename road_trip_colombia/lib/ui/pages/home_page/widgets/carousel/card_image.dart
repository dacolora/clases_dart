import 'package:flutter/material.dart';
import 'package:road_trip_colombia/ui/pages/home_page/widgets/carousel/receta.dart';

import 'mostrar_receta.dart';

class CardImages extends StatelessWidget {
  final Receta carruselImages;
  const CardImages({Key? key, required this.carruselImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          splashColor: Colors.red,
          onTap: () {
            carruselImages.copy();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MostrarReceta(
                          carruselImages: carruselImages,
                        )));
          },
          child: FadeInImage(
            placeholder: const AssetImage("assets/images/loading1.gif"),
            image: AssetImage(carruselImages.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
