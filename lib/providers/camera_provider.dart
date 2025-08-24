import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

class CameraProvider extends ChangeNotifier {
  final Logger _logger = Logger();
  
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  
  // Getters
  CameraController? get controller => _controller;
  List<CameraDescription> get cameras => _cameras;
  int get selectedCameraIndex => _selectedCameraIndex;
  bool get isInitialized => _isInitialized;
  bool get isRecording => _isRecording;
  bool get isFlashOn => _isFlashOn;
  bool get isFrontCamera => _isFrontCamera;
  
  CameraProvider() {
    _initializeCamera();
  }
  
  Future<void> _initializeCamera() async {
    try {
      // Solicitar permisos
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        _logger.w('Permisos de cámara no concedidos');
        return;
      }
      
      // Obtener cámaras disponibles
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _logger.e('No se encontraron cámaras disponibles');
        return;
      }
      
      // Inicializar la cámara trasera por defecto
      await _initializeController(0);
      
    } catch (e) {
      _logger.e('Error al inicializar la cámara: $e');
    }
  }
  
  Future<void> _initializeController(int cameraIndex) async {
    if (cameraIndex >= _cameras.length) return;
    
    try {
      // Liberar controlador anterior si existe
      await _controller?.dispose();
      
      _selectedCameraIndex = cameraIndex;
      _controller = CameraController(
        _cameras[cameraIndex],
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      
      await _controller!.initialize();
      _isInitialized = true;
      _isFrontCamera = _cameras[cameraIndex].lensDirection == CameraLensDirection.front;
      
      notifyListeners();
      
    } catch (e) {
      _logger.e('Error al inicializar el controlador de cámara: $e');
      _isInitialized = false;
      notifyListeners();
    }
  }
  
  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;
    
    final newIndex = _selectedCameraIndex == 0 ? 1 : 0;
    await _initializeController(newIndex);
  }
  
  Future<void> toggleFlash() async {
    if (!_isInitialized || _controller == null) return;
    
    try {
      if (_isFlashOn) {
        await _controller!.setFlashMode(FlashMode.off);
        _isFlashOn = false;
      } else {
        await _controller!.setFlashMode(FlashMode.torch);
        _isFlashOn = true;
      }
      notifyListeners();
    } catch (e) {
      _logger.e('Error al cambiar el flash: $e');
    }
  }
  
  Future<XFile?> takePicture() async {
    if (!_isInitialized || _controller == null) return null;
    
    try {
      final image = await _controller!.takePicture();
      _logger.i('Foto tomada: ${image.path}');
      return image;
    } catch (e) {
      _logger.e('Error al tomar foto: $e');
      return null;
    }
  }
  
  Future<void> startRecording() async {
    if (!_isInitialized || _controller == null || _isRecording) return;
    
    try {
      await _controller!.startVideoRecording();
      _isRecording = true;
      notifyListeners();
      _logger.i('Grabación iniciada');
    } catch (e) {
      _logger.e('Error al iniciar grabación: $e');
    }
  }
  
  Future<XFile?> stopRecording() async {
    if (!_isInitialized || _controller == null || !_isRecording) return null;
    
    try {
      final video = await _controller!.stopVideoRecording();
      _isRecording = false;
      notifyListeners();
      _logger.i('Grabación detenida: ${video.path}');
      return video;
    } catch (e) {
      _logger.e('Error al detener grabación: $e');
      _isRecording = false;
      notifyListeners();
      return null;
    }
  }
  
  Future<void> setFocusPoint(Offset point) async {
    if (!_isInitialized || _controller == null) return;
    
    try {
      await _controller!.setFocusPoint(point);
      await _controller!.setExposurePoint(point);
    } catch (e) {
      _logger.e('Error al establecer punto de enfoque: $e');
    }
  }
  
  Future<void> setZoom(double zoom) async {
    if (!_isInitialized || _controller == null) return;
    
    try {
      final currentZoom = await _controller!.getMaxZoomLevel();
      final newZoom = (zoom * currentZoom).clamp(1.0, currentZoom);
      await _controller!.setZoomLevel(newZoom);
    } catch (e) {
      _logger.e('Error al establecer zoom: $e');
    }
  }
  
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}