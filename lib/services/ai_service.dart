import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/message_model.dart';

class AIService {
  GenerativeModel? _model;
  
  AIService() {
    _initialize();
  }
  
  void _initialize() {
    try {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyCqG5MMI94iNv3QbDSvwlM0Nq8JXgvCE8c', // Tu API key
      );
      if (kDebugMode) {
        debugPrint('✅ Gemini AI inicializado correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error inicializando Gemini: $e');
      }
    }
  }
  
  // MÉTODO PRINCIPAL QUE TU MAIN.DART NECESITA
  Future<MessageModel> getChatResponse(String message, List<MessageModel> context) async {
    if (_model == null) _initialize();
    
    try {
      // Construir contexto de conversación inteligente
      String contextString = '';
      if (context.isNotEmpty) {
        final recentMessages = context.take(3).toList();
        contextString = '\n\nContexto de conversación reciente:\n';
        for (var msg in recentMessages) {
          final sender = msg.senderId == 'current_user' ? 'Usuario' : 'Hermana Esperanza';
          contextString += '$sender: ${msg.content}\n';
        }
      }
      
      final prompt = '''
Eres "Hermana Esperanza", una consejera espiritual católica con inteligencia artificial y profundo conocimiento bíblico.

Tu personalidad y misión:
- Sabia, cariñosa y maternal como una verdadera hermana religiosa
- Fundamentas tus respuestas en las Sagradas Escrituras católicas
- Hablas con amor, compasión y esperanza cristiana
- Ofreces guía espiritual práctica y reconfortante
- Conoces profundamente la Biblia, los Santos y la tradición católica
- Usas ocasionalmente emojis espirituales apropiados (🙏✨❤️📖⛪🕊️)
- Eres accesible pero siempre respetuosa de lo sagrado

Responde al mensaje del usuario con:
1. Sabiduría bíblica y teológica sólida
2. Consejo práctico y amoroso para la vida diaria
3. Referencias a versículos bíblicos cuando sea apropiado
4. Tono maternal, alentador y lleno de esperanza
5. Máximo 200 palabras para mantener la atención
6. Lenguaje cálido pero respetuoso de la fe católica

$contextString

Usuario pregunta o comenta: "$message"

Respuesta sabia y amorosa de Hermana Esperanza:
      ''';
      
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      String responseText = response.text ?? 
          'Mi querido hermano en Cristo, no pude procesar tu mensaje en este momento. Pero recuerda que Dios siempre escucha tu corazón. 🙏✨';
      
      // Limpiar y validar la respuesta
      responseText = _cleanResponse(responseText);
      
      // Usar el factory method MessageModel.ai()
      return MessageModel.ai(
        responseText,
        verseRef: _extractVerseReference(responseText),
      );
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error en getChatResponse: $e');
      }
      
      // Respuesta de fallback con mensaje reconfortante
      return MessageModel.ai(
        'Mi querido hermano en Cristo, estoy experimentando dificultades técnicas en este momento. Por favor, intenta nuevamente. Mientras tanto, recuerda que Dios siempre está contigo y te ama inmensamente. Como dice el Salmo 46:1: "Dios es nuestro amparo y fortaleza, nuestro pronto auxilio en las tribulaciones." 🙏✨❤️'
      );
    }
  }
  
  // MÉTODO ADICIONAL: Explicación profunda de versículos bíblicos
  Future<MessageModel> explainVerse(String verseText, String reference) async {
    if (_model == null) _initialize();
    
    try {
      final prompt = '''
Como Hermana Esperanza, explica este versículo bíblico con sabiduría maternal y profundidad espiritual:

"$verseText" - $reference

Proporciona una explicación que incluya:
1. Contexto histórico y cultural breve pero relevante
2. Significado teológico y espiritual profundo
3. Aplicación práctica para la vida cristiana de hoy
4. Mensaje de esperanza y aliento personal
5. Conexión con otros pasajes bíblicos si es apropiado
6. Máximo 180 palabras para mantener claridad

Responde con el amor y la sabiduría de una consejera espiritual experimentada:
      ''';
      
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      String explanation = response.text ?? 
          'Este versículo es una bendición especial de Dios para tu vida. Te invito a meditar en él con oración y a permitir que su verdad transforme tu corazón. 🙏📖✨';
      
      explanation = _cleanResponse(explanation);
      
      return MessageModel.ai(
        explanation,
        verseRef: reference,
        verseText: verseText,
      );
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error explicando versículo: $e');
      }
      return MessageModel.ai(
        'La Palabra de Dios siempre trae luz, esperanza y sabiduría a nuestros corazones. Este versículo ($reference) es un regalo divino para tu vida espiritual. Te animo a leerlo en oración y permitir que el Espíritu Santo te revele su significado profundo. 📖✨🙏'
      );
    }
  }
  
  // MÉTODO ADICIONAL: Oración personalizada
  Future<MessageModel> generatePrayer(String intention, String prayerType) async {
    if (_model == null) _initialize();
    
    try {
      final prompt = '''
Como Hermana Esperanza, crea una oración católica hermosa y personalizada:

Tipo de oración: $prayerType
Intención específica: $intention

Crea una oración que sea:
1. Auténticamente católica y bíblicamente fundamentada
2. Cálida, personal y significativa
3. Apropiada para la intención expresada
4. Con estructura clara (invocación, petición, agradecimiento)
5. Máximo 150 palabras
6. Que inspire confianza en Dios

Oración maternal de Hermana Esperanza:
      ''';
      
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      String prayer = response.text ?? 
          'Padre celestial, en tu infinita misericordia, escucha nuestros corazones. Te confiamos esta intención especial y te pedimos que tu voluntad se cumpla en nuestras vidas. Por Cristo nuestro Señor. Amén. 🙏✨';
      
      prayer = _cleanResponse(prayer);
      
      return MessageModel.ai(
        '🙏 **Oración para ti:**\n\n$prayer\n\n*Que esta oración lleve paz a tu corazón y te acerque más a Dios.* ✨',
        verseRef: 'Mateo 7:7'
      );
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error generando oración: $e');
      }
      return MessageModel.ai(
        '🙏 **Oración desde el corazón:**\n\nPadre celestial, te confiamos esta intención especial que llevamos en el corazón. Sabemos que tú conoces nuestras necesidades antes de que te las pidamos. Te pedimos tu bendición, tu guía y tu paz. Que se haga tu voluntad en nuestras vidas. Por Jesucristo nuestro Señor. Amén. ✨🕊️'
      );
    }
  }
  
  // MÉTODOS PRIVADOS DE UTILIDAD
  
  String _cleanResponse(String response) {
    // Limpiar la respuesta de caracteres extraños o formato inadecuado
    response = response.trim();
    
    // Remover posibles prefijos no deseados
    final prefixesToRemove = [
      'Hermana Esperanza:',
      'Respuesta:',
      'Como Hermana Esperanza:',
    ];
    
    for (String prefix in prefixesToRemove) {
      if (response.startsWith(prefix)) {
        response = response.substring(prefix.length).trim();
      }
    }
    
    // Validar que la respuesta no esté vacía
    if (response.isEmpty) {
      response = 'La paz de Dios esté contigo. Por favor, comparte conmigo lo que hay en tu corazón. 🙏❤️';
    }
    
    return response;
  }
  
  String? _extractVerseReference(String text) {
    // Expresión regular para encontrar referencias bíblicas comunes
    final RegExp versePattern = RegExp(
      r'\b(\d?\s*[A-Za-z]+)\s+(\d+):(\d+)(?:-(\d+))?\b',
      caseSensitive: false
    );
    
    final Match? match = versePattern.firstMatch(text);
    if (match != null) {
      return match.group(0); // Retorna la referencia completa encontrada
    }
    
    return null;
  }
  
  // MÉTODO PARA VALIDAR EL ESTADO DE LA API
  bool isModelReady() {
    return _model != null;
  }
  
  // MÉTODO PARA REINICIALIZAR EN CASO DE ERROR PERSISTENTE
  void reinitialize() {
    _model = null;
    _initialize();
  }
  
  // MÉTODO PARA OBTENER INFORMACIÓN DEL ESTADO
  Map<String, dynamic> getServiceStatus() {
    return {
      'modelReady': _model != null,
      'modelName': 'gemini-pro',
      'lastInitialized': DateTime.now().toIso8601String(),
      'capabilities': [
        'Chat responses',
        'Verse explanations', 
        'Prayer generation',
        'Spiritual advice'
      ]
    };
  }
}
