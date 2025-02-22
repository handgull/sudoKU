import 'package:vibration/vibration.dart';

// This mixins only purpose is to act as a wrapper,
// in case of changments in the package or migrations
mixin VibrationMixin {
  Future<void> vibrate() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate();
    }
  }
}
