import 'dart:ui';

class JoyButtonsController {
  void Function(Offset globalPosition)? onStickDragStart;
  void Function(Offset globalPosition)? onStickDragUpdate;
  void Function()? onStickDragEnd;

  void start(Offset globalPosition) {
    onStickDragStart?.call(globalPosition);
  }

  void update(Offset globalPosition) {
    onStickDragUpdate?.call(globalPosition);
  }

  void end() {
    onStickDragEnd?.call();
  }
}
