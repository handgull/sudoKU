part of 'dependency_injector.dart';

final List<SingleChildWidget> _providers = [
  Provider<Talker>(
    create: (context) => Talker(),
  ),
  Provider<GameService>(create: (context) => const GameServiceImpl()),
  Provider<GameTimerService>(create: (context) => GameTimerServiceImpl()),
];
