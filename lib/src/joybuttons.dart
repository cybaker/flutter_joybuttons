import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_joybuttons/src/joybuttons_widget.dart';

import 'joybuttons_base.dart';
import 'joybuttons_controller.dart';
import 'joybuttons_stick_offset_calculator.dart';

/// JoyButtons widget
class JoyButtons extends StatefulWidget {
  /// Callback, which is called with [period] frequency when the stick is dragged.
  final TouchDragCallback listener;

  /// Frequency of calling [listener] from the moment the stick is dragged, by default 100 milliseconds.
  final Duration period;

  /// Widgets shown within bounds of JoyButtons.
  /// If empty, one circle widget is added.
  final List<JoyButtonsWidget> buttonWidgets;

  /// Widget that renders joyButtons base, by default [JoyButtonsBase].
  final Widget base;

  /// Controller allows to control joyButtons events outside the widget.
  final JoyButtonsController? controller;

  /// Calculate offset of the stick based on the stick drag start position and the current stick position.
  final ButtonsOffsetCalculator stickOffsetCalculator;

  /// Callback, which is called when the stick starts dragging.
  final Function? onStickDragStart;

  /// Callback, which is called when the stick released.
  final Function? onStickDragEnd;

  const JoyButtons({
    Key? key,
    required this.listener,
    this.period = const Duration(milliseconds: 100),
    this.base = const JoyButtonsBase(),
    this.buttonWidgets = const [
      JoyButtonsWidget(),
      JoyButtonsWidget(
        title: Text("B", style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
      JoyButtonsWidget(
        title: Text("C", style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    ],
    this.stickOffsetCalculator = const CircleStickOffsetCalculator(),
    this.controller,
    this.onStickDragStart,
    this.onStickDragEnd,
  }) : super(key: key);

  @override
  _JoyButtonsState createState() => _JoyButtonsState();
}

class _JoyButtonsState extends State<JoyButtons> {
  final GlobalKey _baseKey = GlobalKey();

  Offset _stickOffset = Offset.zero;
  Timer? _callbackTimer;
  Offset _startDragStickPosition = Offset.zero;
  List<int> _pressed = [];

  @override
  void initState() {
    super.initState();
    widget.controller?.onStickDragStart = (globalPosition) => _stickDragStart(globalPosition);
    widget.controller?.onStickDragUpdate = (globalPosition) => _stickDragUpdate(globalPosition);
    widget.controller?.onStickDragEnd = () => _stickDragEnd();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (point) => _stickDragStart(point.globalPosition),
      onPanUpdate: (point) => _stickDragUpdate(point.globalPosition),
      onPanEnd: (point) => _stickDragEnd(),
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
      width: 100,
      height: 100,
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
            Colors.lightBlue.shade900,
            Colors.lightBlue.shade400,
          ],
        ),
      ),
    );
  }

  Widget getButtons(List<JoyButtonsWidget> buttonWidgets) {
    var divAngle = 2 * 3.1415926 / buttonWidgets.length;

    List<Widget> widgets = [
      for (MapEntry element in buttonWidgets.asMap().entries)
        Transform.rotate(
          angle: element.key * divAngle,
          child: Transform.translate(
            offset: const Offset(0, -75),
            child: element.value,
          ),
        )
    ];

    return Stack(children: widgets);
  }

  void _stickDragStart(Offset globalPosition) {
    _runCallback();
    _startDragStickPosition = globalPosition;
    widget.onStickDragStart?.call();
  }

  void _stickDragUpdate(Offset globalPosition) {
    final baseRenderBox = _baseKey.currentContext!.findRenderObject()! as RenderBox;

    final stickOffset = widget.stickOffsetCalculator.calculate(
      startDragStickPosition: _startDragStickPosition,
      currentDragStickPosition: globalPosition,
      baseSize: baseRenderBox.size,
    );

    _pressed = _calculatePressedButtons(stickOffset);

    setState(() {
      _stickOffset = stickOffset;
    });
  }

  void _stickDragEnd() {
    setState(() {
      _stickOffset = Offset.zero;
    });

    _callbackTimer?.cancel();
    //send zero offset when the stick is released
    widget.listener(TouchDragDetails(_stickOffset.dx, _stickOffset.dy, _pressed));
    _startDragStickPosition = Offset.zero;
    widget.onStickDragEnd?.call();
  }

  void _runCallback() {
    _callbackTimer = Timer.periodic(widget.period, (timer) {
      widget.listener(TouchDragDetails(_stickOffset.dx, _stickOffset.dy, _pressed));
    });
  }

  List<int> _calculatePressedButtons(Offset stickOffset) {
    List<int> pressed = [];

    debugPrint("Distance is ${_stickOffset.distance}");
    if (stickOffset.distance < 0.5)
      pressed = [1, 2, 3];
    else
      pressed = [3];

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
  /// x - the stick offset in the horizontal direction. Can be from -1.0 to +1.0.
  final double x;

  /// y - the stick offset in the vertical direction. Can be from -1.0 to +1.0.
  final double y;

  /// List of buttons pressed
  final List<int> pressed;

  TouchDragDetails(this.x, this.y, this.pressed);
}

/// Possible directions of the joyButtons stick.
enum JoyButtonsMode {
  /// allow move the stick in any direction: vertical, horizontal and diagonal.
  all,

  /// allow move the stick only in vertical direction.
  vertical,

  /// allow move the stick only in horizontal direction.
  horizontal,

  /// allow move the stick only in horizontal and vertical directions, not diagonal.
  horizontalAndVertical,
}
