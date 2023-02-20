import 'package:flutter/material.dart';

class JoyButtonsButton extends StatelessWidget {
  final Widget title;

  final MaterialColor widgetColor;

  const JoyButtonsButton({
    Key? key,
    this.title = const Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Text("A", style: TextStyle(color: Colors.white, fontSize: 32)),
    ),
    this.widgetColor = Colors.blue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Container(
        width: 75,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
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
