import 'package:chessboard_js/models/move_model.dart';
import 'package:chessboard_js/utils/constants.dart';
import '../models/square_model.dart';
import '../models/move_history.dart';
import 'package:chessjs/chessjs.dart' as chessjs;
import 'package:chessjs/pieces.dart';
import '../models/chessboard_model.dart';

typedef MoveCallback(Map<dynamic, dynamic> moveNotation);
typedef CheckMateCallback(chessjs.Color color);
typedef CheckCallback(chessjs.Color color);
typedef DrawCallback();
typedef ResignCallback(bool result);
typedef OfferDrawCallback();

class ChessboardController {
  ChessboardController({
    this.onMove,
    this.onDraw,
    this.onCheck,
    this.onCheckMate,
    this.onResign,
    this.onOfferDraw,
    String? startingPosition,
  }) {
    _logic = chessjs.Chess();

    if (startingPosition != null) {
      final validateFen = chessjs.Chess.validateFen(startingPosition);
      if (validateFen['valid'] == true) {
        _logic.load(startingPosition);
      } else {
        assert(validateFen['valid'] != true,
            '[Error] fen is not valid: ${validateFen['error']}');
      }
    }
    buildBoard();
  }

  /// private fields
  /// model of the board, store the current state of each square
  ChessboardModel _chessboard = ChessboardModel();

  /// the actual logic
  late final chessjs.Chess _logic;

  /// keep track of the move history for the chessboard_notation
  final MoveHistoryNotifier _moveHistoryNotifier = MoveHistoryNotifier();

  /// callbacks
  MoveCallback? onMove;
  CheckMateCallback? onCheckMate;
  CheckCallback? onCheck;
  DrawCallback? onDraw;
  ResignCallback? onResign;
  OfferDrawCallback? onOfferDraw;

  ChessboardModel get board => _chessboard;
  MoveHistoryNotifier get moveHistoryNotifier => _moveHistoryNotifier;
  chessjs.Chess get logic => _logic;

  /// build the board according to the logic state
  void buildBoard() {
    for (final square in _chessboard.squares) {
      Piece? newState = _logic.get(square.value.squareName);
      if (newState != null) {
        updateSquare(square.value.squareName);
      }
    }
  }

  toggleMovesEnabled() {
    _chessboard.enableMoves = !_chessboard.enableMoves;
  }

  flipBoard() {
    _chessboard.whiteTowardUser = !_chessboard.whiteTowardUser;
  }

  setPlayerMode(PlayerMode mode) {
    _chessboard.playerMode = mode;
  }

  /// get history of moves from logic
  List<String> getSanHistory() {
    List<String> history = _logic.getHistorySAN();
    return history;
  }

  /// Get history of game (moves) with details for each move.
  /// Returns a List<Map>
  List<Map> getVerboseHistory() {
    List<Map> history = _logic.getHistoryVerbose();
    return history;
  }

  /// make the actual logic move, used by other functions
  void _makeMove(chessjs.Move move) {
    _logic.makeMove(move);

    /// update history move
    _moveHistoryNotifier
        .addMoveNode(NodeMoveModel(move: _logic.getHistorySAN().last));
    _moveHistoryNotifier.goForward();
  }

  /// undo a logical move and updates the board
  void undoMove() {
    final move = _logic.undoMove();

    /// update history move
    _moveHistoryNotifier.removeMoveNode();
    _moveHistoryNotifier.goBackward();

    /// update board
    if (move != null) _updateBoardAfterMove(move);
  }

  /// make move without calling the controller
  /// callbacks. Others make move methods, call
  /// [refreshBoard] at the end, triggering callbacks
  bool makeMoveWithoutCallback(String move) {
    chessjs.Move? moveObj;
    final moves = _logic.generateMoves();
    for (int i = 0; i < moves.length; i++) {
      if (move == _logic.moveToSan(moves[i])) {
        moveObj = moves[i];
        break;
      }
    }
    if (moveObj != null) {
      _makeMove(moveObj);
      _updateBoardAfterMove(moveObj);
      return true;
    } else {
      return false;
    }
  }

  /// returns true if successfully make the move
  /// otherwise false
  bool makeSanMove(String move) {
    chessjs.Move? moveObj;
    final moves = _logic.generateMoves();
    for (int i = 0; i < moves.length; i++) {
      if (move == _logic.moveToSan(moves[i])) {
        moveObj = moves[i];
        break;
      }
    }
    if (moveObj != null) {
      _makeMove(moveObj);
      _updateBoardAfterMove(moveObj);
      refreshBoard();
      return true;
    } else {
      return false;
    }
  }

  /// Attempt to make a move in the board if successfully made the move,
  /// return true and update the respective squares, otherwise return false.
  bool makePrettyMove(Map<String, String> move) {
    final builtMove = _buildPrettyMove(move);
    if (builtMove != null) {
      _makeMove(builtMove);
      _updateBoardAfterMove(builtMove);
      refreshBoard();
      return true;
    } else {
      return false;
    }
  }

  /// build a [Move] from a Map
  chessjs.Move? _buildPrettyMove(Map<String, String> move) {
    final String? promotionStr = move['promotion'];
    final PieceType? promotionPiece;
    switch (promotionStr) {
      case 'n':
        promotionPiece = PieceType.KNIGHT;
        break;
      case 'b':
        promotionPiece = PieceType.BISHOP;
        break;
      case 'r':
        promotionPiece = PieceType.ROOK;
        break;
      case 'q':
        promotionPiece = PieceType.QUEEN;
        break;
      default:
        promotionPiece = null;
    }

    final possibleMoves = _logic.generateMoves();
    chessjs.Move? builtMove;
    possibleMoves.forEach((possibleMove) {
      if (possibleMove.fromAlgebraic == move['from'] &&
          possibleMove.toAlgebraic == move['to'] &&
          possibleMove.promotion == promotionPiece) {
        builtMove = possibleMove;
      }
    });

    if (builtMove == null) {
      return null;
    } else
      return builtMove;
  }

  SquareNotifier getSquareNotifier(String squareName) {
    final index = _chessboard.squares
        .indexWhere((element) => element.value.squareName == squareName);
    return _chessboard.squares.elementAt(index);
  }

  /// update state of a specific square provided
  /// its squareName and the state from the logic.
  updateSquare(String squareName) {
    final newState = _logic.get(squareName);
    final index = _chessboard.squares
        .indexWhere((element) => element.value.squareName == squareName);
    _chessboard.squares[index].setSquareState(newState: newState);
  }

  /// after playing, update squares involved in the move
  _updateBoardAfterMove(chessjs.Move move) {
    int flags = move.flags;

    /// update square from where the move originated
    updateSquare(move.fromAlgebraic);

    /// if castling, update squares associated
    if ((flags & chessjs.BITS_KSIDE_CASTLE) != 0) {
      if (move.color == chessjs.WHITE) {
        updateSquare('h1');
        updateSquare('g1');
        updateSquare('f1');
      } else {
        updateSquare('h8');
        updateSquare('g8');
        updateSquare('f8');
      }
    } else if ((flags & chessjs.BITS_QSIDE_CASTLE) != 0) {
      if (move.color == chessjs.WHITE) {
        updateSquare('a1');
        updateSquare('c1');
        updateSquare('d1');
      } else {
        updateSquare('a8');
        updateSquare('c8');
        updateSquare('d8');
      }
    }

    /// if en passant, update squares associated
    else if ((flags & (chessjs.BITS_EP_CAPTURE)) != 0) {
      late final squareToUpdate;

      String to = move.toAlgebraic;
      if (move.color == chessjs.WHITE) {
        squareToUpdate = to.replaceAll('6', '5');
      } else if (move.color == chessjs.BLACK) {
        squareToUpdate = to.replaceAll('3', '4');
      }
      updateSquare(squareToUpdate);
      updateSquare(move.fromAlgebraic);
      updateSquare(move.toAlgebraic);
    }

    /// otherwise just update the square where the move finished
    else {
      updateSquare(move.toAlgebraic);
    }
  }

  /// use [refreshBoard] to force controller callbacks
  /// to run, for example onMove, onCheck...
  void refreshBoard() {
    if (logic.inCheckmate && onCheckMate != null) {
      onCheckMate!(logic.turn == chessjs.WHITE ? chessjs.WHITE : chessjs.BLACK);
    } else if ((logic.inDraw ||
            logic.inStalemate ||
            logic.inThreefoldRepetition ||
            logic.insufficientMaterial) &&
        onDraw != null) {
      onDraw!();
    } else if (logic.inCheck && onCheck != null) {
      onCheck!(logic.turn == chessjs.WHITE ? chessjs.WHITE : chessjs.BLACK);
    } else {
      if (onMove != null) onMove!(logic.getHistoryVerbose().last);
    }
  }
}
