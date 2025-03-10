import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sudoku/cubits/theme/theme_cubit.dart';
import 'package:sudoku/di/dependency_injector.dart';
import 'package:sudoku/extensions/localized_context.dart';
import 'package:sudoku/misc/constants.dart';
import 'package:sudoku/routers/app_router.dart';
import 'package:sudoku/theme/theme.dart';

void main() async {
  await runZonedGuarded(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    // I preserve the native splash screen until the app is really ready
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // I do not handle responsivness/adaptivity in this demo app
    // I choosed to support portrait only
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // This check for the web platform is optional for this app
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory(),
    );

    FlutterNativeSplash.remove();

    runApp(const App());
  }, (error, stack) {
    // TODO handle this
  });
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
    return DependencyInjector(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            onGenerateTitle: (context) => context.t?.appName ?? 'APP_NAME',
            debugShowCheckedModeBanner: false,
            routeInformationParser: _appRouter.defaultRouteParser(),
            routerDelegate: _appRouter.delegate(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: K.languagesList,
            theme: LightTheme.make,
            darkTheme: DarkTheme.make,
            themeMode: themeState.mode,
          );
        },
      ),
    );
  }
}
