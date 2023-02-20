import 'package:flutter/material.dart';
import 'package:flutter_joybuttons/flutter_joybuttons.dart';

void main() {
  runApp(const JoyButtonsExampleApp());
}

const ballSize = 20.0;
const step = 10.0;

class JoyButtonsExampleApp extends StatelessWidget {
  const JoyButtonsExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('JoyButtons Example'),
        ),
        body: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JoyButtonsExample()),
              );
            },
            child: const Text('JoyButtons'),
          ),
        ],
      ),
    );
  }
}

class JoyButtonsExample extends StatefulWidget {
  const JoyButtonsExample({Key? key}) : super(key: key);

  @override
  _JoyButtonsExampleState createState() => _JoyButtonsExampleState();
}

class _JoyButtonsExampleState extends State<JoyButtonsExample> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JoyButtons'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, 0.8),
              child: JoyButtons(
                listener: (details) {
                  setState(() {
                    debugPrint("Buttons pressed are ${details.pressed}");
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> buttons = [
    const Positioned(
      top: 40,
      child: ElevatedButton(
            onPressed: null,
            child: Text("Up"),
          ),
    ),
    const ElevatedButton(
          onPressed: null,
          child: Text("Down"),
        ),
  ];

class Ball extends StatelessWidget {
  final double x;
  final double y;

  const Ball(this.x, this.y, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: ballSize,
        height: ballSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
        ),
      ),
    );
  }
}
