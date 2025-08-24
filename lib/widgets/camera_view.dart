import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../providers/camera_provider.dart';
import '../utils/theme.dart';

class CameraView extends StatelessWidget {
  final VoidCallback onClose;

  const CameraView({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<CameraProvider>(
        builder: (context, cameraProvider, child) {
          if (!cameraProvider.isInitialized) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Inicializando cámara...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Vista previa de la cámara
              CameraPreview(cameraProvider.controller!),
              
              // Controles superiores
              _buildTopControls(cameraProvider),
              
              // Controles laterales
              _buildSideControls(cameraProvider),
              
              // Controles inferiores
              _buildBottomControls(cameraProvider),
              
              // Indicador de grabación
              if (cameraProvider.isRecording) _buildRecordingIndicator(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopControls(CameraProvider cameraProvider) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            // Botón de cerrar
            GestureDetector(
              onTap: onClose,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Botón de flash
            GestureDetector(
              onTap: cameraProvider.toggleFlash,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  cameraProvider.isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Botón de cambiar cámara
            GestureDetector(
              onTap: cameraProvider.switchCamera,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.switch_camera,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideControls(CameraProvider cameraProvider) {
    return Positioned(
      right: 16,
      top: 0,
      bottom: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón de zoom
          _buildSideButton(
            icon: Icons.zoom_in,
            onTap: () => cameraProvider.setZoom(1.5),
          ),
          
          const SizedBox(height: 16),
          
          // Botón de zoom out
          _buildSideButton(
            icon: Icons.zoom_out,
            onTap: () => cameraProvider.setZoom(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSideButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildBottomControls(CameraProvider cameraProvider) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Botón de galería (placeholder)
            _buildBottomButton(
              icon: Icons.photo_library,
              onTap: () {
                // TODO: Implementar galería
              },
            ),
            
            // Botón principal de captura
            _buildCaptureButton(cameraProvider),
            
            // Botón de grabación
            _buildRecordButton(cameraProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureButton(CameraProvider cameraProvider) {
    return GestureDetector(
      onTap: () async {
        final image = await cameraProvider.takePicture();
        if (image != null) {
          // TODO: Mostrar preview de la imagen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto guardada'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
        ),
        child: const Icon(
          Icons.camera_alt,
          color: Colors.black,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildRecordButton(CameraProvider cameraProvider) {
    return GestureDetector(
      onTap: () async {
        if (cameraProvider.isRecording) {
          final video = await cameraProvider.stopRecording();
          if (video != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Video guardado'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          cameraProvider.startRecording();
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: cameraProvider.isRecording ? Colors.red : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: Icon(
          cameraProvider.isRecording ? Icons.stop : Icons.fiber_manual_record,
          color: cameraProvider.isRecording ? Colors.white : Colors.red,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return Positioned(
      top: 100,
      left: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'GRABANDO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}