import 'package:chessboard_js/controller/controller.dart';
import 'package:chessjs/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chessboard_js/chessboard_js.dart';

void main() {
  group('Chessboard Controller', () {
    test('makeMoveSan', () {
      final ChessboardController controller = ChessboardController();
      controller.makeSanMove('e4');
      expect(controller.logic.getHistorySAN(), ['e4']);
    });

    test('makePrettyMove', () {
      final ChessboardController controller = ChessboardController();
      controller.makePrettyMove({'from': 'e2', 'to': 'e4'});
      expect(controller.logic.getHistoryVerbose(), [
        {
          'san': 'e4',
          'to': 'e4',
          'from': 'e2',
          'captured': null,
          'color': Color.WHITE,
          'flags': 'b',
        }
      ]);
    });

    test('en passant & capture', () {
      final ChessboardController controller = ChessboardController();
      controller.makeSanMove('e4');
      controller.makeSanMove('e5');
      controller.makeSanMove('f4');
      controller.makeSanMove('exf4');
      controller.makeSanMove('g4');
      controller.makeSanMove('fxg3');

      print(controller.logic.get('g3').runtimeType);

      expect(controller.logic.get('g4'), null);
      expect(controller.logic.get('f4'), null);
      expect(controller.logic.generateFen(),
          'rnbqkbnr/pppp1ppp/8/8/4P3/6p1/PPPP3P/RNBQKBNR w KQkq - 0 4');
    });

    test('en passant & capture', () {
      final ChessboardController controller = ChessboardController();
      controller.makeSanMove('e4');
      controller.makeSanMove('e5');
      controller.makeSanMove('f4');
      controller.makeSanMove('exf4');
      controller.makeSanMove('g4');
      controller.makeSanMove('fxg3');

      print(controller.logic.get('g3').runtimeType);

      expect(controller.logic.get('g4'), null);
      expect(controller.logic.get('f4'), null);
      expect(controller.logic.generateFen(),
          'rnbqkbnr/pppp1ppp/8/8/4P3/6p1/PPPP3P/RNBQKBNR w KQkq - 0 4');
    });
  });
}
