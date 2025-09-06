import 'package:flutter/material.dart';
import '../../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar si el mensaje es del usuario o de Hermana Esperanza
    final isUserMessage = message.senderId == 'current_user';
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUserMessage 
            ? MainAxisAlignment.end     // Mensajes del usuario a la derecha
            : MainAxisAlignment.start,  // Mensajes de Hermana Esperanza a la izquierda
        children: [
          // Avatar de Hermana Esperanza (solo para sus mensajes)
          if (!isUserMessage) _buildAvatar(),
          
          // Espaciado flexible
          if (!isUserMessage) const SizedBox(width: 8),
          
          // La burbuja del mensaje
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUserMessage 
                    ? const Color(0xFF8D6E63)      // Marrón para usuario
                    : const Color(0xFFFFFFFF),     // Blanco para Hermana Esperanza
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isUserMessage 
                      ? const Radius.circular(20) 
                      : const Radius.circular(4),  // Esquina puntiaguda
                  bottomRight: isUserMessage 
                      ? const Radius.circular(4)   // Esquina puntiaguda
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contenido del mensaje
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isUserMessage ? Colors.white : const Color(0xFF2C1810),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  
                  // Hora del mensaje
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: Colors.grey.withValues(alpha: 0.2),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Espaciado para mensajes del usuario
          if (isUserMessage) const SizedBox(width: 40),
        ],
      ),
    );
  }

  // Avatar redondo para Hermana Esperanza
  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFF8D6E63),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  // Formatear la hora del mensaje
  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
