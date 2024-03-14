import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: (MediaQuery.of(context).size.width / 3) * 2,
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
          ),
          child: const Text(
            textAlign: TextAlign.center,
            'Si deseas informacion para viajar a este sitio en particular o armar un plan de viajes, comunicate con nosotros',
            style: TextStyle(
              fontFamily: 'Caveat',
              fontSize: 15.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            socialMedia(FontAwesomeIcons.instagram, () {
              print('Instagram');
            }, Color.fromARGB(255, 225, 16, 16)),
            SizedBox(
              width: 20,
            ),
            socialMedia(
              FontAwesomeIcons.whatsapp,
              () {
                print('Ws');
              },
              Color.fromARGB(255, 70, 188, 114),
            ),
            SizedBox(
              width: 20,
            ),
            socialMedia(
              FontAwesomeIcons.facebook,
              () {
                print('Ws');
              },
              Color.fromARGB(255, 48, 77, 207),
            ),
            SizedBox(
              width: 20,
            ),
            socialMedia(
              FontAwesomeIcons.tiktok,
              () {
                print('Ws');
              },
              Colors.black,
            ),
          ],
        )
      ],
    );
  }

  socialMedia(IconData icon, VoidCallback onClik, Color? color) => InkWell(
        child: GestureDetector(
          onTap: onClik,
          child: SizedBox(
              width: 20,
              height: 20,
              child: Icon(
                icon,
                color: color,
              )),
        ),
      );
}
