import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

class PermissionUtils {
  static final Logger _logger = Logger();
  
  /// Solicita todos los permisos necesarios para la aplicación
  static Future<bool> requestPermissions() async {
    try {
      final results = await Future.wait([
        Permission.camera.request(),
        Permission.microphone.request(),
        Permission.storage.request(),
      ]);
      
      final allGranted = results.every((status) => status == PermissionStatus.granted);
      
      if (allGranted) {
        _logger.i('Todos los permisos concedidos');
      } else {
        _logger.w('Algunos permisos no fueron concedidos');
      }
      
      return allGranted;
    } catch (e) {
      _logger.e('Error al solicitar permisos: $e');
      return false;
    }
  }
  
  /// Verifica si todos los permisos están concedidos
  static Future<bool> checkPermissions() async {
    try {
      final results = await Future.wait([
        Permission.camera.status,
        Permission.microphone.status,
        Permission.storage.status,
      ]);
      
      return results.every((status) => status == PermissionStatus.granted);
    } catch (e) {
      _logger.e('Error al verificar permisos: $e');
      return false;
    }
  }
  
  /// Solicita permisos específicos
  static Future<bool> requestSpecificPermission(Permission permission) async {
    try {
      final status = await permission.request();
      return status == PermissionStatus.granted;
    } catch (e) {
      _logger.e('Error al solicitar permiso específico: $e');
      return false;
    }
  }
  
  /// Verifica el estado de un permiso específico
  static Future<PermissionStatus> checkSpecificPermission(Permission permission) async {
    try {
      return await permission.status;
    } catch (e) {
      _logger.e('Error al verificar permiso específico: $e');
      return PermissionStatus.denied;
    }
  }
  
  /// Abre la configuración de la aplicación
  static Future<bool> openAppSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      _logger.e('Error al abrir configuración de la aplicación: $e');
      return false;
    }
  }
  
  /// Obtiene el mensaje de error para permisos denegados
  static String getPermissionErrorMessage(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return 'Se requiere permiso de cámara para usar esta función.';
      case Permission.microphone:
        return 'Se requiere permiso de micrófono para usar esta función.';
      case Permission.storage:
        return 'Se requiere permiso de almacenamiento para guardar archivos.';
      default:
        return 'Se requiere permiso para usar esta función.';
    }
  }
  
  /// Obtiene el mensaje de solicitud de permiso
  static String getPermissionRequestMessage(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return 'Esta aplicación necesita acceso a la cámara para mostrarte la vista previa y tomar fotos.';
      case Permission.microphone:
        return 'Esta aplicación necesita acceso al micrófono para reconocer comandos de voz.';
      case Permission.storage:
        return 'Esta aplicación necesita acceso al almacenamiento para guardar fotos y videos.';
      default:
        return 'Esta aplicación necesita permisos para funcionar correctamente.';
    }
  }
}