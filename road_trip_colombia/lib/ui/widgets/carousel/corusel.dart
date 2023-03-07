import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class Carousel extends StatelessWidget {
  const Carousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: carruselImages.length,
      itemBuilder: (context, index, realIndex) {
        // ignore: unused_local_variable
        final carruselImage = carruselImages[index];
        return CardImages(
          carruselImages: carruselImages[index],
        );
      },
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        autoPlayCurve: Curves.easeInOut,
        enlargeCenterPage: true,
        autoPlayInterval: const Duration(seconds: 5),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
