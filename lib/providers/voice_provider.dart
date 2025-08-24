import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

class VoiceProvider extends ChangeNotifier {
  final Logger _logger = Logger();
  
  // Speech to Text
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = '';
  double _confidence = 0.0;
  
  // Text to Speech
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  String _currentText = '';
  
  // Configuración
  String _language = 'es-ES';
  double _volume = 0.8;
  double _rate = 0.5;
  double _pitch = 1.0;
  
  // Getters
  bool get speechEnabled => _speechEnabled;
  bool get isListening => _isListening;
  String get lastWords => _lastWords;
  double get confidence => _confidence;
  bool get isSpeaking => _isSpeaking;
  String get currentText => _currentText;
  String get language => _language;
  double get volume => _volume;
  double get rate => _rate;
  double get pitch => _pitch;
  
  VoiceProvider() {
    _initializeSpeech();
    _initializeTts();
  }
  
  Future<void> _initializeSpeech() async {
    try {
      // Solicitar permisos de micrófono
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        _logger.w('Permisos de micrófono no concedidos');
        return;
      }
      
      // Inicializar reconocimiento de voz
      _speechEnabled = await _speechToText.initialize(
        onError: (error) {
          _logger.e('Error de reconocimiento de voz: $error');
          _isListening = false;
          notifyListeners();
        },
        onStatus: (status) {
          _logger.i('Estado de reconocimiento: $status');
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
            notifyListeners();
          }
        },
      );
      
      notifyListeners();
      
    } catch (e) {
      _logger.e('Error al inicializar reconocimiento de voz: $e');
    }
  }
  
  Future<void> _initializeTts() async {
    try {
      // Configurar TTS
      await _flutterTts.setLanguage(_language);
      await _flutterTts.setVolume(_volume);
      await _flutterTts.setSpeechRate(_rate);
      await _flutterTts.setPitch(_pitch);
      
      // Configurar callbacks
      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        notifyListeners();
      });
      
      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        _currentText = '';
        notifyListeners();
      });
      
      _flutterTts.setErrorHandler((msg) {
        _logger.e('Error de TTS: $msg');
        _isSpeaking = false;
        notifyListeners();
      });
      
    } catch (e) {
      _logger.e('Error al inicializar TTS: $e');
    }
  }
  
  Future<void> startListening() async {
    if (!_speechEnabled || _isListening) return;
    
    try {
      _lastWords = '';
      _confidence = 0.0;
      
      await _speechToText.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          _confidence = result.confidence;
          notifyListeners();
        },
        localeId: _language,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: false,
        listenMode: ListenMode.confirmation,
      );
      
      _isListening = true;
      notifyListeners();
      
    } catch (e) {
      _logger.e('Error al iniciar escucha: $e');
    }
  }
  
  Future<void> stopListening() async {
    if (!_isListening) return;
    
    try {
      await _speechToText.stop();
      _isListening = false;
      notifyListeners();
    } catch (e) {
      _logger.e('Error al detener escucha: $e');
    }
  }
  
  Future<void> speak(String text) async {
    if (text.isEmpty || _isSpeaking) return;
    
    try {
      _currentText = text;
      await _flutterTts.speak(text);
    } catch (e) {
      _logger.e('Error al hablar: $e');
    }
  }
  
  Future<void> stopSpeaking() async {
    if (!_isSpeaking) return;
    
    try {
      await _flutterTts.stop();
      _isSpeaking = false;
      _currentText = '';
      notifyListeners();
    } catch (e) {
      _logger.e('Error al detener habla: $e');
    }
  }
  
  Future<void> setLanguage(String language) async {
    _language = language;
    await _flutterTts.setLanguage(language);
    notifyListeners();
  }
  
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _flutterTts.setVolume(_volume);
    notifyListeners();
  }
  
  Future<void> setRate(double rate) async {
    _rate = rate.clamp(0.1, 1.0);
    await _flutterTts.setSpeechRate(_rate);
    notifyListeners();
  }
  
  Future<void> setPitch(double pitch) async {
    _pitch = pitch.clamp(0.5, 2.0);
    await _flutterTts.setPitch(_pitch);
    notifyListeners();
  }
  
  // Métodos de utilidad
  bool get isAvailable => _speechEnabled && !_isListening;
  
  void clearLastWords() {
    _lastWords = '';
    _confidence = 0.0;
    notifyListeners();
  }
  
  // Comandos de voz predefinidos
  Map<String, List<String>> get voiceCommands => {
    'saludo': ['hola', 'buenos días', 'buenas tardes', 'buenas noches'],
    'despedida': ['adiós', 'hasta luego', 'nos vemos', 'chao'],
    'foto': ['toma una foto', 'sácame una foto', 'fotografía'],
    'grabar': ['graba video', 'inicia grabación', 'empieza a grabar'],
    'parar': ['para grabación', 'detén grabación', 'stop'],
    'cambiar cámara': ['cambia cámara', 'cámara frontal', 'cámara trasera'],
    'flash': ['enciende flash', 'apaga flash', 'linterna'],
    'ajustes': ['configuración', 'opciones', 'preferencias'],
    'ayuda': ['ayúdame', 'qué puedes hacer', 'comandos'],
  };
  
  String? processVoiceCommand(String text) {
    final lowerText = text.toLowerCase();
    
    for (final entry in voiceCommands.entries) {
      for (final command in entry.value) {
        if (lowerText.contains(command)) {
          return entry.key;
        }
      }
    }
    
    return null;
  }
  
  @override
  void dispose() {
    _speechToText.cancel();
    _flutterTts.stop();
    super.dispose();
  }
}