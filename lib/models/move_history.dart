import 'package:chessboard_js/models/move_model.dart';
import 'package:flutter/cupertino.dart';

/// will be change to support variations

class MoveHistoryModel {
  MoveHistoryModel();

  /// whole move history
  List<NodeMoveModel> _history = [];

  /// current move display on the board
  int _currentIndex = 0;

  List<NodeMoveModel> get history => _history;
  int get currentIndex => _currentIndex;

  set currentIndex(newIndex) {
    _currentIndex = newIndex;
  }
}

class MoveHistoryNotifier extends ValueNotifier<MoveHistoryModel> {
  MoveHistoryNotifier([MoveHistoryModel? value]) : super(value ?? MoveHistoryModel());

  /// go forward
  void goForward(NodeMoveModel move) {
    if (value._currentIndex < value._history.length - 1)
      value._currentIndex = value._currentIndex + 1;
  }

  /// go back
  void goBackward(NodeMoveModel move) {
    if (value._currentIndex > 0) value._currentIndex = value._currentIndex - 1;
  }

  /// add a move to the move history
  void addMoveNode(NodeMoveModel move) {
    value._history.add(move);
  }

  /// remove a move from the move history
  void removeMoveNode() {
    if (value._history.isNotEmpty)
      value._history.removeLast();
  }
}
