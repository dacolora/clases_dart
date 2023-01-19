// Ejercicio 3. Obtener el primer y ultimo caracter de una variable
// tipo String ejemplo = 'hola como estas';
// tipo List = [12323,41321,913,233]

void main() {
  List<dynamic> lista = ['12323', 'hola', 913, 233, true];

  print(lista[0] = lista.first);
  print(lista[0] == lista.first);

  String obtenerCaracteres(String palabra) {
    return 'primera letra ${palabra[0]}, ultima letra ${palabra[palabra.length - 1]} ';
  }

  print(obtenerCaracteres('validar esto'));
}
