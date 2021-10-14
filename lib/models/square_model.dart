import 'package:chessjs/pieces.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// representation of an square in the board
/// has an [squareName] and [squarePiece] which can be null
/// if there is no piece on that square.

class SquareModel extends Equatable {
  SquareModel({
    this.squarePiece,
    required this.squareName,
  });

  final String squareName;
  late final Piece? squarePiece;

  SquareModel copyWith({required Piece? squareState}) {
    return SquareModel(
      squarePiece: squareState,
      squareName: this.squareName,
    );
  }

  @override
  List<Object?> get props => [squareName, squarePiece];
}


/// Notifier for updates on the state ([squarePiece]) of the respective square.
/// This approach can target specific squares, and avoids rebuilding the whole board
class SquareNotifier extends ValueNotifier<SquareModel> {
  SquareNotifier(value) : super(value);

  void setSquareState({Piece? newState}) {
    value = value.copyWith(squareState: newState);
    notifyListeners();
  }
}
