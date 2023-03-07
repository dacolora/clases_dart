import 'package:flutter/material.dart';
import 'package:road_trip_colombia/ui/commons/bottom_navigation/bc_bottom_navigation.dart';

import '../commons/app_bar/app_bar.dart';
import 'home_page/home.dart';
import 'list_page/list_page.dart';

class RoadTrip extends StatefulWidget {
  static const routeName = '/RoadTrip';
  const RoadTrip({super.key});

  @override
  State<RoadTrip> createState() => _RoadTripState();
}

class _RoadTripState extends State<RoadTrip> {
  late int index = 0;
  BottomNavigation? bottom;

  @override
  void initState() {
    bottom = BottomNavigation(curreinIndex: (i) {
      setState(() {
        index = i;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarItem(),
        bottomNavigationBar: bottom,
        body: Routes(index: index),
        floatingActionButton: floatingActionButton());
  }

  Widget floatingActionButton() {
    Widget widget = const SizedBox();
    if (index == 0) {
      widget = FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      );
    }
    return widget;
  }
}

class Routes extends StatelessWidget {
  final int index;
  const Routes({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      const HomePage(),
      const ListPage(),
    ];
    return list[index];
  }
}
