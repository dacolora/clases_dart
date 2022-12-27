import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: Game()));
}

class Game extends FlameGame {
  SpriteComponent king = SpriteComponent();
  SpriteComponent man = SpriteComponent();
  @override
  Future<void> onLoad() async {
    super.onLoad();
    print('ejecicion del juego');
  }
}
