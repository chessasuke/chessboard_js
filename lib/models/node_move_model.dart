import 'package:flutter/material.dart';

class NodeMoveModel {
  NodeMoveModel({required this.move, this.childrenMoves});

  final String move;
  final List<String>? childrenMoves;

  factory NodeMoveModel.fromJson(String data) => NodeMoveModel(move: data);

  NodeMoveModel copyWith({
    String? move,
    List<String>? childrenMoves,
  }) =>
      NodeMoveModel(
        move: move ?? this.move,
        childrenMoves: childrenMoves ?? this.childrenMoves,
      );
}

/// notification send from the [SquareUI] when user makes a move.
/// It's caught by the [ChessboardUI] which updates
/// the [chessjs] in the [controller] with the new move.
class MoveNotification extends Notification {
  MoveNotification({required this.move});
  final Map<String, String> move;
}
