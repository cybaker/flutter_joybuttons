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
        body: const JoyButtonsExample(),
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
  List<int> _pressed = [];
  double dimension = 60;

  List<Widget> buttons = [
    const JoyButtonsButton(
      title: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text("A", style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
    ),
    const JoyButtonsButton(
      title: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text("B", style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
    ),
    const JoyButtonsButton(
      title: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text("C", style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: dimension,
                    height: dimension,
                    color: _pressed.contains(0) ? Colors.green : Colors.green.shade100,
                    child: const Text("A", style: TextStyle(color: Colors.white, fontSize: 32)),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: dimension,
                    height: dimension,
                    color: _pressed.contains(1) ? Colors.green : Colors.green.shade100,
                    child: const Text("B", style: TextStyle(color: Colors.white, fontSize: 32)),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: dimension,
                    height: dimension,
                    color: _pressed.contains(2) ? Colors.green : Colors.green.shade100,
                    child: const Text("C", style: TextStyle(color: Colors.white, fontSize: 32)),
                  ),
                ],
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.8),
              child: JoyButtons(
                buttonWidgets: buttons,
                listener: (details) {
                  setState(() {
                    _pressed = details.pressed;
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
