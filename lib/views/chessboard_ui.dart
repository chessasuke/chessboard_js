import 'package:audioplayers/audioplayers.dart';
import 'package:chessboard_js/models/move_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'square_ui.dart';
import '../controller/controller.dart';
import '../utils/constants.dart';

class ChessBoard extends StatelessWidget {
  ChessBoard({
    required this.size,
    required this.controller,
    this.boardType = BoardType.brown,
  });

  final ChessboardController controller;
  final double size;
  final BoardType boardType;
  final AudioPlayer audioPlayer = AudioPlayer();

  playLocal() async {
    await audioPlayer.play(moveSoundPath, isLocal: true);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: size,
          height: size,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: size * 0.90,
                  height: size * 0.90,
                  child: getBoardImage(boardType),
                ),
              ),

              /// the pieces on the chessboard
              /// meaning, state of each square
              Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    width: size * 0.90,
                    height: size * 0.90,
                    child: buildChessBoard(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the board, drawing each square
  Widget buildChessBoard() {
    final pieceSize = size / 8;
    return NotificationListener<MoveNotification>(
      onNotification: (moveNotifier) {
        controller.makePrettyMove(moveNotifier.move);
        return true;
      },
      child: Column(children: [
        if (controller.board.whiteTowardUser)
          for (final row in squareList)
            Expanded(
              flex: 1,
              child: Row(
                children: row.map((squareName) {
                  return SquareUI(
                    key: ValueKey(squareName),
                    squareNotifier: controller.getSquareNotifier(squareName),
                    squareName: squareName,
                    size: pieceSize,
                    controller: controller,
                    onMove: (move) {
                      playLocal();
                    },
                  );
                }).toList(),
              ),
            )
        else
          for (final row in squareList.reversed)
            Expanded(
              flex: 1,
              child: Row(
                children: row.reversed
                    .map((squareName) => SquareUI(
                          key: ValueKey(squareName),
                          squareNotifier:
                              controller.getSquareNotifier(squareName),
                          squareName: squareName,
                          size: pieceSize,
                          controller: controller,
                          onMove: (move) {
                            playLocal();
                          },
                        ))
                    .toList(),
              ),
            )
      ]),
    );
  }

  /// Returns the board image
  Image? getBoardImage(BoardType boardType) {
    switch (boardType) {
      case BoardType.brown:
        return Image.asset(
          'packages/chessboard_js/images/brown_board.png',
          fit: BoxFit.contain,
        );
      case BoardType.darkBrown:
        return Image.asset(
          "packages/chessboard_js/images/dark_brown_board.png",
          fit: BoxFit.cover,
        );
      case BoardType.green:
        return Image.asset(
          "packages/chessboard_js/images/green_board.png",
          fit: BoxFit.cover,
        );
      case BoardType.orange:
        return Image.asset(
          "packages/chessboard_js/images/orange_board.png",
          fit: BoxFit.cover,
        );
      default:
        return null;
    }
  }
}
