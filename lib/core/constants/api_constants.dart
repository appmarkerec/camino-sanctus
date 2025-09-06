import '../../config/secrets.dart';

class ApiConstants {
  // Gemini API usando secrets
  static const String geminiApiKey = Secrets.geminiApiKey;
  
  // Free Use Bible API - SIN LÍMITES, SIN AUTENTICACIÓN  
  static const String bibleApiBaseUrl = 'https://bible.helloao.org/api';
  
  // App constants
  static const String appName = 'Camino Sanctus';
  static const String defaultLanguage = 'es_ES';
  static const String defaultTranslation = 'RVR1960'; // ← ESTA LÍNEA FALTABA
  
  // Endpoints específicos
  static const String verseEndpoint = '/verse';
  static const String searchEndpoint = '/search';
  
  // Voice settings
  static const double defaultSpeechRate = 0.5;
  static const double defaultPitch = 1.0;
  static const String defaultVoiceLocale = 'es-ES';
  
  // App settings
  static const int maxMessagesHistory = 100;
  static const Duration responseTimeout = Duration(seconds: 30);
}
