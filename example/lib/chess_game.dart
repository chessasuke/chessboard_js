import 'package:flutter/material.dart';
import 'package:chessboard_js/chessboard_js.dart';

class ChessGame extends StatelessWidget {
  final ChessboardController controller = ChessboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Theme(
        data: ThemeData.dark(),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ChessBoard(
                size: 500,
                controller: controller,
              ),
            ),
            /// show last move
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder<MoveHistoryModel>(
                builder: (BuildContext context, history, Widget? child) {
                  if (history.moves.isNotEmpty)
                    return Text(history.moves.last.move, style: TextStyle(color: Colors.white));
                  else {
                    return Text('Empty Moves', style: TextStyle(color: Colors.white));
                  }
                },
                valueListenable: controller.moveHistoryNotifier,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
