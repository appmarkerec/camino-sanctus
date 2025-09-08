import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/message_model.dart';
import 'services/ai_service.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'presentation/screens/main_container.dart'; // ✅ ADDED: MainContainer import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(MessageModelAdapter());
  } catch (e) {
    debugPrint('Hive error: $e');
  }
  
  runApp(const CaminoSanctusApp());
}

class CaminoSanctusApp extends StatelessWidget {
  const CaminoSanctusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camino Sanctus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFF5F1E9),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8D6E63),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8D6E63),
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            shadowColor: Colors.brown.shade800,
          ),
        ),
      ),
      home: const MainContainer(), // ✅ CHANGED: Now uses MainContainer with bottom nav
    );
  }
}

// ✅ OPTIONAL: Keep HomeScreen for testing (can be removed later)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.church, size: 26),
            SizedBox(width: 10),
            Text('Camino Sanctus'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.brown.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.church,
                        size: 82,
                        color: Color(0xFF8D6E63),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '¡Bienvenido a Camino Sanctus!',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF5D4037),
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Text(
                            '🎤 Tu asistente bíblico católico con IA y voz está listo.\n\nHermana Esperanza te espera para conversar sobre las Sagradas Escrituras.',
                            style: TextStyle(
                              fontSize: 17,
                              height: 1.6,
                              color: Color(0xFF8D6E63),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 42),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 68,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to MainContainer instead of ChatScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainContainer(),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome, size: 30),
                            SizedBox(width: 14),
                            Text(
                              'Entrar a la App',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _testHive(context),
                    icon: const Icon(Icons.storage, color: Color(0xFF8D6E63)),
                    label: const Text(
                      'Probar Hive Database',
                      style: TextStyle(color: Color(0xFF8D6E63), fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF8D6E63), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _testHive(BuildContext context) async {
    try {
      final box = await Hive.openBox<MessageModel>('test_messages');
      
      final testMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '¡Hola, Hermana Esperanza AI con voz!',
        senderId: 'current_user',
        timestamp: DateTime.now(),
        conversationId: 'test_conversation',
        type: 'user',
      );
      
      await box.add(testMessage);
      final messages = box.values.toList();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Hive funcionando: ${messages.length} mensajes'),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      
      await box.close();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error Hive: $e'),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

// ✅ MOVED: Your ChatScreen stays the same (now accessible via MainContainer)
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String _errorMessage = '';
  late Box<MessageModel> _messageBox;
  
  final AIService _aiService = AIService();
  
  // Voice input variables
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = '';
  
  // Animation controllers
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeHive();
    _initSpeech();
    
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeHive() async {
    try {
      _messageBox = await Hive.openBox<MessageModel>('chat_messages');
      _loadMessages();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error inicializando chat: $e';
      });
    }
  }

  void _loadMessages() {
    setState(() {
      _messages = _messageBox.values.toList().reversed.toList();
    });
  }

  Future<void> _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onError: (error) {
          setState(() {
            _errorMessage = 'Error de voz: ${error.errorMsg}';
            _isListening = false;
          });
          _pulseAnimationController.stop();
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            setState(() {
              _isListening = false;
            });
            _pulseAnimationController.stop();
          }
        },
      );
      setState(() {});
    } catch (e) {
      setState(() {
        _speechEnabled = false;
        _errorMessage = 'Reconocimiento de voz no disponible: $e';
      });
    }
  }

  Future<void> _startListening() async {
    if (!_speechEnabled) {
      _showFeedback('🎤 Micrófono no disponible', Colors.orange);
      return;
    }
    
    try {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: 'es_ES',
        listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
       ),
      );

      setState(() {
        _isListening = true;
        _errorMessage = '';
        _lastWords = '';
      });
      
      _pulseAnimationController.repeat(reverse: true);
      _showFeedback('🎤 Escuchando...', Colors.green);
      
    } catch (e) {
      setState(() {
        _errorMessage = 'Error iniciando grabación: $e';
      });
      _showFeedback('❌ Error de micrófono', Colors.red);
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speechToText.stop();
      setState(() {
        _isListening = false;
      });
      _pulseAnimationController.stop();
      _showFeedback('🔇 Grabación detenida', Colors.grey);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error deteniendo grabación: $e';
      });
    }
  }

  void _onSpeechResult(result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _controller.text = _lastWords;
    });
    
    if (result.finalResult && _lastWords.trim().isNotEmpty) {
      _pulseAnimationController.stop();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!_isLoading && _lastWords.trim().isNotEmpty) {
          _sendMessage(_lastWords.trim());
        }
      });
    }
  }

  void _showFeedback(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _sendMessage(String messageText) async {
    if (messageText.trim().isEmpty || _isLoading) return;

    final userMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: messageText.trim(),
      senderId: 'current_user',
      timestamp: DateTime.now(),
      conversationId: 'default_conversation',
      type: 'user',
    );

    _controller.clear();
    _focusNode.requestFocus();

    setState(() {
      _messages.insert(0, userMessage);
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      await _messageBox.add(userMessage);
      
      final aiMessage = await _aiService.getChatResponse(
        messageText.trim(), 
        _messages.where((m) => m.senderId == 'hermana_esperanza').take(5).toList(),
      );
      
      await _messageBox.add(aiMessage);

      setState(() {
        _messages.insert(0, aiMessage);
        _isLoading = false;
      });

      if (_scrollController.hasClients) {
        await Future.delayed(const Duration(milliseconds: 100));
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }

      if (aiMessage.content.length > 100) {
        _showFeedback('✨ Respuesta AI generada', Colors.blue);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error AI: $e';
      });
      
      final fallbackMessage = MessageModel(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        content: 'Mi querido hermano en Cristo, estoy experimentando dificultades técnicas en este momento. Por favor, intenta nuevamente. Mientras tanto, recuerda que Dios siempre está contigo. 🙏✨',
        senderId: 'hermana_esperanza',
        timestamp: DateTime.now(),
        conversationId: 'default_conversation',
        type: 'ai',
      );
      
      await _messageBox.add(fallbackMessage);
      
      setState(() {
        _messages.insert(0, fallbackMessage);
      });
      
      _showFeedback('⚠️ Problema temporal de conexión', Colors.orange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome, color: Color(0xFF8D6E63), size: 24),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hermana Esperanza AI',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Consejera Espiritual con IA y Voz',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_speechEnabled ? Icons.mic : Icons.mic_off),
            tooltip: _speechEnabled ? 'Micrófono habilitado' : 'Micrófono deshabilitado',
            onPressed: _speechEnabled ? null : () {
              _showFeedback('🎤 Reinicia la app para habilitar micrófono', Colors.orange);
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5DC),
      body: Column(
        children: [
          if (_errorMessage.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red[50],
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red[800], fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, size: 88, color: Color(0xFF8D6E63)),
                          SizedBox(height: 28),
                          Text(
                            '¡Hola! Soy Hermana Esperanza AI',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF5D4037),
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 18),
                          Text(
                            '🎤 Puedes escribir o hablar conmigo.\n\n¿En qué puedo ayudarte hoy?',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF8D6E63),
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Hermana Esperanza está consultando la IA...',
                              style: TextStyle(
                                color: const Color(0xFF8D6E63).withValues(alpha: 0.85),
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8D6E63)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (_isListening)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withValues(alpha: 0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.mic, color: Colors.white, size: 22),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.4), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _lastWords.isEmpty 
                                  ? '🎤 Escuchando... Di tu pregunta en español'
                                  : '🎤 $_lastWords',
                              style: TextStyle(
                                color: Colors.red[800],
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isUser = message.senderId == 'current_user';
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                gradient: isUser ? const LinearGradient(
                  colors: [Color(0xFF8D6E63), Color(0xFF6D4C41)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ) : null,
                color: isUser ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(22),
                  topRight: const Radius.circular(22),
                  bottomLeft: isUser ? const Radius.circular(22) : const Radius.circular(6),
                  bottomRight: isUser ? const Radius.circular(6) : const Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFF2C1810),
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          
          if (isUser) const SizedBox(width: 50),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 25,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F6F0),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF8D6E63).withValues(alpha: 0.24), width: 1.8),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: 5,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.send,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2C1810),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Pregúntale a Hermana Esperanza o usa el micrófono...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF8D6E63).withValues(alpha: 0.6),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: _speechEnabled
                                ? (_isListening ? _stopListening : _startListening)
                                : () => _showFeedback('🎤 Micrófono no disponible', Colors.orange),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _isListening 
                                    ? Colors.red.withValues(alpha: 0.5)
                                    : _speechEnabled 
                                        ? const Color(0xFF8D6E63).withValues(alpha: 0.5)
                                        : Colors.grey.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isListening ? Icons.mic : Icons.mic_none,
                                color: _isListening 
                                    ? Colors.red 
                                    : _speechEnabled 
                                        ? const Color(0xFF8D6E63)
                                        : Colors.grey,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.psychology,
                              color: const Color(0xFF8D6E63).withValues(alpha: 0.55),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty && !_isLoading) {
                      _sendMessage(value.trim());
                    }
                  },
                  enabled: !_isLoading,
                ),
              ),
            ),
            
            const SizedBox(width: 14),
            
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: _isLoading 
                    ? LinearGradient(
                        colors: [Colors.grey.shade400, Colors.grey.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                shape: BoxShape.circle,
                boxShadow: _isLoading ? [] : [
                  BoxShadow(
                    color: const Color(0xFF8D6E63).withValues(alpha: 0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: _isLoading 
                      ? null 
                      : () {
                          if (_controller.text.trim().isNotEmpty) {
                            _sendMessage(_controller.text.trim());
                          } else {
                            _focusNode.requestFocus();
                          }
                        },
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _speechToText.stop();
    _pulseAnimationController.dispose();
    _messageBox.close();
    super.dispose();
  }
}
