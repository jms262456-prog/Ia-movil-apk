# Compañera Virtual - Aplicación Interactiva

Una aplicación móvil avanzada de compañera virtual con capacidades de cámara, reconocimiento de voz y inteligencia artificial, completamente desarrollada en Flutter.

## 🌟 Características Principales

### 🎤 Interacción por Voz
- **Reconocimiento de voz** en tiempo real
- **Síntesis de voz** con múltiples configuraciones
- **Comandos de voz** predefinidos
- **Configuración personalizable** de volumen, velocidad y tono

### 📸 Funcionalidades de Cámara
- **Vista previa en tiempo real** de la cámara
- **Captura de fotos** con alta calidad
- **Grabación de video** con controles avanzados
- **Cambio entre cámaras** frontal y trasera
- **Control de flash** automático y manual
- **Zoom digital** con controles táctiles

### 🤖 Inteligencia Artificial
- **5 personalidades diferentes** predefinidas
- **Respuestas contextuales** inteligentes
- **Procesamiento de comandos** de voz y texto
- **Sistema de emociones** en las respuestas
- **Configuración de creatividad** y formalidad

### 🎨 Interfaz Moderna
- **Diseño Material 3** con temas claro y oscuro
- **Animaciones fluidas** y transiciones suaves
- **Interfaz intuitiva** y fácil de usar
- **Responsive design** para diferentes tamaños de pantalla

## 🚀 Personalidades Disponibles

### 🌸 Luna (Amigable)
- **Descripción**: Compañera cálida y cariñosa
- **Estilo**: Casual y cercano
- **Color**: Verde suave

### 🧠 Athena (Profesional)
- **Descripción**: Asistente inteligente y enfocada
- **Estilo**: Formal y eficiente
- **Color**: Azul profesional

### 🎈 Nova (Juguetona)
- **Descripción**: Compañera energética y divertida
- **Estilo**: Entusiasta y animado
- **Color**: Naranja vibrante

### 🌙 Shadow (Misteriosa)
- **Descripción**: Compañera misteriosa e intrigante
- **Estilo**: Enigmático y sugerente
- **Color**: Púrpura oscuro

### 💋 Venus (Seductora)
- **Descripción**: Compañera seductora y atractiva
- **Estilo**: Sensual y atractivo
- **Color**: Rosa intenso

## 📱 Comandos de Voz Disponibles

### Comandos Básicos
- **"Hola"** - Saludo inicial
- **"Adiós"** - Despedida
- **"Cómo estás"** - Pregunta sobre bienestar
- **"Gracias"** - Agradecimiento

### Comandos de Cámara
- **"Toma una foto"** - Capturar imagen
- **"Graba video"** - Iniciar grabación
- **"Para grabación"** - Detener grabación
- **"Cambia cámara"** - Alternar entre cámaras
- **"Enciende flash"** - Activar linterna
- **"Apaga flash"** - Desactivar linterna

### Comandos de Sistema
- **"Ajustes"** - Abrir configuración
- **"Ayuda"** - Mostrar comandos disponibles

## 🛠️ Instalación y Configuración

### Requisitos Previos
- **Flutter SDK** 3.0.0 o superior
- **Dart SDK** 2.17.0 o superior
- **Android Studio** o **VS Code**
- **Dispositivo Android** con API 21+ o emulador

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/companera-virtual.git
   cd companera-virtual
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar permisos**
   - Asegúrate de que tu dispositivo tenga permisos de cámara y micrófono
   - La aplicación solicitará permisos automáticamente al iniciar

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

### Configuración de Android

1. **Abrir `android/app/build.gradle`**
2. **Verificar configuración mínima**:
   ```gradle
   android {
       compileSdkVersion 33
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 33
       }
   }
   ```

3. **Permisos en `android/app/src/main/AndroidManifest.xml`**:
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.RECORD_AUDIO" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   ```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── providers/               # Proveedores de estado
│   ├── app_state.dart       # Estado global de la aplicación
│   ├── camera_provider.dart # Control de cámara
│   ├── voice_provider.dart  # Control de voz
│   └── ai_provider.dart     # Procesamiento de IA
├── screens/                 # Pantallas principales
│   └── home_screen.dart     # Pantalla principal
├── widgets/                 # Widgets reutilizables
│   ├── companion_avatar.dart # Avatar de la compañera
│   ├── voice_controls.dart  # Controles de voz
│   ├── camera_view.dart     # Vista de cámara
│   ├── chat_interface.dart  # Interfaz de chat
│   └── control_panel.dart   # Panel de configuración
└── utils/                   # Utilidades
    ├── permissions.dart     # Manejo de permisos
    └── theme.dart          # Temas y estilos
```

## 🔧 Configuración Avanzada

### Personalización de Personalidades

Puedes agregar nuevas personalidades editando el archivo `lib/providers/app_state.dart`:

```dart
Map<String, Map<String, dynamic>> get personalityPresets => {
  'tu_personalidad': {
    'name': 'Nombre',
    'description': 'Descripción de la personalidad',
    'voice_pitch': 1.0,
    'speech_style': 'estilo',
  },
  // ... otras personalidades
};
```

### Configuración de IA

En `lib/providers/ai_provider.dart` puedes:
- Ajustar la creatividad de las respuestas
- Configurar el nivel de formalidad
- Habilitar/deshabilitar contexto
- Personalizar respuestas por personalidad

### Temas Personalizados

Modifica `lib/utils/theme.dart` para:
- Cambiar colores principales
- Ajustar estilos de texto
- Personalizar componentes UI

## 🚀 Funcionalidades Futuras

### Próximas Actualizaciones
- [ ] **Integración con APIs de IA** (OpenAI, Google AI)
- [ ] **Reconocimiento facial** y análisis de emociones
- [ ] **Sistema de memoria** a largo plazo
- [ ] **Múltiples idiomas** de soporte
- [ ] **Sincronización en la nube** de configuraciones
- [ ] **Widgets de escritorio** para Android
- [ ] **Modo AR** con realidad aumentada
- [ ] **Sistema de plugins** para funcionalidades adicionales

### Modo Extensible
La aplicación está diseñada para ser fácilmente extensible. Puedes:
- Agregar nuevas personalidades
- Implementar nuevos comandos de voz
- Integrar servicios externos de IA
- Crear widgets personalizados
- Añadir funcionalidades de cámara avanzadas

## 🤝 Contribución

¡Las contribuciones son bienvenidas! Para contribuir:

1. **Fork** el repositorio
2. **Crea** una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. **Commit** tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. **Push** a la rama (`git push origin feature/nueva-funcionalidad`)
5. **Crea** un Pull Request

### Guías de Contribución
- Mantén el código limpio y bien documentado
- Sigue las convenciones de Flutter/Dart
- Agrega tests para nuevas funcionalidades
- Actualiza la documentación según sea necesario

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🆘 Soporte

Si tienes problemas o preguntas:

1. **Revisa** la documentación
2. **Busca** en los issues existentes
3. **Crea** un nuevo issue con detalles completos
4. **Contacta** al equipo de desarrollo

## 🙏 Agradecimientos

- **Flutter Team** por el framework increíble
- **Comunidad de desarrolladores** por las librerías utilizadas
- **Contribuidores** que han ayudado al proyecto

---

**¡Disfruta de tu compañera virtual! 🌟**

*Desarrollado con ❤️ usando Flutter*