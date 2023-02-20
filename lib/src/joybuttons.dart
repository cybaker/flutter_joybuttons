import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_joybuttons/src/joybuttons_button.dart';

import 'joybuttons_base.dart';
import 'joybuttons_controller.dart';
import 'joybuttons_touch_offset_calculator.dart';

/// JoyButtons widget
class JoyButtons extends StatefulWidget {
  /// Callback, which is called with [period] frequency when the stick is dragged.
  final TouchDragCallback listener;

  /// Frequency of calling [listener] from the moment the stick is dragged, by default 100 milliseconds.
  final Duration period;

  /// Widgets shown within bounds of JoyButtons.
  /// If empty, one circle widget is added.
  final List<JoyButtonsButton> buttonWidgets;

  /// Buttons reported when the all button is pressed
  final List<int> allButtonList;

  /// All button (center button) scale from total Widget size. 1.0 is full size, 0.0 is zero size.
  final double allButtonScale;

  /// JoyButtons size, default 200, 200. Width and Height must be the same.
  final Size size;

  /// Widget that renders joyButtons base, by default [JoyButtonsBase].
  final Widget base;

  /// Controller allows to control joyButtons events outside the widget.
  final JoyButtonsController? controller;

  /// Calculate offset of the touch from center based on the drag start position and the current position.
  final TouchOffsetCalculator touchOffsetCalculator;

  /// Callback, which is called when the stick starts dragging.
  final Function? onStickDragStart;

  /// Callback, which is called when the stick released.
  final Function? onTouchDragEnd;

  const JoyButtons({
    Key? key,
    required this.listener,
    this.size = const Size(200, 200),
    this.period = const Duration(milliseconds: 100),
    this.base = const JoyButtonsBase(
      size: Size(200, 200),
    ),
    this.buttonWidgets = const [
      JoyButtonsButton(),
      JoyButtonsButton(
        title: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text("B", style: TextStyle(color: Colors.white, fontSize: 32)),
        ),
      ),
      JoyButtonsButton(
        title: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text("C", style: TextStyle(color: Colors.white, fontSize: 32)),
        ),
      ),
      JoyButtonsButton(
        title: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text("D", style: TextStyle(color: Colors.white, fontSize: 32)),
        ),
      ),
    ],
    this.allButtonList = const [0, 1, 2, 3],
    this.allButtonScale = 0.4,
    this.touchOffsetCalculator = const CircleStickOffsetCalculator(),
    this.controller,
    this.onStickDragStart,
    this.onTouchDragEnd,
  }) : super(key: key);

  @override
  _JoyButtonsState createState() => _JoyButtonsState();
}

class _JoyButtonsState extends State<JoyButtons> {
  final GlobalKey _baseKey = GlobalKey();

  late Offset _center;

  /// Angle between button centers depends on how many buttons
  late double _angleStep;

  Timer? _callbackTimer;
  List<int> _pressed = [];

  @override
  void initState() {
    super.initState();
    widget.controller?.onStickDragStart = (globalPosition) => _dragStart(globalPosition);
    widget.controller?.onStickDragUpdate = (globalPosition) => _dragUpdate(globalPosition);
    widget.controller?.onStickDragEnd = () => _dragEnd();

    _center = Offset(widget.size.width / 2, widget.size.height / 2);
    _angleStep = 2 * math.pi / widget.buttonWidgets.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (point) => _dragStart(point.localPosition),
      onPanUpdate: (point) => _dragUpdate(point.localPosition),
      onPanEnd: (point) => _dragEnd(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            key: _baseKey,
            child: widget.base,
          ),
          getButtons(widget.buttonWidgets),
          allWidget(),
        ],
      ),
    );
  }

  Container allWidget() {
    return Container(
      width: widget.size.width * widget.allButtonScale,
      height: widget.size.height * widget.allButtonScale,
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
            Colors.lightBlue.shade400,
            Colors.lightBlue.shade900,
          ],
        ),
      ),
    );
  }

  Widget getButtons(List<JoyButtonsButton> buttonWidgets) {
    var divAngle = _angleStep;
    double heightOffset = widget.size.height / 4;

    List<Widget> widgets = [
      for (MapEntry element in buttonWidgets.asMap().entries)
        Transform.rotate(
          angle: element.key * divAngle,
          child: Transform.translate(
            offset: Offset(0, -heightOffset),
            child: element.value,
          ),
        )
    ];

    return Stack(children: widgets);
  }

  void _dragStart(Offset touchPosition) {
    _runCallback();
    var offsetFromCenter = touchPosition - _center;
    _pressed = _calculatePressedButtons(offsetFromCenter);
    widget.onStickDragStart?.call();
  }

  void _dragUpdate(Offset touchPosition) {
    var offsetFromCenter = touchPosition - _center;
    // debugPrint("Touch offset local $offsetFromCenter");
    _pressed = _calculatePressedButtons(offsetFromCenter);
  }

  void _dragEnd() {
    _callbackTimer?.cancel();
    widget.listener(TouchDragDetails(_pressed));
    widget.onTouchDragEnd?.call();
  }

  void _runCallback() {
    _callbackTimer = Timer.periodic(widget.period, (timer) {
      widget.listener(TouchDragDetails(_pressed));
    });
  }

  List<int> _calculatePressedButtons(Offset offsetFromCenter) {
    List<int> pressed = [];

    // debugPrint("Distance is ${offsetFromCenter.distance}");
    if (offsetFromCenter.distance < widget.allButtonScale * widget.size.width / 2) {
      // All buttons are pressed in the middle
      pressed = widget.allButtonList;
    } else {
      // touch is not inside the ALL button, calculate which others are pressed
      // 0 angle is North on canvas.
      // First button is centered on angle 0.

      // pressedAngle values are from 0 to pi clockwise from North, 0 to -pi counterwise.
      var pressedAngle = math.atan2(offsetFromCenter.dx, -offsetFromCenter.dy);

      widget.buttonWidgets.asMap().forEach((index, value) {
        var buttonAngle = index * _angleStep;
        var deltaAngle = buttonAngle - pressedAngle;
        if (deltaAngle > math.pi) {
          deltaAngle = 2 * math.pi - deltaAngle;
        }
        debugPrint("pressedAngle is $pressedAngle, buttonAngle is $buttonAngle, deltaAngle is $deltaAngle");
        if (deltaAngle.abs() < (_angleStep / 2)) {
          pressed.add(index);
        }
      });
    }

    return pressed;
  }

  @override
  void dispose() {
    _callbackTimer?.cancel();
    super.dispose();
  }
}

typedef TouchDragCallback = void Function(TouchDragDetails details);

/// Contains the stick offset from the center of the base.
class TouchDragDetails {
  /// List of input buttons pressed
  final List<int> pressed;

  TouchDragDetails(this.pressed);
}
