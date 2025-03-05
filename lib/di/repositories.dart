part of 'dependency_injector.dart';

final List<RepositoryProvider<dynamic>> _repositories = [
  RepositoryProvider<GameRepository>(
    create: (context) => GameRepositoryImpl(
      logger: context.read(),
      gameService: context.read(),
      sudokuCellMapper: context.read(),
      sudokuDataMapper: context.read(),
    ),
  ),
  RepositoryProvider<GameTimerRepository>(
    create: (context) => GameTimerRepositoryImpl(
      logger: context.read(),
      gameTimerService: context.read(),
    ),
  ),
];
