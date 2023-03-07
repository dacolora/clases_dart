import 'package:flutter/material.dart';

import '../../pages/home_page.dart';

class BottomNavigation extends StatelessWidget {
  final int index;
  const BottomNavigation({
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (i) {
        switch (i) {
          case 0:
            if (index != i) {
              Navigator.pushNamed(context, HomePage.routeName);
            }
            break;
          case 1:
            if (index != i) {
              //   Navigator.pushNamed(context, BcBannerComponent.routeName);
            }
            break;
          default:
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.ac_unit_sharp), label: ''),
        BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_rounded), label: '')
      ],
    );
  }
}
