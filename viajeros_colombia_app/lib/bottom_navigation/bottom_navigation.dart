import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../atraccion/atraccion_model.dart';
import '../ui/screens/entry_point.dart';
import '../ui/screens/page_departamento.dart';

class BottomNavigation extends StatefulWidget {
  final int index;
  const BottomNavigation({super.key, required this.index});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          gap: 8,
          selectedIndex: widget.index,
          onTabChange: (index) {
            switch (index) {
              case 0:
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) {
                    return PlacePage(
                      place: AtraccionModel(),
                    );
                  },
                ));
                break;

              case 1:
                print('Seleccionaste la opción B.');
                break;

              case 2:
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) {
                    return EntryPoint();
                  },
                ));
                break;
              case 3:
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) {
                    return EntryPoint();
                  },
                ));
                break;
            }
          },
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.map,
              text: 'Mapa',
            ),
            GButton(
              icon: Icons.location_city,
              text: 'City',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
