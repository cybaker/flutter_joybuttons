# Flutter JoyButtons

[![Pub](https://img.shields.io/pub/v/flutter_joybuttons.svg)](https://pub.dev/packages/flutter_joybuttons)
[![License](https://img.shields.io/github/license/cybaker/flutter_joybuttons)](https://github.com/cybaker/flutter_joybuttons/blob/master/LICENSE)
[![Pub likes](https://badgen.net/pub/likes/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons/score)
[![Pub popularity](https://badgen.net/pub/popularity/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons/score)
[![Pub points](https://badgen.net/pub/points/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons/score)
[![Flutter platform](https://badgen.net/pub/flutter-platform/flutter_joybuttons)](https://pub.dev/packages/flutter_joybuttons)

Virtual JoyButtons for Flutter touchscreen apps. Inspired by programming Gravitar for smartphones and needing shield and bullets simultaneously.

- [JoyButtons](#JoyButtons)
- [UseCases](#UseCases)
- [Customization](#Customization)

[Run the example app in your web or mobile browser](https://cybaker.github.io/flutter_joybuttons/)

# JoyButtons:
Virtual JoyButtons are one way to press multiple buttons simultaneously. Physical game controllers allow simultaneous presses by different fingers. A touchscreen device is limited to front facing touchscreens which make simultaneous button pressing a real challenge.

Thus, JoyButtons are here. The user uses one thumb and can active multiple buttons simultaneously, just not in all possible combinations.
There are any number of buttons outside a center button. Like a virtual joystick, the user can move their thumb around the two dimensions.
If the thumb is pressing over the center area, the reported presses are sent back to the listener. The center presses are customizable by the programmer.
If the thumb is pressing in the JoyButtons outside the center area, then presses are reported for one or two adjacent buttons. This is also customizable.

# UseCases:
- activate one button, two buttons, or all buttons simultaneously with a single thumb or finger
- press and hold and callback at regular intervals the pressed buttons

Shoutout to [flutter_joystick](https://github.com/pavelzaichyk/flutter_joystick)
for code inspiration. [Gravitar](https://github.com/cybaker/Gravitar) also uses flutter_joystick for mobile.

# Customization

flutter_joybuttons uses by default 4 JoyButtonsButton or you can pass a list of one or more JoyButtonsButton. The example lets you change how many are used. There can be a large amount of buttons defined. Just note the more
buttons there are, the less angular difference between buttons. 2 to 5 buttons seem reasonable.

The example shows 4 buttons setup. The center area report all 4 buttons when pressed. The outer buttons
can activate simultaneously with an adjacent button or alone. In the example, pressing
the outer area and sweeping around 360 degrees will activate 1 or 2 buttons simultaneously, while moving to the 
center button will activate all buttons. You can define which buttons are reported when pressing the center - not all buttons must activate.

Between the outer buttons, the area between buttons that allows multiple button activation is customizeable by simultaneousOverlapScale. A value of 0.0 means no overlap area so only single buttons are activated while pressing in the outer area. A value of 1.0 means that the overlap is 100% into the adjacent buttons, so there are always multiple activations while pressing in the outer area. The default value is 0.4.

Center button scale is the size of the center 

## API Customizations
- buttonWidgets: the List<Widget> defining each button. Button widget can be custom - background color, shape, size, and text, any Flutter UI widget.
- simultaneousOverlapScale from 0.0 (alone) to 1.0 (always with an adjacent) or alone and with an adjacent (default of about 0.4)
- centerButtonScale: from 0.0 to 1.0, the relative size of the center circle defining the center press area. 1.0 covers all the buttons.
- centerButtonOutput: List<int> defines what to report when the center button is pressed. The integers represent the position of buttonWidgets pressed.
