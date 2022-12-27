# first_sprite

bueno lo primero que vamos agregar son nuestras dependencias en el pubspec.yaml con el fin de traer las importaciones correspondientes a nuestro proyecto, por hay derecho agregamos los assets con el fin de evidencia en nuestro emulador todas las imagenes que vamos a precargar

```yaml
flame: ^1.5.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

agregaremos las imagenes que queremos anexar a nuestro proyecto creando la carpeta assets y dentro la de images

es muy importante que tengan estos nombres debido a que las funciones que utilizaremos de sprint e sprintAnimations buscan estas rutas implicitamente

agregamos una imagen de fondo y dos personajes con los que queramos interactuar, e muy importantes que estos personajes no tenga ningun fondo con el fin de que sea vea presentable la superposicion.

----

Listo, ahora empezemos a modificar la clase de renderizacion de la ui, borramos todos el ejemplo de muestra que contiene el flutter create

dejamos solamente en nuestra clase `main.dart`
 
 ```dart
void main() {
  runApp(const MyApp());
}
```
posterior agregamos la clase GameWidget la cual es un stafulWidget que nos permite renderizar el arbol de flame, este tiene solo una propiedad requeridad llamada game, la cual instanciara nuestro juego que se extienda de FlameGame

```dart
void main() {
  runApp(GameWidget(game: Game()));
}
class Game extends FlameGame {}
```

esta extension nos permitiara renderizar todos los estados de nuestro juego, el metodo principal el cual vamos a sobrescribir es el metodo de carga el cual es un futuro, lo que significa que los eventos que se encuentren dentro de este evento pueden ocurrir en algun momento del futuro, por ejemplo cargar una imagen del local storage, como vamos a hacer a continuacion, este evento es obligatoriamente asincrono con el fin de esperar hasta que se renderie su contenido

```dart
class Game extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    print('ejecucion del juego');
  }
}
```

la propiedad con la que podemos agregar a nuestro metodo de carga las imagenes se llama `SpriteComponent` este metodo permite localizar la imagen y agregarle parametros para su renderizacion, vamos a crear una instancia por cada imagen que tengamos, esta la agregaremos fuera del metodo 'onLoad' con el fin de tenerla global dentro de toda nuetra clase

```dart
class Game extends FlameGame {
  SpriteComponent king = SpriteComponent();
  SpriteComponent man = SpriteComponent();
  ```
    ahora dentro del metodo onload llamaremos un sprite y le agregaremos los parametros correspondientes como tamaño y posicion 
