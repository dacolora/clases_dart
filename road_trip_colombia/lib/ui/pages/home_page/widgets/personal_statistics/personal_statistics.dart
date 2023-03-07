

import 'package:flutter/material.dart';

import '../avatar/avatar.dart';

class PersonalStatistics extends StatelessWidget {
  const PersonalStatistics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        const Avatar(
          image: AssetImage('assets/images/r.jpg'),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          children: const [
            Text(
              '36',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              'Lugares\nconocidos',
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          children: const [
            Text(
              '12',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              'Lugares\nX Visitar',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          children: const [
            Text(
              '1',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              'Lugares\nCreados',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
        const SizedBox(
          width: 40,
        ),
      ],
    );
  }
}
