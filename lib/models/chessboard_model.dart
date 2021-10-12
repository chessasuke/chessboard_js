import 'square_model.dart';
import '../utils/constants.dart';

/// List of each square and their states

class ChessboardModel //extends ChangeNotifier
{
  ChessboardModel() {
    /// Initialize square names for the chessboard
    /// The state of the square would be set by the controller
    List<SquareNotifier> board = [];
    squareList.expand((element) => element).forEach((square) {
      board.add(SquareNotifier(SquareModel(squareName: square)));
    });
    this._squares = board;
  }

  late final List<SquareNotifier> _squares;

  List<SquareNotifier> get squares => _squares;
}
