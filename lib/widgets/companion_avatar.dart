import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/theme.dart';

class CompanionAvatar extends StatelessWidget {
  final String name;
  final String personality;
  final bool isSpeaking;
  final AnimationController pulseController;

  const CompanionAvatar({
    super.key,
    required this.name,
    required this.personality,
    required this.isSpeaking,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _getPersonalityGradient(),
            boxShadow: [
              BoxShadow(
                color: _getPersonalityColor().withOpacity(0.3),
                blurRadius: isSpeaking ? 20 : 10,
                spreadRadius: isSpeaking ? 5 : 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Avatar principal
              Container(
                width: 56,
                height: 56,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: _getPersonalityImage(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // Indicador de habla
              if (isSpeaking)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              
              // Efecto de pulso
              if (isSpeaking)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getPersonalityColor().withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                  ).animate(
                    onPlay: (controller) => controller.repeat(),
                  ).scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.3, 1.3),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                  ).then().scale(
                    begin: const Offset(1.3, 1.3),
                    end: const Offset(1.0, 1.0),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  LinearGradient _getPersonalityGradient() {
    switch (personality) {
      case 'amigable':
        return const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'profesional':
        return const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'juguetona':
        return const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'misteriosa':
        return const LinearGradient(
          colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'seductora':
        return const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFF06292)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8B7FF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getPersonalityColor() {
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
        return const Color(0xFF6C63FF);
    }
  }

  AssetImage _getPersonalityImage() {
    switch (personality) {
      case 'amigable':
        return const AssetImage('assets/images/luna_avatar.png');
      case 'profesional':
        return const AssetImage('assets/images/athena_avatar.png');
      case 'juguetona':
        return const AssetImage('assets/images/nova_avatar.png');
      case 'misteriosa':
        return const AssetImage('assets/images/shadow_avatar.png');
      case 'seductora':
        return const AssetImage('assets/images/venus_avatar.png');
      default:
        return const AssetImage('assets/images/default_avatar.png');
    }
  }
}