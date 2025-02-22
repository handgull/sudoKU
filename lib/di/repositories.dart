part of 'dependency_injector.dart';

final List<RepositoryProvider<dynamic>> _repositories = [
  RepositoryProvider<GameRepository>(
    create:
        (context) => GameRepositoryImpl(
          gameService: context.read(),
          sudokuCellMapper: context.read(),
          sudokuDataMapper: context.read(),
        ),
  ),
];
