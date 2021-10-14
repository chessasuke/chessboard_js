import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class NotationTileMove extends StatelessWidget {
  NotationTileMove({
    Key? key,
    required this.style,
    required this.move,
    required this.width,
  }) : super(key: key);

  final TextStyle style;
  final String move;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Center(child: Text(move, style: style)),
    );
  }
}

class NotationTileIndex extends StatelessWidget {
  const NotationTileIndex({
    Key? key,
    required this.moveNumber,
    required this.style,
    required this.indexWidth,
  }) : super(key: key);

  final int moveNumber;
  final TextStyle style;
  final double indexWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: indexWidth,
        child: Center(child: Text('$moveNumber', style: style)));
  }
}

/// to display the result of the game
class NotationTileResult extends StatelessWidget {
  const NotationTileResult({
    required this.result,
    required this.style,
  });
  final String result;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(result, style: style),
    );
  }
}
