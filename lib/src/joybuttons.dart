import 'dart:async';

import 'package:flutter/material.dart';

import 'joybuttons_base.dart';
import 'joybuttons_controller.dart';
import 'joybuttons_stick.dart';
import 'joybuttons_stick_offset_calculator.dart';

/// JoyButtons widget
class JoyButtons extends StatefulWidget {
  /// Callback, which is called with [period] frequency when the stick is dragged.
  final TouchDragCallback listener;

  /// Frequency of calling [listener] from the moment the stick is dragged, by default 100 milliseconds.
  final Duration period;

  /// Widget that renders joyButtons base, by default [JoyButtonsBase].
  final Widget? base;

  /// Widget that renders joyButtons stick, it places in the center of [base] widget, by default [JoyButtonsStick].
  final Widget stick;

  /// Controller allows to control joyButtons events outside the widget.
  final JoyButtonsController? controller;

  /// Possible directions mode of the joyButtons stick, by default [JoyButtonsMode.all]
  final JoyButtonsMode mode;

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
    this.base,
    this.stick = const JoybuttonsStick(),
    this.mode = JoyButtonsMode.all,
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

  @override
  void initState() {
    super.initState();
    widget.controller?.onStickDragStart =
        (globalPosition) => _stickDragStart(globalPosition);
    widget.controller?.onStickDragUpdate =
        (globalPosition) => _stickDragUpdate(globalPosition);
    widget.controller?.onStickDragEnd = () => _stickDragEnd();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(_stickOffset.dx, _stickOffset.dy),
      children: [
        Container(
          key: _baseKey,
          child: widget.base ?? JoyButtonsBase(mode: widget.mode),
        ),
        GestureDetector(
          onPanStart: (details) => _stickDragStart(details.globalPosition),
          onPanUpdate: (details) => _stickDragUpdate(details.globalPosition),
          onPanEnd: (details) => _stickDragEnd(),
          child: widget.stick,
        ),
      ],
    );
  }

  void _stickDragStart(Offset globalPosition) {
    _runCallback();
    _startDragStickPosition = globalPosition;
    widget.onStickDragStart?.call();
  }

  void _stickDragUpdate(Offset globalPosition) {
    final baseRenderBox =
        _baseKey.currentContext!.findRenderObject()! as RenderBox;

    final stickOffset = widget.stickOffsetCalculator.calculate(
      mode: widget.mode,
      startDragStickPosition: _startDragStickPosition,
      currentDragStickPosition: globalPosition,
      baseSize: baseRenderBox.size,
    );

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
    widget.listener(StickDragDetails(_stickOffset.dx, _stickOffset.dy));
    _startDragStickPosition = Offset.zero;
    widget.onStickDragEnd?.call();
  }

  void _runCallback() {
    _callbackTimer = Timer.periodic(widget.period, (timer) {
      widget.listener(StickDragDetails(_stickOffset.dx, _stickOffset.dy));
    });
  }

  @override
  void dispose() {
    _callbackTimer?.cancel();
    super.dispose();
  }
}

typedef TouchDragCallback = void Function(StickDragDetails details);

/// Contains the stick offset from the center of the base.
class StickDragDetails {
  /// x - the stick offset in the horizontal direction. Can be from -1.0 to +1.0.
  final double x;

  /// y - the stick offset in the vertical direction. Can be from -1.0 to +1.0.
  final double y;

  StickDragDetails(this.x, this.y);
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
