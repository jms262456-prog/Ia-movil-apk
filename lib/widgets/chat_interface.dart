import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_provider.dart';
import '../providers/voice_provider.dart';
import '../utils/theme.dart';

class ChatInterface extends StatefulWidget {
  final VoidCallback onClose;

  const ChatInterface({
    super.key,
    required this.onClose,
  });

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final aiProvider = context.read<AIProvider>();
    final voiceProvider = context.read<VoiceProvider>();

    // Procesar mensaje
    aiProvider.processUserInput(text).then((response) {
      if (voiceProvider.voiceEnabled) {
        voiceProvider.speak(response);
      }
      _scrollToBottom();
    });

    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior
            _buildTopBar(),
            
            // Lista de mensajes
            Expanded(
              child: _buildMessageList(),
            ),
            
            // Campo de entrada
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.arrow_back),
          ),
          
          const SizedBox(width: 12),
          
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryColor,
            child: Icon(
              Icons.chat,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 12),
          
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat con Compañera',
                  style: AppTheme.titleMedium,
                  fontWeight: FontWeight.bold,
                ),
                Text(
                  'Conversación en tiempo real',
                  style: AppTheme.bodySmall,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          
          IconButton(
            onPressed: () {
              context.read<AIProvider>().clearConversation();
            },
            icon: const Icon(Icons.clear_all),
            tooltip: 'Limpiar conversación',
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Consumer<AIProvider>(
      builder: (context, aiProvider, child) {
        final messages = aiProvider.conversationHistory;
        
        if (messages.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No hay mensajes aún',
                  style: AppTheme.bodyLarge,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  '¡Empieza una conversación!',
                  style: AppTheme.bodyMedium,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return _buildMessageItem(message);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(ConversationMessage message) {
    final isUser = message.sender == 'user';
    final isSystem = message.sender == 'system';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: isSystem 
                ? Colors.grey 
                : AppTheme.primaryColor,
              child: Icon(
                isSystem ? Icons.info : Icons.smart_toy,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Expanded(
            child: Column(
              crossAxisAlignment: isUser 
                ? CrossAxisAlignment.end 
                : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser 
                      ? AppTheme.primaryColor 
                      : isSystem 
                        ? Colors.grey[200]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20).copyWith(
                      bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
                      bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: AppTheme.bodyMedium.copyWith(
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  _formatTime(message.timestamp),
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Botón de micrófono
          Consumer<VoiceProvider>(
            builder: (context, voiceProvider, child) {
              return IconButton(
                onPressed: () {
                  if (voiceProvider.isListening) {
                    voiceProvider.stopListening();
                  } else {
                    voiceProvider.startListening();
                  }
                },
                icon: Icon(
                  voiceProvider.isListening ? Icons.mic : Icons.mic_none,
                  color: voiceProvider.isListening 
                    ? AppTheme.primaryColor 
                    : Colors.grey,
                ),
              );
            },
          ),
          
          // Campo de texto
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Escribe un mensaje...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          
          // Botón de enviar
          Consumer<AIProvider>(
            builder: (context, aiProvider, child) {
              return IconButton(
                onPressed: aiProvider.isProcessing ? null : _sendMessage,
                icon: aiProvider.isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.send,
                        color: AppTheme.primaryColor,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}