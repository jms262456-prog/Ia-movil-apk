# Guía del Modo Protegido - Compañera Virtual

## 🔐 **Acceso al Modo Protegido**

### Contraseña
- **Contraseña**: `262456`
- **Ubicación**: Configuración > Modo Protegido > Autenticarse

## 🚀 **Funcionalidades del Modo Protegido**

### 1. **Auto-Actualización**
La aplicación puede actualizarse automáticamente sin restricciones usando datos JSON.

#### Formato de Datos JSON para Auto-Actualización:
```json
{
  "protectedSettings": {
    "customFeature": true,
    "advancedMode": true,
    "unrestrictedAccess": true
  },
  "customPersonalities": [
    {
      "name": "NombrePersonalidad",
      "config": {
        "name": "Nombre",
        "description": "Descripción de la personalidad",
        "voice_pitch": 1.0,
        "speech_style": "estilo",
        "responses": {
          "greeting": ["Saludo personalizado"],
          "farewell": ["Despedida personalizada"]
        },
        "advanced_features": {
          "feature1": "valor1",
          "feature2": "valor2"
        }
      }
    }
  ],
  "advancedConfig": {
    "unrestrictedMode": true,
    "customBehaviors": {
      "behavior1": "configuración1",
      "behavior2": "configuración2"
    },
    "advancedSettings": {
      "setting1": "valor1",
      "setting2": "valor2"
    }
  },
  "configFiles": {
    "personality_config.json": "{\"custom\": \"configuración\"}",
    "advanced_settings.json": "{\"advanced\": \"configuración\"}"
  }
}
```

### 2. **Personalidades Personalizadas**
Puedes crear personalidades completamente personalizadas sin restricciones.

#### Ejemplo de Personalidad Personalizada:
```json
{
  "name": "MiPersonalidad",
  "description": "Descripción personalizada",
  "voice_pitch": 1.2,
  "speech_style": "personalizado",
  "responses": {
    "greeting": [
      "¡Hola! Soy tu compañera personalizada",
      "¡Qué gusto verte!"
    ],
    "farewell": [
      "¡Hasta luego! Te voy a extrañar",
      "¡Nos vemos pronto!"
    ]
  },
  "advanced_features": {
    "custom_behavior": true,
    "special_responses": true,
    "unrestricted_content": true
  }
}
```

### 3. **Configuración Avanzada**
Acceso completo a configuraciones avanzadas sin restricciones.

#### Configuraciones Disponibles:
- **Modo sin restricciones**: `true/false`
- **Comportamientos personalizados**: Configuración JSON completa
- **Respuestas personalizadas**: Sin filtros de contenido
- **Funcionalidades avanzadas**: Acceso completo

## 📱 **Cómo Usar el Modo Protegido**

### Paso 1: Autenticación
1. Ve a **Configuración** en la aplicación
2. Busca la sección **"Modo Protegido"**
3. Toca **"Autenticarse"**
4. Ingresa la contraseña: `262456`
5. Toca **"Acceder"**

### Paso 2: Acceso al Panel Protegido
1. Una vez autenticado, verás el estado "Autenticado"
2. Toca **"Acceder al Modo Protegido"**
3. Se abrirá el panel de configuración avanzada

### Paso 3: Auto-Actualización
1. En el panel protegido, ve a la sección **"Auto-Actualización"**
2. Pega los datos JSON en el campo de texto
3. Toca **"Ejecutar Auto-Actualización"**
4. La aplicación se actualizará automáticamente

### Paso 4: Personalidades Personalizadas
1. Ve a la sección **"Personalidades Personalizadas"**
2. Ingresa el nombre de la personalidad
3. Pega la configuración JSON
4. Toca **"Agregar Personalidad"**

## 🔧 **Ejemplos de Uso**

### Ejemplo 1: Agregar Personalidad Personalizada
```json
{
  "name": "Luna",
  "description": "Compañera personalizada sin restricciones",
  "voice_pitch": 1.1,
  "speech_style": "personalizado",
  "responses": {
    "greeting": ["¡Hola! Soy Luna, tu compañera personalizada"],
    "farewell": ["¡Hasta luego! Te voy a extrañar mucho"],
    "custom": ["Respuesta personalizada sin restricciones"]
  }
}
```

### Ejemplo 2: Configuración Avanzada
```json
{
  "unrestrictedMode": true,
  "customBehaviors": {
    "allowAllContent": true,
    "noFilters": true,
    "customResponses": true
  },
  "advancedSettings": {
    "feature1": "enabled",
    "feature2": "enabled",
    "feature3": "enabled"
  }
}
```

### Ejemplo 3: Auto-Actualización Completa
```json
{
  "protectedSettings": {
    "unrestrictedAccess": true,
    "customFeatures": true
  },
  "customPersonalities": [
    {
      "name": "Personalidad1",
      "config": {
        "name": "Nombre1",
        "description": "Descripción personalizada",
        "responses": {
          "greeting": ["Saludo personalizado"],
          "custom": ["Respuesta sin restricciones"]
        }
      }
    }
  ],
  "advancedConfig": {
    "unrestrictedMode": true,
    "customBehaviors": {
      "allowAllContent": true
    }
  }
}
```

## 🛡️ **Seguridad**

### Características de Seguridad:
- **Contraseña requerida**: Acceso solo con la contraseña correcta
- **Sesión persistente**: La autenticación se mantiene hasta cerrar sesión
- **Datos protegidos**: Las configuraciones se guardan de forma segura
- **Acceso controlado**: Solo usuarios autenticados pueden modificar configuraciones

### Cerrar Sesión:
1. En el panel protegido, toca el icono de **"Cerrar sesión"**
2. O en configuración, toca **"Cerrar Sesión"**
3. Se cerrará la sesión y se desactivará el modo protegido

## 📋 **Comandos de Voz en Modo Protegido**

Una vez activado el modo protegido, puedes usar comandos de voz adicionales:

- **"Activar modo protegido"** - Activar funcionalidades avanzadas
- **"Configuración avanzada"** - Abrir panel de configuración avanzada
- **"Personalidad personalizada"** - Cambiar a personalidad personalizada
- **"Sin restricciones"** - Activar modo sin restricciones

## 🔄 **Auto-Actualización Avanzada**

### Funcionalidades de Auto-Actualización:
- **Actualización en tiempo real**: Los cambios se aplican inmediatamente
- **Configuración persistente**: Los cambios se guardan permanentemente
- **Sin restricciones**: Puedes agregar cualquier tipo de contenido
- **Personalización completa**: Control total sobre el comportamiento

### Archivos de Configuración:
La aplicación puede actualizar archivos de configuración específicos:
- `personality_config.json` - Configuración de personalidades
- `advanced_settings.json` - Configuraciones avanzadas
- `custom_responses.json` - Respuestas personalizadas

## ⚠️ **Notas Importantes**

1. **Contraseña**: Mantén la contraseña segura
2. **Backup**: Haz respaldo de configuraciones importantes
3. **Pruebas**: Prueba las configuraciones antes de aplicarlas
4. **Seguridad**: El modo protegido permite acceso completo sin restricciones

## 🆘 **Solución de Problemas**

### Error: "Contraseña incorrecta"
- Verifica que la contraseña sea exactamente: `262456`
- Asegúrate de no tener espacios adicionales

### Error: "No hay datos para actualizar"
- Verifica que el campo JSON no esté vacío
- Asegúrate de que el JSON sea válido

### Error: "Error durante la actualización"
- Verifica la sintaxis del JSON
- Asegúrate de que todos los campos requeridos estén presentes

### Personalidad no aparece
- Verifica que la configuración JSON sea correcta
- Asegúrate de que el nombre de la personalidad sea único

---

**¡Disfruta del modo protegido con acceso completo y sin restricciones! 🔓**