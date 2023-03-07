import 'package:flutter/material.dart';

import 'widgets/banners/banner_left_image.dart';
import 'widgets/carousel/corusel.dart';
import 'widgets/personal_statistics/personal_statistics.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: ListView(
          children: const <Widget>[
            PersonalStatistics(),
            SizedBox(
              height: 20,
            ),
            Text(
              'Lugares Mas Recomendados',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Carousel(),
            SizedBox(
              height: 20,
            ),
            BannerLeftImage(),
          ],
        ));
  }
}
