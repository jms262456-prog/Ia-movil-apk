# IA Móvil - Asistente de Inteligencia Artificial de Código Abierto

![IA Móvil Logo](https://img.shields.io/badge/IA%20M%C3%B3vil-Open%20Source%20AI-blue?style=for-the-badge&logo=android)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![React 18+](https://img.shields.io/badge/react-18+-blue.svg)](https://reactjs.org/)
[![Flask](https://img.shields.io/badge/flask-2.3+-green.svg)](https://flask.palletsprojects.com/)
[![Docker](https://img.shields.io/badge/docker-ready-blue.svg)](https://www.docker.com/)

## 🚀 Descripción

**IA Móvil** es un asistente de inteligencia artificial de código abierto diseñado para dispositivos móviles, inspirado en las capacidades de Manus. Proporciona una interfaz conversacional intuitiva con acceso a herramientas avanzadas como búsqueda web, ejecución de código, manipulación de archivos, análisis de datos y mucho más.

### ✨ Características Principales

- **🤖 Asistente IA Conversacional**: Interfaz de chat intuitiva con capacidades avanzadas de procesamiento de lenguaje natural
- **🔍 Búsqueda Web Inteligente**: Integración con APIs de búsqueda para obtener información actualizada
- **💻 Ejecución de Código**: Soporte para Python, JavaScript y Bash en entorno sandboxed
- **📁 Gestión de Archivos**: Operaciones CRUD completas con almacenamiento seguro
- **📊 Análisis de Datos**: Capacidades de análisis y visualización de datos estructurados
- **🔧 Arquitectura Modular**: Sistema de herramientas extensible y personalizable
- **📱 Diseño Responsivo**: Optimizado para dispositivos móviles y desktop
- **🔒 Seguridad**: Ejecución sandboxed y validación de entrada robusta
- **🆓 Completamente Gratuito**: Sin anuncios, sin suscripciones, código 100% abierto

## 🏗️ Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND (React)                         │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐│
│  │   Chat UI       │ │   Tool Display  │ │   Status Bar    ││
│  └─────────────────┘ └─────────────────┘ └─────────────────┘│
└─────────────────────────────────────────────────────────────┘
                              │ HTTP/WebSocket
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    BACKEND (Flask)                          │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐│
│  │   AI Agent      │ │   Tool Manager  │ │   API Routes    ││
│  └─────────────────┘ └─────────────────┘ └─────────────────┘│
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    SERVICIOS EXTERNOS                       │
│  ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐│
│  │   OpenAI API    │ │   Search APIs   │ │   File System   ││
│  └─────────────────┘ └─────────────────┘ └─────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

## 📋 Requisitos del Sistema

### Desarrollo
- **Python**: 3.8 o superior
- **Node.js**: 16.x o superior
- **npm/pnpm**: Para gestión de dependencias del frontend
- **Git**: Para control de versiones

### Producción
- **Sistema Operativo**: Ubuntu 20.04+, CentOS 8+, o Debian 11+
- **RAM**: Mínimo 2GB, recomendado 4GB
- **Almacenamiento**: 20GB disponibles
- **Red**: Conexión a internet estable
- **Docker** (opcional): Para despliegue containerizado

## 🛠️ Instalación y Configuración

### Instalación Rápida con Docker

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/ia-movil.git
cd ia-movil

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus configuraciones

# Iniciar con Docker Compose
docker-compose up -d

# La aplicación estará disponible en http://localhost:80
```

### Instalación Manual

#### 1. Configurar Backend

```bash
# Navegar al directorio del backend
cd ai_mobile_backend

# Crear entorno virtual
python3 -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate

# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno
export OPENAI_API_KEY="tu-clave-openai-aqui"
export FLASK_SECRET_KEY="clave-secreta-muy-segura"

# Iniciar servidor de desarrollo
python src/main.py
```

#### 2. Configurar Frontend

```bash
# En una nueva terminal, navegar al frontend
cd ai_mobile_frontend

# Instalar dependencias
pnpm install

# Iniciar servidor de desarrollo
pnpm run dev
```

#### 3. Acceder a la Aplicación

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:5000
- **Documentación API**: http://localhost:5000/api/docs

## 🔧 Configuración

### Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto con las siguientes variables:

```bash
# Configuración del Backend
FLASK_ENV=development
FLASK_SECRET_KEY=tu-clave-secreta-muy-segura
OPENAI_API_KEY=tu-clave-openai
OPENAI_API_BASE=https://api.openai.com/v1

# Configuración de Base de Datos
DATABASE_URL=sqlite:///app.db

# Configuración de CORS
CORS_ORIGINS=http://localhost:5173,http://localhost:3000

# Configuración de Herramientas
TEMP_DIR=/tmp/ai_agent_workspace
MAX_FILE_SIZE=16777216  # 16MB

# Configuración de Búsqueda (opcional)
SEARCH_API_KEY=tu-clave-de-busqueda-opcional
```

### Configuración Avanzada

Para configuraciones más avanzadas, consulta los archivos:
- `ai_mobile_backend/src/config.py` - Configuración del backend
- `ai_mobile_frontend/vite.config.js` - Configuración del frontend
- `docker-compose.yml` - Configuración de contenedores

## 📚 Uso de la Aplicación

### Interfaz de Usuario

La aplicación presenta una interfaz de chat limpia y moderna donde puedes:

1. **Enviar mensajes**: Escribe tu consulta o solicitud en el campo de texto
2. **Ver respuestas**: El asistente responderá con información detallada
3. **Observar herramientas**: Las herramientas utilizadas se muestran con badges
4. **Revisar historial**: Mantén un historial completo de la conversación

### Comandos y Capacidades

#### Búsqueda Web
```
Busca información sobre inteligencia artificial en 2024
```

#### Ejecución de Código
```
Ejecuta este código Python:
print("Hola mundo desde IA Móvil!")
```

#### Manipulación de Archivos
```
Crea un archivo llamado "notas.txt" con el contenido "Mis notas importantes"
```

#### Análisis de Datos
```
Analiza estos datos: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

## 🔌 API Endpoints

### Endpoints Principales

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/ai/chat` | Enviar mensaje al asistente IA |
| GET | `/api/ai/status` | Obtener estado del agente |
| POST | `/api/ai/reset` | Reiniciar conversación |
| GET | `/api/tools` | Listar herramientas disponibles |
| POST | `/api/tools/search` | Realizar búsqueda web |
| POST | `/api/tools/execute` | Ejecutar código |
| POST | `/api/tools/file` | Operaciones de archivos |

### Ejemplo de Uso de API

```javascript
// Enviar mensaje al asistente
const response = await fetch('/api/ai/chat', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    message: "Hola, ¿cómo estás?",
    conversation_id: "session-123"
  })
});

const data = await response.json();
console.log(data.response);
```

## 🚀 Despliegue en Producción

### Despliegue con Docker

```bash
# Build y despliegue
docker-compose -f docker-compose.prod.yml up -d

# Verificar estado
docker-compose ps

# Ver logs
docker-compose logs -f
```

### Despliegue Manual

1. **Configurar servidor web** (Nginx/Apache)
2. **Instalar dependencias** de producción
3. **Configurar SSL/TLS** para HTTPS
4. **Configurar base de datos** (PostgreSQL/MySQL para producción)
5. **Configurar monitoreo** y logs

Consulta la [Guía de Despliegue](deployment_guide.md) para instrucciones detalladas.

## 📱 Aplicación Móvil Nativa

### Generar APK para Android

```bash
cd ai_mobile_frontend

# Instalar Capacitor
npm install @capacitor/core @capacitor/cli @capacitor/android

# Inicializar proyecto móvil
npx cap init "IA Móvil" "com.tudominio.iamovil"

# Build y sincronizar
npm run build
npx cap sync android

# Abrir en Android Studio
npx cap open android
```

### Generar App para iOS

```bash
# Instalar dependencias iOS
npm install @capacitor/ios

# Sincronizar y abrir Xcode
npx cap sync ios
npx cap open ios
```

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Por favor, sigue estos pasos:

1. **Fork** el repositorio
2. **Crea** una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. **Commit** tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. **Push** a la rama (`git push origin feature/nueva-funcionalidad`)
5. **Abre** un Pull Request

### Guías de Contribución

- Sigue las convenciones de código existentes
- Agrega tests para nuevas funcionalidades
- Actualiza la documentación según sea necesario
- Asegúrate de que todos los tests pasen

## 🐛 Reporte de Bugs

Si encuentras un bug, por favor abre un issue con:

- Descripción detallada del problema
- Pasos para reproducir
- Comportamiento esperado vs actual
- Screenshots (si aplica)
- Información del sistema

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

## 🙏 Agradecimientos

- **OpenAI** por proporcionar las APIs de IA
- **React** y **Flask** por los frameworks base
- **Comunidad Open Source** por las librerías y herramientas
- **Manus** por la inspiración del diseño

## 📞 Soporte

- **Documentación**: [Wiki del proyecto](https://github.com/tu-usuario/ia-movil/wiki)
- **Issues**: [GitHub Issues](https://github.com/tu-usuario/ia-movil/issues)
- **Discusiones**: [GitHub Discussions](https://github.com/tu-usuario/ia-movil/discussions)
- **Email**: soporte@tu-dominio.com

## 🗺️ Roadmap

### Versión 1.1
- [ ] Soporte para más modelos de IA (Anthropic, Cohere)
- [ ] Integración con bases de datos externas
- [ ] Sistema de plugins extensible
- [ ] Modo offline con modelos locales

### Versión 1.2
- [ ] Interfaz de voz (Speech-to-Text/Text-to-Speech)
- [ ] Colaboración en tiempo real
- [ ] Integración con servicios en la nube
- [ ] Análisis avanzado de datos

### Versión 2.0
- [ ] Agentes especializados por dominio
- [ ] Interfaz de realidad aumentada
- [ ] Integración IoT
- [ ] Marketplace de herramientas

---

**Desarrollado con ❤️ por la comunidad Open Source**

*¿Te gusta el proyecto? ¡Dale una ⭐ en GitHub!*

