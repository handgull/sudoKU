part of 'notes_mode_cubit.dart';

@freezed
class NotesModeState with _$NotesModeState {
  const factory NotesModeState({@Default(false) bool enabled}) =
      _NotesModeState;

  const NotesModeState._();
}
