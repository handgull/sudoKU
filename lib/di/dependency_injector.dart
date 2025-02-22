import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pine/pine.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sudoku/cubits/theme/theme_cubit.dart';
import 'package:sudoku/models/sudoku_cell/sudoku_cell.dart';
import 'package:sudoku/models/sudoku_data/sudoku_data.dart';
import 'package:sudoku/repositories/game_repository.dart';
import 'package:sudoku/repositories/game_timer_repository.dart';
import 'package:sudoku/repositories/mappers/sudoku_cell_mapper.dart';
import 'package:sudoku/repositories/mappers/sudoku_data_mapper.dart';
import 'package:sudoku/services/game_service.dart';
import 'package:sudoku/services/game_timer_service.dart';
import 'package:sudoku/services/network/jto/sudoku_cell/sudoku_cell_jto.dart';
import 'package:sudoku/services/network/jto/sudoku_data/sudoku_data_jto.dart';

part 'blocs.dart';

part 'mappers.dart';

part 'providers.dart';

part 'repositories.dart';

class DependencyInjector extends StatelessWidget {
  const DependencyInjector({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => DependencyInjectorHelper(
    blocs: _blocs,
    mappers: _mappers,
    providers: _providers,
    repositories: _repositories,
    child: child,
  );
}
