import 'package:flutter/material.dart';

class BannerLeftImage extends StatelessWidget {
  const BannerLeftImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          color: const Color(0xFF353537),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(22.0),
              child: Row(
                children: [
                  Image.asset(
                    fit: BoxFit.fill,
                    'assets/images/horizonte.png',
                    height: 80.0,
                    width: 100.0,
                  ),
                ],
              )),
        ));
  }
}
