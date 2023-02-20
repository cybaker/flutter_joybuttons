import 'package:flutter/material.dart';

class JoyButtonsWidget extends StatelessWidget {
  final Text title;

  final MaterialColor widgetColor;

  const JoyButtonsWidget({Key? key, this.title = const Text("A", style: TextStyle(color: Colors.white, fontSize: 24),), this.widgetColor = Colors.blue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widgetColor.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              widgetColor.shade900,
              widgetColor.shade400,
            ],
          ),
        ),
      ),
      title
    ]);
  }
}
