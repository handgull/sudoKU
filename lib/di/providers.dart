part of 'dependency_injector.dart';

final List<SingleChildWidget> _providers = [
  Provider<GameService>(create: (context) => const GameServiceImpl()),
  Provider<GameTimerService>(create: (context) => GameTimerServiceImpl()),
];
