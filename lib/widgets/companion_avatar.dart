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
  late AnimationController _blinkController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _hairAnimation;
  late Animation<double> _blinkAnimation;

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
    
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 200),
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
    
    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
    
    _startAnimations();
  }

  void _startAnimations() {
    _breathingController.repeat(reverse: true);
    _hairController.repeat(reverse: true);
    
    // Parpadear cada 3-5 segundos
    _scheduleBlink();
    
    if (widget.isSpeaking) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _scheduleBlink() {
    Future.delayed(Duration(milliseconds: 3000 + (DateTime.now().millisecondsSinceEpoch % 2000)), () {
      if (mounted) {
        _blinkController.forward().then((_) {
          _blinkController.reverse().then((_) {
            _scheduleBlink();
          });
        });
      }
    });
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
    _blinkController.dispose();
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
            animation: Listenable.merge([_pulseAnimation, _breathingAnimation, _hairAnimation, _blinkAnimation]),
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
                      // Avatar anime principal
                      _buildAnimeAvatar(avatarSettings, isUnrestricted),
                      
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

  Widget _buildAnimeAvatar(Map<String, dynamic> avatarSettings, bool isUnrestricted) {
    final style = avatarSettings['style'] ?? 'default';
    final expression = avatarSettings['expression'] ?? 'friendly';
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: Center(
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: AnimeAvatarPainter(
            style: style,
            expression: expression,
            isUnrestricted: isUnrestricted,
            personality: widget.personality,
            blinkValue: _blinkAnimation.value,
            hairValue: _hairAnimation.value,
          ),
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
}

class AnimeAvatarPainter extends CustomPainter {
  final String style;
  final String expression;
  final bool isUnrestricted;
  final String personality;
  final double blinkValue;
  final double hairValue;

  AnimeAvatarPainter({
    required this.style,
    required this.expression,
    required this.isUnrestricted,
    required this.personality,
    required this.blinkValue,
    required this.hairValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Color de piel
    final skinColor = Color(0xFFFFE4C4);
    
    // Color de cabello
    final hairColor = _getHairColor();
    
    // Color de ojos
    final eyeColor = _getEyeColor();

    // Dibujar cabello
    _drawHair(canvas, center, radius, hairColor);
    
    // Dibujar cara
    _drawFace(canvas, center, radius, skinColor);
    
    // Dibujar ojos
    _drawEyes(canvas, center, radius, eyeColor);
    
    // Dibujar boca
    _drawMouth(canvas, center, radius);
    
    // Dibujar detalles faciales
    _drawFacialDetails(canvas, center, radius);
  }

  void _drawHair(Canvas canvas, Offset center, double radius, Color hairColor) {
    final hairPaint = Paint()
      ..color = hairColor
      ..style = PaintingStyle.fill;

    // Cabello principal
    final hairPath = Path();
    hairPath.moveTo(center.dx - radius * 0.8, center.dy - radius * 0.3);
    hairPath.quadraticBezierTo(
      center.dx - radius * 0.9, center.dy - radius * 0.8,
      center.dx, center.dy - radius * 0.9
    );
    hairPath.quadraticBezierTo(
      center.dx + radius * 0.9, center.dy - radius * 0.8,
      center.dx + radius * 0.8, center.dy - radius * 0.3
    );
    hairPath.lineTo(center.dx + radius * 0.7, center.dy + radius * 0.2);
    hairPath.quadraticBezierTo(
      center.dx + radius * 0.5, center.dy + radius * 0.4,
      center.dx, center.dy + radius * 0.3
    );
    hairPath.quadraticBezierTo(
      center.dx - radius * 0.5, center.dy + radius * 0.4,
      center.dx - radius * 0.7, center.dy + radius * 0.2
    );
    hairPath.close();
    
    canvas.drawPath(hairPath, hairPaint);

    // Mechas de cabello
    _drawHairStrands(canvas, center, radius, hairColor);
  }

  void _drawHairStrands(Canvas canvas, Offset center, double radius, Color hairColor) {
    final hairPaint = Paint()
      ..color = hairColor
      ..style = PaintingStyle.fill;

    // Mechas laterales
    for (int i = 0; i < 3; i++) {
      final strandPath = Path();
      final xOffset = (i - 1) * radius * 0.2;
      final yOffset = -radius * 0.1 + i * radius * 0.05;
      
      strandPath.moveTo(center.dx + xOffset, center.dy + yOffset);
      strandPath.quadraticBezierTo(
        center.dx + xOffset + radius * 0.1, center.dy + yOffset + radius * 0.2,
        center.dx + xOffset, center.dy + yOffset + radius * 0.4
      );
      strandPath.quadraticBezierTo(
        center.dx + xOffset - radius * 0.05, center.dy + yOffset + radius * 0.3,
        center.dx + xOffset, center.dy + yOffset + radius * 0.2
      );
      strandPath.close();
      
      canvas.drawPath(strandPath, hairPaint);
    }
  }

  void _drawFace(Canvas canvas, Offset center, double radius, Color skinColor) {
    final facePaint = Paint()
      ..color = skinColor
      ..style = PaintingStyle.fill;

    // Cara ovalada
    final faceRect = Rect.fromCenter(
      center: center,
      width: radius * 1.6,
      height: radius * 2.0,
    );
    
    canvas.drawOval(faceRect, facePaint);

    // Mejillas rosadas
    final cheekPaint = Paint()
      ..color = Color(0xFFFFB6C1).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - radius * 0.4, center.dy + radius * 0.1),
      radius * 0.15,
      cheekPaint,
    );
    
    canvas.drawCircle(
      Offset(center.dx + radius * 0.4, center.dy + radius * 0.1),
      radius * 0.15,
      cheekPaint,
    );
  }

  void _drawEyes(Canvas canvas, Offset center, double radius, Color eyeColor) {
    final eyePaint = Paint()
      ..color = eyeColor
      ..style = PaintingStyle.fill;

    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Ojo izquierdo
    final leftEyeCenter = Offset(center.dx - radius * 0.25, center.dy - radius * 0.1);
    canvas.drawCircle(leftEyeCenter, radius * 0.12, eyePaint);
    
    // Pupila izquierda
    final leftPupilCenter = Offset(
      leftEyeCenter.dx + radius * 0.02,
      leftEyeCenter.dy + radius * 0.02
    );
    canvas.drawCircle(leftPupilCenter, radius * 0.06, pupilPaint);
    
    // Brillo ojo izquierdo
    canvas.drawCircle(
      Offset(leftEyeCenter.dx - radius * 0.04, leftEyeCenter.dy - radius * 0.04),
      radius * 0.03,
      highlightPaint,
    );

    // Ojo derecho
    final rightEyeCenter = Offset(center.dx + radius * 0.25, center.dy - radius * 0.1);
    canvas.drawCircle(rightEyeCenter, radius * 0.12, eyePaint);
    
    // Pupila derecha
    final rightPupilCenter = Offset(
      rightEyeCenter.dx + radius * 0.02,
      rightEyeCenter.dy + radius * 0.02
    );
    canvas.drawCircle(rightPupilCenter, radius * 0.06, pupilPaint);
    
    // Brillo ojo derecho
    canvas.drawCircle(
      Offset(rightEyeCenter.dx - radius * 0.04, rightEyeCenter.dy - radius * 0.04),
      radius * 0.03,
      highlightPaint,
    );

    // Párpados (para el parpadeo)
    final eyelidPaint = Paint()
      ..color = Color(0xFFFFE4C4)
      ..style = PaintingStyle.fill;

    final eyelidHeight = radius * 0.12 * blinkValue;
    
    // Párpado izquierdo
    canvas.drawOval(
      Rect.fromCenter(
        center: leftEyeCenter,
        width: radius * 0.24,
        height: eyelidHeight,
      ),
      eyelidPaint,
    );
    
    // Párpado derecho
    canvas.drawOval(
      Rect.fromCenter(
        center: rightEyeCenter,
        width: radius * 0.24,
        height: eyelidHeight,
      ),
      eyelidPaint,
    );
  }

  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = Color(0xFFFF69B4)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Boca según la expresión
    switch (expression) {
      case 'friendly':
        // Sonrisa suave
        final smilePath = Path();
        smilePath.moveTo(center.dx - radius * 0.2, center.dy + radius * 0.2);
        smilePath.quadraticBezierTo(
          center.dx, center.dy + radius * 0.3,
          center.dx + radius * 0.2, center.dy + radius * 0.2
        );
        canvas.drawPath(smilePath, mouthPaint);
        break;
      case 'seductive':
        // Sonrisa seductora
        final seductivePath = Path();
        seductivePath.moveTo(center.dx - radius * 0.15, center.dy + radius * 0.15);
        seductivePath.quadraticBezierTo(
          center.dx, center.dy + radius * 0.25,
          center.dx + radius * 0.15, center.dy + radius * 0.15
        );
        canvas.drawPath(seductivePath, mouthPaint);
        break;
      default:
        // Boca neutral
        canvas.drawLine(
          Offset(center.dx - radius * 0.15, center.dy + radius * 0.2),
          Offset(center.dx + radius * 0.15, center.dy + radius * 0.2),
          mouthPaint,
        );
    }
  }

  void _drawFacialDetails(Canvas canvas, Offset center, double radius) {
    // Nariz
    final nosePaint = Paint()
      ..color = Color(0xFFFFE4C4).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx, center.dy + radius * 0.05),
      radius * 0.03,
      nosePaint,
    );

    // Cejas
    final eyebrowPaint = Paint()
      ..color = _getHairColor()
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;

    // Ceja izquierda
    canvas.drawLine(
      Offset(center.dx - radius * 0.35, center.dy - radius * 0.25),
      Offset(center.dx - radius * 0.15, center.dy - radius * 0.2),
      eyebrowPaint,
    );
    
    // Ceja derecha
    canvas.drawLine(
      Offset(center.dx + radius * 0.15, center.dy - radius * 0.2),
      Offset(center.dx + radius * 0.35, center.dy - radius * 0.25),
      eyebrowPaint,
    );
  }

  Color _getHairColor() {
    switch (personality) {
      case 'seductora':
        return Color(0xFF8B4513); // Marrón oscuro
      case 'amigable':
        return Color(0xFFD2691E); // Marrón cálido
      case 'profesional':
        return Color(0xFF2F4F4F); // Gris oscuro
      case 'juguetona':
        return Color(0xFFFF69B4); // Rosa
      case 'misteriosa':
        return Color(0xFF4B0082); // Púrpura oscuro
      default:
        return Color(0xFF8B4513); // Marrón por defecto
    }
  }

  Color _getEyeColor() {
    switch (personality) {
      case 'seductora':
        return Color(0xFF4169E1); // Azul real
      case 'amigable':
        return Color(0xFF32CD32); // Verde lima
      case 'profesional':
        return Color(0xFF1E90FF); // Azul dodger
      case 'juguetona':
        return Color(0xFFFF6347); // Tomate
      case 'misteriosa':
        return Color(0xFF9370DB); // Púrpura medio
      default:
        return Color(0xFF4169E1); // Azul por defecto
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}