import 'package:flutter/material.dart';
import 'package:flutter_joybuttons/flutter_joybuttons.dart';

void main() {
  runApp(const JoyButtonsExampleApp());
}

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
  double dimension = 45;

  double _numberOfButtons = 3;

  List<Widget> getButtons() {
    return [
      testButton("A", Colors.amber),
      testButton("B", Colors.blue),
      testButton("C", Colors.amber),
      testButton("D", Colors.green),
      testButton("E", Colors.yellow),
      testButton("F", Colors.red),
    ];
  }

  JoyButtonsButton testButton(String label, MaterialColor color) {
    return JoyButtonsButton(
    widgetColor: color,
    title: Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 32)),
    ),
  );
  }

  List<Widget> getContainers(int number) {
    List<Widget> all = [
      testIndicator("A", 0, Colors.amber),
      testIndicator("B", 1, Colors.blue),
      testIndicator("C", 2, Colors.amber),
      testIndicator("D", 3, Colors.green),
      testIndicator("E", 4, Colors.yellow),
      testIndicator("F", 5, Colors.red),
    ];
    return all.take(number).toList();
  }

  Container testIndicator(String label, int index, Color color) {
    return Container(
      alignment: Alignment.center,
      width: dimension,
      height: dimension,
      color: _pressed.contains(index) ? color : Colors.grey.shade200,
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 32)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Change the number of Buttons", style: const TextStyle(fontSize: 24)),
            Slider(
              min: 1.0,
              max: 6.0,
              value: _numberOfButtons,
              divisions: 5,
              label: '${_numberOfButtons.round()}',
              onChanged: (value) {
                setState(() {
                  _numberOfButtons = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...getContainers(_numberOfButtons.round()),
                ],
              ),
            ),
            const Text("Touch inside the circle to see which buttons are pressed", style: const TextStyle(fontSize: 24)),
            Align(
              alignment: const Alignment(0, 0.8),
              child: JoyButtons(
                centerButtonOutput: List.generate(_numberOfButtons.round(), (index) => index),
                buttonWidgets: getButtons().take(_numberOfButtons.round()).toList(),
                listener: (details) {
                  setState(() {
                    _pressed = details.pressed;
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
