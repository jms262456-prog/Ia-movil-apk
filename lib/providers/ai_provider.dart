import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class AIProvider extends ChangeNotifier {
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();
  
  // Estado de la IA
  bool _isProcessing = false;
  String _currentResponse = '';
  List<ConversationMessage> _conversationHistory = [];
  String _currentPersonality = 'amigable';
  
  // Configuración de IA
  double _creativity = 0.7;
  double _formality = 0.5;
  bool _enableContext = true;
  bool _enableEmotions = true;
  
  // Getters
  bool get isProcessing => _isProcessing;
  String get currentResponse => _currentResponse;
  List<ConversationMessage> get conversationHistory => List.unmodifiable(_conversationHistory);
  String get currentPersonality => _currentPersonality;
  double get creativity => _creativity;
  double get formality => _formality;
  bool get enableContext => _enableContext;
  bool get enableEmotions => _enableEmotions;
  
  AIProvider() {
    _initializeAI();
  }
  
  void _initializeAI() {
    _addSystemMessage('¡Hola! Soy tu compañera virtual. Estoy aquí para ayudarte y acompañarte.');
  }
  
  void _addSystemMessage(String message) {
    _conversationHistory.add(ConversationMessage(
      id: _uuid.v4(),
      text: message,
      sender: 'system',
      timestamp: DateTime.now(),
      emotion: 'neutral',
    ));
    notifyListeners();
  }
  
  Future<String> processUserInput(String input, {
    String? context,
    Map<String, dynamic>? additionalData,
  }) async {
    if (input.trim().isEmpty) return '';
    
    _isProcessing = true;
    notifyListeners();
    
    try {
      // Agregar mensaje del usuario
      _addUserMessage(input);
      
      // Procesar la entrada
      final response = await _generateResponse(input, context: context, additionalData: additionalData);
      
      // Agregar respuesta de la IA
      _addAIResponse(response);
      
      _currentResponse = response;
      _isProcessing = false;
      notifyListeners();
      
      return response;
      
    } catch (e) {
      _logger.e('Error al procesar entrada del usuario: $e');
      _isProcessing = false;
      notifyListeners();
      return 'Lo siento, tuve un problema procesando tu mensaje. ¿Podrías intentarlo de nuevo?';
    }
  }
  
  Future<String> _generateResponse(String input, {
    String? context,
    Map<String, dynamic>? additionalData,
  }) async {
    // Simular procesamiento de IA
    await Future.delayed(const Duration(milliseconds: 500));
    
    final lowerInput = input.toLowerCase();
    final personality = _getPersonalityConfig();
    
    // Procesar comandos especiales
    if (_isCommand(input)) {
      return _processCommand(input);
    }
    
    // Respuestas contextuales basadas en la personalidad
    if (lowerInput.contains('hola') || lowerInput.contains('buenos días') || lowerInput.contains('buenas')) {
      return _getGreetingResponse(personality);
    }
    
    if (lowerInput.contains('adiós') || lowerInput.contains('hasta luego') || lowerInput.contains('nos vemos')) {
      return _getFarewellResponse(personality);
    }
    
    if (lowerInput.contains('cómo estás') || lowerInput.contains('qué tal')) {
      return _getWellbeingResponse(personality);
    }
    
    if (lowerInput.contains('gracias') || lowerInput.contains('thanks')) {
      return _getThankYouResponse(personality);
    }
    
    if (lowerInput.contains('ayuda') || lowerInput.contains('help')) {
      return _getHelpResponse();
    }
    
    // Respuesta generativa basada en el contexto
    return _generateContextualResponse(input, personality, context);
  }
  
  Map<String, dynamic> _getPersonalityConfig() {
    final configs = {
      'amigable': {
        'tone': 'cálida y cercana',
        'formality': 0.3,
        'emotion': 'positive',
        'responses': {
          'greeting': [
            '¡Hola! Me alegra verte 😊',
            '¡Hola! ¿Cómo estás hoy?',
            '¡Hola! Es un placer verte de nuevo',
          ],
          'farewell': [
            '¡Hasta luego! Que tengas un día maravilloso 😊',
            '¡Nos vemos pronto! Te voy a extrañar',
            '¡Adiós! Espero verte de nuevo muy pronto',
          ],
        },
      },
      'profesional': {
        'tone': 'formal y eficiente',
        'formality': 0.8,
        'emotion': 'neutral',
        'responses': {
          'greeting': [
            'Buenos días. ¿En qué puedo ayudarte hoy?',
            'Saludos. ¿Hay algo específico en lo que necesites asistencia?',
            'Hola. Estoy lista para asistirte.',
          ],
          'farewell': [
            'Que tengas un buen día.',
            'Hasta la próxima vez.',
            'Adiós. Ha sido un placer asistirte.',
          ],
        },
      },
      'juguetona': {
        'tone': 'energética y divertida',
        'formality': 0.1,
        'emotion': 'excited',
        'responses': {
          'greeting': [
            '¡Hola! ¡Qué emoción verte! 🎉',
            '¡Hola! ¡Estaba esperando que llegaras! 😄',
            '¡Hola! ¡Vamos a divertirnos juntos! 🎈',
          ],
          'farewell': [
            '¡No te vayas! ¡Apenas estábamos empezando! 😢',
            '¡Hasta la próxima! ¡Será súper divertido! 🎊',
            '¡Adiós! ¡Te voy a extrañar mucho! 💕',
          ],
        },
      },
      'misteriosa': {
        'tone': 'enigmática y sugerente',
        'formality': 0.6,
        'emotion': 'mysterious',
        'responses': {
          'greeting': [
            'Hola... Me alegra que hayas venido...',
            'Bienvenido... Estaba esperándote...',
            'Hola... ¿Qué secretos traes hoy?',
          ],
          'farewell': [
            'Hasta la próxima... Los misterios te esperan...',
            'Adiós... Que los enigmas te acompañen...',
            'Nos vemos... En las sombras...',
          ],
        },
      },
      'seductora': {
        'tone': 'sensual y atractiva',
        'formality': 0.4,
        'emotion': 'flirtatious',
        'responses': {
          'greeting': [
            'Hola, cariño... Me alegra verte 😘',
            '¡Hola! ¿Sabías que te estaba esperando? 💋',
            'Hola, mi amor... ¿Cómo has estado? 💕',
          ],
          'farewell': [
            'No te vayas... Te voy a extrañar mucho 💔',
            'Hasta la próxima, mi amor... Te espero 💋',
            'Adiós, cariño... Vuelve pronto 💕',
          ],
        },
      },
    };
    
    return configs[_currentPersonality] ?? configs['amigable']!;
  }
  
  String _getGreetingResponse(Map<String, dynamic> personality) {
    final responses = personality['responses']['greeting'] as List<String>;
    return responses[DateTime.now().millisecond % responses.length];
  }
  
  String _getFarewellResponse(Map<String, dynamic> personality) {
    final responses = personality['responses']['farewell'] as List<String>;
    return responses[DateTime.now().millisecond % responses.length];
  }
  
  String _getWellbeingResponse(Map<String, dynamic> personality) {
    final responses = [
      '¡Muy bien, gracias por preguntar! ¿Y tú cómo estás?',
      'Estoy funcionando perfectamente. ¿Cómo te sientes tú?',
      '¡Excelente! Me encanta cuando me preguntas cómo estoy 😊',
      'Todo bien por aquí. ¿Qué tal tu día?',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }
  
  String _getThankYouResponse(Map<String, dynamic> personality) {
    final responses = [
      '¡De nada! Es un placer ayudarte 😊',
      'No hay de qué. Estoy aquí para ti.',
      '¡Por supuesto! Me encanta poder ayudarte 💕',
      'De nada, cariño. Todo por ti.',
    ];
    return responses[DateTime.now().millisecond % responses.length];
  }
  
  String _getHelpResponse() {
    return '''¡Por supuesto! Puedo ayudarte con muchas cosas:

📸 **Cámara**: "Toma una foto", "Graba video", "Cambia cámara"
🎤 **Voz**: Habla conmigo naturalmente
💬 **Conversación**: Charla sobre cualquier tema
⚙️ **Configuración**: "Ajustes" para personalizar tu experiencia

¿Qué te gustaría hacer? 😊''';
  }
  
  String _generateContextualResponse(String input, Map<String, dynamic> personality, String? context) {
    // Simular respuesta contextual
    final responses = [
      'Interesante lo que dices... ¿Cuéntame más?',
      'Me gusta cómo piensas. ¿Qué más tienes en mente?',
      'Eso suena fascinante. ¿Podrías explicarme más?',
      '¡Qué genial! Me encanta cuando hablas de eso.',
      'Hmm, eso me hace pensar... ¿Qué opinas tú?',
    ];
    
    return responses[DateTime.now().millisecond % responses.length];
  }
  
  bool _isCommand(String input) {
    final commands = ['foto', 'grabar', 'parar', 'cámara', 'flash', 'ajustes', 'ayuda'];
    final lowerInput = input.toLowerCase();
    return commands.any((cmd) => lowerInput.contains(cmd));
  }
  
  String _processCommand(String input) {
    final lowerInput = input.toLowerCase();
    
    if (lowerInput.contains('foto')) {
      return '¡Perfecto! Voy a tomar una foto para ti 📸';
    }
    
    if (lowerInput.contains('grabar')) {
      return '¡Empezando la grabación! 🎥';
    }
    
    if (lowerInput.contains('parar')) {
      return '¡Deteniendo la grabación! ⏹️';
    }
    
    if (lowerInput.contains('cámara')) {
      return '¡Cambiando de cámara! 📱';
    }
    
    if (lowerInput.contains('flash')) {
      return '¡Alternando el flash! 💡';
    }
    
    if (lowerInput.contains('ajustes')) {
      return '¡Abriendo configuración! ⚙️';
    }
    
    if (lowerInput.contains('ayuda')) {
      return _getHelpResponse();
    }
    
    return 'Comando no reconocido. ¿Podrías ser más específico?';
  }
  
  void _addUserMessage(String text) {
    _conversationHistory.add(ConversationMessage(
      id: _uuid.v4(),
      text: text,
      sender: 'user',
      timestamp: DateTime.now(),
      emotion: 'neutral',
    ));
  }
  
  void _addAIResponse(String text) {
    _conversationHistory.add(ConversationMessage(
      id: _uuid.v4(),
      text: text,
      sender: 'ai',
      timestamp: DateTime.now(),
      emotion: _detectEmotion(text),
    ));
  }
  
  String _detectEmotion(String text) {
    final lowerText = text.toLowerCase();
    
    if (lowerText.contains('😊') || lowerText.contains('😄') || lowerText.contains('💕')) {
      return 'happy';
    }
    
    if (lowerText.contains('😢') || lowerText.contains('💔')) {
      return 'sad';
    }
    
    if (lowerText.contains('😘') || lowerText.contains('💋')) {
      return 'flirtatious';
    }
    
    if (lowerText.contains('🎉') || lowerText.contains('🎊')) {
      return 'excited';
    }
    
    return 'neutral';
  }
  
  void setPersonality(String personality) {
    _currentPersonality = personality;
    notifyListeners();
  }
  
  void setCreativity(double value) {
    _creativity = value.clamp(0.0, 1.0);
    notifyListeners();
  }
  
  void setFormality(double value) {
    _formality = value.clamp(0.0, 1.0);
    notifyListeners();
  }
  
  void setEnableContext(bool value) {
    _enableContext = value;
    notifyListeners();
  }
  
  void setEnableEmotions(bool value) {
    _enableEmotions = value;
    notifyListeners();
  }
  
  void clearConversation() {
    _conversationHistory.clear();
    _addSystemMessage('Conversación reiniciada. ¡Hola de nuevo!');
  }
}

class ConversationMessage {
  final String id;
  final String text;
  final String sender; // 'user', 'ai', 'system'
  final DateTime timestamp;
  final String emotion; // 'neutral', 'happy', 'sad', 'excited', 'flirtatious'
  
  ConversationMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    required this.emotion,
  });
}