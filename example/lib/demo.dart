import 'package:flutter/material.dart';
import 'package:chessboard_js/chessboard_js.dart';

class Demo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChessGame(),
    );
  }
}

class ChessGame extends StatefulWidget {
  @override
  _ChessGameState createState() => _ChessGameState();
}

class _ChessGameState extends State<ChessGame> {

final initialPosition = 'rnbqkb1r/ppp1pppp/5n2/3p4/5P2/4P3/PPPP2PP/RNBQKBNR w KQkq - 1 3';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!
          .focusInDirection(TraversalDirection.down),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Theme(
          data: ThemeData.dark(),
          child: Row(
            children: [
              ChessBoard(
                size: 400,
                controller: ChessboardController(),
              ),
              ChessBoard(
                size: 400,
                controller: ChessboardController(
                  startingPosition: initialPosition
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
