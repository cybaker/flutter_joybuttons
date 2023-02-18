import 'dart:math';
import 'dart:ui';

import 'joybuttons.dart';

abstract class ButtonsOffsetCalculator {
  Offset calculate({
    required JoyButtonsMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  });
}

class CircleStickOffsetCalculator implements ButtonsOffsetCalculator {
  const CircleStickOffsetCalculator();

  @override
  Offset calculate({
    required JoyButtonsMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  }) {
    double x = currentDragStickPosition.dx - startDragStickPosition.dx;
    double y = currentDragStickPosition.dy - startDragStickPosition.dy;
    final radius = baseSize.width / 2;

    final isPointInCircle = x * x + y * y < radius * radius;

    if (!isPointInCircle) {
      final mult = sqrt(radius * radius / (y * y + x * x));
      x *= mult;
      y *= mult;
    }

    final xOffset = x / radius;
    final yOffset = y / radius;

    switch (mode) {
      case JoyButtonsMode.all:
        return Offset(xOffset, yOffset);
      case JoyButtonsMode.vertical:
        return Offset(0.0, yOffset);
      case JoyButtonsMode.horizontal:
        return Offset(xOffset, 0.0);
      case JoyButtonsMode.horizontalAndVertical:
        return Offset(xOffset.abs() > yOffset.abs() ? xOffset : 0,
            yOffset.abs() > xOffset.abs() ? yOffset : 0);
    }
  }
}

class RectangleStickOffsetCalculator implements ButtonsOffsetCalculator {
  const RectangleStickOffsetCalculator();

  @override
  Offset calculate({
    required JoyButtonsMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  }) {
    double x = currentDragStickPosition.dx - startDragStickPosition.dx;
    double y = currentDragStickPosition.dy - startDragStickPosition.dy;

    final xOffset = _normalizeOffset(x / (baseSize.width / 2));
    final yOffset = _normalizeOffset(y / (baseSize.height / 2));

    switch (mode) {
      case JoyButtonsMode.all:
        return Offset(xOffset, yOffset);
      case JoyButtonsMode.vertical:
        return Offset(0.0, yOffset);
      case JoyButtonsMode.horizontal:
        return Offset(xOffset, 0.0);
      case JoyButtonsMode.horizontalAndVertical:
        return Offset(xOffset.abs() > yOffset.abs() ? xOffset : 0,
            yOffset.abs() > xOffset.abs() ? yOffset : 0);
    }
  }

  double _normalizeOffset(double point) {
    if (point > 1) {
      return 1;
    }
    if (point < -1) {
      return -1;
    }
    return point;
  }
}
