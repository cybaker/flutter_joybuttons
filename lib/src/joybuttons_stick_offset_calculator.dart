import 'dart:math';
import 'dart:ui';

import 'joybuttons.dart';

abstract class ButtonsOffsetCalculator {
  Offset calculate({
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  });
}

class CircleStickOffsetCalculator implements ButtonsOffsetCalculator {
  const CircleStickOffsetCalculator();

  @override
  Offset calculate({
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

    return Offset(xOffset, yOffset);
  }
}

class RectangleStickOffsetCalculator implements ButtonsOffsetCalculator {
  const RectangleStickOffsetCalculator();

  @override
  Offset calculate({
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  }) {
    double x = currentDragStickPosition.dx - startDragStickPosition.dx;
    double y = currentDragStickPosition.dy - startDragStickPosition.dy;

    final xOffset = _normalizeOffset(x / (baseSize.width / 2));
    final yOffset = _normalizeOffset(y / (baseSize.height / 2));

    return Offset(xOffset, yOffset);
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
