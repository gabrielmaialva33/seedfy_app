import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../services/nvidia_ai_service.dart';
import '../../../services/firebase_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final NvidiaAIService _aiService = NvidiaAIService();
  final ImagePicker _imagePicker = ImagePicker();
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isLoading = false;
  bool _isListening = false;
  bool _isSpeechAvailable = false;
  late AnimationController _typingAnimationController;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeTts();
    _typingAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    // Mensagem de boas-vindas
    _addMessage(ChatMessage(
      text: "🌱 Olá! Sou seu assistente de jardinagem com IA da NVIDIA!\n\n"
            "Posso ajudar com:\n"
            "• 📸 Análise de plantas por foto\n"
            "• 🌿 Identificação de doenças\n"
            "• 💡 Dicas de cuidado\n"
            "• 🗓️ Planejamento de plantio\n"
            "• 🎤 Comandos de voz\n\n"
            "Como posso ajudar hoje?",
      isFromUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> _initializeSpeech() async {
    _isSpeechAvailable = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage("pt-BR");
    await _flutterTts.setSpeechRate(0.8);
    await _flutterTts.setPitch(1.0);
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
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

  Future<void> _sendMessage({String? text, File? image}) async {
    final messageText = text ?? _messageController.text.trim();
    if (messageText.isEmpty && image == null) return;

    // Adicionar mensagem do usuário
    _addMessage(ChatMessage(
      text: messageText,
      isFromUser: true,
      timestamp: DateTime.now(),
      image: image,
    ));

    _messageController.clear();

    setState(() {
      _isLoading = true;
    });

    _typingAnimationController.repeat();

    try {
      String? imageBase64;
      if (image != null) {
        final bytes = await image.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      final response = await _aiService.chatWithGardenAssistant(
        messageText,
        imageBase64: imageBase64,
      );

      // Salvar mensagens no Firebase
      try {
        await FirebaseService.saveChatMessage(
          message: messageText,
          isFromUser: true,
          imageBase64: imageBase64,
        );
        await FirebaseService.saveChatMessage(
          message: response,
          isFromUser: false,
        );
      } catch (e) {
        debugPrint('Failed to save chat to Firebase: $e');
      }

      _addMessage(ChatMessage(
        text: response,
        isFromUser: false,
        timestamp: DateTime.now(),
      ));

      // Falar resposta (apenas primeiras 200 caracteres)
      if (response.length > 10) {
        final shortResponse = response.length > 200 
            ? '${response.substring(0, 200)}...'
            : response;
        await _flutterTts.speak(shortResponse);
      }

    } catch (e) {
      _addMessage(ChatMessage(
        text: "Desculpe, ocorreu um erro: $e\n\nTente novamente!",
        isFromUser: false,
        timestamp: DateTime.now(),
      ));
    }

    setState(() {
      _isLoading = false;
    });

    _typingAnimationController.stop();
  }

  void _startListening() async {
    if (!_isSpeechAvailable) return;

    setState(() {
      _isListening = true;
    });

    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _messageController.text = result.recognizedWords;
        });
      },
    );
  }

  void _stopListening() async {
    setState(() {
      _isListening = false;
    });
    await _speechToText.stop();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (image != null) {
      await _sendMessage(
        text: "Analise esta planta para mim:",
        image: File(image.path),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ).animate(),
            const SizedBox(width: 12),
            const Text('🤖 Garden AI Assistant'),
          ],
        ),
        backgroundColor: theme.colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () async {
              if (_messages.isNotEmpty && !_messages.last.isFromUser) {
                await _flutterTts.speak(_messages.last.text);
              }
            },
            tooltip: 'Repetir última resposta',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _messages.clear();
              });
            },
            tooltip: 'Limpar conversa',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            // Lista de mensagens
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isLoading) {
                    return _buildTypingIndicator();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),

            // Barra de input
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isFromUser;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
              child: const Icon(Icons.eco, size: 16, color: Colors.white),
            ).animate().scale(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.image != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        message.image!,
                        width: 200,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : theme.colorScheme.onSurface,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: isUser 
                          ? Colors.white.withValues(alpha: 0.7)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ).animate().slideX(begin: isUser ? 1 : -1).fadeIn(),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ).animate().scale(),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.green,
            child: const Icon(Icons.eco, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    ).animate(
      controller: _typingAnimationController,
    ).scale(
      delay: Duration(milliseconds: index * 200),
      duration: const Duration(milliseconds: 600),
    );
  }

  Widget _buildInputBar() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botão de câmera
            Container(
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.green),
                onPressed: _pickImage,
                tooltip: 'Analisar planta com foto',
              ),
            ),
            const SizedBox(width: 8),

            // Campo de texto
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Pergunte sobre suas plantas...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Botão de voz
            Container(
              decoration: BoxDecoration(
                color: _isListening 
                    ? Colors.red.withValues(alpha: 0.1)
                    : Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : Colors.blue,
                ),
                onPressed: _isListening ? _stopListening : _startListening,
                tooltip: _isListening ? 'Parar gravação' : 'Gravar mensagem',
              ),
            ).animate(),
            const SizedBox(width: 8),

            // Botão de envio
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _isLoading ? null : () => _sendMessage(),
              ),
            ).animate().scale(),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'agora';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}min';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${time.day}/${time.month}';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  final File? image;

  ChatMessage({
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    this.image,
  });
}