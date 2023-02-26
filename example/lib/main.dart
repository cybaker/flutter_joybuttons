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

class JoyButtonsExample extends StatefulWidget {
  const JoyButtonsExample({Key? key}) : super(key: key);

  @override
  _JoyButtonsExampleState createState() => _JoyButtonsExampleState();
}

class _JoyButtonsExampleState extends State<JoyButtonsExample> {
  List<int> _pressed = [];
  double dimension = 45;

  double _sizeOfCenter = 0.4;
  double _numberOfButtons = 3;
  final double _maxButtons = 50;

  final _names = List.generate(26, (index) => String.fromCharCode(index + 65));
  final _colors = [
    Colors.amber,
    Colors.blue,
    Colors.pink,
    Colors.green,
    Colors.red,
    Colors.lime,
  ];

  List<Widget> getButtons() {
    return List.generate(_numberOfButtons.round(), (index) {
      var name = _names[index % _names.length];
      var color = _colors[index % _colors.length];
      return testButton(name, color);
    });
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

  List<Widget> getIndicators(int number) {
    return List.generate(_numberOfButtons.round(), (index) {
      var name = _names[index % _names.length];
      var color = _colors[index % _colors.length];
      return testIndicator(name, index, color);
    });
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
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Number of Buttons", style: TextStyle(fontSize: 24)),
                ),
                Slider(
                  min: 1.0,
                  max: _maxButtons,
                  value: _numberOfButtons,
                  divisions: (_maxButtons - 1.0).round(),
                  label: '${_numberOfButtons.round()}',
                  onChanged: (value) {
                    setState(() {
                      _numberOfButtons = value;
                    });
                  },
                ),
              ],
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Size of center", style: TextStyle(fontSize: 24)),
                ),
                Slider(
                  min: 0.0,
                  max: 1.0,
                  value: _sizeOfCenter,
                  divisions: 20,
                  label: _sizeOfCenter.toString(),
                  onChanged: (value) {
                    setState(() {
                      _sizeOfCenter = value;
                    });
                  },
                ),
              ],
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Pressed buttons", style: TextStyle(fontSize: 24)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      ...getIndicators(_numberOfButtons.round()),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Touch joybuttons widget to see which buttons are reported as pressed",
                      style: TextStyle(fontSize: 24)),
                ),
                JoyButtons(
                  centerButtonOutput: List.generate(_numberOfButtons.round(), (index) => index),
                  centerWidget: JoyButtonsCenter(size: Size(200*_sizeOfCenter, 200*_sizeOfCenter),),
                  buttonWidgets: getButtons(),
                  listener: (details) {
                    setState(() {
                      _pressed = details.pressed;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
