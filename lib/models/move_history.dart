import 'package:chessboard_js/models/move_model.dart';
import 'package:flutter/cupertino.dart';

enum ChessResult { draw, white, black, none, playing }

/// will be change to support variations
class MoveHistoryModel {
  MoveHistoryModel({
    this.currentIndex = 0,
    this.result = ChessResult.playing,
  });

  final List<NodeMoveModel> _moves = [];
  int currentIndex;
  ChessResult result;
  List<NodeMoveModel> get moves => _moves;
}

class MoveHistoryNotifier extends ValueNotifier<MoveHistoryModel> {
  MoveHistoryNotifier([MoveHistoryModel? value])
      : super(value ?? MoveHistoryModel());

  /// go forward
  void goForward() {
    if (value.currentIndex < value._moves.length) {
      value.currentIndex = value.currentIndex + 1;
      notifyListeners();
    }
  }

  /// go back
  void goBackward() {
    if (value.currentIndex > 0) {
      value.currentIndex = value.currentIndex - 1;
      notifyListeners();
    }
  }

  /// add a move to the move history
  void addMoveNode(NodeMoveModel move) {
    value._moves.add(move);
  }

  /// remove a move from the move history
  void removeMoveNode() {
    if (value._moves.isNotEmpty) value._moves.removeLast();
  }

  /// add a move to the move history
  void setResult(ChessResult result) {
    value.result = result;
    notifyListeners();
  }
}
