import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../utils/theme.dart';

class CompanionAvatar extends StatefulWidget {
  final String personality;
  final bool isSpeaking;
  final double size;
  final VoidCallback? onTap;

  const CompanionAvatar({
    super.key,
    required this.personality,
    this.isSpeaking = false,
    this.size = 120,
    this.onTap,
  });

  @override
  State<CompanionAvatar> createState() => _CompanionAvatarState();
}

class _CompanionAvatarState extends State<CompanionAvatar>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _breathingController;
  late AnimationController _hairController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _hairAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _breathingController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _hairController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    
    _hairAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hairController, curve: Curves.easeInOut),
    );
    
    _startAnimations();
  }

  void _startAnimations() {
    _breathingController.repeat(reverse: true);
    _hairController.repeat(reverse: true);
    
    if (widget.isSpeaking) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(CompanionAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isSpeaking != oldWidget.isSpeaking) {
      if (widget.isSpeaking) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _breathingController.dispose();
    _hairController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final avatarSettings = appState.avatarSettings;
        final isUnrestricted = appState.unrestrictedMode;
        
        return GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: Listenable.merge([_pulseAnimation, _breathingAnimation, _hairAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isSpeaking 
                  ? _pulseAnimation.value 
                  : _breathingAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _getAvatarGradient(avatarSettings, isUnrestricted),
                    boxShadow: [
                      BoxShadow(
                        color: _getAvatarColor(avatarSettings, isUnrestricted).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Avatar principal
                      _buildAvatarFace(avatarSettings, isUnrestricted),
                      
                      // Efectos de cabello
                      if (avatarSettings['hair'] == 'long')
                        _buildHairEffect(avatarSettings, isUnrestricted),
                      
                      // Accesorios
                      ..._buildAccessories(avatarSettings, isUnrestricted),
                      
                      // Indicador de habla
                      if (widget.isSpeaking)
                        _buildSpeakingIndicator(),
                      
                      // Efectos especiales para modo sin restricciones
                      if (isUnrestricted)
                        _buildUnrestrictedEffects(),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAvatarFace(Map<String, dynamic> avatarSettings, bool isUnrestricted) {
    final style = avatarSettings['style'] ?? 'default';
    final expression = avatarSettings['expression'] ?? 'friendly';
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: Center(
        child: Icon(
          _getAvatarIcon(style, expression, isUnrestricted),
          size: widget.size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHairEffect(Map<String, dynamic> avatarSettings, bool isUnrestricted) {
    return Positioned(
      top: -10,
      left: -10,
      right: -10,
      child: Transform.rotate(
        angle: _hairAnimation.value * 0.1,
        child: Container(
          height: widget.size * 0.8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isUnrestricted 
                ? [Colors.purple.withOpacity(0.3), Colors.pink.withOpacity(0.1)]
                : [Colors.brown.withOpacity(0.3), Colors.brown.withOpacity(0.1)],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAccessories(Map<String, dynamic> avatarSettings, bool isUnrestricted) {
    final accessories = avatarSettings['accessories'] as List<dynamic>? ?? [];
    final List<Widget> widgets = [];
    
    for (int i = 0; i < accessories.length; i++) {
      final accessory = accessories[i];
      widgets.add(
        Positioned(
          top: widget.size * 0.1 + (i * 10),
          right: widget.size * 0.1,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isUnrestricted ? Colors.pink : Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite,
              size: 12,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    
    return widgets;
  }

  Widget _buildSpeakingIndicator() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.mic,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildUnrestrictedEffects() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.purple.withOpacity(0.2),
              Colors.pink.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _getAvatarGradient(Map<String, dynamic> avatarSettings, bool isUnrestricted) {
    final style = avatarSettings['style'] ?? 'default';
    
    if (isUnrestricted) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFF6B9D),
          Color(0xFFC44569),
          Color(0xFF8B5CF6),
        ],
      );
    }
    
    switch (style) {
      case 'sexy':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6B9D),
            Color(0xFFC44569),
            Color(0xFFE91E63),
          ],
        );
      case 'seductive':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF9C27B0),
            Color(0xFFE91E63),
            Color(0xFFFF5722),
          ],
        );
      default:
        return _getPersonalityGradient(widget.personality);
    }
  }

  Color _getAvatarColor(Map<String, dynamic> avatarSettings, bool isUnrestricted) {
    final style = avatarSettings['style'] ?? 'default';
    
    if (isUnrestricted) {
      return const Color(0xFF8B5CF6);
    }
    
    switch (style) {
      case 'sexy':
        return const Color(0xFFE91E63);
      case 'seductive':
        return const Color(0xFF9C27B0);
      default:
        return _getPersonalityColor(widget.personality);
    }
  }

  IconData _getAvatarIcon(String style, String expression, bool isUnrestricted) {
    if (isUnrestricted) {
      return Icons.favorite;
    }
    
    switch (style) {
      case 'sexy':
        return Icons.favorite_border;
      case 'seductive':
        return Icons.favorite;
      default:
        return _getPersonalityIcon(widget.personality);
    }
  }

  LinearGradient _getPersonalityGradient(String personality) {
    switch (personality) {
      case 'amigable':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
        );
      case 'profesional':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
        );
      case 'juguetona':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
        );
      case 'misteriosa':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
        );
      case 'seductora':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE91E63), Color(0xFFF06292)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
        );
    }
  }

  Color _getPersonalityColor(String personality) {
    switch (personality) {
      case 'amigable':
        return const Color(0xFF4CAF50);
      case 'profesional':
        return const Color(0xFF2196F3);
      case 'juguetona':
        return const Color(0xFFFF9800);
      case 'misteriosa':
        return const Color(0xFF9C27B0);
      case 'seductora':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData _getPersonalityIcon(String personality) {
    switch (personality) {
      case 'amigable':
        return Icons.favorite;
      case 'profesional':
        return Icons.psychology;
      case 'juguetona':
        return Icons.celebration;
      case 'misteriosa':
        return Icons.auto_awesome;
      case 'seductora':
        return Icons.favorite_border;
      default:
        return Icons.person;
    }
  }
}