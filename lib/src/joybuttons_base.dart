import 'package:flutter/material.dart';

class JoyButtonsBase extends StatelessWidget {

  /// Size of the JoyButton base
  final Size size;

  const JoyButtonsBase({
    Key? key,
    this.size = const Size(200, 200),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: _JoyButtonsBasePainter(),
      ),
    );
  }
}

class _JoyButtonsBasePainter extends CustomPainter {

  final _borderPaint = Paint()
    ..color = Colors.grey.shade300
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, _borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
