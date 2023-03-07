import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final Function(int) curreinIndex;
  const BottomNavigation({
    super.key,
    required this.curreinIndex,
  });

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.white,
      elevation: 2,
      currentIndex: index,
      backgroundColor: Colors.black,
      onTap: (i) {
        setState(() {
          index = i;
          widget.curreinIndex(i);
        });
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.ac_unit_sharp,
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.accessibility_rounded,
            ),
            label: '')
      ],
    );
  }
}
