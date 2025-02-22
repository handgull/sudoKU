part of 'dependency_injector.dart';

// If this array becomes too long:
// do not use DI for every mapper but only highly reusable ones.
final List<SingleChildWidget> _mappers = [
  Provider<DTOMapper<SudokuCellJTO, SudokuCell>>(
    create: (_) => const SudokuCellMapper(),
  ),
  Provider<DTOMapper<SudokuDataJTO, SudokuData>>(
    create: (context) => SudokuDataMapper(sudokuCellMapper: context.read()),
  ),
];
