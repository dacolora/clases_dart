import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../helpers/responsive_design.dart';
import '../widgets/carousel/corusel.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homePage';
  const HomePage({super.key});

  // This widget is the homePage page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarItem(),
      bottomNavigationBar: const BottomNavigation(
        index: 0,
      ),
      body: Container(
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
