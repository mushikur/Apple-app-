/// Abstract voice service for speech I/O.
abstract class VoiceService {
  Future<void> init();
  Future<void> speak(String text);
  Future<void> stopSpeaking();
  Future<String?> listen();
  Future<void> stopListening();
  bool get isAvailable;
  bool get isSpeaking;
  bool get isListening;
  void dispose();
}
