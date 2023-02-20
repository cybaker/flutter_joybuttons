import 'dart:async';

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
    this.base = const JoyButtonsBase(size: Size(200, 200),),
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
  Timer? _callbackTimer;
  List<int> _pressed = [];

  @override
  void initState() {
    super.initState();
    widget.controller?.onStickDragStart = (globalPosition) => _dragStart(globalPosition);
    widget.controller?.onStickDragUpdate = (globalPosition) => _dragUpdate(globalPosition);
    widget.controller?.onStickDragEnd = () => _dragEnd();

    _center = Offset(widget.size.width/2, widget.size.height/2);
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
            color: Colors.blue.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightGreen.shade900,
            Colors.lightGreen.shade400,
          ],
        ),
      ),
    );
  }

  Widget getButtons(List<JoyButtonsButton> buttonWidgets) {
    var divAngle = 2 * 3.1415926 / buttonWidgets.length;
    double offset = widget.size.height/4;

    List<Widget> widgets = [
      for (MapEntry element in buttonWidgets.asMap().entries)
        Transform.rotate(
          angle: element.key * divAngle,
          child: Transform.translate(
            offset: Offset(0, -offset),
            child: element.value,
          ),
        )
    ];

    return Stack(children: widgets);
  }

  void _dragStart(Offset touchPosition) {
    _runCallback();
    var offsetFromCenter = touchPosition - _center;
    // debugPrint("Touch offset local $offsetFromCenter");
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

  List<int> _calculatePressedButtons(Offset touchOffset) {
    List<int> pressed = [];

    debugPrint("Distance is ${touchOffset.distance}");
    if (touchOffset.distance < widget.allButtonScale * widget.size.width/2) {
      // All buttons are pressed in the middle
      pressed = List.generate(widget.buttonWidgets.length, (index) => index);
    } else { // touch is not inside the ALL button, calculate which others are pressed
      pressed = [3];
      // TODO calculate which button(s) are tapped
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
