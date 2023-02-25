// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_joybuttons/src/joybuttons.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Joybuttons press test', (WidgetTester tester) async {
    var pressed = <int>[];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('JoyButtons Example'),
        ),
        body: JoyButtons(listener: (details) {
          pressed = details.pressed;
        }),
      ),
    ));

    final Offset offsetA = tester.getCenter(find.text("A"));
    final Offset offsetB = tester.getCenter(find.text("B"));
    final Offset offsetC = tester.getCenter(find.text("C"));
    final Offset offsetD = tester.getCenter(find.text("D"));

    var gesture = await tester.startGesture(offsetA);
    await tester.pump();
    expect(pressed, equals([0]));

    await gesture.moveTo((offsetA + offsetB) / 2);
    await tester.pump();
    expect(pressed, equals([0, 1]));

    await gesture.moveTo(offsetB);
    await tester.pump();
    expect(pressed, equals([1]));

    await gesture.moveTo((offsetB + offsetC) / 2);
    await tester.pump();
    expect(pressed, equals([1, 2]));

    await gesture.moveTo(offsetC);
    await tester.pump();
    expect(pressed, equals([2]));

    await gesture.moveTo((offsetC + offsetD) / 2);
    await tester.pump();
    expect(pressed, equals([2, 3]));

    await gesture.moveTo(offsetD);
    await tester.pump();
    expect(pressed, equals([3]));

    await gesture.moveTo((offsetA + offsetD) / 2);
    await tester.pump();
    expect(pressed, equals([0, 3]));

    final Offset center = tester.getCenter(find.byKey(const Key("joybuttons_center")));
    await gesture.moveTo(center);
    await tester.pump();
    expect(pressed, equals([0, 1, 2, 3]));

    await gesture.cancel();
    await tester.pump();
    expect(pressed, equals([]));
  });

  testWidgets('Joybuttons centerButtonOutput', (WidgetTester tester) async {
    var pressed = <int>[];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('JoyButtons Example'),
        ),
        body: JoyButtons(
            centerButtonOutput: const [99],
            listener: (details) {
              pressed = details.pressed;
            }),
      ),
    ));

    final Offset center = tester.getCenter(find.byKey(const Key("joybuttons_center")));
    var gesture = await tester.startGesture(center);
    await tester.pump();
    expect(pressed, equals([99]));
  });
}
