// Ejercicio 4. obtener el primer y ultimo caracter de una palabra

void main() {
  String obtenerCaracteres(List<dynamic> lista) {
    late dynamic firstWord, lastWord;
    firstWord = lista.first;
    lastWord = lista.last;

    return 'primer caracter $firstWord, ultimo caracter $lastWord ';
  }

  String caracteres(List<dynamic> lista) {
    late dynamic first, last;

    first = lista[0];
    last = lista[lista.length - 1];

    return 'primer  $first, ultimo  $last ';
  }

  print(obtenerCaracteres([1, 2, 3, 4, 5, 6, 7]));
  print(obtenerCaracteres(['23', 'mario', 'camilo', 'daniel']));
  print(obtenerCaracteres([true, 'mario', 'camilo', 2]));
  print('--------------------');
  print(caracteres([1, 2, 3, 4, 5, 6, 7]));
  print(caracteres(['23', 'mario', 'camilo', 'daniel']));
  print(caracteres([true, 'mario', 'camilo', 2]));
}
