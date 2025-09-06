import 'package:hive_flutter/hive_flutter.dart';

part 'message_model.g.dart';

@HiveType(typeId: 0)
class MessageModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  String senderId;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  String conversationId;

  @HiveField(5)
  String type;

  // Campos opcionales para features avanzadas
  @HiveField(6)
  String? verseReference;

  @HiveField(7)
  String? verseText;

  MessageModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.timestamp,
    required this.conversationId,
    required this.type,
    this.verseReference,
    this.verseText,
  });

  // Getters computados (NO serializados por Hive)
  String get text => content;
  bool get isUser => senderId == 'current_user';

  // Factory methods para facilitar la creación
  factory MessageModel.user(String messageContent) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: messageContent,
      senderId: 'current_user',
      timestamp: DateTime.now(),
      conversationId: 'default_conversation',
      type: 'user',
    );
  }

  factory MessageModel.ai(String messageContent, {String? verseRef, String? verseText}) {
    return MessageModel(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      content: messageContent,
      senderId: 'hermana_esperanza',  
      timestamp: DateTime.now(),
      conversationId: 'default_conversation',
      type: 'ai',
      verseReference: verseRef,
      verseText: verseText,
    );
  }

  // Constructor vacío para casos especiales
  factory MessageModel.empty() {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '',
      senderId: '',
      timestamp: DateTime.now(),
      conversationId: '',
      type: 'text',
    );
  }

  // Método para debugging
  @override
  String toString() {
    return 'MessageModel(id: $id, content: $content, senderId: $senderId, type: $type)';
  }

  // Método para clonar el mensaje
  MessageModel copyWith({
    String? id,
    String? content,
    String? senderId,
    DateTime? timestamp,
    String? conversationId,
    String? type,
    String? verseReference,
    String? verseText,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      senderId: senderId ?? this.senderId,
      timestamp: timestamp ?? this.timestamp,
      conversationId: conversationId ?? this.conversationId,
      type: type ?? this.type,
      verseReference: verseReference ?? this.verseReference,
      verseText: verseText ?? this.verseText,
    );
  }
}

@HiveType(typeId: 1)
enum MessageType {
  @HiveField(0)
  text,
  @HiveField(1)
  verse,
  @HiveField(2)
  prayer,
  @HiveField(3)
  question,
}
