import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/services/gemini_service.dart';

// Chat Message Model
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isError = false,
  });
}

// State class
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  ChatState({this.messages = const [], this.isLoading = false});

  ChatState copyWith({List<ChatMessage>? messages, bool? isLoading}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Provider for Gemini Service
final geminiServiceProvider = Provider<GeminiService>((ref) => GeminiService());

// Chat State Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final GeminiService _geminiService;
  
  // Keep track of chat history for context
  List<Content> _history = [];

  ChatNotifier(this._geminiService) : super(ChatState(messages: [
    ChatMessage(text: 'Hi! I can help you find products, compare prices, or build a PC kit. What can I do for you today?', isUser: false),
  ]));

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(text: text, isUser: true);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      // Stream response
      final stream = _geminiService.streamContent(text, history: _history);
      
      String accumulatedText = '';
      
      // Temporary message for streaming
      // We will update this in real-time or just wait for full response for simplicity first
      // Let's implement full response wait first to ensure stability, then switch to streaming if needed
      // Actually, streaming is better UX. Let's try to handle it.
      
      // For now, let's wait for the stream to complete to construct the full history item correctly
      await for (final chunk in stream) {
        if (chunk.text != null) {
          accumulatedText += chunk.text!;
        }
      }

      // Add assistant response
      final aiMessage = ChatMessage(text: accumulatedText, isUser: false);
      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
      
      // Update history
      _history.add(Content.text(text));
      _history.add(Content.model([TextPart(accumulatedText)]));

    } catch (e) {
      state = state.copyWith(
        messages: [...state.messages, ChatMessage(text: "Sorry, I encountered an error: $e", isUser: false, isError: true)],
        isLoading: false,
      );
    }
  }
  
  void clearChat() {
     _history = [];
     state = ChatState(messages: [
        ChatMessage(text: 'Hi! I can help you find products, compare prices, or build a PC kit. What can I do for you today?', isUser: false),
     ]);
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final service = ref.watch(geminiServiceProvider);
  return ChatNotifier(service);
});
