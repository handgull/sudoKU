import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/cubits/theme/theme_cubit.dart';
import 'package:sudoku/extensions/localized_context.dart';
import 'package:sudoku/misc/constants.dart';
import 'package:sudoku/routers/app_router.gr.dart';
import 'package:sudoku/widgets/main_app_bar.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        leading: const Icon(Icons.calculate, color: Colors.redAccent),
        changeMode: (mode) => context.read<ThemeCubit>().changeMode(mode),
      ),
      body: ListView(padding: const EdgeInsets.all(K.pagesPadding)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.navigate(const GameRoute());
        },
        tooltip: context.t?.newGame,
        child: const Icon(Icons.add),
      ),
    );
  }
}
