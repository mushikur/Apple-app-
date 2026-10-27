import 'voice_service.dart';

/// Mock voice service for development.
class MockVoiceService implements VoiceService {
  bool _speaking = false;
  bool _listening = false;

  @override
  Future<void> init() async {}

  @override
  bool get isAvailable => false;

  @override
  bool get isSpeaking => _speaking;

  @override
  bool get isListening => _listening;

  @override
  Future<void> speak(String text) async {
    _speaking = true;
    await Future.delayed(Duration(milliseconds: text.length * 50));
    _speaking = false;
  }

  @override
  Future<void> stopSpeaking() async => _speaking = false;

  @override
  Future<String?> listen() async {
    _listening = true;
    await Future.delayed(const Duration(seconds: 2));
    _listening = false;
    return 'Hello there!';
  }

  @override
  Future<void> stopListening() async => _listening = false;

  @override
  void dispose() {}
}
