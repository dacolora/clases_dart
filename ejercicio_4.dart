// Ejercicio 4. ejecutar la consola para guardar una variable y utilizarla

import 'dart:io';

void main() {
  print('Enter your name ?');
  String name = stdin.readLineSync() ?? 'Daniel';
  print(' Hello $name');
}
