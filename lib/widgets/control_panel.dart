import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/voice_provider.dart';
import '../providers/ai_provider.dart';
import '../utils/theme.dart';
import 'protected_mode_auth.dart';
import 'protected_mode_panel.dart';

class ControlPanel extends StatelessWidget {
  final VoidCallback onClose;

  const ControlPanel({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior
            _buildTopBar(),
            
            // Contenido del panel
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.arrow_back),
          ),
          
          const SizedBox(width: 12),
          
          const Icon(
            Icons.settings,
            color: AppTheme.primaryColor,
            size: 24,
          ),
          
          const SizedBox(width: 12),
          
          const Text(
            'Configuración',
            style: AppTheme.titleLarge,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personalidad de la compañera
          _buildPersonalitySection(),
          
          const SizedBox(height: 24),
          
          // Configuración de voz
          _buildVoiceSection(),
          
          const SizedBox(height: 24),
          
          // Configuración de IA
          _buildAISection(),
          
          const SizedBox(height: 24),
          
          // Configuración general
          _buildGeneralSection(),
          
          const SizedBox(height: 24),
          
          // Modo protegido
          _buildProtectedModeSection(),
          
          const SizedBox(height: 24),
          
          // Información de la aplicación
          _buildAppInfoSection(),
        ],
      ),
    );
  }

  Widget _buildPersonalitySection() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.psychology,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Personalidad',
                      style: AppTheme.titleMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Selector de personalidad
                DropdownButtonFormField<String>(
                  value: appState.companionPersonality,
                  decoration: const InputDecoration(
                    labelText: 'Personalidad de la compañera',
                    border: OutlineInputBorder(),
                  ),
                  items: appState.personalityPresets.keys.map((personality) {
                    final preset = appState.personalityPresets[personality]!;
                    return DropdownMenuItem(
                      value: personality,
                      child: Text(preset['name'] as String),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      appState.applyPersonalityPreset(value);
                      context.read<AIProvider>().setPersonality(value);
                    }
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Descripción de la personalidad
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    appState.personalityPresets[appState.companionPersonality]?['description'] ?? '',
                    style: AppTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVoiceSection() {
    return Consumer<VoiceProvider>(
      builder: (context, voiceProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.record_voice_over,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Configuración de Voz',
                      style: AppTheme.titleMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Habilitar voz
                SwitchListTile(
                  title: const Text('Habilitar voz'),
                  subtitle: const Text('Reconocimiento y síntesis de voz'),
                  value: voiceProvider.voiceEnabled,
                  onChanged: (value) {
                    // TODO: Implementar toggle de voz
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Volumen
                _buildSliderSetting(
                  label: 'Volumen',
                  value: voiceProvider.volume,
                  onChanged: voiceProvider.setVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                ),
                
                const SizedBox(height: 16),
                
                // Velocidad
                _buildSliderSetting(
                  label: 'Velocidad',
                  value: voiceProvider.rate,
                  onChanged: voiceProvider.setRate,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                ),
                
                const SizedBox(height: 16),
                
                // Tono
                _buildSliderSetting(
                  label: 'Tono',
                  value: voiceProvider.pitch,
                  onChanged: voiceProvider.setPitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAISection() {
    return Consumer<AIProvider>(
      builder: (context, aiProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.smart_toy,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Configuración de IA',
                      style: AppTheme.titleMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Habilitar procesamiento de IA
                SwitchListTile(
                  title: const Text('Procesamiento de IA'),
                  subtitle: const Text('Habilitar respuestas inteligentes'),
                  value: aiProvider.aiProcessingEnabled,
                  onChanged: (value) {
                    // TODO: Implementar toggle de IA
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Creatividad
                _buildSliderSetting(
                  label: 'Creatividad',
                  value: aiProvider.creativity,
                  onChanged: aiProvider.setCreativity,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                ),
                
                const SizedBox(height: 16),
                
                // Formalidad
                _buildSliderSetting(
                  label: 'Formalidad',
                  value: aiProvider.formality,
                  onChanged: aiProvider.setFormality,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                ),
                
                const SizedBox(height: 16),
                
                // Habilitar contexto
                SwitchListTile(
                  title: const Text('Contexto'),
                  subtitle: const Text('Mantener contexto de conversación'),
                  value: aiProvider.enableContext,
                  onChanged: aiProvider.setEnableContext,
                ),
                
                const SizedBox(height: 8),
                
                // Habilitar emociones
                SwitchListTile(
                  title: const Text('Emociones'),
                  subtitle: const Text('Mostrar emociones en respuestas'),
                  value: aiProvider.enableEmotions,
                  onChanged: aiProvider.setEnableEmotions,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneralSection() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Configuración General',
                      style: AppTheme.titleMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Modo oscuro
                SwitchListTile(
                  title: const Text('Modo oscuro'),
                  subtitle: const Text('Cambiar tema de la aplicación'),
                  value: appState.isDarkMode,
                  onChanged: appState.setDarkMode,
                ),
                
                const SizedBox(height: 8),
                
                // Actualizaciones automáticas
                SwitchListTile(
                  title: const Text('Actualizaciones automáticas'),
                  subtitle: const Text('Descargar actualizaciones automáticamente'),
                  value: appState.autoUpdateEnabled,
                  onChanged: appState.setAutoUpdateEnabled,
                ),
                
                const SizedBox(height: 16),
                
                // Nombre del usuario
                TextFormField(
                  initialValue: appState.userName,
                  decoration: const InputDecoration(
                    labelText: 'Tu nombre',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  onChanged: appState.setUserName,
                ),
                
                const SizedBox(height: 16),
                
                // Nombre de la compañera
                TextFormField(
                  initialValue: appState.companionName,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la compañera',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.favorite),
                  ),
                  onChanged: appState.setCompanionName,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppInfoSection() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Información de la Aplicación',
                      style: AppTheme.titleMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                _buildInfoItem('Versión', '1.0.0'),
                _buildInfoItem('Desarrollador', 'Compañera Virtual Team'),
                _buildInfoItem('Licencia', 'Código Abierto'),
                
                const SizedBox(height: 16),
                
                // Modo Protegido
                if (appState.isAuthenticated) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Modo Protegido Activo',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Personalidades: ${appState.customPersonalities.length}',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: appState.isProtectedMode,
                          onChanged: (value) {
                            appState.toggleProtectedMode();
                          },
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                ],
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar exportar datos
                    },
                    child: const Text('Exportar Datos'),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar resetear aplicación
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Resetear Aplicación'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliderSetting({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required double min,
    required double max,
    required int divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${(value * 100).toInt()}%',
          style: AppTheme.bodyMedium,
          fontWeight: FontWeight.w500,
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          divisions: divisions,
        ),
      ],
    );
  }

  Widget _buildProtectedModeSection() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      appState.isAuthenticated ? Icons.security : Icons.lock,
                      color: appState.isAuthenticated ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Modo Protegido',
                      style: AppTheme.titleMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                if (appState.isAuthenticated) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Autenticado',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Personalidades personalizadas: ${appState.customPersonalities.length}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProtectedModePanel(
                              onClose: null,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Acceder al Modo Protegido'),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        appState.logoutProtectedMode();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                      ),
                      child: const Text('Cerrar Sesión'),
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'No autenticado',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Accede para configuraciones avanzadas y personalización sin restricciones',
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showProtectedModeAuth();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Autenticarse'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProtectedModeAuth() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProtectedModeAuth(
        onSuccess: () {
          Navigator.pop(context);
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.bodyMedium,
            fontWeight: FontWeight.w500,
          ),
          Text(
            value,
            style: AppTheme.bodyMedium,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }
}