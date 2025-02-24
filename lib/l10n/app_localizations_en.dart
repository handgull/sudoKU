// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'sudo...KU!';

  @override
  String get darkTheme => 'Modalità scura';

  @override
  String get lightTheme => 'Modalità chiaro';

  @override
  String get newGame => 'New game!';

  @override
  String get notesOn => 'Notes: ON';

  @override
  String get notesOff => 'Notes: OFF';

  @override
  String get erase => 'Erase';

  @override
  String get difficulty => 'Select Difficulty';

  @override
  String get beginner => 'Beginner';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'PAUSED';

  @override
  String get resume => 'Resume';

  @override
  String get errorStartingGame => 'Error starting the new game!';
}
