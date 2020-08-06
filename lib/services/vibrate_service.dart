import 'package:vibration/vibration.dart';

class VibrateService {
  void vibrateOn() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }

  void vibrateOff() {
    Vibration.cancel();
  }
}
