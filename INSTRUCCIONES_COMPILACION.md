# Instrucciones de Compilación - Compañera Virtual

## 🚀 Compilación Rápida

### 1. Verificar Flutter
```bash
flutter doctor
```
Asegúrate de que Flutter esté correctamente instalado y configurado.

### 2. Obtener Dependencias
```bash
flutter pub get
```

### 3. Ejecutar en Modo Debug
```bash
flutter run
```

### 4. Compilar APK de Release
```bash
flutter build apk --release
```

## 📱 Configuración Detallada

### Requisitos del Sistema
- **Flutter SDK**: 3.0.0 o superior
- **Dart SDK**: 2.17.0 o superior
- **Android Studio**: 2021.3 o superior
- **Android SDK**: API 21+ (Android 5.0)
- **Dispositivo**: Android 5.0+ o emulador

### Configuración de Android Studio

1. **Abrir el proyecto**
   - Abre Android Studio
   - Selecciona "Open an existing project"
   - Navega a la carpeta del proyecto y selecciónala

2. **Configurar SDK**
   - Ve a File > Settings > Appearance & Behavior > System Settings > Android SDK
   - Asegúrate de tener instalado:
     - Android SDK Platform 33 (Android 13)
     - Android SDK Build-Tools 33.0.0
     - Android SDK Platform-Tools

3. **Configurar Emulador**
   - Ve a Tools > AVD Manager
   - Crea un nuevo dispositivo virtual
   - Recomendado: Pixel 6 con API 33

### Configuración de Permisos

La aplicación solicitará automáticamente los siguientes permisos:

- **Cámara**: Para captura de fotos y videos
- **Micrófono**: Para reconocimiento de voz
- **Almacenamiento**: Para guardar archivos multimedia
- **Internet**: Para futuras funcionalidades de IA

### Solución de Problemas Comunes

#### Error: "Permission denied"
```bash
# En Linux/macOS
chmod +x android/gradlew
```

#### Error: "Gradle sync failed"
```bash
# Limpiar cache de Gradle
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

#### Error: "Camera not available"
- Verifica que el dispositivo tenga cámara
- Asegúrate de que los permisos estén concedidos
- En emulador, verifica que la cámara esté habilitada

#### Error: "Microphone not available"
- Verifica que el dispositivo tenga micrófono
- Asegúrate de que los permisos estén concedidos
- En emulador, verifica que el micrófono esté habilitado

#### Error: "Speech recognition not working"
- Verifica que Google Play Services esté actualizado
- Asegúrate de tener conexión a internet
- Verifica que el idioma español esté instalado

## 🔧 Configuración Avanzada

### Modo de Desarrollo

1. **Habilitar modo debug**
   ```bash
   flutter run --debug
   ```

2. **Habilitar hot reload**
   - Presiona `r` en la terminal para hot reload
   - Presiona `R` para hot restart

3. **Ver logs detallados**
   ```bash
   flutter run --verbose
   ```

### Modo de Producción

1. **Compilar APK optimizado**
   ```bash
   flutter build apk --release --split-per-abi
   ```

2. **Compilar App Bundle**
   ```bash
   flutter build appbundle --release
   ```

3. **Firmar APK**
   ```bash
   # Generar keystore
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   
   # Firmar APK
   jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ~/upload-keystore.jks app-release-unsigned.apk upload
   ```

### Configuración de ProGuard

El archivo `android/app/proguard-rules.pro` ya está configurado para optimizar el código. Si necesitas personalizarlo:

```proguard
# Reglas para Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Reglas para cámara
-keep class androidx.camera.** { *; }

# Reglas para ML Kit
-keep class com.google.mlkit.** { *; }

# Reglas para TensorFlow Lite
-keep class org.tensorflow.lite.** { *; }
```

## 📊 Optimización de Rendimiento

### Configuración de Memoria

1. **Aumentar heap size**
   ```bash
   export GRADLE_OPTS="-Xmx4096m -XX:MaxPermSize=512m"
   ```

2. **Configurar Android Studio**
   - Ve a Help > Edit Custom VM Options
   - Ajusta los valores de memoria según tu sistema

### Optimización de Build

1. **Habilitar paralelización**
   ```bash
   export GRADLE_OPTS="-Dorg.gradle.parallel=true"
   ```

2. **Habilitar cache**
   ```bash
   export GRADLE_OPTS="-Dorg.gradle.caching=true"
   ```

## 🧪 Testing

### Ejecutar Tests
```bash
# Tests unitarios
flutter test

# Tests de integración
flutter test integration_test/

# Tests con coverage
flutter test --coverage
```

### Testing en Dispositivo Físico

1. **Habilitar modo desarrollador**
   - Ve a Configuración > Acerca del teléfono
   - Toca 7 veces en "Número de compilación"

2. **Habilitar depuración USB**
   - Ve a Configuración > Opciones de desarrollador
   - Activa "Depuración USB"

3. **Conectar dispositivo**
   ```bash
   flutter devices
   flutter run -d <device-id>
   ```

## 📦 Distribución

### Preparar para Google Play Store

1. **Generar App Bundle**
   ```bash
   flutter build appbundle --release
   ```

2. **Probar en dispositivos**
   - Instala en diferentes dispositivos
   - Verifica todas las funcionalidades
   - Prueba en diferentes versiones de Android

3. **Subir a Google Play Console**
   - Crea una cuenta de desarrollador
   - Sube el archivo .aab
   - Completa la información de la aplicación

### Preparar para Distribución Externa

1. **Generar APK universal**
   ```bash
   flutter build apk --release
   ```

2. **Firmar APK**
   - Usa el proceso de firma descrito arriba

3. **Distribuir**
   - Sube a servicios como Firebase App Distribution
   - Comparte directamente con usuarios

## 🔍 Debugging

### Logs de Flutter
```bash
flutter logs
```

### Logs de Android
```bash
adb logcat
```

### Debugging de Cámara
```bash
adb shell dumpsys media.camera
```

### Debugging de Audio
```bash
adb shell dumpsys audio
```

## 📚 Recursos Adicionales

- [Documentación de Flutter](https://flutter.dev/docs)
- [Guía de Android](https://developer.android.com/guide)
- [ML Kit Documentation](https://developers.google.com/ml-kit)
- [TensorFlow Lite](https://www.tensorflow.org/lite)

## 🆘 Soporte

Si encuentras problemas:

1. **Revisa los logs** de error
2. **Verifica la configuración** de Flutter
3. **Consulta la documentación** oficial
4. **Crea un issue** en el repositorio

---

**¡Feliz desarrollo! 🚀**