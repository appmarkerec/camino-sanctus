import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;

  const ChatInputField({
    super.key,
    required this.onSendMessage,
    required this.isLoading,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Campo de texto expandible
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5DC),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
              ),
              child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null, // Permite múltiples líneas
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Escribe tu mensaje a Hermana Esperanza...',
                  hintStyle: TextStyle(
                    color: Color(0xFF8D6E63),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2C1810),
                ),
                // Enviar mensaje al presionar Enter
                onFieldSubmitted: (value) => _sendMessage(),
                enabled: !widget.isLoading, // Deshabilitado mientras carga
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Botón de enviar
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF8D6E63),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                widget.isLoading ? Icons.hourglass_empty : Icons.send,
                color: Colors.white,
              ),
              onPressed: widget.isLoading ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
      _focusNode.requestFocus(); // Mantener el cursor en el campo
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
