import '../utils/utils.dart';
import 'package:flutter/scheduler.dart';
import 'notation_widgets.dart';
import '../models/move_history.dart';
import 'package:flutter/material.dart';

/// Panel to display chessboard_notation
class Notation extends StatelessWidget {
  Notation({
    this.notationHeight = 200,
    this.notationWidth = 125,
    this.notationTileHeight = 30,
    this.notationMoveWidth = 50,
    this.notationIndexWidth = 25,
     this.style,
     this.backgroundColor,
    required this.moveHistoryNotifier,
  });

  /// height of notation box
  final double notationHeight;

  /// width of notation box
  final double notationWidth;

  /// height of notation tile row
  final double notationTileHeight;

  /// width of a half move on the notation tile row
  final double notationMoveWidth;

  /// width of the move number on the notation tile row
  final double notationIndexWidth;

  /// background color
  final Color? backgroundColor;

  /// text style of notation
  final TextStyle? style;

  /// move history model notifier
  final MoveHistoryNotifier moveHistoryNotifier;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MoveHistoryModel>(
        valueListenable: moveHistoryNotifier,
        builder: (context, history, child) {
          /// if run out of space start scrolling to the bottom
          if ((notationTileHeight * (history.moves.length / 2).ceil()) >=
              notationHeight) {
            final scheduler = SchedulerBinding.instance;
            if (scheduler != null) {
              scheduler.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  print('scroll');
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.elasticOut,
                  );
                }
              });
            }
          }

          return Container(
            decoration: BoxDecoration(
                color: backgroundColor ?? Theme.of(context).backgroundColor,
                border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            width: notationWidth,
            height: notationHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: (history.moves.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: notationTileHeight,
                          width: notationWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NotationTileIndex(
                                indexWidth: notationIndexWidth,
                                moveNumber: index + 1,
                                style: style ?? TextStyle(),
                              ),
                              NotationTileMove(
                                width: notationMoveWidth,
                                style: style ?? TextStyle(),
                                move: history.moves[index * 2].move,
                              ),
                              if ((index * 2 + 1) < history.moves.length)
                                NotationTileMove(
                                  width: notationMoveWidth,
                                  style: style ?? TextStyle(),
                                  move: history.moves[index * 2 + 1].move,
                                )
                              else
                                SizedBox(width: notationMoveWidth)
                            ],
                          ),
                        );
                      }),
                ),
                if (history.result != ChessResult.playing)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: NotationTileResult(
                      result: getResultFromEnum(history.result),
                      style: style ?? TextStyle(),
                    ),
                  )
              ],
            ),
          );
        });
  }
}
