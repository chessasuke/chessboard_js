import 'package:flutter/material.dart';
import 'chess_game.dart';


/// This example shows how to use the chessboard widget.
/// The property [_isUserWhite] is set to [UserPlayer.any], so both sides
/// can move, to only play with white we can set this property to [UserPlayer.isWhite]
/// and pass the black move programmatically using the controller. The
/// [enableKeyboard] property is set to true so, the game
/// can also be iterated with the right/left arrow keyboards

void main() {
  runApp(MaterialApp(home: ChessGame()));
}
