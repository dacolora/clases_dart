// Ejercicio 2. Crear metodo que permita invertir cadenas de caracteres

// Ejemplo : flutter and dart
// Resultado : trad dna rettulf

void main() {
  String invertir(String world) {
    late String newWorld;
    late List<String> list = [];
    for (var i = world.length - 1; i >= 0; i--) {
      list.add(world[i]);
      newWorld = list.join();
    }
    return newWorld;
  }

  print(invertir('flutter and dart'));
}
