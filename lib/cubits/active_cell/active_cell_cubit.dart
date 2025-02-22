import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_cell_cubit.freezed.dart';
part 'active_cell_state.dart';

class ActiveCellCubit extends Cubit<ActiveCellState> {
  ActiveCellCubit() : super(const ActiveCellState.activating());

  FutureOr<void> setActive(int quadrant, int index) {
    emit(const ActiveCellState.activating());
    try {
      emit(ActiveCellState.active(quadrant, index));
    } on Exception catch (_) {
      // This state is nearly impossible to achieve
      // in the future maybe should be handled by UI, but not now
      emit(const ActiveCellState.errorAttivating());
    }
  }
}
