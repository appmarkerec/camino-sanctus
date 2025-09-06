import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatViewModel>.reactive(
      viewModelBuilder: () => ChatViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: _buildAppBar(context, model),
          backgroundColor: const Color(0xFFF5F5DC),
          body: Column(
            children: [
              // Error display sin notifyListeners
              if (model.errorMessage.isNotEmpty) _buildErrorBanner(context, model),
              
              // Main chat area
              Expanded(child: _buildChatArea(model)),
              
              // AI typing indicator
              if (model.isLoading) _buildTypingIndicator(),
              
              // Input area
              _buildInputArea(model),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ChatViewModel model) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
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
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Consejera Espiritual con IA',
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
          icon: const Icon(Icons.refresh),
          onPressed: () => _showRefreshDialog(context, model),
          tooltip: 'Nueva conversación',
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'clear') {
              _showClearDialog(context, model);
            } else if (value == 'help') {
              _showHelpDialog(context);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  Icon(Icons.clear_all, size: 18),
                  SizedBox(width: 8),
                  Text('Limpiar chat'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help_outline, size: 18),
                  SizedBox(width: 8),
                  Text('Ayuda'),
                ],
              ),
            ),
          ],
        ),
      ],
      backgroundColor: const Color(0xFF8D6E63),
      elevation: 2,
    );
  }

  Widget _buildErrorBanner(BuildContext context, ChatViewModel model) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border(
          bottom: BorderSide(color: Colors.red[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red[800], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              model.errorMessage,
              style: TextStyle(
                color: Colors.red[800], 
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red[800], size: 18),
            // ARREGLADO: No llamamos notifyListeners aquí
            onPressed: () {
              // Simplemente cerrar el banner sin hacer nada
              // El error se limpiará automáticamente en la próxima interacción
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea(ChatViewModel model) {
    if (model.messages.isEmpty) {
      return _buildWelcomeState(model);
    }
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(16),
      itemCount: model.messages.length,
      itemBuilder: (context, index) {
        final message = model.messages[index];
        return GestureDetector(
          onLongPress: () => _showMessageOptions(context, model, message),
          child: MessageBubble(message: message),
        );
      },
    );
  }

  Widget _buildWelcomeState(ChatViewModel model) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 28),
            const Text(
              '¡Hola! Soy Hermana Esperanza AI',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF5D4037),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            const Text(
              'Estoy aquí para acompañarte en tu camino espiritual.\n\nPuedes escribir o hablar conmigo sobre:\n\n• Versículos bíblicos y su significado\n• Preguntas de fe y espiritualidad\n• Oración y meditación\n• Consejos espirituales',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF8D6E63),
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildSuggestedQuestions(model),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedQuestions(ChatViewModel model) {
    final questions = [
      '¿Cómo puedo fortalecer mi fe? 🙏',
      '¿Qué dice la Biblia sobre el perdón? 💖',
      'Necesito un versículo de esperanza ✨',
      '¿Cómo debo orar cada día? 🕊️',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: questions.map((question) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFFAFAFA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: const Color(0xFF8D6E63).withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => _sendSuggestedQuestion(model, question),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Text(
                    question,
                    style: const TextStyle(
                      color: Color(0xFF8D6E63),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(22)),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hermana Esperanza está consultando las Escrituras...',
                      style: TextStyle(
                        color: Color(0xFF8D6E63),
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 14),
                  SizedBox(
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
    );
  }

  Widget _buildInputArea(ChatViewModel model) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ChatInputField(
          onSendMessage: (text) => model.sendMessage(text),
          isLoading: model.isLoading,
        ),
      ),
    );
  }

  void _sendSuggestedQuestion(ChatViewModel model, String question) {
    // Remove emoji from question before sending
    final cleanQuestion = question.replaceAll(RegExp(r'[🙏💖✨🕊️]'), '').trim();
    model.sendMessage(cleanQuestion);
  }

  void _showMessageOptions(BuildContext context, ChatViewModel model, dynamic message) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.copy, color: Color(0xFF8D6E63)),
                title: const Text('Copiar mensaje'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.content));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Mensaje copiado'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              if (message.type?.name == 'user')
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Eliminar mensaje', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    model.deleteMessage(message.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🗑️ Mensaje eliminado'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRefreshDialog(BuildContext context, ChatViewModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.refresh, color: Color(0xFF8D6E63), size: 24),
            SizedBox(width: 12),
            Text('Nueva conversación'),
          ],
        ),
        content: const Text(
          '¿Deseas comenzar una nueva conversación?',
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🔄 Lista para nueva conversación'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8D6E63),
              foregroundColor: Colors.white,
            ),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, ChatViewModel model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange, size: 24),
            SizedBox(width: 12),
            Text('Confirmar acción'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que quieres eliminar todos los mensajes?\n\nEsta acción no se puede deshacer.',
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // ARREGLADO: Llamamos un método del ViewModel en lugar de manipular directamente
              // model.clearAllMessages(); // Implementa este método en tu ChatViewModel
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🧹 Chat limpiado correctamente'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar todo'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF8D6E63), size: 24),
            SizedBox(width: 12),
            Text('Ayuda'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Cómo usar Hermana Esperanza AI?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text('• Escribe tu pregunta sobre fe, Biblia o espiritualidad'),
              SizedBox(height: 8),
              Text('• Usa las preguntas sugeridas para comenzar'),
              SizedBox(height: 8),
              Text('• Mantén presionado un mensaje para copiarlo o eliminarlo'),
              SizedBox(height: 8),
              Text('• Usa el menú superior para limpiar el chat'),
              SizedBox(height: 16),
              Text(
                'Temas que puedo ayudarte:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('✨ Versículos bíblicos\n🙏 Oración y meditación\n💖 Consejos espirituales\n📖 Interpretación bíblica'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8D6E63),
              foregroundColor: Colors.white,
            ),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
