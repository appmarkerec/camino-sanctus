import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../core/constants/api_constants.dart';

class VoiceService {
  static final FlutterTts _tts = FlutterTts();
  static final SpeechToText _speech = SpeechToText();
  static bool _isListening = false;
  static bool _isInitialized = false;
  static bool _isSpeaking = false;

  // Inicializar servicios de voz
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configurar TTS con configuración avanzada
      await _configureTTS();
      
      // Inicializar Speech Recognition con manejo mejorado de errores
      _isInitialized = await _speech.initialize(
        onError: (error) {
          if (kDebugMode) {
            debugPrint('❌ Speech recognition error: ${error.errorMsg}');
          }
          _isListening = false;
        },
        onStatus: (status) {
          if (kDebugMode) {
            debugPrint('🎤 Speech recognition status: $status');
          }
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
          }
        },
      );

      if (kDebugMode) {
        debugPrint('✅ Voice services initialized successfully');
        debugPrint('🎤 Speech available: ${_speech.isAvailable}');
        debugPrint('🔊 TTS languages: ${await _tts.getLanguages}');
      }
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error initializing voice services: $e');
      }
      _isInitialized = false;
    }
  }

  static Future<void> _configureTTS() async {
    try {
      // Configuración básica de TTS
      await _tts.setLanguage(ApiConstants.defaultVoiceLocale);
      await _tts.setSpeechRate(ApiConstants.defaultSpeechRate);
      await _tts.setPitch(ApiConstants.defaultPitch);
      
      // Configuraciones adicionales
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(true);
      
      // Callbacks para monitorear el estado del TTS
      _tts.setStartHandler(() {
        _isSpeaking = true;
        if (kDebugMode) {
          debugPrint('🔊 TTS started speaking');
        }
      });
      
      _tts.setCompletionHandler(() {
        _isSpeaking = false;
        if (kDebugMode) {
          debugPrint('🔊 TTS finished speaking');
        }
      });
      
      _tts.setErrorHandler((msg) {
        _isSpeaking = false;
        if (kDebugMode) {
          debugPrint('❌ TTS error: $msg');
        }
      });
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error configuring TTS: $e');
      }
    }
  }

  // Hablar texto con validaciones mejoradas
  static Future<void> speak(String text) async {
    if (text.trim().isEmpty) {
      if (kDebugMode) {
        debugPrint('⚠️ Cannot speak empty text');
      }
      return;
    }

    try {
      if (!_isInitialized) await initialize();
      
      // Detener habla anterior si está en progreso
      if (_isSpeaking) {
        await stop();
      }
      
      await _tts.speak(text.trim());
      
      if (kDebugMode) {
        debugPrint('🔊 Speaking: "${text.substring(0, text.length > 50 ? 50 : text.length)}${text.length > 50 ? '...' : ''}"');
      }
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error speaking: $e');
      }
    }
  }

  // Detener habla
  static Future<void> stop() async {
    try {
      if (_isSpeaking) {
        await _tts.stop();
        _isSpeaking = false;
        
        if (kDebugMode) {
          debugPrint('🔇 TTS stopped');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error stopping speech: $e');
      }
    }
  }

  // Pausar habla
  static Future<void> pause() async {
    try {
      if (_isSpeaking) {
        await _tts.pause();
        
        if (kDebugMode) {
          debugPrint('⏸️ TTS paused');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error pausing speech: $e');
      }
    }
  }

  // Iniciar escucha con configuración mejorada
  static Future<void> startListening({
    required Function(String) onResult,
    Function(String)? onPartialResult,
    Function(String)? onError,
    Duration? listenFor,
    Duration? pauseFor,
    String? localeId,
  }) async {
    try {
      if (!_isInitialized) await initialize();
      
      if (!_speech.isAvailable) {
        if (kDebugMode) {
          debugPrint('❌ Speech recognition not available');
        }
        onError?.call('Speech recognition not available');
        return;
      }

      if (_isListening) {
        if (kDebugMode) {
          debugPrint('⚠️ Already listening, stopping previous session');
        }
        await stopListening();
      }

      _isListening = true;
      
      // BLOQUE ACTUALIZADO CON LA NUEVA API
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
            if (kDebugMode) {
              debugPrint('🎤 Final result: "${result.recognizedWords}"');
            }
          } else if (onPartialResult != null) {
            onPartialResult(result.recognizedWords);
            if (kDebugMode) {
              debugPrint('🎤 Partial result: "${result.recognizedWords}"');
            }
          }
        },
        listenFor: listenFor ?? const Duration(seconds: 30),
        pauseFor: pauseFor ?? const Duration(seconds: 3),
        localeId: localeId ?? 'es_ES',
        listenOptions: SpeechListenOptions(
          partialResults: onPartialResult != null,
          cancelOnError: false,
          listenMode: ListenMode.confirmation,
        ),
      );

      if (kDebugMode) {
        debugPrint('🎤 Started listening (locale: ${localeId ?? 'es_ES'})');
      }
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error starting listening: $e');
      }
      _isListening = false;
      onError?.call(e.toString());
    }
  }

  // Detener escucha
  static Future<void> stopListening() async {
    try {
      if (_isListening) {
        _isListening = false;
        await _speech.stop();
        
        if (kDebugMode) {
          debugPrint('🔇 Stopped listening');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error stopping listening: $e');
      }
    }
  }

  // Cancelar escucha (más agresivo que stop)
  static Future<void> cancelListening() async {
    try {
      if (_isListening) {
        _isListening = false;
        await _speech.cancel();
        
        if (kDebugMode) {
          debugPrint('❌ Cancelled listening');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error cancelling listening: $e');
      }
    }
  }

  // Métodos de configuración avanzada
  static Future<void> setLanguage(String language) async {
    try {
      await _tts.setLanguage(language);
      if (kDebugMode) {
        debugPrint('🌐 TTS language set to: $language');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error setting language: $e');
      }
    }
  }

  static Future<void> setSpeechRate(double rate) async {
    try {
      await _tts.setSpeechRate(rate);
      if (kDebugMode) {
        debugPrint('⚡ TTS speech rate set to: $rate');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error setting speech rate: $e');
      }
    }
  }

  static Future<void> setPitch(double pitch) async {
    try {
      await _tts.setPitch(pitch);
      if (kDebugMode) {
        debugPrint('🎵 TTS pitch set to: $pitch');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error setting pitch: $e');
      }
    }
  }

  static Future<void> setVolume(double volume) async {
    try {
      await _tts.setVolume(volume);
      if (kDebugMode) {
        debugPrint('🔊 TTS volume set to: $volume');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error setting volume: $e');
      }
    }
  }

  // Obtener idiomas disponibles para TTS
  static Future<List<dynamic>> getAvailableLanguages() async {
    try {
      final languages = await _tts.getLanguages;
      if (kDebugMode) {
        debugPrint('🌐 Available TTS languages: ${languages.length}');
      }
      return languages;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting available languages: $e');
      }
      return [];
    }
  }

  // Obtener voces disponibles
  static Future<List<dynamic>> getAvailableVoices() async {
    try {
      final voices = await _tts.getVoices;
      if (kDebugMode) {
        debugPrint('🎭 Available TTS voices: ${voices.length}');
      }
      return voices;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting available voices: $e');
      }
      return [];
    }
  }

  // Obtener locales disponibles para Speech-to-Text
  static Future<List<LocaleName>> getAvailableLocales() async {
    try {
      if (!_isInitialized) await initialize();
      final locales = await _speech.locales();
      if (kDebugMode) {
        debugPrint('🎤 Available STT locales: ${locales.length}');
      }
      return locales;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting available locales: $e');
      }
      return [];
    }
  }

  // Obtener estado del servicio
  static Map<String, dynamic> getServiceStatus() {
    return {
      'initialized': _isInitialized,
      'isListening': _isListening,
      'isSpeaking': _isSpeaking,
      'speechAvailable': _speech.isAvailable,
      'hasPermission': _speech.hasPermission,
      'lastError': _speech.lastError?.errorMsg,
    };
  }

  // Verificar permisos
  static Future<bool> checkPermissions() async {
    try {
      if (!_isInitialized) await initialize();
      final hasPermission = await _speech.hasPermission;
      
      if (kDebugMode) {
        debugPrint('🔐 Microphone permission: $hasPermission');
      }
      
      return hasPermission;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error checking permissions: $e');
      }
      return false;
    }
  }

  // Limpiar recursos
  static Future<void> dispose() async {
    try {
      await stop();
      await stopListening();
      _isInitialized = false;
      _isListening = false;
      _isSpeaking = false;
      
      if (kDebugMode) {
        debugPrint('🧹 Voice service disposed');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error disposing voice service: $e');
      }
    }
  }

  // Getters mejorados
  static bool get isListening => _isListening;
  static bool get isInitialized => _isInitialized;
  static bool get isAvailable => _speech.isAvailable;
  static bool get isSpeaking => _isSpeaking;
  static Future<bool> get hasPermission async {
    if (!_isInitialized) await initialize();
    return await _speech.hasPermission;
  }  
  static String? get lastError => _speech.lastError?.errorMsg;

  // Método de utilidad para leer versículos bíblicos
  static Future<void> speakVerse(String verseText, String reference) async {
    final textToSpeak = 'Versículo bíblico: $reference. $verseText';
    await speak(textToSpeak);
  }

  // Método para leer respuestas de AI con formato mejorado
  static Future<void> speakAIResponse(String response) async {
    // Limpiar texto de markdown y emojis para mejor pronunciación
    String cleanText = response
        .replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'\1') // Remove bold markdown
        .replaceAll(RegExp(r'\*([^*]+)\*'), r'\1') // Remove italic markdown
        .replaceAll(RegExp(r'#{1,6}\s+'), '') // Remove headers
        .replaceAll(RegExp(r'[📖📚🙏✨❤️⛪🕊️💡]'), '') // Remove common emojis
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
        .trim();
    
    await speak(cleanText);
  }

  // Método adicional para configuración rápida en español
  static Future<void> configureForSpanish() async {
    try {
      await setLanguage('es-ES');
      await setSpeechRate(0.5);
      await setPitch(1.0);
      await setVolume(1.0);
      
      if (kDebugMode) {
        debugPrint('🇪🇸 Voice service configured for Spanish');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error configuring for Spanish: $e');
      }
    }
  }

  // Método para escucha rápida en español (compatible con tu app)
  static Future<void> quickSpanishListen({
    required Function(String) onResult,
    Function(String)? onPartialResult,
    Function(String)? onError,
  }) async {
    await startListening(
      onResult: onResult,
      onPartialResult: onPartialResult,
      onError: onError,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'es_ES',
    );
  }
}
