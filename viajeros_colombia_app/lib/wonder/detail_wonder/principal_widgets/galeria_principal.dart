import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_app_colombia/ui/widgets/titulo.dart';

import '../../../atraccion/atraccion_model.dart';

class GaleriaPrincipal extends StatelessWidget {
  final AtraccionModel place;
  const GaleriaPrincipal(this.place, {super.key});

  @override
  Widget build(BuildContext context) {
    Future<List<String>> getImages() async {
      try {
        String manifestContent =
            await rootBundle.loadString('AssetManifest.json');
        Map<String, dynamic> manifestMap = json.decode(manifestContent);

        // Filtrar las claves que corresponden a la carpeta de imágenes
        List<String> imageKeys = manifestMap.keys
            .where((String key) => key.startsWith(place.fotos ?? ''))
            .toList();

        return imageKeys;
      } catch (e) {
        print('Error: $e');
        return [];
      }
    }

    return FutureBuilder(
        future: getImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<String> imageNames = snapshot.data as List<String>;

            return Stack(
              children: [
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   child: Opacity(
                //     opacity: 0.75,
                //     child: Image.asset(imageNames.first),
                //   ),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 45,
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.7,
                        scrollDirection: Axis.horizontal,
                        aspectRatio: 2.0,
                        initialPage: 1,
                      ),
                      items: imageNames.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Ajusta el valor a tu gusto
                              child: FadeInImage(
                                image: AssetImage(imageUrl),
                                placeholder: AssetImage(imageNames.first),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    Titulo(place.nombre ?? '')
                  ],
                ),
              ],
            );
          }
        });
  }
}
