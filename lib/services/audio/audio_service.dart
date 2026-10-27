import 'dart:async';

/// Abstract audio/music mode service.
abstract class AudioService {
  Future<void> init();
  bool get isMusicModeActive;
  void setMusicMode(bool active);
  Stream<bool> get musicModeStream;
  void dispose();
}
