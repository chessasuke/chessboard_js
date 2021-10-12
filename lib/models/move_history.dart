import 'package:chessboard_js/models/move_model.dart';
import 'package:flutter/cupertino.dart';

/// will be change to support variations

class MoveHistoryModel{
  MoveHistoryModel();

  /// whole move history
  final List<NodeMoveModel> _moves = [];

  /// current move display on the board
  int _currentIndex = 0;

  List<NodeMoveModel> get moves => _moves;
  int get currentIndex => _currentIndex;

  set currentIndex(newIndex) {
    _currentIndex = newIndex;
  }
}

class MoveHistoryNotifier extends ValueNotifier<MoveHistoryModel> {
  MoveHistoryNotifier([MoveHistoryModel? value])
      : super(value ?? MoveHistoryModel());

  /// go forward
  void goForward() {
    if (value._currentIndex < value._moves.length - 1) {
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
}
