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
  double dimension = 60;

  double _numberOfButtons = 3;

  List<Widget> buttons = [
    const JoyButtonsButton(
      widgetColor: Colors.amber,
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
      widgetColor: Colors.green,
      title: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text("C", style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
    ),
    const JoyButtonsButton(
      widgetColor: Colors.red,
      title: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text("D", style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
    ),
    const JoyButtonsButton(
      widgetColor: Colors.yellow,
      title: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text("E", style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
    ),
  ];

  List<Widget> getContainers(int number) {
    List<Widget> all = [
      Container(
        alignment: Alignment.center,
        width: dimension,
        height: dimension,
        color: _pressed.contains(0) ? Colors.amber : Colors.grey.shade200,
        child: const Text("A", style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
      Container(
        alignment: Alignment.center,
        width: dimension,
        height: dimension,
        color: _pressed.contains(1) ? Colors.blue : Colors.grey.shade200,
        child: const Text("B", style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
      Container(
        alignment: Alignment.center,
        width: dimension,
        height: dimension,
        color: _pressed.contains(2) ? Colors.green : Colors.grey.shade200,
        child: const Text("C", style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
      Container(
        alignment: Alignment.center,
        width: dimension,
        height: dimension,
        color: _pressed.contains(3) ? Colors.redAccent : Colors.grey.shade200,
        child: const Text("D", style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
      Container(
        alignment: Alignment.center,
        width: dimension,
        height: dimension,
        color: _pressed.contains(4) ? Colors.yellow : Colors.grey.shade200,
        child: const Text("E", style: TextStyle(color: Colors.white, fontSize: 32)),
      ),
    ];
    return all.take(number).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Slider(
              min: 1.0,
              max: 5.0,
              value: _numberOfButtons,
              divisions: 4,
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
            Align(
              alignment: const Alignment(0, 0.8),
              child: JoyButtons(
                centerButtonOutput: List.generate(_numberOfButtons.round(), (index) => index),
                buttonWidgets: buttons.take(_numberOfButtons.round()).toList(),
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
