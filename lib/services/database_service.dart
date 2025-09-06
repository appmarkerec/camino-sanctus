import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/message_model.dart';

class DatabaseService {
  static late Box<MessageModel> _messageBox;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await Hive.initFlutter();

      // Registrar adaptadores si no están registrados
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(MessageModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(MessageTypeAdapter());
      }

      _messageBox = await Hive.openBox<MessageModel>('chat_messages');
      _isInitialized = true;
      
      if (kDebugMode) {
        debugPrint('✅ Database initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Database initialization error: $e');
      }
    }
  }

  // Messages CRUD con IDs correctos
  static Future<void> saveMessage(MessageModel message) async {
    try {
      if (!_isInitialized) await initialize();
      await _messageBox.put(message.id, message); // Usar message.id que ya existe
      if (kDebugMode) {
        debugPrint('💾 Message saved successfully: ${message.id}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error saving message: $e');
      }
    }
  }

  static List<MessageModel> getAllMessages() {
    try {
      if (!_isInitialized) return [];
      final messages = _messageBox.values.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      if (kDebugMode) {
        debugPrint('📥 Retrieved ${messages.length} messages from database');
      }
      
      return messages;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting messages: $e');
      }
      return [];
    }
  }

  static Future<void> deleteMessage(String id) async {
    try {
      if (!_isInitialized) await initialize();
      await _messageBox.delete(id);
      
      if (kDebugMode) {
        debugPrint('🗑️ Message deleted successfully: $id');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error deleting message: $e');
      }
    }
  }

  static Future<void> clearAllMessages() async {
    try {
      if (!_isInitialized) await initialize();
      final count = _messageBox.length;
      await _messageBox.clear();
      
      if (kDebugMode) {
        debugPrint('🧹 Cleared $count messages from database');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error clearing messages: $e');
      }
    }
  }

  // Métodos adicionales mejorados
  static Future<MessageModel?> getMessageById(String id) async {
    try {
      if (!_isInitialized) await initialize();
      return _messageBox.get(id);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting message by ID: $e');
      }
      return null;
    }
  }

  static List<MessageModel> getMessagesByConversation(String conversationId) {
    try {
      if (!_isInitialized) return [];
      
      final messages = _messageBox.values
          .where((message) => message.conversationId == conversationId)
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      if (kDebugMode) {
        debugPrint('📥 Retrieved ${messages.length} messages for conversation: $conversationId');
      }
      
      return messages;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting messages by conversation: $e');
      }
      return [];
    }
  }

  static List<MessageModel> searchMessages(String query) {
    try {
      if (!_isInitialized) return [];
      
      final searchTerm = query.toLowerCase();
      final results = _messageBox.values
          .where((message) => 
              message.content.toLowerCase().contains(searchTerm) ||
              (message.verseReference?.toLowerCase().contains(searchTerm) ?? false))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      if (kDebugMode) {
        debugPrint('🔍 Search for "$query" returned ${results.length} results');
      }
      
      return results;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error searching messages: $e');
      }
      return [];
    }
  }

  static Future<void> updateMessage(MessageModel message) async {
    try {
      if (!_isInitialized) await initialize();
      await _messageBox.put(message.id, message);
      
      if (kDebugMode) {
        debugPrint('✏️ Message updated successfully: ${message.id}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error updating message: $e');
      }
    }
  }

  static int getMessageCount() {
    try {
      if (!_isInitialized) return 0;
      return _messageBox.length;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting message count: $e');
      }
      return 0;
    }
  }

  static Map<String, dynamic> getDatabaseStats() {
    try {
      if (!_isInitialized) {
        return {
          'initialized': false,
          'totalMessages': 0,
          'userMessages': 0,
          'aiMessages': 0,
        };
      }

      final messages = _messageBox.values.toList();
      final userMessages = messages.where((m) => m.senderId == 'current_user');
      final aiMessages = messages.where((m) => m.senderId == 'hermana_esperanza');

      return {
        'initialized': _isInitialized,
        'totalMessages': messages.length,
        'userMessages': userMessages.length,
        'aiMessages': aiMessages.length,
        'messagesWithVerses': messages.where((m) => m.verseReference != null).length,
        'boxPath': _messageBox.path,
        'boxName': _messageBox.name,
      };
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting database stats: $e');
      }
      return {'error': e.toString()};
    }
  }

  static Future<bool> exportData(String filePath) async {
    try {
      if (!_isInitialized) await initialize();
      
      // Esta funcionalidad podría implementarse para exportar datos
      // Por ahora solo retornamos el estado de éxito
      
      if (kDebugMode) {
        debugPrint('📤 Data export requested to: $filePath');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error exporting data: $e');
      }
      return false;
    }
  }

  static Future<void> compactDatabase() async {
    try {
      if (!_isInitialized) await initialize();
      await _messageBox.compact();
      
      if (kDebugMode) {
        debugPrint('🗜️ Database compacted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error compacting database: $e');
      }
    }
  }

  static Future<void> closeDatabase() async {
    try {
      if (_isInitialized && _messageBox.isOpen) {
        await _messageBox.close();
        _isInitialized = false;
        
        if (kDebugMode) {
          debugPrint('🔒 Database closed successfully');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error closing database: $e');
      }
    }
  }

  // Getter para verificar si está inicializado
  static bool get isInitialized => _isInitialized;
  
  // Getter para obtener la box (uso interno)
  static Box<MessageModel> get messageBox {
    if (!_isInitialized) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _messageBox;
  }
}
