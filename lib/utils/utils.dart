import 'package:chessboard_js/chessboard_js.dart';
import 'package:chessjs/pieces.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:chessjs/chessjs.dart' as chessjs;
import '../chess_vectors/chess_vectors_flutter.dart';

final goBackKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowLeft,
);
final goForwardKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowRight,
);

class GoBackIntent extends Intent {}

class GoForwardIntent extends Intent {}

class MakeMoveShortcut extends StatelessWidget {
  const MakeMoveShortcut({
    required this.isEnabled,
    required this.child,
    required this.onGoBack,
    required this.onGoForward,
  });
  final bool isEnabled;
  final Widget child;
  final VoidCallback onGoBack;
  final VoidCallback onGoForward;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      enabled: isEnabled,
      autofocus: true,
      shortcuts: {
        goBackKeySet: GoBackIntent(),
        goForwardKeySet: GoForwardIntent(),
      },
      actions: {
        GoBackIntent: CallbackAction(onInvoke: (e) => onGoBack.call()),
        GoForwardIntent: CallbackAction(onInvoke: (e) => onGoForward.call()),
      },
      child: child,
    );
  }
}

/// Show dialog when pawn reaches last square
Future<String?> promotionDialog(
    BuildContext context, chessjs.Color turn) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      final color = turn;
      return AlertDialog(
        title: Text('Choose promotion'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              child: color == chessjs.WHITE ? WhiteQueen() : BlackQueen(),
              onTap: () {
                Navigator.of(context).pop("q");
              },
            ),
            InkWell(
              child: color == chessjs.WHITE ? WhiteRook() : BlackRook(),
              onTap: () {
                Navigator.of(context).pop("r");
              },
            ),
            InkWell(
              child: color == chessjs.WHITE ? WhiteBishop() : BlackBishop(),
              onTap: () {
                Navigator.of(context).pop("b");
              },
            ),
            InkWell(
              child: color == chessjs.WHITE ? WhiteKnight() : BlackKnight(),
              onTap: () {
                Navigator.of(context).pop("n");
              },
            ),
          ],
        ),
      );
    },
  ).then((value) {
    return value;
  });
}

/// Get image to display on square
Widget getImageToDisplay({
  required double size,
  required Piece? squareState,
}) {
  Widget imageToDisplay = const SizedBox();

  if (squareState == null) {
    return imageToDisplay;
  }

  String piece = (squareState.color == chessjs.WHITE ? 'W' : 'B') +
      squareState.type.toUpperCase();

  switch (piece) {
    case "WP":
      imageToDisplay = WhitePawn(size: size);
      break;
    case "WR":
      imageToDisplay = WhiteRook(size: size);
      break;
    case "WN":
      imageToDisplay = WhiteKnight(size: size);
      break;
    case "WB":
      imageToDisplay = WhiteBishop(size: size);
      break;
    case "WQ":
      imageToDisplay = WhiteQueen(size: size);
      break;
    case "WK":
      imageToDisplay = WhiteKing(size: size);
      break;
    case "BP":
      imageToDisplay = BlackPawn(size: size);
      break;
    case "BR":
      imageToDisplay = BlackRook(size: size);
      break;
    case "BN":
      imageToDisplay = BlackKnight(size: size);
      break;
    case "BB":
      imageToDisplay = BlackBishop(size: size);
      break;
    case "BQ":
      imageToDisplay = BlackQueen(size: size);
      break;
    case "BK":
      imageToDisplay = BlackKing(size: size);
      break;
    default:
      imageToDisplay = const SizedBox();
  }

  return imageToDisplay;
}

String getResultFromEnum(ChessResult result) {
  switch (result) {
    case ChessResult.white:
      return '1-0';
    case ChessResult.black:
      return '1-0';
    case ChessResult.draw:
      return '1/2';
    default:
      return 'none';
  }
}
