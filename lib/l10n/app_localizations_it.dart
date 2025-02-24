// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'sudo...KU!';

  @override
  String get darkTheme => 'Modalità scura';

  @override
  String get lightTheme => 'Modalità chiaro';

  @override
  String get newGame => 'Nuova partita!';

  @override
  String get notesOn => 'Note: ON';

  @override
  String get notesOff => 'Note: OFF';

  @override
  String get erase => 'Cancella';

  @override
  String get difficulty => 'Seleziona Difficoltà';

  @override
  String get beginner => 'Principiante';

  @override
  String get easy => 'Facile';

  @override
  String get medium => 'Medio';

  @override
  String get hard => 'Difficile';

  @override
  String get pause => 'Pausa';

  @override
  String get paused => 'IN PAUSA';

  @override
  String get resume => 'Riprendi';

  @override
  String get errorStartingGame => 'Errore nella creazione della nuova partita!';
}
