import 'package:flutter/cupertino.dart';

import 'square_model.dart';
import '../utils/constants.dart';

/// List of each square and their states
class ChessboardModel {
  ChessboardModel({
    this.enableMoves = true,
    this.whiteTowardUser = true,
    this.playerMode = PlayerMode.any,
    List<SquareNotifier>? board,
  }) {
    /// Initialize square names for the chessboard
    /// The state of the square would be set by the controller
    if (board != null) {
      this.squares = board;
    } else {
      final temp = <SquareNotifier>[];
      for (final square in squareList.expand((element) => element)) {
        temp.add(SquareNotifier(SquareModel(squareName: square)));
      }
      squares = temp;
    }
  }

/// list of states for the squares of this board
  late final List<SquareNotifier> squares;

  /// if move on the board are locked
  bool enableMoves;

  /// Player mode, used by controller to allow moves by one side
  PlayerMode playerMode;

  /// if white is toward the user
  bool whiteTowardUser;
  ValueNotifier<bool> get flipBoardNotifier => ValueNotifier(whiteTowardUser);
}
