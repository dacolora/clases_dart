import 'package:flutter/material.dart';

class Titulo extends StatelessWidget {
  final String titulo;
  const Titulo(this.titulo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: const TextStyle(
        fontFamily: 'DancingScript',
        height: 0.8,
        fontSize: 65.0,
        color: Color.fromARGB(255, 11, 11, 186),
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
              // bottomLeft
              offset: Offset(-1.5, -1.5),
              color: Colors.white),
          Shadow(
              // bottomRight
              offset: Offset(1.5, -1.5),
              color: Colors.white),
          Shadow(
              // topRight
              offset: Offset(1.5, 1.5),
              color: Colors.white),
          Shadow(
              // topLeft
              offset: Offset(-1.5, 1.5),
              color: Colors.white),
        ],
      ),
    );
  }
}
