import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_joybuttons/flutter_joybuttons.dart';

import 'joybuttons_controller.dart';

/// JoyButtons widget
class JoyButtons extends StatefulWidget {
  /// Callback, which is called with [period] frequency during dragging.
  final TouchDragCallback listener;

  /// Widgets shown within bounds of JoyButtons.
  /// If empty, one circle widget is added.
  final List<Widget> buttonWidgets;

  /// Buttons reported when the all button is pressed. Defaults to all [buttonWidgets] reported.
  final List<int> centerButtonOutput;

  /// Center button scale relative to total Widget size. 1.0 is full size, 0.0 is zero size. Defalut is 0.4.
  final Widget centerWidget;

  /// Overlap on both sides of a button's tap region, from 0.0 to 1.0. This adds to the tappable region for all
  /// outside buttons, not the center button. This allows adjacent buttons to be pressed simultaneously.
  /// overlapScale is relative to the radians between two outside buttons. 0.0 means adding no additional overlap,
  /// 1.0 means adding additional overlap radians equal to the radians between two outside buttons.
  final double simultaneousOverlapScale;

  /// JoyButtons size, default 200, 200. Width and Height must be the same.
  final Size size;

  /// Widget that renders joyButtons base, by default [JoyButtonsBase].
  final Widget base;

  /// Controller allows to control joyButtons events outside the widget.
  final JoyButtonsController? controller;

  const JoyButtons({
    Key? key,
    required this.listener,
    this.size = const Size(200, 200),
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
    this.centerButtonOutput = const [],
    this.centerWidget = const JoyButtonsCenter(widgetColor: Colors.deepPurple),
    this.simultaneousOverlapScale = 0.4,
    this.controller,
  }) : super(key: key);

  @override
  JoyButtonsState createState() => JoyButtonsState();
}

class JoyButtonsState extends State<JoyButtons> {
  final GlobalKey _baseKey = GlobalKey();

  late Offset _center;

  /// Angle between button centers depends on how many buttons
  late double _angleStep;

  late List<int> _centerButtonList;

  List<int> _pressed = [];

  @override
  void initState() {
    super.initState();
    widget.controller?.onTouchDragStart =
        (globalPosition) => _dragStart(globalPosition);
    widget.controller?.onTouchDragUpdate =
        (globalPosition) => _dragUpdate(globalPosition);
    widget.controller?.onTouchDragEnd = () => _dragEnd();

    _center = Offset(widget.size.width / 2, widget.size.height / 2);

    _angleStep = 2 * math.pi / widget.buttonWidgets.length;

    _updateCenterButtonOutput();
  }

  void _updateCenterButtonOutput() {
    if (widget.centerButtonOutput.isEmpty) {
      _centerButtonList =
          List.generate(widget.buttonWidgets.length, (index) => index);
    } else {
      _centerButtonList = widget.centerButtonOutput;
    }
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
          widget.centerWidget,
        ],
      ),
    );
  }

  Widget getButtons(List<Widget> buttonWidgets) {
    _angleStep = 2 * math.pi / widget.buttonWidgets.length;
    _updateCenterButtonOutput();
    double heightOffset = widget.size.height / 4;

    List<Widget> widgets = [
      for (MapEntry element in buttonWidgets.asMap().entries)
        Transform.rotate(
          angle: element.key * _angleStep,
          child: Transform.translate(
            offset: Offset(0, -heightOffset),
            child: element.value,
          ),
        )
    ];

    return Stack(children: widgets);
  }

  void _dragStart(Offset touchPosition) {
    var offsetFromCenter = touchPosition - _center;
    _pressed = _calculatePressedButtons(offsetFromCenter);
    widget.listener(TouchDragActivated(_pressed));
  }

  void _dragUpdate(Offset touchPosition) {
    var offsetFromCenter = touchPosition - _center;
    _pressed = _calculatePressedButtons(offsetFromCenter);
    widget.listener(TouchDragActivated(_pressed));
  }

  void _dragEnd() {
    _pressed = [];
    widget.listener(TouchDragActivated(_pressed));
  }

  List<int> _calculatePressedButtons(Offset offsetFromCenter) {
    List<int> pressed = [];

    if (offsetFromCenter.distance <
        (widget.centerWidget as JoyButtonsCenter).size.width / 2) {
      // Center button pressed
      pressed = _centerButtonList;
    } else {
      // touch was outside the Center button, calculate which others are pressed
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
        if (deltaAngle.abs() <
            ((1 + widget.simultaneousOverlapScale) * _angleStep / 2)) {
          pressed.add(index);
        }
      });
    }

    return pressed;
  }
}

typedef TouchDragCallback = void Function(TouchDragActivated activity);

/// Holds the pressed results
class TouchDragActivated {
  /// List of input buttons pressed
  final List<int> pressed;

  TouchDragActivated(this.pressed);
}
