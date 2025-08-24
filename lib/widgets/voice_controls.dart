import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/voice_provider.dart';
import '../utils/theme.dart';

class VoiceControls extends StatelessWidget {
  final Function(String) onVoiceCommand;

  const VoiceControls({
    super.key,
    required this.onVoiceCommand,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceProvider>(
      builder: (context, voiceProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Estado del reconocimiento de voz
              _buildVoiceStatus(voiceProvider),
              
              const SizedBox(height: 16),
              
              // Controles de voz
              _buildVoiceControls(voiceProvider),
              
              // Texto reconocido
              if (voiceProvider.lastWords.isNotEmpty)
                _buildRecognizedText(voiceProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVoiceStatus(VoiceProvider voiceProvider) {
    return Row(
      children: [
        // Indicador de estado
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: voiceProvider.isListening 
              ? Colors.red 
              : voiceProvider.speechEnabled 
                ? Colors.green 
                : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Texto de estado
        Expanded(
          child: Text(
            voiceProvider.isListening 
              ? 'Escuchando...' 
              : voiceProvider.speechEnabled 
                ? 'Listo para escuchar' 
                : 'Voz deshabilitada',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        // Nivel de confianza
        if (voiceProvider.isListening && voiceProvider.confidence > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(voiceProvider.confidence * 100).toInt()}%',
              style: AppTheme.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVoiceControls(VoiceProvider voiceProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Botón de micrófono
        _buildVoiceButton(
          icon: voiceProvider.isListening ? Icons.mic : Icons.mic_none,
          label: voiceProvider.isListening ? 'Detener' : 'Escuchar',
          isActive: voiceProvider.isListening,
          onTap: () {
            if (voiceProvider.isListening) {
              voiceProvider.stopListening();
            } else {
              voiceProvider.startListening();
            }
          },
        ),
        
        // Botón de configuración de voz
        _buildVoiceButton(
          icon: Icons.settings_voice,
          label: 'Config',
          isActive: false,
          onTap: () {
            _showVoiceSettings(context);
          },
        ),
        
        // Botón de comandos de voz
        _buildVoiceButton(
          icon: Icons.help_outline,
          label: 'Ayuda',
          isActive: false,
          onTap: () {
            _showVoiceCommands(context);
          },
        ),
      ],
    );
  }

  Widget _buildVoiceButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive 
            ? Colors.white.withOpacity(0.3)
            : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isActive 
              ? Colors.white 
              : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTheme.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecognizedText(VoiceProvider voiceProvider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Texto reconocido:',
            style: AppTheme.labelSmall.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            voiceProvider.lastWords,
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onVoiceCommand(voiceProvider.lastWords);
                    voiceProvider.clearLastWords();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('Ejecutar'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: voiceProvider.clearLastWords,
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showVoiceSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Consumer<VoiceProvider>(
          builder: (context, voiceProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configuración de Voz',
                    style: AppTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  
                  // Volumen
                  Text(
                    'Volumen: ${(voiceProvider.volume * 100).toInt()}%',
                    style: AppTheme.bodyMedium,
                  ),
                  Slider(
                    value: voiceProvider.volume,
                    onChanged: voiceProvider.setVolume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Velocidad
                  Text(
                    'Velocidad: ${(voiceProvider.rate * 100).toInt()}%',
                    style: AppTheme.bodyMedium,
                  ),
                  Slider(
                    value: voiceProvider.rate,
                    onChanged: voiceProvider.setRate,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tono
                  Text(
                    'Tono: ${(voiceProvider.pitch * 100).toInt()}%',
                    style: AppTheme.bodyMedium,
                  ),
                  Slider(
                    value: voiceProvider.pitch,
                    onChanged: voiceProvider.setPitch,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón de prueba
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        voiceProvider.speak('Esta es una prueba de voz');
                      },
                      child: const Text('Probar Voz'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showVoiceCommands(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comandos de Voz',
                style: AppTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView(
                  children: [
                    _buildCommandItem('Saludo', ['hola', 'buenos días', 'buenas tardes']),
                    _buildCommandItem('Despedida', ['adiós', 'hasta luego', 'nos vemos']),
                    _buildCommandItem('Foto', ['toma una foto', 'sácame una foto']),
                    _buildCommandItem('Grabar', ['graba video', 'inicia grabación']),
                    _buildCommandItem('Parar', ['para grabación', 'detén grabación']),
                    _buildCommandItem('Cámara', ['cambia cámara', 'cámara frontal']),
                    _buildCommandItem('Flash', ['enciende flash', 'apaga flash']),
                    _buildCommandItem('Ayuda', ['ayúdame', 'qué puedes hacer']),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommandItem(String title, List<String> commands) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            commands.join(', '),
            style: AppTheme.bodySmall.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}