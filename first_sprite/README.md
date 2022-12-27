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

ahora dentro del metodo onload llamaremos un sprite y le agregaremos los parametros correspondientes como tamaño y posicion. para ello utilizamos el operador en cascada `..` lo cual permite unificar los diferentes parametros en un solo llamado sin tener que nombrar numerosas veces la instancia de clase, es como una forma abreviada de copiar nuestro codigo.
con ellos evitamos llamar `king.una propiedad` y  `king.otra propiedad`

siemplemente llamamos una sola vez king y con los dos puntos agregamos el resto de propiedades.

la primera propiedad que agregamos el sprite el cual nos permite asociarle a la instancia la imagen de los assets mediante el metodo `loadSprite`

nos saca error pq necesita un await a la espera de la carga de la imagen

agregamos tambien la propiedad [size] la cual se asume que este es el tamaño aproximado del objeto que se dibujará en la pantalla. Por lo tanto, este tamaño se utilizará para la detección de colisiones 

esta recibe un `Vector2` este vector lo vamos a tener muy presente a lo largo de todos nuestros juegos, podemos poner para este caso 100 y 100 
por ultimo para poder visualizar nuestra rey debemos agregarlo con un add a nuestra carga de eventos add(king);

```dart
  @override
  Future<void> onLoad() async {
    super.onLoad();
    king
      ..sprite = await loadSprite('king.png')
      ..size = Vector2(300, 300);
    add(king);
  }
 ```

 bueno vemos que esto lo agrega en la posicion (0,0) que es la parte superior izquierda del dispoitivo. por tal motivo a nuestra instancia de king debemos agregarle tambien una posicion inicial podemos agregarla una a una con x y y o de una vez con ambas con el parametro position

 ```dart
 // ..y = 300
 // ..x = 50;
  ..position = Vector2(50, 300);
 ```

 po ultimo para esta seccion agregaremos el background para que no se vea el fondo negro, al igual que con las dos anteriores imagenes, insertamos la imagen dentro de los assets y posteriormente le asignamos una variable loadSprite, esta imagen tambien es necesaria generarla dentro de un SpriteComponente. por lo tanto quedaria

```dart
  SpriteComponent background = SpriteComponent();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    background
      ..sprite = await loadSprite('background.png')
      ..size = size;

    add(background);
  }
}
```
el `size = size` es una herramienta muy util que nos da Flame y es que nos entrega el tamaño del dispositivo, y con ellos podemos darle utilidad para cubrir todo el ancho y alto del dispositivo
otro dato adicional es que el `add(background)` debe hacerse antes de agregar a los dos personajes
esto se debe que el va a gregando por capaz dejando atras lo primero que se va agregando.
por ende si ponemos de ultimo el background este taparia a los dos personajes.

para organizar un poco las imagenes y que estas queden en la parte inferior de nuestro dispositivo volvemos a haer uso de la propiedad size.
primero agregamos una variables constantes para el tamaño de los personajes

```dart  
double sizeComponent = 150;
```
con esto agregamos esta variable en los size de los personajes de modo que quedarian
```dart  
   ..size = Vector2(sizeComponent, sizeComponent)
``
y para la posicion utilzamos cualquier coordenada en x, pero en y agregamos el tamaño del celular y le restamos la altua del componente, con esto quedaria ubicado en la parte inferior del dispositivo
..position = Vector2(250, size.y - sizeComponent);

```dart
void main() {
  runApp(GameWidget(game: Game()));
}

class Game extends FlameGame {
  SpriteComponent king = SpriteComponent();
  SpriteComponent man = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  double sizeComponent = 150.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    background
      ..sprite = await loadSprite('background.jpg')
      ..size = size;

    king
      ..sprite = await loadSprite('king.png')
      ..size = Vector2(sizeComponent, sizeComponent)
      ..position = Vector2(20, size.y - sizeComponent);
    man
      ..sprite = await loadSprite('man.png')
      ..size = Vector2(sizeComponent, sizeComponent)
      ..position = Vector2(250, size.y - sizeComponent);
    add(background);
    add(king);
    add(man);
  }
}
```
por ultimo para visualizar mejor la imagen, podemos voltear el celular con la  funcion de escucha `WidgetsFlutterBinding.ensureInitialized();` y posteriormente agregamos el metodo `Flame.device.setLandscape();` que permite genera el cambio del orientacion del dispositivo
```dart
void main() {
  runApp(GameWidget(game: Game()));
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();
}
```



/// FIN