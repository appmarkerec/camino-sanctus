import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import 'package:flutter/foundation.dart';


class BibleService {
  static const String _baseUrl = ApiConstants.bibleApiBaseUrl;
  
  // Obtener versículo específico
  static Future<Map<String, dynamic>?> getVerse(String reference) async {
    try {
      if (kDebugMode) debugPrint('🔍 Buscando versículo: $reference');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/$reference?translation=${ApiConstants.defaultTranslation}'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (kDebugMode) debugPrint('📡 Respuesta API: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) debugPrint('✅ Versículo encontrado: ${data['text']?.substring(0, 50)}...');
        return data;
      } else {
        if (kDebugMode) debugPrint('❌ Error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('🚨 Error de conexión: $e');
      return null;
    }
  }
  
  // Buscar versículos por tema
  static Future<List<dynamic>> searchVerses(String query) async {
    try {
      if (kDebugMode) debugPrint('🔍 Buscando: "$query"');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/search?q=${Uri.encodeComponent(query)}&translation=${ApiConstants.defaultTranslation}'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final verses = data['verses'] ?? [];
        if (kDebugMode) debugPrint('✅ Encontrados ${verses.length} versículos');
        return verses;
      } else {
        if (kDebugMode) debugPrint('❌ Error en búsqueda: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      if (kDebugMode) debugPrint('🚨 Error de conexión: $e');
      return [];
    }
  }
  
  // Obtener versículo del día
  static Future<Map<String, dynamic>?> getVerseOfTheDay() async {
    // Lista de versículos populares para rotar
    final popularVerses = [
      'Juan 3:16',
      'Filipenses 4:13', 
      'Salmos 23:1',
      'Romanos 8:28',
      'Proverbios 3:5-6'
    ];
    
    final randomIndex = DateTime.now().day % popularVerses.length;
    return await getVerse(popularVerses[randomIndex]);
  }
}
