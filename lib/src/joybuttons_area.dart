import 'package:flutter/material.dart';
import 'package:flutter_joybuttons/flutter_joybuttons.dart';

import 'joybuttons.dart';
import 'joybuttons_controller.dart';
import 'joybuttons_widget.dart';
import 'joybuttons_stick_offset_calculator.dart';

/// Allow to place the joyButtons in any place where user click.
/// Just need to place other widgets as child of [JoyButtonsArea] widget.
class JoyButtonsArea extends StatefulWidget {
  /// The [child] contained by the joyButtons area.
  final Widget? child;

  /// Initial joyButtons alignment relative to the joyButtons area, by default [Alignment.bottomCenter].
  final Alignment initialJoyButtonsAlignment;

  /// Callback, which is called with [period] frequency when the stick is dragged.
  final TouchDragCallback listener;

  /// Frequency of calling [listener] from the moment the stick is dragged, by default 100 milliseconds.
  final Duration period;

  /// Widget that renders joyButtons base, by default [JoyButtonsBase].
  final Widget base;

  /// Widget that renders joyButtons stick, it places in the center of [base] widget, by default [JoyButtonsStick].
  final Widget stick;

  /// Mode possible direction
  final JoyButtonsMode mode;

  /// Calculate offset of the stick based on the stick drag start position and the current stick position.
  final ButtonsOffsetCalculator stickOffsetCalculator;

  /// Callback, which is called when the stick starts dragging.
  final Function? onStickDragStart;

  /// Callback, which is called when the stick released.
  final Function? onStickDragEnd;

  const JoyButtonsArea({
    Key? key,
    this.child,
    this.initialJoyButtonsAlignment = Alignment.bottomCenter,
    required this.listener,
    this.period = const Duration(milliseconds: 100),
    this.base = const JoyButtonsBase(),
    this.stick = const JoyButtonsWidget(),
    this.mode = JoyButtonsMode.all,
    this.stickOffsetCalculator = const CircleStickOffsetCalculator(),
    this.onStickDragStart,
    this.onStickDragEnd,
  }) : super(key: key);

  @override
  _JoyButtonsAreaState createState() => _JoyButtonsAreaState();
}

class _JoyButtonsAreaState extends State<JoyButtonsArea> {
  final _areaKey = GlobalKey();
  final _joyButtonsKey = GlobalKey();
  final _controller = JoyButtonsController();
  late Alignment _joyButtonsAlignment;

  @override
  void didChangeDependencies() {
    _joyButtonsAlignment = widget.initialJoyButtonsAlignment;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _areaKey,
      onPanStart: _startDrag,
      onPanUpdate: _updateDrag,
      onPanEnd: _endDrag,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Stack(
          children: [
            if (widget.child != null) Align(child: widget.child),
            Align(
              alignment: _joyButtonsAlignment,
              child: JoyButtons(
                key: _joyButtonsKey,
                controller: _controller,
                listener: widget.listener,
                period: widget.period,
                base: widget.base,
                onStickDragStart: widget.onStickDragStart,
                onStickDragEnd: widget.onStickDragEnd,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startDrag(DragStartDetails details) {
    final localPosition = details.localPosition;
    final joyButtonsSize = _joyButtonsKey.currentContext!.size!;

    final areaBox = _areaKey.currentContext!.findRenderObject()! as RenderBox;

    final halfWidth = areaBox.size.width / 2;
    final halfHeight = areaBox.size.height / 2;

    final xAlignment =
        (localPosition.dx - halfWidth) / (halfWidth - joyButtonsSize.width / 2);
    final yAlignment = (localPosition.dy - halfHeight) /
        (halfHeight - joyButtonsSize.height / 2);

    setState(() {
      _joyButtonsAlignment = Alignment(xAlignment, yAlignment);
    });
    _controller.start(details.globalPosition);
  }

  void _updateDrag(DragUpdateDetails details) {
    _controller.update(details.globalPosition);
  }

  void _endDrag(DragEndDetails details) {
    setState(() {
      _joyButtonsAlignment = widget.initialJoyButtonsAlignment;
    });

    _controller.end();
  }
}
