import 'package:flutter/material.dart';

class JoyButtonsCenter extends StatelessWidget {
  static const joyButtonsCenterKey = "flutter_joybuttons_center";

  final MaterialColor widgetColor;

  final Size size;

  const JoyButtonsCenter(
      {Key? key,
      this.widgetColor = Colors.blue,
      this.size = const Size(80, 80)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key(joyButtonsCenterKey),
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 4),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widgetColor.shade400,
            widgetColor.shade900,
          ],
        ),
      ),
    );
  }
}
