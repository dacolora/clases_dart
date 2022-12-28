import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: Game()));
  WidgetsFlutterBinding.ensureInitialized();
  //Flame.device.setLandscape();
}

class Game extends FlameGame {
  SpriteComponent mario = SpriteComponent();
  SpriteComponent luigi = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  double sizeHeight = 360.0;
  double sizeWidth = 200.0;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    background
      ..sprite = await loadSprite('background.png')
      ..size = size;

    mario
      ..sprite = await loadSprite('mario.png')
      ..size = Vector2(sizeWidth, sizeHeight)
      ..position = Vector2(20, size.y - sizeHeight - 20);
    luigi
      ..sprite = await loadSprite('luigi.png')
      ..size = Vector2(sizeWidth, sizeHeight)
      ..position = Vector2(220, 20);
    add(background);
    add(mario);
    add(luigi);
  }
}
