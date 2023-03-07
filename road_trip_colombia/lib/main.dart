import 'package:flutter/material.dart';

import 'ui/pages/principal_page.dart';
import 'ui/pages/list_page/list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        ListPage.routeName: (context) => const ListPage(),
        //  HomePage.routeName: (context) => const HomePage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RoadTrip(),
    );
  }
}
