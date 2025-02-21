import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pine/pine.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sudoku/cubits/theme/theme_cubit.dart';

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
