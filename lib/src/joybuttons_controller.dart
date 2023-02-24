import 'dart:ui';

class JoyButtonsController {
  void Function(Offset globalPosition)? onTouchDragStart;
  void Function(Offset globalPosition)? onTouchDragUpdate;
  void Function()? onTouchDragEnd;

  void start(Offset globalPosition) {
    onTouchDragStart?.call(globalPosition);
  }

  void update(Offset globalPosition) {
    onTouchDragUpdate?.call(globalPosition);
  }

  void end() {
    onTouchDragEnd?.call();
  }
}
