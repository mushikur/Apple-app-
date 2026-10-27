import 'dart:async';
import 'audio_service.dart';

/// Mock audio service for development.
class MockAudioService implements AudioService {
  final _controller = StreamController<bool>.broadcast();
  bool _musicMode = false;

  @override
  Future<void> init() async {}

  @override
  bool get isMusicModeActive => _musicMode;

  @override
  void setMusicMode(bool active) {
    _musicMode = active;
    _controller.add(active);
  }

  @override
  Stream<bool> get musicModeStream => _controller.stream;

  @override
  void dispose() => _controller.close();
}
