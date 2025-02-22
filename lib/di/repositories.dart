part of 'dependency_injector.dart';

final List<RepositoryProvider<dynamic>> _repositories = [
  RepositoryProvider<GameRepository>(
    create:
        (context) => GameRepositoryImpl(
          gameService: context.read(),
          sudokuDataMapper: context.read(),
        ),
  ),
];
