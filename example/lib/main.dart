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
                MaterialPageRoute(
                    builder: (context) => const JoyButtonsExample()),
              );
            },
            child: const Text('JoyButtons'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const JoyButtonsAreaExample()),
              );
            },
            child: const Text('JoyButtons Area'),
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
  var _joyButtonsNum = 2;
  var _buttonNameList = <String>[];

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
                  });
                },
                buttonWidgets: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JoyButtonsAreaExample extends StatefulWidget {
  const JoyButtonsAreaExample({Key? key}) : super(key: key);

  @override
  _JoyButtonsAreaExampleState createState() => _JoyButtonsAreaExampleState();
}

class _JoyButtonsAreaExampleState extends State<JoyButtonsAreaExample> {
  double _x = 100;
  double _y = 100;
  final JoyButtonsMode _joyButtonsMode = JoyButtonsMode.all;

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text('JoyButtons Area'), ),
      body: SafeArea(
        child: JoyButtonsArea(
          mode: _joyButtonsMode,
          initialJoyButtonsAlignment: const Alignment(0, 0.8),
          listener: (details) {
            setState(() {
              _x = _x + step * details.x;
              _y = _y + step * details.y;
            });
          },
          child: Stack(
            children: [
              Ball(_x, _y),
            ],
          ),
        ),
      ),
    );
  }
}

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
