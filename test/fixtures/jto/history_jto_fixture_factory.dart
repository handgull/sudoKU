import 'package:data_fixture_dart/data_fixture_dart.dart';
import 'package:sudoku/models/enums/difficulty.dart';
import 'package:sudoku/services/network/jto/history/history_jto.dart';

extension HistoryJTOFixture on HistoryJTO {
  static HistoryJTOFixtureFactory factory() => HistoryJTOFixtureFactory();
}

class HistoryJTOFixtureFactory extends JsonFixtureFactory<HistoryJTO> {
  @override
  FixtureDefinition<HistoryJTO> definition() => define(
    (faker) =>
        HistoryJTO(entries: HistoryEntryJTOFixture.factory().makeMany(5)),
  );

  @override
  JsonFixtureDefinition<HistoryJTO> jsonDefinition() =>
      defineJson((object) => {});
}

extension HistoryEntryJTOFixture on HistoryEntryJTO {
  static HistoryEntryJTOFixtureFactory factory() =>
      HistoryEntryJTOFixtureFactory();
}

class HistoryEntryJTOFixtureFactory
    extends JsonFixtureFactory<HistoryEntryJTO> {
  @override
  FixtureDefinition<HistoryEntryJTO> definition() => define(
    (faker) => HistoryEntryJTO(
      dateTime: faker.date.dateTime(),
      gameDuration: faker.randomGenerator.integer(100),
      difficulty: faker.randomGenerator.element(Difficulty.values),
    ),
  );

  @override
  JsonFixtureDefinition<HistoryEntryJTO> jsonDefinition() =>
      defineJson((object) => {});
}
