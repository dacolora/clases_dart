import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: Game()));
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setLandscape();
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
