import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class AppState extends ChangeNotifier {
  final Logger _logger = Logger();
  
  // App Settings
  bool _isDarkMode = false;
  bool _isFirstLaunch = true;
  String _userName = '';
  String _companionName = 'Luna';
  String _companionPersonality = 'friendly';
  bool _autoUpdateEnabled = true;
  
  // Interaction Settings
  bool _voiceEnabled = true;
  bool _cameraEnabled = true;
  bool _aiProcessingEnabled = true;
  double _voiceVolume = 0.8;
  double _speechRate = 0.5;
  
  // Session Data
  DateTime? _lastInteraction;
  int _interactionCount = 0;
  List<String> _conversationHistory = [];
  
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
  
  AppState() {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      _userName = prefs.getString('userName') ?? '';
      _companionName = prefs.getString('companionName') ?? 'Luna';
      _companionPersonality = prefs.getString('companionPersonality') ?? 'friendly';
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
      _logger.e('Error loading settings: $e');
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
      _logger.e('Error saving settings: $e');
    }
  }
  
  // Settings Methods
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
  
  // Interaction Methods
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
  
  // Personality Presets
  Map<String, Map<String, dynamic>> get personalityPresets => {
    'friendly': {
      'name': 'Luna',
      'description': 'Warm and caring companion',
      'voice_pitch': 1.0,
      'speech_style': 'casual',
    },
    'professional': {
      'name': 'Athena',
      'description': 'Intelligent and focused assistant',
      'voice_pitch': 0.9,
      'speech_style': 'formal',
    },
    'playful': {
      'name': 'Nova',
      'description': 'Energetic and fun companion',
      'voice_pitch': 1.1,
      'speech_style': 'enthusiastic',
    },
    'mysterious': {
      'name': 'Shadow',
      'description': 'Mysterious and intriguing companion',
      'voice_pitch': 0.8,
      'speech_style': 'whispered',
    },
  };
  
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