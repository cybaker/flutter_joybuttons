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
    // canvas.drawCircle(center, radius - 12, _centerPaint);
    // canvas.drawCircle(center, radius - 60, _centerPaint);

      // // draw vertical arrows
      // canvas.drawLine(Offset(center.dx - 30, center.dy - 50),
      //     Offset(center.dx, center.dy - 70), _linePaint);
      // canvas.drawLine(Offset(center.dx + 30, center.dy - 50),
      //     Offset(center.dx, center.dy - 70), _linePaint);
      // canvas.drawLine(Offset(center.dx - 30, center.dy + 50),
      //     Offset(center.dx, center.dy + 70), _linePaint);
      // canvas.drawLine(Offset(center.dx + 30, center.dy + 50),
      //     Offset(center.dx, center.dy + 70), _linePaint);
      //
      // // draw horizontal arrows
      // canvas.drawLine(Offset(center.dx - 50, center.dy - 30),
      //     Offset(center.dx - 70, center.dy), _linePaint);
      // canvas.drawLine(Offset(center.dx - 50, center.dy + 30),
      //     Offset(center.dx - 70, center.dy), _linePaint);
      // canvas.drawLine(Offset(center.dx + 50, center.dy - 30),
      //     Offset(center.dx + 70, center.dy), _linePaint);
      // canvas.drawLine(Offset(center.dx + 50, center.dy + 30),
      //     Offset(center.dx + 70, center.dy), _linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
