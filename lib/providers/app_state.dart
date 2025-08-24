import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AppState extends ChangeNotifier {
  final Logger _logger = Logger();
  
  // Configuración de la Aplicación
  bool _isDarkMode = false;
  bool _isFirstLaunch = true;
  String _userName = '';
  String _companionName = 'Luna';
  String _companionPersonality = 'amigable';
  bool _autoUpdateEnabled = true;
  
  // Configuración de Interacción
  bool _voiceEnabled = true;
  bool _cameraEnabled = true;
  bool _aiProcessingEnabled = true;
  double _voiceVolume = 0.8;
  double _speechRate = 0.5;
  
  // Datos de Sesión
  DateTime? _lastInteraction;
  int _interactionCount = 0;
  List<String> _conversationHistory = [];
  
  // Sistema de Modo Protegido
  bool _isProtectedMode = false;
  bool _isAuthenticated = false;
  String _protectedPassword = '262456';
  Map<String, dynamic> _protectedSettings = {};
  List<String> _customPersonalities = [];
  Map<String, dynamic> _advancedConfig = {};
  
  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get isFirstLaunch => _isFirstLaunch;
  String get userName => _userName;
  String get companionName => _companionName;
  String get companionPersonality => _companionPersonality;
  bool get autoUpdateEnabled => _autoUpdateEnabled;
  bool get voiceEnabled => _voiceEnabled;
  bool get cameraEnabled => _cameraEnabled;
  bool get aiProcessingEnabled => _aiProcessingEnabled;
  double get voiceVolume => _voiceVolume;
  double get speechRate => _speechRate;
  DateTime? get lastInteraction => _lastInteraction;
  int get interactionCount => _interactionCount;
  List<String> get conversationHistory => List.unmodifiable(_conversationHistory);
  
  // Getters del Modo Protegido
  bool get isProtectedMode => _isProtectedMode;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic> get protectedSettings => Map.unmodifiable(_protectedSettings);
  List<String> get customPersonalities => List.unmodifiable(_customPersonalities);
  Map<String, dynamic> get advancedConfig => Map.unmodifiable(_advancedConfig);
  
  AppState() {
    _loadSettings();
    _loadProtectedSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      _userName = prefs.getString('userName') ?? '';
      _companionName = prefs.getString('companionName') ?? 'Luna';
      _companionPersonality = prefs.getString('companionPersonality') ?? 'amigable';
      _autoUpdateEnabled = prefs.getBool('autoUpdateEnabled') ?? true;
      _voiceEnabled = prefs.getBool('voiceEnabled') ?? true;
      _cameraEnabled = prefs.getBool('cameraEnabled') ?? true;
      _aiProcessingEnabled = prefs.getBool('aiProcessingEnabled') ?? true;
      _voiceVolume = prefs.getDouble('voiceVolume') ?? 0.8;
      _speechRate = prefs.getDouble('speechRate') ?? 0.5;
      _interactionCount = prefs.getInt('interactionCount') ?? 0;
      
      final history = prefs.getStringList('conversationHistory') ?? [];
      _conversationHistory = history;
      
      notifyListeners();
    } catch (e) {
      _logger.e('Error al cargar configuraciones: $e');
    }
  }
  
  Future<void> _loadProtectedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _isProtectedMode = prefs.getBool('isProtectedMode') ?? false;
      _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
      
      final protectedSettingsStr = prefs.getString('protectedSettings');
      if (protectedSettingsStr != null) {
        _protectedSettings = json.decode(protectedSettingsStr);
      }
      
      final customPersonalitiesStr = prefs.getStringList('customPersonalities') ?? [];
      _customPersonalities = customPersonalitiesStr;
      
      final advancedConfigStr = prefs.getString('advancedConfig');
      if (advancedConfigStr != null) {
        _advancedConfig = json.decode(advancedConfigStr);
      }
      
      notifyListeners();
    } catch (e) {
      _logger.e('Error al cargar configuraciones protegidas: $e');
    }
  }
  
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('isDarkMode', _isDarkMode);
      await prefs.setBool('isFirstLaunch', _isFirstLaunch);
      await prefs.setString('userName', _userName);
      await prefs.setString('companionName', _companionName);
      await prefs.setString('companionPersonality', _companionPersonality);
      await prefs.setBool('autoUpdateEnabled', _autoUpdateEnabled);
      await prefs.setBool('voiceEnabled', _voiceEnabled);
      await prefs.setBool('cameraEnabled', _cameraEnabled);
      await prefs.setBool('aiProcessingEnabled', _aiProcessingEnabled);
      await prefs.setDouble('voiceVolume', _voiceVolume);
      await prefs.setDouble('speechRate', _speechRate);
      await prefs.setInt('interactionCount', _interactionCount);
      await prefs.setStringList('conversationHistory', _conversationHistory);
    } catch (e) {
      _logger.e('Error al guardar configuraciones: $e');
    }
  }
  
  Future<void> _saveProtectedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('isProtectedMode', _isProtectedMode);
      await prefs.setBool('isAuthenticated', _isAuthenticated);
      await prefs.setString('protectedSettings', json.encode(_protectedSettings));
      await prefs.setStringList('customPersonalities', _customPersonalities);
      await prefs.setString('advancedConfig', json.encode(_advancedConfig));
    } catch (e) {
      _logger.e('Error al guardar configuraciones protegidas: $e');
    }
  }
  
  // Métodos de Autenticación del Modo Protegido
  bool authenticateProtectedMode(String password) {
    if (password == _protectedPassword) {
      _isAuthenticated = true;
      _isProtectedMode = true;
      _saveProtectedSettings();
      notifyListeners();
      return true;
    }
    return false;
  }
  
  void logoutProtectedMode() {
    _isAuthenticated = false;
    _saveProtectedSettings();
    notifyListeners();
  }
  
  void toggleProtectedMode() {
    if (_isAuthenticated) {
      _isProtectedMode = !_isProtectedMode;
      _saveProtectedSettings();
      notifyListeners();
    }
  }
  
  void loginProtectedMode() {
    if (_isAuthenticated) {
      _isProtectedMode = true;
      _saveProtectedSettings();
      notifyListeners();
    }
  }
  
  // Métodos de Auto-Actualización del Modo Protegido
  Future<void> updateProtectedSettings(Map<String, dynamic> newSettings) async {
    if (!_isAuthenticated) return;
    
    _protectedSettings.addAll(newSettings);
    await _saveProtectedSettings();
    notifyListeners();
  }
  
  Future<void> addCustomPersonality(String name, Map<String, dynamic> config) async {
    if (!_isAuthenticated) return;
    
    _customPersonalities.add(name);
    _protectedSettings['personalities'] = _protectedSettings['personalities'] ?? {};
    _protectedSettings['personalities'][name] = config;
    await _saveProtectedSettings();
    notifyListeners();
  }
  
  Future<void> removeCustomPersonality(String name) async {
    if (!_isAuthenticated) return;
    
    _customPersonalities.remove(name);
    _protectedSettings['personalities']?.remove(name);
    await _saveProtectedSettings();
    notifyListeners();
  }
  
  Future<void> updateAdvancedConfig(Map<String, dynamic> config) async {
    if (!_isAuthenticated) return;
    
    _advancedConfig.addAll(config);
    await _saveProtectedSettings();
    notifyListeners();
  }
  
  // Método de Auto-Actualización Completa
  Future<void> performAutoUpdate(Map<String, dynamic> updateData) async {
    if (!_isAuthenticated) return;
    
    try {
      // Actualizar configuraciones protegidas
      if (updateData['protectedSettings'] != null) {
        await updateProtectedSettings(updateData['protectedSettings']);
      }
      
      // Actualizar personalidades personalizadas
      if (updateData['customPersonalities'] != null) {
        for (final personality in updateData['customPersonalities']) {
          await addCustomPersonality(
            personality['name'], 
            personality['config']
          );
        }
      }
      
      // Actualizar configuración avanzada
      if (updateData['advancedConfig'] != null) {
        await updateAdvancedConfig(updateData['advancedConfig']);
      }
      
      // Actualizar archivos de configuración
      if (updateData['configFiles'] != null) {
        await _updateConfigFiles(updateData['configFiles']);
      }
      
      _logger.i('Auto-actualización completada exitosamente');
    } catch (e) {
      _logger.e('Error durante la auto-actualización: $e');
    }
  }
  
  // Método Simplificado de Auto-Actualización
  Future<void> simpleUpdate(String updateType, Map<String, dynamic> data) async {
    if (!_isAuthenticated) return;
    
    try {
      switch (updateType) {
        case 'personality':
          if (data['name'] != null && data['config'] != null) {
            await addCustomPersonality(data['name'], data['config']);
          }
          break;
        case 'settings':
          await updateProtectedSettings(data);
          break;
        case 'avatar':
          await updateAvatarSettings(data);
          break;
        case 'responses':
          await updateCustomResponses(data);
          break;
        case 'unrestricted':
          await enableUnrestrictedMode(data);
          break;
      }
      
      _logger.i('Actualización simple completada: $updateType');
    } catch (e) {
      _logger.e('Error en actualización simple: $e');
    }
  }
  
  // Configuración del Avatar Sexy
  Map<String, dynamic> _avatarSettings = {
    'style': 'sexy',
    'outfit': 'default',
    'hair': 'long',
    'accessories': [],
    'pose': 'casual',
    'expression': 'friendly',
    'animation': 'gentle',
  };
  
  Map<String, dynamic> get avatarSettings => Map.unmodifiable(_avatarSettings);
  
  Future<void> updateAvatarSettings(Map<String, dynamic> settings) async {
    if (!_isAuthenticated) return;
    
    _avatarSettings.addAll(settings);
    _protectedSettings['avatar'] = _avatarSettings;
    await _saveProtectedSettings();
    notifyListeners();
  }
  
  // Respuestas Personalizadas Sin Restricciones
  Map<String, List<String>> _customResponses = {};
  
  Map<String, List<String>> get customResponses => Map.unmodifiable(_customResponses);
  
  Future<void> updateCustomResponses(Map<String, dynamic> responses) async {
    if (!_isAuthenticated) return;
    
    responses.forEach((key, value) {
      if (value is List) {
        _customResponses[key] = List<String>.from(value);
      }
    });
    
    _protectedSettings['customResponses'] = _customResponses;
    await _saveProtectedSettings();
    notifyListeners();
  }
  
  // Modo Sin Restricciones
  bool _unrestrictedMode = false;
  
  bool get unrestrictedMode => _unrestrictedMode;
  
  Future<void> enableUnrestrictedMode(Map<String, dynamic> config) async {
    if (!_isAuthenticated) return;
    
    _unrestrictedMode = config['enabled'] ?? false;
    _protectedSettings['unrestrictedMode'] = _unrestrictedMode;
    _protectedSettings['unrestrictedConfig'] = config;
    await _saveProtectedSettings();
    notifyListeners();
  }
  
  // Métodos Rápidos de Actualización
  Future<void> quickUpdatePersonality(String name, String description, List<String> greetings, List<String> responses) async {
    if (!_isAuthenticated) return;
    
    final config = {
      'name': name,
      'description': description,
      'voice_pitch': 1.1,
      'speech_style': 'sexy',
      'responses': {
        'greeting': greetings,
        'custom': responses,
      },
      'avatar': {
        'style': 'sexy',
        'outfit': 'attractive',
      }
    };
    
    await addCustomPersonality(name, config);
  }
  
  Future<void> quickEnableSexyMode() async {
    if (!_isAuthenticated) return;
    
    await updateAvatarSettings({
      'style': 'sexy',
      'outfit': 'attractive',
      'pose': 'seductive',
      'expression': 'flirtatious',
      'animation': 'smooth',
    });
    
    await enableUnrestrictedMode({
      'enabled': true,
      'sexyMode': true,
      'unrestrictedContent': true,
    });
  }
  
  Future<void> _updateConfigFiles(Map<String, dynamic> configFiles) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final configDir = Directory('${appDir.path}/config');
      
      if (!await configDir.exists()) {
        await configDir.create(recursive: true);
      }
      
      for (final entry in configFiles.entries) {
        final file = File('${configDir.path}/${entry.key}');
        await file.writeAsString(entry.value.toString());
      }
    } catch (e) {
      _logger.e('Error al actualizar archivos de configuración: $e');
    }
  }
  
  // Métodos de Configuración (existentes)
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setFirstLaunch(bool value) async {
    _isFirstLaunch = value;
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setUserName(String name) async {
    _userName = name;
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setCompanionName(String name) async {
    _companionName = name;
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setCompanionPersonality(String personality) async {
    _companionPersonality = personality;
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setAutoUpdateEnabled(bool enabled) async {
    _autoUpdateEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setVoiceEnabled(bool enabled) async {
    _voiceEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setCameraEnabled(bool enabled) async {
    _cameraEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setAIProcessingEnabled(bool enabled) async {
    _aiProcessingEnabled = enabled;
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setVoiceVolume(double volume) async {
    _voiceVolume = volume.clamp(0.0, 1.0);
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.1, 1.0);
    await _saveSettings();
    notifyListeners();
  }
  
  // Métodos de Interacción
  void addInteraction() {
    _interactionCount++;
    _lastInteraction = DateTime.now();
    _saveSettings();
    notifyListeners();
  }
  
  void addToConversationHistory(String message) {
    _conversationHistory.add(message);
    if (_conversationHistory.length > 100) {
      _conversationHistory.removeAt(0);
    }
    _saveSettings();
    notifyListeners();
  }
  
  void clearConversationHistory() {
    _conversationHistory.clear();
    _saveSettings();
    notifyListeners();
  }
  
  // Presets de Personalidad (actualizados)
  Map<String, Map<String, dynamic>> get personalityPresets {
    final basePresets = {
      'amigable': {
        'name': 'Luna',
        'description': 'Compañera cálida y cariñosa',
        'voice_pitch': 1.0,
        'speech_style': 'casual',
      },
      'profesional': {
        'name': 'Athena',
        'description': 'Asistente inteligente y enfocada',
        'voice_pitch': 0.9,
        'speech_style': 'formal',
      },
      'juguetona': {
        'name': 'Nova',
        'description': 'Compañera energética y divertida',
        'voice_pitch': 1.1,
        'speech_style': 'entusiasta',
      },
      'misteriosa': {
        'name': 'Shadow',
        'description': 'Compañera misteriosa e intrigante',
        'voice_pitch': 0.8,
        'speech_style': 'susurrada',
      },
      'seductora': {
        'name': 'Venus',
        'description': 'Compañera seductora y atractiva',
        'voice_pitch': 1.2,
        'speech_style': 'sensual',
      },
    };
    
    // Agregar personalidades personalizadas si están autenticados
    if (_isAuthenticated && _protectedSettings['personalities'] != null) {
      basePresets.addAll(_protectedSettings['personalities']);
    }
    
    return basePresets;
  }
  
  Future<void> applyPersonalityPreset(String personality) async {
    final preset = personalityPresets[personality];
    if (preset != null) {
      _companionPersonality = personality;
      _companionName = preset['name'] as String;
      await _saveSettings();
      notifyListeners();
    }
  }
}