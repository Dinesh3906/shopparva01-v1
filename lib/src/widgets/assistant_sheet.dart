import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/theme_tokens.dart';
import '../state/chat_provider.dart';

class AssistantSheet extends ConsumerStatefulWidget {
  const AssistantSheet({super.key});

  @override
  ConsumerState<AssistantSheet> createState() => _AssistantSheetState();
}

class _AssistantSheetState extends ConsumerState<AssistantSheet> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSend() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;

    _textController.clear();
    ref.read(chatProvider.notifier).sendMessage(text);
    
    // Scroll to bottom after frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    
    // Auto-scroll on new messages
    ref.listen(chatProvider, (prev, next) {
      if (next.messages.length > (prev?.messages.length ?? 0)) {
         WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          _buildDragHandle(),
          _buildHeader(context),
          const Divider(color: Colors.white10),
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Use local controller for auto-scroll
              padding: const EdgeInsets.all(16),
              itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= chatState.messages.length) {
                  return const _LoadingIndicator();
                }
                final message = chatState.messages[index];
                return _ChatBubble(message: message);
              },
            ),
          ),
          _buildInputArea(context, chatState.isLoading),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      height: 4,
      width: 40,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ShopParva Assistant',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white54),
            onPressed: () {
              ref.read(chatProvider.notifier).clearChat();
            },
            tooltip: 'Clear Chat',
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              enabled: !isLoading,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ask me anything...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: isLoading ? null : _handleSend,
            icon: Icon(Icons.send_rounded, 
              color: isLoading ? Colors.white24 : ThemeTokens.primary),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final isError = message.isError;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser 
              ? ThemeTokens.primary.withOpacity(0.2) 
              : (isError ? Colors.red.withOpacity(0.2) : ThemeTokens.surfaceMuted),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(16),
          ),
          border: isUser 
             ? Border.all(color: ThemeTokens.primary.withOpacity(0.5))
             : (isError ? Border.all(color: Colors.red.withOpacity(0.5)) : null),
        ),
        child: isUser 
          ? Text(message.text, style: const TextStyle(color: Colors.white))
          : MarkdownBody(
              data: message.text,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(color: Colors.white),
                strong: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                code: const TextStyle(color: Colors.amberAccent, fontFamily: 'monospace'),
                listBullet: const TextStyle(color: Colors.white),
              ),
            ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                color: ThemeTokens.surfaceMuted,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                )
            ),
            child: const SizedBox(
                width: 24, 
                height: 24, 
                child: CircularProgressIndicator(strokeWidth: 2, color: ThemeTokens.primary)
            )
        )
    );
  }
}
