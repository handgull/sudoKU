import 'package:auto_route/auto_route.dart';
import 'package:sudoku/routers/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute<GameRoute>(
      page: GameRoute.page,
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
      path: '/',
    ),
    CustomRoute<StatsRoute>(
      page: StatsRoute.page,
      transitionsBuilder: TransitionsBuilders.slideRightWithFade,
    ),
  ];
}
