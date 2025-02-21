import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sudoku/extensions/localized_context.dart';
import 'package:sudoku/misc/constants.dart';
import 'package:sudoku/routers/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.t?.appName ?? 'APP_NAME',
      debugShowCheckedModeBanner: false,
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: K.languagesList,
    );
  }
}
