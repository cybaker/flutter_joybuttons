# Flutter JoyButtons

[![Pub](https://img.shields.io/pub/v/flutter_joybuttons.svg)](https://pub.dev/packages/flutter_joybuttons)
[![License](https://img.shields.io/github/license/cybaker/flutter_joybuttons)](https://github.com/cybaker/flutter_joybuttons/blob/master/LICENSE)
[![Pub likes](https://badgen.net/pub/likes/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons/score)
[![Pub popularity](https://badgen.net/pub/popularity/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons/score)
[![Pub points](https://badgen.net/pub/points/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons/score)
[![Flutter platform](https://badgen.net/pub/flutter-platform/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons)

Virtual JoyButtons for Flutter touchscreen apps. Inspired by programming Gravitar for smartphones and needing shield and bullets simultaneously.

- [JoyButtons](#JoyButtons)
- [Primary use cases](#Primary use cases)
- [Customization](#Customization)

# JoyButtons:
Virtual JoyButtons are one way to press multiple buttons simultaneously. Physical game controllers allow simultaneous presses by different fingers. A touchscreen device is limited to front facing touchscreens which make simultaneous button pressing a real challenge.

Thus, JoyButtons are here. The user uses one thumb and can active multiple buttons simultaneously, just not in all possible combinations.
There are any number of buttons outside a center button. Like a virtual joystick, the user can move their thumb around the two dimensions.
If the thumb is pressing over the center area, the reported presses are sent back to the listener. The center presses are customizable by the programmer.
If the thumb is pressing in the JoyButtons outside the center area, then presses are reported for one or two adjacent buttons. This is also customizable.

## Primary use cases:
- activate one button, two buttons, or all buttons simultaneously with a single thumb or finger
- press and hold and callback at regular intervals the pressed buttons

Thanks to [![flutter_joystick](https://img.shields.io/github/license/cybaker/flutter_joystick)](https://github.com/cybaker/flutter_joystick)
for code inspiration. Gravitar also uses flutter_joystick.

### Customization

There are a minimum of 2 buttons needed to define and setup. There can be a large amount of buttons defined. Just note the more
buttons there are, the less angular difference between buttons. 2 to 5 buttons seem reasonable.

The example shows 3 buttons setup. The center area report all 3 buttons when pressed. The outer buttons
can activate simultaneously with an adjacent button or alone. In the example, pressing
the outer area and sweeping around 360 degrees will activate 1 or 2 buttons simultaneously, while moving to the 
center button will activate all 3 buttons.

Customizations
Number of outer buttons.
Button background color, shape, size, and text.
Center button color and scale.
simultaneousOverlapScale from 0.0 (alone) to 1.0 (always with an adjacent) or alone and with an adjacent (default of about 0.4)