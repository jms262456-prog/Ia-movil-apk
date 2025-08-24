import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'companion_avatar.dart';

class AvatarPreview extends StatefulWidget {
  const AvatarPreview({super.key});

  @override
  State<AvatarPreview> createState() => _AvatarPreviewState();
}

class _AvatarPreviewState extends State<AvatarPreview> {
  bool _isSpeaking = false;
  String _currentPersonality = 'seductora';
  bool _showUnrestrictedMode = false;

  final List<String> _personalities = [
    'amigable',
    'profesional', 
    'juguetona',
    'misteriosa',
    'seductora',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Preview del Avatar',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Avatar principal
                _buildMainAvatar(appState),
                
                const SizedBox(height: 32),
                
                // Controles
                _buildControls(),
                
                const SizedBox(height: 32),
                
                // Preview de todas las personalidades
                _buildPersonalityPreviews(),
                
                const SizedBox(height: 32),
                
                // Configuración del avatar
                _buildAvatarSettings(appState),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainAvatar(AppState appState) {
    return Center(
      child: Column(
        children: [
          // Avatar grande
          CompanionAvatar(
            personality: _currentPersonality,
            isSpeaking: _isSpeaking,
            size: 200,
            onTap: () {
              setState(() {
                _isSpeaking = !_isSpeaking;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Información del avatar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  _getPersonalityName(_currentPersonality),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getPersonalityDescription(_currentPersonality),
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (appState.unrestrictedMode)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.purple),
                    ),
                    child: const Text(
                      'MODO SIN RESTRICCIONES',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Controles',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isSpeaking = !_isSpeaking;
                    });
                  },
                  icon: Icon(_isSpeaking ? Icons.mic_off : Icons.mic),
                  label: Text(_isSpeaking ? 'Detener' : 'Hablar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSpeaking ? Colors.red : Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showUnrestrictedMode = !_showUnrestrictedMode;
                    });
                  },
                  icon: const Icon(Icons.flash_on),
                  label: const Text('Efectos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showUnrestrictedMode ? Colors.purple : Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityPreviews() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Personalidades',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _personalities.map((personality) {
              final isSelected = personality == _currentPersonality;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPersonality = personality;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      CompanionAvatar(
                        personality: personality,
                        size: 60,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getPersonalityName(personality),
                        style: TextStyle(
                          color: isSelected ? Colors.blue : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSettings(AppState appState) {
    final avatarSettings = appState.avatarSettings;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Configuración del Avatar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildSettingItem('Estilo', avatarSettings['style'] ?? 'default'),
          _buildSettingItem('Outfit', avatarSettings['outfit'] ?? 'default'),
          _buildSettingItem('Cabello', avatarSettings['hair'] ?? 'default'),
          _buildSettingItem('Pose', avatarSettings['pose'] ?? 'casual'),
          _buildSettingItem('Expresión', avatarSettings['expression'] ?? 'friendly'),
          _buildSettingItem('Animación', avatarSettings['animation'] ?? 'gentle'),
          _buildSettingItem('Accesorios', '${(avatarSettings['accessories'] as List<dynamic>?)?.length ?? 0} items'),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPersonalityName(String personality) {
    switch (personality) {
      case 'amigable':
        return 'Luna';
      case 'profesional':
        return 'Athena';
      case 'juguetona':
        return 'Nova';
      case 'misteriosa':
        return 'Shadow';
      case 'seductora':
        return 'Venus';
      default:
        return 'Compañera';
    }
  }

  String _getPersonalityDescription(String personality) {
    switch (personality) {
      case 'amigable':
        return 'Compañera cálida y cariñosa';
      case 'profesional':
        return 'Asistente inteligente y enfocada';
      case 'juguetona':
        return 'Compañera energética y divertida';
      case 'misteriosa':
        return 'Compañera misteriosa e intrigante';
      case 'seductora':
        return 'Compañera seductora y atractiva';
      default:
        return 'Tu compañera virtual';
    }
  }
}