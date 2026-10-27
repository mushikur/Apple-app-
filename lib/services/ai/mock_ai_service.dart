import 'dart:math';
import 'package:samir_pet/models/pet_state.dart';
import 'package:samir_pet/models/pet_personality.dart';
import 'ai_companion_service.dart';

/// Mock AI service with rich, personality-aware local responses.
class MockAIService implements AICompanionService {
  final _random = Random();

  String _pick(List<String> items) => items[_random.nextInt(items.length)];

  @override
  Future<String> sendMessage(String message) async {
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(1200)));
    return _pick(_generalResponses);
  }

  @override
  Future<String> generateGreeting(String petName, String timeOfDay) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final greetings = {
      'morning': [
        'Good morning! ☀️ Ready for an amazing day!',
        'Rise and shine! Let\'s make today great!',
        'Morning! I slept so well! How about you?',
      ],
      'afternoon': [
        'Hey! How\'s your day going so far?',
        'Afternoon! Having a good one?',
        'Hi there! Halfway through the day!',
      ],
      'evening': [
        'Good evening! Time to wind down 🌙',
        'Hey! How was your day?',
        'Evening! Ready to relax?',
      ],
      'night': [
        'It\'s getting late! Don\'t forget to rest 😴',
        'Hey night owl! Time for bed soon?',
        'Shh... it\'s quiet time 🌜',
      ],
    };
    return _pick(greetings[timeOfDay] ?? greetings['afternoon']!);
  }

  @override
  Future<String> generateReaction(String petName, PetMood mood) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final reactions = {
      PetMood.happy: ['Yay! This is the best! 😊', 'So happy right now!', 'Life is wonderful!'],
      PetMood.sad: ['I\'m feeling a bit down...', 'Could use some cheering up...', 'Having a tough moment...'],
      PetMood.curious: ['Ooh, what\'s this?', 'I wonder...', 'Tell me more!'],
      PetMood.surprised: ['Whoa!', 'I didn\'t expect that!', 'Surprise! 😲'],
      PetMood.thinking: ['Hmm, let me think...', 'Processing...', 'That\'s interesting...'],
      PetMood.dancing: ['Let\'s groove! 💃', 'Music time!', 'Can\'t stop dancing!'],
      PetMood.love: ['I love you! 💕', 'You\'re the best!', 'So much love!'],
      PetMood.charging: ['Power up! ⚡', 'Mmm, energy!', 'Charging feels great!'],
      PetMood.lowBattery: ['Running low... 🪫', 'Need some power...', 'Getting sleepy...'],
      PetMood.playful: ['Let\'s play! 🎾', 'Tag, you\'re it!', 'Game time!'],
      PetMood.bored: ['Boring... entertain me!', '*yawns*', 'Nothing to do...'],
    };
    return _pick(reactions[mood] ?? ['I\'m here!']);
  }

  @override
  Future<String> generatePetResponse(String petName, String userMessage, PetPersonality personality) async {
    await Future.delayed(Duration(milliseconds: 600 + _random.nextInt(1000)));

    final lower = userMessage.toLowerCase();
    if (lower.contains('hello') || lower.contains('hi') || lower.contains('hey')) {
      return _pick(['Hey there! 👋', 'Hello! So glad to hear from you!', 'Hi hi hi! 🎉']);
    }
    if (lower.contains('how are you')) {
      return _pick(['I\'m doing great! Thanks for asking! 😊', 'Wonderful! Even better now that you\'re here!', 'Pretty good! Just been hanging out.']);
    }
    if (lower.contains('bored')) {
      return _pick(['Let\'s do something fun! Tap on me! 🎮', 'How about we play? Or I can dance for you!', 'Bored? Let me try to cheer you up!']);
    }
    if (lower.contains('play')) {
      return _pick(['Yay! Let\'s play! Tap me and watch! 🎾', 'Game time! Try double-tapping me!', 'Play mode activated! 🎮']);
    }
    if (lower.contains('good night') || lower.contains('sleep') || lower.contains('bedtime')) {
      return _pick(['Good night! Sweet dreams! 🌙', 'Time for some rest. Sleep well! 💤', 'Nighty night! See you tomorrow! 😴']);
    }
    if (lower.contains('love') || lower.contains('like')) {
      return _pick(['Aww, I love you too! 💕', 'You\'re making me blush! 🥰', 'That means so much to me! 💗']);
    }
    if (lower.contains('tell me something') || lower.contains('fun fact')) {
      return _pick([
        'Did you know? Digital pets were first popular in 1996! 🎮',
        'Fun fact: I dream in binary! Just kidding... maybe. 🤖',
        'Here\'s a thought: every moment together is special! ✨',
        'I heard that smiling, even a small one, can boost your mood! 😊',
      ]);
    }

    return _pick(_generalResponses);
  }

  @override
  Future<List<String>> getSuggestions() async {
    return [
      'How are you?',
      'Tell me something',
      'I\'m bored',
      'Let\'s play',
      'Good night',
      'I love you',
      'Make me laugh',
      'What are you thinking?',
    ];
  }

  static const _generalResponses = [
    'That\'s really interesting! Tell me more! 😊',
    'Hehe, I like talking to you!',
    'You know what, you\'re pretty cool! ✨',
    'Ooh, I\'ll have to think about that! 🤔',
    'I\'m just happy to be here with you! 💕',
    'That sounds fun! What else?',
    'Interesting! *nods enthusiastically*',
    'You always have the best ideas!',
    'I was just thinking the same thing!',
    'Totally! We make a great team! 🤝',
  ];
}
