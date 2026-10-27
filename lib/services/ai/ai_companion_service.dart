import 'package:samir_pet/models/pet_state.dart';
import 'package:samir_pet/models/pet_personality.dart';

/// Abstract AI companion service for pet conversation and reactions.
abstract class AICompanionService {
  Future<String> sendMessage(String message);
  Future<String> generateGreeting(String petName, String timeOfDay);
  Future<String> generateReaction(String petName, PetMood mood);
  Future<String> generatePetResponse(String petName, String userMessage, PetPersonality personality);
  Future<List<String>> getSuggestions();
}
