import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/services/game_timer_service.dart';

void main() {
  late GameTimerService service;
  late int randomInitialSeconds;

  setUp(() {
    // here i set the ticks for blazing fast tests
    service = GameTimerServiceImpl(const Duration(milliseconds: 50));
    randomInitialSeconds = faker.randomGenerator.integer(100, min: 1);
  });

  tearDown(() async {
    await service.close();
  });

  group('when the method start is called', () {
    test('if i give a paramether the timer should start from that number', () {
      service.start(randomInitialSeconds);

      expect(service.paused, isFalse);
      expect(service.timer.take(1), emitsInOrder([randomInitialSeconds]));
    });

    test('the values should increment', () {
      service.start();

      expect(service.paused, isFalse);
      expect(service.timer.take(3), emitsInOrder([0, 1, 2]));
    });

    test('initial seconds should be greater than 0', () {
      try {
        service.start(-randomInitialSeconds);
        expect(true, isFalse, reason: 'Expecting an exception!');
        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        expect(error, isInstanceOf<RangeError>());
      }
    });
  });

  group('when the method togglePause is called', () {
    test('the timer should stop and restart', () {
      service.start();

      expect(service.paused, isFalse);
      expect(service.timer.take(1), emitsInOrder([isA<int>()]));

      service.togglePause();

      expect(service.paused, isTrue);

      service.togglePause();

      expect(service.paused, isFalse);
      expect(service.timer.take(1), emitsInOrder([isA<int>()]));
    });
  });

  group('when the method close is called', () {
    test('the timer status should be paused', () async {
      service.start();
      await service.close();

      expect(service.paused, isTrue);
    });
  });
}
