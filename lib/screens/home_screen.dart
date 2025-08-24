import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:camera/camera.dart';

import '../providers/app_state.dart';
import '../providers/camera_provider.dart';
import '../providers/voice_provider.dart';
import '../providers/ai_provider.dart';
import '../utils/theme.dart';
import '../widgets/camera_view.dart';
import '../widgets/voice_controls.dart';
import '../widgets/chat_interface.dart';
import '../widgets/companion_avatar.dart';
import '../widgets/control_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  
  bool _showCamera = false;
  bool _showChat = false;
  bool _showControls = false;
  
  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Iniciar animaciones
    _fadeController.forward();
    _pulseController.repeat(reverse: true);
    
    // Configurar listeners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCompanion();
    });
  }
  
  void _initializeCompanion() {
    final aiProvider = context.read<AIProvider>();
    final voiceProvider = context.read<VoiceProvider>();
    
    // Mensaje de bienvenida
    aiProvider.processUserInput('hola').then((response) {
      if (voiceProvider.voiceEnabled) {
        voiceProvider.speak(response);
      }
    });
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
  
  void _toggleCamera() {
    setState(() {
      _showCamera = !_showCamera;
      if (_showCamera) {
        _slideController.forward();
      } else {
        _slideController.reverse();
      }
    });
  }
  
  void _toggleChat() {
    setState(() {
      _showChat = !_showChat;
    });
  }
  
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
          ),
          
          // Contenido principal
          SafeArea(
            child: Column(
              children: [
                // Barra superior
                _buildTopBar(),
                
                // Área principal
                Expanded(
                  child: _buildMainArea(),
                ),
                
                // Panel de control inferior
                _buildBottomPanel(),
              ],
            ),
          ),
          
          // Overlay de cámara
          if (_showCamera) _buildCameraOverlay(),
          
          // Overlay de chat
          if (_showChat) _buildChatOverlay(),
          
          // Overlay de controles
          if (_showControls) _buildControlsOverlay(),
        ],
      ),
    );
  }
  
  Widget _buildTopBar() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar de la compañera
              CompanionAvatar(
                name: appState.companionName,
                personality: appState.companionPersonality,
                isSpeaking: context.watch<VoiceProvider>().isSpeaking,
                pulseController: _pulseController,
              ),
              
              const SizedBox(width: 12),
              
              // Información de la compañera
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appState.companionName,
                      style: AppTheme.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getPersonalityDescription(appState.companionPersonality),
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Botones de acción
              Row(
                children: [
                  IconButton(
                    onPressed: _toggleCamera,
                    icon: Icon(
                      _showCamera ? Icons.camera_alt : Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleChat,
                    icon: Icon(
                      _showChat ? Icons.chat_bubble : Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleControls,
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMainArea() {
    return Consumer<AIProvider>(
      builder: (context, aiProvider, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Área de estado
              _buildStatusArea(aiProvider),
              
              const SizedBox(height: 24),
              
              // Área de interacción principal
              Expanded(
                child: _buildInteractionArea(aiProvider),
              ),
              
              const SizedBox(height: 24),
              
              // Controles de voz
              VoiceControls(
                onVoiceCommand: (command) {
                  _handleVoiceCommand(command);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildStatusArea(AIProvider aiProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Indicador de estado
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: aiProvider.isProcessing ? Colors.orange : Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Texto de estado
          Expanded(
            child: Text(
              aiProvider.isProcessing 
                ? 'Procesando tu mensaje...' 
                : 'Lista para interactuar',
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Contador de interacciones
          Consumer<AppState>(
            builder: (context, appState, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${appState.interactionCount}',
                  style: AppTheme.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildInteractionArea(AIProvider aiProvider) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mensaje principal
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              aiProvider.isProcessing 
                ? 'Pensando...' 
                : aiProvider.currentResponse.isNotEmpty 
                  ? aiProvider.currentResponse 
                  : '¡Hola! Soy tu compañera virtual. Habla conmigo o usa los controles para interactuar.',
              style: AppTheme.bodyLarge.copyWith(
                color: Colors.white,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Botones de acción rápida
          if (!aiProvider.isProcessing) _buildQuickActions(),
        ],
      ),
    );
  }
  
  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          _buildActionButton(
            icon: Icons.camera_alt,
            label: 'Foto',
            onTap: () => _handleVoiceCommand('foto'),
          ),
          _buildActionButton(
            icon: Icons.videocam,
            label: 'Grabar',
            onTap: () => _handleVoiceCommand('grabar'),
          ),
          _buildActionButton(
            icon: Icons.switch_camera,
            label: 'Cámara',
            onTap: () => _handleVoiceCommand('cambiar cámara'),
          ),
          _buildActionButton(
            icon: Icons.flash_on,
            label: 'Flash',
            onTap: () => _handleVoiceCommand('flash'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTheme.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomButton(
            icon: Icons.mic,
            label: 'Voz',
            isActive: context.watch<VoiceProvider>().isListening,
            onTap: () {
              final voiceProvider = context.read<VoiceProvider>();
              if (voiceProvider.isListening) {
                voiceProvider.stopListening();
              } else {
                voiceProvider.startListening();
              }
            },
          ),
          _buildBottomButton(
            icon: Icons.photo_camera,
            label: 'Cámara',
            isActive: _showCamera,
            onTap: _toggleCamera,
          ),
          _buildBottomButton(
            icon: Icons.chat,
            label: 'Chat',
            isActive: _showChat,
            onTap: _toggleChat,
          ),
          _buildBottomButton(
            icon: Icons.settings,
            label: 'Ajustes',
            isActive: _showControls,
            onTap: _toggleControls,
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive 
                ? Colors.white.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive 
                  ? Colors.white 
                  : Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
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
    );
  }
  
  Widget _buildCameraOverlay() {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Transform.translate(
            offset: Offset(0, (1 - _slideController.value) * 100),
            child: CameraView(
              onClose: _toggleCamera,
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildChatOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: ChatInterface(
        onClose: _toggleChat,
      ),
    );
  }
  
  Widget _buildControlsOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: ControlPanel(
        onClose: _toggleControls,
      ),
    );
  }
  
  String _getPersonalityDescription(String personality) {
    final descriptions = {
      'amigable': 'Compañera cálida y cariñosa',
      'profesional': 'Asistente inteligente y enfocada',
      'juguetona': 'Compañera energética y divertida',
      'misteriosa': 'Compañera misteriosa e intrigante',
      'seductora': 'Compañera seductora y atractiva',
    };
    
    return descriptions[personality] ?? 'Compañera virtual';
  }
  
  void _handleVoiceCommand(String command) {
    final aiProvider = context.read<AIProvider>();
    final voiceProvider = context.read<VoiceProvider>();
    final cameraProvider = context.read<CameraProvider>();
    final appState = context.read<AppState>();
    
    // Procesar comando
    aiProvider.processUserInput(command).then((response) {
      if (voiceProvider.voiceEnabled) {
        voiceProvider.speak(response);
      }
    });
    
    // Ejecutar acción correspondiente
    switch (command) {
      case 'foto':
        cameraProvider.takePicture();
        break;
      case 'grabar':
        if (cameraProvider.isRecording) {
          cameraProvider.stopRecording();
        } else {
          cameraProvider.startRecording();
        }
        break;
      case 'cambiar cámara':
        cameraProvider.switchCamera();
        break;
      case 'flash':
        cameraProvider.toggleFlash();
        break;
      case 'ajustes':
        _toggleControls();
        break;
    }
    
    // Incrementar contador de interacciones
    appState.addInteraction();
  }
}