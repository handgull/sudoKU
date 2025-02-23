import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'notes_mode_state.dart';
part 'notes_mode_cubit.freezed.dart';

class NotesModeCubit extends HydratedCubit<NotesModeState> {
  NotesModeCubit() : super(const NotesModeState());

  @override
  NotesModeState? fromJson(Map<String, dynamic> json) =>
      NotesModeState(enabled: json['mode'] as bool);

  @override
  Map<String, dynamic>? toJson(NotesModeState state) => {
    'enabled': state.enabled,
  };

  void toggleMode() => emit(NotesModeState(enabled: !state.enabled));
}
