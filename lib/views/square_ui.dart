import '../models/move_model.dart';
import '../models/square_model.dart';
import '../utils/constants.dart';
import 'package:chessjs/chessjs.dart' as chessjs;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../controller/controller.dart';
import '../utils/utils.dart';

typedef Null MoveCallback(Map<String, String> moveNotation);

class SquareUI extends StatelessWidget {
  const SquareUI({
    Key? key,
    required this.squareName,
    required this.squareNotifier,
    required this.size,
    required this.controller,
    required this.onMove,
  }) : super(key: key);

  final ChessboardController controller;
  final String squareName;
  final ValueListenable<SquareModel> squareNotifier;
  final double size;
  final MoveCallback? onMove;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SquareModel>(
      valueListenable: squareNotifier,
      builder: (context, square, _) {
        return Expanded(
            flex: 1,
            child: DragTarget(
              builder: (context, accepted, rejected) {
                /// get the piece on the square
                final state = square.squarePiece;
                return state != null
                    ?

                    /// if there is a piece on the square, returns a draggable image of the piece
                    Draggable(
                        child:
                            getImageToDisplay(size: size, squareState: state),
                        feedback: getImageToDisplay(
                          size: (1.15 * size),
                          squareState: state,
                        ),

                        /// Data to be dropped in this drag target: the squareName where
                        /// the move originated, and the type and color of the piece that was
                        /// on that square
                        data: [
                          squareName,
                          state.type.toUpperCase(),
                          state.color,
                        ],
                      )

                    /// Changing here Container for SizedBox wont allow to make a move
                    /// Container expands to the child size, SizedBox wont, so the drag target
                    /// property will be on a 0 size widget and wont work
                    : Container();

                /// accepted information about the move
                /// the square from where the move originated is moveInfo[0],
                /// the type of piece is moveInfo[1], and the color is moveInfo[2]
              },
              onWillAccept: (List? moveInfo) {
                if (moveInfo != null) {
                  /// If dragging and dropping in same place return false
                  if (moveInfo[0] != squareName) {
                    /// moveInfo should have 3 items
                    if (moveInfo.length == 3) {
                      /// Accept only if the game turn is right and the enableUserMoves is true
                      if (moveInfo[2] == controller.logic.turn &&
                          controller.board.enableMoves) {
                        /// control who are allowed to move with the isUserWhite property
                        if (controller.board.playerMode == PlayerMode.any ||
                            (controller.board.playerMode == PlayerMode.isWhite &&
                                controller.logic.turn == chessjs.WHITE) ||
                            (controller.board.playerMode == PlayerMode.isBlack &&
                                controller.logic.turn == chessjs.BLACK)) {
                          /// DO NOT ACCEPT ILLEGAL MOVES
                          final legalMoves = controller.logic.generateMoves();
                          legalMoves.removeWhere((move) {
                            /// if the [from] move field is different, discard move from the legal moves
                            if (move.fromAlgebraic != moveInfo[0]) {
                              return true;
                            } else {
                              /// if [to] move part is different, also discard move
                              if (move.toAlgebraic != squareName) {
                                return true;
                              } else {
                                return false;
                              }
                            }
                          });

                          /// If there were not matches of intended move don't accept
                          if (legalMoves.isEmpty) {
                            return false;
                          } else {
                            return true;
                          }
                        }

                        /// incorrect turn to play
                        else {
                          return false;
                        }
                      }

                      /// moves not enable
                      else {
                        return false;
                      }
                    }

                    /// missing move information
                    else {
                      return false;
                    }
                  } else
                    return false;
                } else
                  return false;
              },
              onAccept: (List moveInfo) async {
                Map<String, String>? move;

                /// handle promotion
                if (moveInfo[1] == "P" &&
                    ((moveInfo[0][1] == "7" &&
                            squareName[1] == "8" &&
                            moveInfo[2] == chessjs.WHITE) ||
                        (moveInfo[0][1] == "2" &&
                            squareName[1] == "1" &&
                            moveInfo[2] == chessjs.BLACK))) {
                  /// get the promotion piece selected by the user from the dialog
                  String? val =
                      await promotionDialog(context, controller.logic.turn);
                  if (val == 'n' || val == 'b' || val == 'r' || val == 'q') {
                    /// move to return in case of promotion
                    move = {
                      "from": moveInfo[0],
                      "to": squareName,
                      "promotion": val!,
                    };
                    /// dispatch a move notification to the controller in the chessboard
                    /// The controller will make the move internally and will notify
                    /// the corespondent square listeners
                    MoveNotification(move: move).dispatch(context);
                    if (onMove != null) {
                      onMove!(move);
                    }
                  }
                } else {
                  move = {"from": moveInfo[0], "to": squareName};
                  /// dispatch a move notification to the controller in the chessboard
                  /// The controller will make the move internally and will notify
                  /// the corespondent square listeners
                  MoveNotification(move: move).dispatch(context);
                  if (onMove != null) {
                    onMove!(move);
                  }
                }
              },
            ));
      },
    );
  }
}
