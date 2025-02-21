import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/cubits/theme/theme_cubit.dart';
import 'package:sudoku/widgets/main_app_bar.dart';

@RoutePage()
class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        changeMode: (mode) => context.read<ThemeCubit>().changeMode(mode),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}),
    );
  }
}
