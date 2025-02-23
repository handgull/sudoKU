part of 'active_cell_cubit.dart';

@freezed
sealed class ActiveCellState with _$ActiveCellState {
  const factory ActiveCellState.activating() = ActivatingActiveCellState;

  const factory ActiveCellState.active(int? quadrant, int? index) =
      ActiveActiveCellState;

  const factory ActiveCellState.errorAttivating() =
      ErrorAttivatingActiveCellState;
}
