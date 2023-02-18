# Flutter JoyButtons

[![Pub](https://img.shields.io/pub/v/flutter_joybuttons.svg)](https://pub.dev/packages/flutter_joybuttons)
[![License](https://img.shields.io/github/license/cybaker/flutter_joybuttons)](https://github.com/cybaker/flutter_joybuttons/blob/master/LICENSE)
[![Pub likes](https://badgen.net/pub/likes/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons/score)
[![Pub popularity](https://badgen.net/pub/popularity/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons/score)
[![Pub points](https://badgen.net/pub/points/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons/score)
[![Flutter platform](https://badgen.net/pub/flutter-platform/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons)

A virtual JoyButtons for Flutter applications. Inspired by Gravitar for mobile. 

JoyButtons are a variant of virtual Joysticks. Tapping multiple buttons simultaneously on a touchscreen with one thumb is impossible. Multiple fingers are possible, but holding a phone and using a thumb for a joystick and fingers for multiple buttons is near impossible. This Widget solves some of those multiple button simultaneous tap use cases.

## Use cases:
- activate one button, two buttons, or all buttons simultaneously
- press and hold to continuously callback which buttons are pressed

Thanks to [![flutter_joystick](https://img.shields.io/github/license/cybaker/flutter_joystick)](https://github.com/cybaker/flutter_joystick)
for code inspiration.

- [JoyButtons](#joyButtons)
- [JoyButtons Area](#joyButtons-area)
- [Customization](#customization) 
- [Donate](#donate)


### JoyButtons

![JoyButtons](TODO "JoyButtons")

```dart
JoyButtons(listener: (details) {
...
})
```

`JoyButtons` arguments:

Parameter | Description
--- | --- 
listener | callback, which is called with `period` frequency when the stick is dragged. Listener parameter `details` contains the stick offset from the center of the base (can be from -1.0 to +1.0).
period | frequency of calling `listener` from the moment the stick is dragged, by default 100 milliseconds.
mode | possible directions mode of the joyButtons stick, by default `all`

Possible joyButtons modes:

Mode | Description
--- | --- 
all | allow move the stick in any direction: vertical, horizontal and diagonal
vertical | allow move the stick only in vertical direction
horizontal | allow move the stick only in horizontal direction
horizontalAndVertical | allow move the stick only in horizontal and vertical directions, not diagonal

![JoyButtons Vertical](https://i.giphy.com/media/FXQG3ttV35Ca5L5ZA7/giphy.gif "JoyButtons Vertical")
![JoyButtons Horizontal](https://i.giphy.com/media/SN9YMtBKaHLkw5iIvB/giphy.gif "JoyButtons Horizontal")
![JoyButtons Horizontal And Vertical](https://i.giphy.com/media/znAdOQr52MmKTssc91/giphy.gif "JoyButtons Horizontal And Vertical")

### JoyButtons Area

![JoyButtons](https://i.giphy.com/media/2uFUWJcOaaTPFbIFBd/giphy.gif "JoyButtons Area")

`JoyButtonsArea` allows to render a joyButtons anywhere in this area where user clicks.

```dart
JoyButtonsArea(
  listener: (details) {
    ...
  },
  child: ...
)
```

`JoyButtonsArea` has the same arguments as `JoyButtons` (listener, period, mode, etc.).

Additional `JoyButtonsArea` arguments:

Parameter | Description
--- | ---
initialJoyButtonsAlignment | Initial joyButtons alignment relative to the joyButtons area, by default `Alignment.bottomCenter`.
child | The `child` contained by the joyButtons area.

### Customization

![Square JoyButtons](https://i.giphy.com/media/kjGJmILAeBJFXGtcgt/giphy.gif "Square JoyButtons")

`JoyButtons` and `JoyButtonsArea` have additional arguments that allow to customize their appearance and behaviour.

Parameter | Description
--- | ---
base | Widget that renders joyButtons base, by default `JoyButtonsBase`.
stick | Widget that renders joyButtons stick, it places in the center of `base` widget, by default `JoyButtonsStick`.
stickOffsetCalculator | Calculate offset of the stick based on the stick drag start position and the current stick position. The package currently only supports circle and rectangle joyButtons shapes. By default `CircleStickOffsetCalculator`.
