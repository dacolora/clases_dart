import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app_colombia/wonder/detail_wonder/principal_widgets/galeria_principal.dart';
import 'package:travel_app_colombia/ui/widgets/informacion_principal.dart';
import 'package:travel_app_colombia/ui/widgets/social_media.dart';
import 'package:travel_app_colombia/ui/widgets/titulo.dart';

import '../../atraccion/atraccion_model.dart';
import '../../bottom_navigation/bottom_navigation.dart';

class PlacePage extends StatelessWidget {
  final AtraccionModel place;
  const PlacePage({
    required this.place,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(
        index: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/images/santa_marta/tay/tay_2.jpg',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    InformacionPrincipal(place: place),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 45,
                                  backgroundImage: const AssetImage(
                                      'assets/images/map.jpg.webp'),
                                  child: GestureDetector(),
                                ),
                              ),
                              const Text(
                                'Ubicacion del lugar',
                                style: TextStyle(
                                  fontFamily: 'JosefinSans',
                                  fontSize: 10.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SocialMedia(),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
