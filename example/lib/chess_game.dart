import 'package:chessboard_js/notation/notation.dart';
import 'package:chessboard_js/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:chessboard_js/chessboard_js.dart';

class ChessGame extends StatelessWidget {
  final ChessboardController controller = ChessboardController();

  final ValueNotifier<bool> flipBoard = ValueNotifier(true);

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
                whiteTowardUser: flipBoard,
              ),
            ),

            /// show last move
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Notation(
                        backgroundColor: Colors.black,
                        style: TextStyle(color: Colors.white),
                        moveHistoryNotifier: controller.moveHistoryNotifier,
                      )),
                  SizedBox(
                      width: 125,
                      height: 60,
                      child: Center(
                          child: Row(
                        children: [
                          Tooltip(
                            message: 'Flip board',
                            child: InkWell(
                              onTap: () => flipBoard.value = !flipBoard.value,
                              child: Icon(Icons.flip_camera_android),
                            ),
                          ),
                          Tooltip(
                            message: 'Enable/Disable moves',
                            child: InkWell(
                              onTap: () => controller.toggleMovesEnabled(),
                              child: Icon(Icons.block),
                            ),
                          ),
                        ],
                      ))),
                  SizedBox(
                      width: 125,
                      height: 60,
                      child: Center(
                          child: Row(
                        children: [
                          Tooltip(
                            message:
                                'PlayerMode.isBlack - allow only black moves',
                            child: InkWell(
                              onTap: () =>
                                  controller.setPlayerMode(PlayerMode.isBlack),
                              child: Icon(Icons.dark_mode_outlined),
                            ),
                          ),
                          Tooltip(
                            message: 'PlayerMode.any - allow any color moves',
                            child: InkWell(
                              onTap: () =>
                                  controller.setPlayerMode(PlayerMode.any),
                              child: Icon(
                                Icons.light_mode_sharp,
                              ),
                            ),
                          )
                        ],
                      )))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
