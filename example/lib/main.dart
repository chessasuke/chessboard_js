import 'package:flutter/material.dart';

import 'demo.dart';


/// This example shows how to use the chessboard widget.
/// The property [_isUserWhite] is set to null, so both sides
/// can move, to only play with white we can set this property to true
/// and pass the black move programmatically using the controller. The
/// [enableKeyboard] property is set to true so, the game
/// can also be iterated with the right/left arrow keyboards

void main() {
  runApp(Demo());
}
