import 'package:chessboard_js/models/move_model.dart';
import 'package:flutter/cupertino.dart';

enum ChessResult { draw, white, black, none }

/// will be change to support variations
class MoveHistoryModel {
  MoveHistoryModel();

  /// whole move history
  final List<NodeMoveModel> _moves = [];

  /// current move display on the board
  int _currentIndex = 0;

  ChessResult _result = ChessResult.none;

  List<NodeMoveModel> get moves => _moves;
  int get currentIndex => _currentIndex;
  ChessResult get result => _result;

  set currentIndex(newIndex) {
    _currentIndex = newIndex;
  }

  set result(result) {
    _result = result;
  }
}

class MoveHistoryNotifier extends ValueNotifier<MoveHistoryModel> {
  MoveHistoryNotifier([MoveHistoryModel? value])
      : super(value ?? MoveHistoryModel());

  /// go forward
  void goForward() {
    if (value._currentIndex < value._moves.length) {
      value._currentIndex = value._currentIndex + 1;
      notifyListeners();
    }
  }

  /// go back
  void goBackward() {
    if (value._currentIndex > 0) {
      value._currentIndex = value._currentIndex - 1;
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
