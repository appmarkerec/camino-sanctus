import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/message_model.dart';
import '../../services/ai_service.dart';

class ChatViewModel extends ChangeNotifier {
  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String _errorMessage = '';
  late Box<MessageModel> _messageBox;
  bool _isInitialized = false;
  
  final ScrollController scrollController = ScrollController();
  final AIService _aiService = AIService();

  // Getters
  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;

  ChatViewModel() {
    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    try {
      await _initializeHive();
      await _loadMessages();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _setError('Error inicializando chat: $e');
      if (kDebugMode) {
        debugPrint('Error inicializando chat: $e');
      }
    }
  }

  Future<void> _initializeHive() async {
    try {
      _messageBox = await Hive.openBox<MessageModel>('chat_messages_viewmodel');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error opening database: $e');
      }
      throw Exception('Error abriendo base de datos: $e');
    }
  }

  Future<void> _loadMessages() async {
    try {
      if (!_isInitialized && !_messageBox.isOpen) {
        await _initializeHive();
      }
      
      final allMessages = _messageBox.values.toList();
      // Ordenar por timestamp (más recientes primero para mostrar en ListView reverse)
      allMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      _messages = allMessages;
      notifyListeners();
    } catch (e) {
      _setError('Error cargando mensajes: $e');
      if (kDebugMode) {
        debugPrint('Error cargando mensajes: $e');
      }
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      // Crear y agregar mensaje del usuario
      final userMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: text.trim(),
        senderId: 'current_user',
        timestamp: DateTime.now(),
        conversationId: 'default_conversation',
        type: 'user',
      );

      await _addMessageToChat(userMessage);

      // Verificar si es una referencia bíblica o pregunta general
      if (_isBibleReference(text)) {
        await _handleBibleReference(text.trim());
      } else {
        await _handleGeneralQuestion(text.trim());
      }

    } catch (e) {
      _setError('Error enviando mensaje: $e');
      if (kDebugMode) {
        debugPrint('Error in sendMessage: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _addMessageToChat(MessageModel message) async {
    try {
      await _messageBox.add(message);
      _messages.insert(0, message); // Insertar al inicio para ListView reverse
      notifyListeners();
      _scrollToBottom();
    } catch (e) {
      throw Exception('Error guardando mensaje: $e');
    }
  }

  bool _isBibleReference(String text) {
    // Detectar patrones bíblicos comunes
    final biblePatterns = [
      RegExp(r'\b(1|2|3)?\s*[A-Za-zñáéíóúü]+\s+\d+:\d+\b', caseSensitive: false),
      RegExp(r'\b(1|2|3)?\s*[A-Za-zñáéíóúü]+\s+\d+\b', caseSensitive: false),
      RegExp(r'\b(Génesis|Éxodo|Levítico|Juan|Mateo|Lucas|Marcos|Romanos|Corintios|Gálatas|Efesios|Filipenses|Colosenses|Tesalonicenses|Timoteo|Tito|Filemón|Hebreos|Santiago|Pedro|Judas|Apocalipsis|Salmos?|Proverbios)\b', caseSensitive: false),
    ];
    
    return biblePatterns.any((pattern) => pattern.hasMatch(text.trim()));
  }

  Future<void> _handleBibleReference(String reference) async {
    try {
      // Simular búsqueda de versículo (puedes reemplazar con API real)
      final verseData = _getSimulatedVerse(reference);
      
      if (verseData != null) {
        final verseMessage = MessageModel.ai(
          '📖 **${verseData['reference']}**\n\n"${verseData['text']}"\n\n💡 Este versículo nos recuerda la importancia de mantener nuestra fe y confianza en Dios. ¿Te gustaría que conversemos sobre su significado?',
          verseRef: verseData['reference'],
          verseText: verseData['text'],
        );
        
        await _addMessageToChat(verseMessage);
        
      } else {
        final errorMessage = MessageModel.ai(
          '❌ No pude encontrar el versículo "$reference". \n\nPuedes intentar con referencias como:\n• Juan 3:16\n• Salmos 23:1\n• Mateo 6:33\n• Filipenses 4:13\n\n¿Hay algo más en lo que pueda ayudarte espiritualmente? 🙏'
        );
        
        await _addMessageToChat(errorMessage);
      }
      
    } catch (e) {
      final errorMessage = MessageModel.ai(
        'Disculpa, tuve dificultades buscando ese versículo. Pero recuerda que la Palabra de Dios siempre está disponible para nosotros. ¿Hay alguna pregunta espiritual en la que pueda acompañarte? 🙏✨'
      );
      
      await _addMessageToChat(errorMessage);
    }
  }

  Future<void> _handleGeneralQuestion(String question) async {
    try {
      // Usar el AIService real que ya tienes funcionando
      final conversationHistory = _messages
          .where((m) => m.senderId == 'hermana_esperanza')
          .take(3)
          .toList();
      
      final aiMessage = await _aiService.getChatResponse(question, conversationHistory);
      
      await _addMessageToChat(aiMessage);
      
      // Opcional: Sugerir versículos relacionados
      await _suggestRelatedVerse(question);
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error in AI response: $e');
      }
      final errorMessage = MessageModel.ai(
        'Mi querido hermano en Cristo, estoy experimentando algunas dificultades técnicas en este momento. Por favor, intenta nuevamente. Mientras tanto, recuerda que Dios siempre escucha tu corazón y está contigo. 🙏✨❤️'
      );
      
      await _addMessageToChat(errorMessage);
    }
  }

  Future<void> _suggestRelatedVerse(String question) async {
    try {
      // Detectar temas y sugerir versículos apropiados
      final theme = _detectTheme(question.toLowerCase());
      final verse = _getThematicVerse(theme);
      
      if (verse != null) {
        // Esperar un poco antes de enviar la sugerencia
        await Future.delayed(const Duration(seconds: 2));
        
        final verseMessage = MessageModel.ai(
          '📚 **Versículo relacionado:**\n\n"${verse['text']}"\n*- ${verse['reference']}*\n\n¿Te gustaría que reflexionemos juntos sobre este pasaje? 🤔✨'
        );
        
        await _addMessageToChat(verseMessage);
      }
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error suggesting verse: $e');
      }
      // No mostrar error al usuario, es funcionalidad opcional
    }
  }

  String _detectTheme(String question) {
    final themes = {
      'amor': ['amor', 'amar', 'querer', 'cariño', 'afecto'],
      'fe': ['fe', 'creer', 'confianza', 'confiar'],
      'esperanza': ['esperanza', 'esperar', 'futuro', 'mañana'],
      'paz': ['paz', 'tranquilidad', 'calma', 'serenidad'],
      'perdón': ['perdón', 'perdonar', 'disculpa', 'perdona'],
      'oración': ['oración', 'orar', 'rezar', 'plegaria'],
      'miedo': ['miedo', 'temor', 'ansiedad', 'preocupación'],
      'tristeza': ['triste', 'tristeza', 'dolor', 'sufrimiento'],
      'gratitud': ['gracias', 'gratitud', 'agradecer', 'bendición'],
    };
    
    for (final theme in themes.keys) {
      if (themes[theme]!.any((word) => question.contains(word))) {
        return theme;
      }
    }
    
    return 'general';
  }

  Map<String, String>? _getThematicVerse(String theme) {
    final verses = {
      'amor': {
        'reference': '1 Juan 4:8',
        'text': 'El que no ama, no ha conocido a Dios; porque Dios es amor.'
      },
      'fe': {
        'reference': 'Hebreos 11:1',
        'text': 'Es, pues, la fe la certeza de lo que se espera, la convicción de lo que no se ve.'
      },
      'esperanza': {
        'reference': 'Jeremías 29:11',
        'text': 'Porque yo sé los pensamientos que tengo acerca de vosotros, dice Jehová, pensamientos de paz, y no de mal, para daros el fin que esperáis.'
      },
      'paz': {
        'reference': 'Juan 14:27',
        'text': 'La paz os dejo, mi paz os doy; yo no os la doy como el mundo la da. No se turbe vuestro corazón, ni tenga miedo.'
      },
      'perdón': {
        'reference': '1 Juan 1:9',
        'text': 'Si confesamos nuestros pecados, él es fiel y justo para perdonar nuestros pecados, y limpiarnos de toda maldad.'
      },
      'oración': {
        'reference': 'Mateo 7:7',
        'text': 'Pedid, y se os dará; buscad, y hallaréis; llamad, y se os abrirá.'
      },
      'miedo': {
        'reference': 'Josué 1:9',
        'text': 'Mira que te mando que te esfuerces y seas valiente; no temas ni desmayes, porque Jehová tu Dios estará contigo en dondequiera que vayas.'
      },
      'tristeza': {
        'reference': 'Salmos 34:18',
        'text': 'Cercano está Jehová a los quebrantados de corazón; y salva a los contritos de espíritu.'
      },
      'gratitud': {
        'reference': '1 Tesalonicenses 5:18',
        'text': 'Dad gracias en todo, porque esta es la voluntad de Dios para con vosotros en Cristo Jesús.'
      },
    };
    
    return verses[theme];
  }

  Map<String, String>? _getSimulatedVerse(String reference) {
    // Base de datos simulada de versículos populares
    final verses = {
      'juan 3:16': {
        'reference': 'Juan 3:16',
        'text': 'Porque de tal manera amó Dios al mundo, que ha dado a su Hijo unigénito, para que todo aquel que en él cree, no se pierda, mas tenga vida eterna.'
      },
      'salmos 23:1': {
        'reference': 'Salmos 23:1',
        'text': 'Jehová es mi pastor; nada me faltará.'
      },
      'filipenses 4:13': {
        'reference': 'Filipenses 4:13',
        'text': 'Todo lo puedo en Cristo que me fortalece.'
      },
      'mateo 6:33': {
        'reference': 'Mateo 6:33',
        'text': 'Mas buscad primeramente el reino de Dios y su justicia, y todas estas cosas os serán añadidas.'
      },
      'proverbios 3:5': {
        'reference': 'Proverbios 3:5',
        'text': 'Fíate de Jehová de todo tu corazón, y no te apoyes en tu propia prudencia.'
      },
      'salmos 23': {
        'reference': 'Salmos 23:1',
        'text': 'Jehová es mi pastor; nada me faltará.'
      },
      'juan 14:6': {
        'reference': 'Juan 14:6',
        'text': 'Jesús le dijo: Yo soy el camino, y la verdad, y la vida; nadie viene al Padre, sino por mí.'
      },
    };
    
    final normalizedRef = reference.toLowerCase().trim();
    return verses[normalizedRef];
  }

  // Métodos de utilidad mejorados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0, // Para ListView reverse
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  // Métodos públicos adicionales mejorados
  Future<void> clearChat() async {
    try {
      if (_messageBox.isOpen) {
        await _messageBox.clear();
      }
      _messages.clear();
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Error limpiando el chat: $e');
      if (kDebugMode) {
        debugPrint('Error clearing chat: $e');
      }
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      final messageIndex = _messages.indexWhere((msg) => msg.id == messageId);
      if (messageIndex != -1) {
        final message = _messages[messageIndex];
        if (message.isInBox) {
          await message.delete(); // Hive method
        }
        _messages.removeAt(messageIndex);
        notifyListeners();
      }
    } catch (e) {
      _setError('Error eliminando mensaje: $e');
      if (kDebugMode) {
        debugPrint('Error deleting message: $e');
      }
    }
  }

  Future<void> refreshMessages() async {
    await _loadMessages();
  }

  // Método para exportar conversación mejorado
  String exportConversation() {
    final buffer = StringBuffer();
    buffer.writeln('=== Conversación con Hermana Esperanza AI ===');
    buffer.writeln('Fecha: ${DateTime.now().toString().substring(0, 19)}');
    buffer.writeln('Total de mensajes: ${_messages.length}');
    buffer.writeln('');
    
    for (final message in _messages.reversed) {
      final sender = message.senderId == 'current_user' ? 'Usuario' : 'Hermana Esperanza';
      final timestamp = message.timestamp.toString().substring(0, 19);
      buffer.writeln('[$sender - $timestamp]');
      buffer.writeln(message.content);
      
      if (message.verseReference != null) {
        buffer.writeln('Referencia bíblica: ${message.verseReference}');
      }
      buffer.writeln('');
    }
    
    buffer.writeln('=== Fin de la conversación ===');
    return buffer.toString();
  }

  // Estadísticas de conversación mejoradas
  Map<String, dynamic> getConversationStats() {
    final userMessages = _messages.where((m) => m.senderId == 'current_user');
    final aiMessages = _messages.where((m) => m.senderId == 'hermana_esperanza');
    final messagesWithVerses = _messages.where((m) => m.verseReference != null);
    
    return {
      'totalMessages': _messages.length,
      'userMessages': userMessages.length,
      'aiMessages': aiMessages.length,
      'messagesWithVerses': messagesWithVerses.length,
      'averageMessageLength': _messages.isEmpty ? 0 : 
        _messages.map((m) => m.content.length).reduce((a, b) => a + b) / _messages.length,
      'oldestMessage': _messages.isEmpty ? null : 
        _messages.map((m) => m.timestamp).reduce((a, b) => a.isBefore(b) ? a : b),
      'newestMessage': _messages.isEmpty ? null : 
        _messages.map((m) => m.timestamp).reduce((a, b) => a.isAfter(b) ? a : b),
    };
  }

  // Método para buscar mensajes
  List<MessageModel> searchMessages(String query) {
    if (query.trim().isEmpty) return [];
    
    final searchTerm = query.toLowerCase();
    return _messages.where((message) {
      return message.content.toLowerCase().contains(searchTerm) ||
             (message.verseReference?.toLowerCase().contains(searchTerm) ?? false);
    }).toList();
  }

  // Método para obtener mensajes por fecha
  List<MessageModel> getMessagesByDate(DateTime date) {
    return _messages.where((message) {
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      final targetDate = DateTime(date.year, date.month, date.day);
      return messageDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  @override
  void dispose() {
    try {
      scrollController.dispose();
      if (_messageBox.isOpen) {
        _messageBox.close();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error during dispose: $e');
      }
    }
    super.dispose();
  }
}
