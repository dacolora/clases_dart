// Ejercicio: generar el area de un circulo apartir de su radio

import 'dart:math';

void main() {
  double areaCircle(double radio) {
    return 3.1416 * radio * radio;
  }

  double areaCircle2(double radio) {
    return pi * radio * radio;
  }

  double areaCircle3(double radio) {
    return pi * pow(radio, 2);
  }

  print(pi);
  print('area del circulo es igual a ${areaCircle(5)}');
  print('area2 del circulo es igual a ${areaCircle2(5)}');
  print('area2 del circulo es igual a ${areaCircle3(5)}');
}
