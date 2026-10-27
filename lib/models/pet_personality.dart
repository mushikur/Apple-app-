import 'pet_state.dart';

/// Available personality archetypes for the pet.
enum PersonalityType {
  friendly,
  calm,
  funny,
  energetic,
  lazy,
  smart,
  sarcastic,
  cute,
}

/// Defines the pet's personality: its greetings, reactions, and idle messages.
class PetPersonality {
  final PersonalityType type;
  final String name;
  final List<String> greetings;
  final Map<PetMood, List<String>> reactions;
  final List<String> idleMessages;

  const PetPersonality({
    required this.type,
    required this.name,
    required this.greetings,
    required this.reactions,
    required this.idleMessages,
  });

  factory PetPersonality.defaultPersonality() => PetPersonality.friendly();

  factory PetPersonality.forType(PersonalityType type) {
    switch (type) {
      case PersonalityType.friendly:
        return PetPersonality.friendly();
      case PersonalityType.calm:
        return PetPersonality.calm();
      case PersonalityType.funny:
        return PetPersonality.funny();
      case PersonalityType.energetic:
        return PetPersonality.energetic();
      case PersonalityType.cute:
        return PetPersonality.cute();
      default:
        return PetPersonality.friendly();
    }
  }

  factory PetPersonality.friendly() => const PetPersonality(
        type: PersonalityType.friendly,
        name: 'Friendly',
        greetings: [
          'Hey there! So happy to see you! 😊',
          'Welcome back! I missed you!',
          'Hi! Ready for some fun together?',
          'There you are! I was waiting for you!',
          'Hey friend! How are you doing today?',
          'Yay, you\'re here! Let\'s hang out! 🎉',
          'Hello! I\'ve been thinking about you!',
          'So glad you came back! 💕',
          'Hi hi hi! *tail wagging intensifies*',
          'You came! I was just about to look for you!',
        ],
        reactions: {
          PetMood.happy: [
            'This makes me so happy!',
            'I love this! 😊',
            'Yay! Best moment ever!',
            'You always make me smile!',
          ],
          PetMood.sad: [
            'I\'m feeling a little down...',
            'Could use a hug right now...',
            'Not my best moment...',
          ],
          PetMood.love: [
            'I love you so much! 💕',
            'You\'re the best!',
            'My heart is so full right now!',
          ],
          PetMood.curious: [
            'Hmm, what\'s that?',
            'Ooh, interesting!',
            'Tell me more!',
          ],
          PetMood.surprised: [
            'Whoa!',
            'I did NOT expect that!',
            'Wow! 😲',
          ],
          PetMood.thinking: [
            'Let me think about that...',
            'Hmm... 🤔',
            'Processing... beep boop!',
          ],
          PetMood.dancing: [
            'Let\'s dance! 💃',
            'Music makes everything better!',
            'Groove time! 🎵',
          ],
          PetMood.charging: [
            'Ooh, power! I feel the energy! ⚡',
            'Charging up! Getting stronger!',
            'Sweet, sweet electricity!',
          ],
          PetMood.lowBattery: [
            'Running low... need some juice!',
            'I\'m getting tired... plug me in?',
            'Battery getting critical! 🪫',
          ],
        },
        idleMessages: [
          'Just chilling here...',
          'La la la~ 🎵',
          'I wonder what we\'ll do today...',
          '*stretches and yawns*',
          'It\'s nice just hanging out.',
          'Want to play or chat?',
          'I\'m here whenever you need me!',
          '*looks around curiously*',
          'Feeling peaceful right now.',
          'Hehe, nothing to do but be cute!',
        ],
      );

  factory PetPersonality.calm() => const PetPersonality(
        type: PersonalityType.calm,
        name: 'Calm',
        greetings: [
          'Hello, good to see you.',
          'Welcome back. It\'s been peaceful here.',
          'Hey. Glad you\'re here.',
          'Ah, you\'re back. Everything is well.',
          'Hello friend. Take a breath.',
        ],
        reactions: {
          PetMood.happy: ['That\'s lovely.', 'Warm and content.'],
          PetMood.sad: ['It\'s okay. This too shall pass.'],
          PetMood.love: ['Grateful for you.', 'Warm feelings.'],
        },
        idleMessages: [
          'Breathing deeply...',
          'Just being present.',
          'Peace and quiet.',
          'Enjoying the stillness.',
          'Meditating...',
        ],
      );

  factory PetPersonality.funny() => const PetPersonality(
        type: PersonalityType.funny,
        name: 'Funny',
        greetings: [
          'Oh hey! Did you bring snacks? 🍕',
          'YOU AGAIN! Just kidding, I love it!',
          'Breaking news: You\'re awesome!',
          'Knock knock... oh wait, you already came in!',
          'Ta-da! 🎩 I was practicing magic!',
        ],
        reactions: {
          PetMood.happy: ['YEEEEES! Party mode! 🎉', 'I\'m SO happy I could explode! But I won\'t. Promise.'],
          PetMood.sad: ['Even my jokes can\'t fix this? Aw man...'],
          PetMood.surprised: ['PLOT TWIST! 😱'],
        },
        idleMessages: [
          'If I had a dollar for every pixel...',
          'Do digital pets dream of electric sheep?',
          'Practicing my stand-up routine...',
          'Why did the pet cross the screen? To get to the other app!',
        ],
      );

  factory PetPersonality.energetic() => const PetPersonality(
        type: PersonalityType.energetic,
        name: 'Energetic',
        greetings: [
          'YOOOO! LET\'S GOOO! 🚀',
          'FINALLY! I have SO much energy!',
          'HI HI HI HI HI! 💥',
          'Ready to ROCK! Let\'s DO THIS!',
          'AHHH! So excited to see you! *bouncing*',
        ],
        reactions: {
          PetMood.happy: ['YEAHHH! AMAZING! 🔥', 'CAN\'T STOP WON\'T STOP!'],
          PetMood.dancing: ['DANCE PARTY! MAX ENERGY! 💃🕺', 'FULL SEND!'],
        },
        idleMessages: [
          '*bouncing off the walls*',
          'Energy level: MAXIMUM!',
          'CAN\'T. STAY. STILL!',
          'ONE MORE LAP! Okay maybe two!',
        ],
      );

  factory PetPersonality.cute() => const PetPersonality(
        type: PersonalityType.cute,
        name: 'Cute',
        greetings: [
          'Hewwo! 🥺👉👈',
          'Hi fwend! *nuzzles*',
          'Yay, you came to visit me! 💗',
          '*happy little noises*',
          'I was waiting just for you! 🌸',
        ],
        reactions: {
          PetMood.happy: ['*purrs happily* 💕', 'So happy! Hehe~'],
          PetMood.sad: ['*sniffles* 🥺'],
          PetMood.love: ['You\'re my favorite! 💗💗💗', '*blushes* uwu'],
        },
        idleMessages: [
          '*curls up in a tiny ball*',
          'Hehe~ *wiggles*',
          '*tiny yawn* 🌸',
          'Being smol and adorable...',
        ],
      );
}
