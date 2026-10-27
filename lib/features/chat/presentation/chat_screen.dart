import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samir_pet/animation/pet_widget.dart';
import 'package:samir_pet/core/constants/app_colors.dart';
import 'package:samir_pet/core/constants/app_typography.dart';
import 'package:samir_pet/core/utils/haptic_utils.dart';
import 'package:samir_pet/features/chat/models/chat_message.dart';
import 'package:samir_pet/models/pet_event.dart';
import 'package:samir_pet/providers/app_settings_provider.dart';
import 'package:samir_pet/providers/pet_provider.dart';
import 'package:samir_pet/services/service_locator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  List<String> _suggestions = [];
  bool _isThinking = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final petName = context.read<AppSettingsProvider>().settings.petName;
    _suggestions = await ServiceLocator.ai.getSuggestions();

    // Pet greeting
    final greeting = await ServiceLocator.ai.generateGreeting(petName, 'afternoon');

    if (!mounted) return;
    setState(() {
      _messages.add(
        ChatMessage(
          id: '0',
          text: greeting,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isThinking = true;
    });

    _textController.clear();
    _scrollToBottom();
    HapticUtils.lightTap();

    // Trigger pet thinking
    final petProvider = context.read<PetProvider>();
    petProvider.processEvent(PetEvent(type: PetEventType.thinkRequested));

    final settings = context.read<AppSettingsProvider>().settings;
    final response = await ServiceLocator.ai.generatePetResponse(
      settings.petName,
      userMsg.text,
      petProvider.personality,
    );

    if (!mounted) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      _isThinking = false;
    });

    petProvider.processEvent(PetEvent(type: PetEventType.userTappedPet));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = context.watch<PetProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<AppSettingsProvider>().settings.petName),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBgGradient : AppColors.lightBgGradient,
        ),
        child: Column(
          children: [
            // Mini Interactive Pet at top
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: PetWidget(
                engine: petProvider.engine,
                size: 110,
                interactive: true,
              ),
            ),
            const Divider(height: 1),

            // Chat Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(msg, isDark);
                },
              ),
            ),

            if (_isThinking)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Thinking...',
                      style: AppTypography.caption.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),

            // Quick Suggestions Chips
            if (_suggestions.isNotEmpty)
              Container(
                height: 44,
                margin: const EdgeInsets.only(bottom: 6),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(
                          suggestion,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        backgroundColor: AppColors.glassColor(Theme.of(context).brightness),
                        side: BorderSide(
                          color: AppColors.glassBorder(Theme.of(context).brightness),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        onPressed: () => _sendMessage(suggestion),
                      ),
                    );
                  },
                ),
              ),

            // Message Input Field
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.glassColor(Theme.of(context).brightness),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: AppColors.glassBorder(Theme.of(context).brightness),
                          ),
                        ),
                        child: TextField(
                          controller: _textController,
                          textInputAction: TextInputAction.send,
                          onSubmitted: _sendMessage,
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Talk to your pet...',
                            hintStyle: TextStyle(
                              color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white),
                        onPressed: () => _sendMessage(_textController.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isDark) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: msg.isUser
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(msg.isUser ? 18 : 4),
            bottomRight: Radius.circular(msg.isUser ? 4 : 18),
          ),
          border: Border.all(
            color: msg.isUser
                ? Colors.transparent
                : AppColors.glassBorder(Theme.of(context).brightness),
          ),
        ),
        child: Text(
          msg.text,
          style: AppTypography.chatMessage.copyWith(
            color: msg.isUser
                ? Colors.white
                : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
        ),
      ),
    );
  }
}
