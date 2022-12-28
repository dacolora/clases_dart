import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: Game()));
  WidgetsFlutterBinding.ensureInitialized();
  //Flame.device.setLandscape();
}

class Game extends FlameGame with HasTappables {
  SpriteComponent mario = SpriteComponent();
  SpriteComponent luigi = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  double sizeHeight = 360.0;
  double sizeWidth = 200.0;
  bool turnMario = false;
  DialogButton dialogButton = DialogButton();
  final Vector2 buttonSize = Vector2(50, 50);
  TextPaint dialogTextPaint = TextPaint(style: const TextStyle(fontSize: 36));
  int dialogLevel = 0;
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
    dialogButton
      ..sprite = await loadSprite('luigi.png')
      ..size = buttonSize
      ..position = Vector2(size.x / 2, size.y / 2);

    if (dialogLevel == 3) {}
  }

  //This method is called periodically by the game engine to request that your
  //component updates itself.
//The time [dt] in seconds (with microseconds precision provided by Flutter)
//since the last update cycle. This time can vary according to hardware capacity, so make sure to update your state considering this. All components in the tree are always updated by the same amount. The time each one takes to update adds up to the next update cycle.
  @override
  void update(double dt) {
    //print(dialogLevel);
    super.update(dt);
    if (mario.y > 0) {
      mario.y -= 200 * dt;
    } else if (turnMario == false) {
      mario.flipHorizontallyAroundCenter();
      turnMario = true;
      if (dialogLevel == 2) {
        dialogLevel = 3;
        add(dialogButton);
      }
    }

    if (luigi.y < (size.y - sizeHeight)) {
      luigi.y += 200 * dt;
      if (luigi.y > 50 && dialogLevel == 0) {
        dialogLevel = 1;
      }
      if (luigi.y > 150 && dialogLevel == 1) {
        dialogLevel = 2;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    switch (dialogLevel) {
      case 1:
        dialogTextPaint.render(canvas, 'Mamabichos', Vector2(10, size.y / 2));
        break;
      case 2:
        dialogTextPaint.render(
            canvas,
            'pegalo del todo esto\n'
            'debe ser mas rapido\n'
            'de lo que pensaba',
            Vector2(10, size.y / 2));
        break;
      case 3:
        dialogTextPaint.render(canvas, 'q mrda', Vector2(10, size.y / 2));
        break;
    }
  }
}

class DialogButton extends SpriteComponent with Tappable {
  @override
  bool onTapDown(TapDownInfo event) {
    try {
      print('tap dialogbuuton');
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
