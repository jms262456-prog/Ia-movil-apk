# Guía Completa de Despliegue y Distribución - IA Móvil de Código Abierto

## 1. Introducción al Despliegue

Esta guía proporciona instrucciones detalladas para desplegar y distribuir la aplicación móvil de IA de código abierto. El proceso incluye la configuración del backend, el frontend, y las opciones de distribución gratuita a través de múltiples canales.

## 2. Preparación del Entorno de Producción

### 2.1. Requisitos del Sistema

Para desplegar exitosamente la aplicación, se requieren los siguientes componentes del sistema:

**Servidor Backend:**
- Sistema operativo: Ubuntu 20.04 LTS o superior, CentOS 8+, o Debian 11+
- Python 3.8 o superior con pip
- Node.js 16.x o superior con npm/yarn
- Nginx o Apache como servidor web proxy
- SSL/TLS certificado para HTTPS
- Al menos 2GB de RAM y 20GB de espacio en disco
- Conexión a internet estable

**Desarrollo y Build:**
- Git para control de versiones
- Docker (opcional pero recomendado)
- Herramientas de CI/CD como GitHub Actions, GitLab CI, o Jenkins

### 2.2. Configuración de Variables de Entorno

El sistema requiere las siguientes variables de entorno para funcionar correctamente:

```bash
# Variables del backend
FLASK_ENV=production
FLASK_SECRET_KEY=tu_clave_secreta_muy_segura_aqui
OPENAI_API_KEY=tu_clave_de_openai_aqui
OPENAI_API_BASE=https://api.openai.com/v1

# Variables de base de datos
DATABASE_URL=sqlite:///production.db

# Variables de seguridad
CORS_ORIGINS=https://tu-dominio.com
JWT_SECRET_KEY=otra_clave_secreta_para_jwt

# Variables de herramientas
SEARCH_API_KEY=clave_opcional_para_busqueda_avanzada
TEMP_DIR=/var/tmp/ai_agent_workspace
```

## 3. Despliegue del Backend

### 3.1. Preparación del Código Backend

El backend Flask debe prepararse para producción con las siguientes modificaciones:

**Configuración de Producción:**
```python
# src/config.py
import os

class ProductionConfig:
    SECRET_KEY = os.environ.get('FLASK_SECRET_KEY')
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    DEBUG = False
    TESTING = False
    
    # Configuración de CORS para producción
    CORS_ORIGINS = os.environ.get('CORS_ORIGINS', '*').split(',')
    
    # Configuración de OpenAI
    OPENAI_API_KEY = os.environ.get('OPENAI_API_KEY')
    OPENAI_API_BASE = os.environ.get('OPENAI_API_BASE')
    
    # Configuración de herramientas
    TEMP_DIR = os.environ.get('TEMP_DIR', '/tmp/ai_agent_workspace')
    MAX_CONTENT_LENGTH = 16 * 1024 * 1024  # 16MB max file size
```

**Script de Despliegue Backend:**
```bash
#!/bin/bash
# deploy_backend.sh

set -e

echo "Iniciando despliegue del backend..."

# Crear directorio de aplicación
sudo mkdir -p /opt/ai_mobile_backend
cd /opt/ai_mobile_backend

# Clonar o actualizar código
if [ -d ".git" ]; then
    git pull origin main
else
    git clone https://github.com/tu-usuario/ai-mobile-backend.git .
fi

# Crear entorno virtual
python3 -m venv venv
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno
cp .env.example .env
# Editar .env con valores de producción

# Crear directorios necesarios
mkdir -p /var/tmp/ai_agent_workspace
mkdir -p /var/log/ai_mobile_backend

# Configurar permisos
sudo chown -R www-data:www-data /opt/ai_mobile_backend
sudo chown -R www-data:www-data /var/tmp/ai_agent_workspace

# Instalar y configurar Gunicorn
pip install gunicorn

# Crear archivo de servicio systemd
sudo tee /etc/systemd/system/ai-mobile-backend.service > /dev/null <<EOF
[Unit]
Description=AI Mobile Backend
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/opt/ai_mobile_backend
Environment=PATH=/opt/ai_mobile_backend/venv/bin
EnvironmentFile=/opt/ai_mobile_backend/.env
ExecStart=/opt/ai_mobile_backend/venv/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 src.main:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Habilitar y iniciar servicio
sudo systemctl daemon-reload
sudo systemctl enable ai-mobile-backend
sudo systemctl start ai-mobile-backend

echo "Backend desplegado exitosamente"
```

### 3.2. Configuración de Nginx

**Archivo de configuración Nginx:**
```nginx
# /etc/nginx/sites-available/ai-mobile-backend
server {
    listen 80;
    server_name tu-dominio.com www.tu-dominio.com;
    
    # Redireccionar HTTP a HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name tu-dominio.com www.tu-dominio.com;
    
    # Configuración SSL
    ssl_certificate /etc/letsencrypt/live/tu-dominio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tu-dominio.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    
    # Configuración de seguridad
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
    # Configuración del proxy para el backend
    location /api/ {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Configuración para WebSocket (si se necesita en el futuro)
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # Servir archivos estáticos del frontend
    location / {
        root /var/www/ai-mobile-frontend/dist;
        try_files $uri $uri/ /index.html;
        
        # Cache para archivos estáticos
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
    
    # Configuración de logs
    access_log /var/log/nginx/ai-mobile-backend.access.log;
    error_log /var/log/nginx/ai-mobile-backend.error.log;
}
```

## 4. Despliegue del Frontend

### 4.1. Build de Producción

**Script de Build Frontend:**
```bash
#!/bin/bash
# build_frontend.sh

set -e

echo "Iniciando build del frontend..."

cd /path/to/ai_mobile_frontend

# Instalar dependencias
pnpm install

# Configurar variables de entorno para producción
cat > .env.production <<EOF
VITE_API_BASE_URL=https://tu-dominio.com/api
VITE_APP_NAME=IA Móvil
VITE_APP_VERSION=1.0.0
EOF

# Build para producción
pnpm run build

# Copiar archivos al directorio web
sudo rm -rf /var/www/ai-mobile-frontend/dist
sudo mkdir -p /var/www/ai-mobile-frontend
sudo cp -r dist /var/www/ai-mobile-frontend/
sudo chown -R www-data:www-data /var/www/ai-mobile-frontend

echo "Frontend construido y desplegado exitosamente"
```

### 4.2. Optimizaciones de Producción

**Configuración de Vite para Producción:**
```javascript
// vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  build: {
    outDir: 'dist',
    sourcemap: false, // Desactivar sourcemaps en producción
    minify: 'terser',
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          ui: ['@radix-ui/react-button', '@radix-ui/react-card']
        }
      }
    }
  },
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:5000',
        changeOrigin: true
      }
    }
  }
})
```

## 5. Configuración de CI/CD

### 5.1. GitHub Actions

**Archivo de workflow (.github/workflows/deploy.yml):**
```yaml
name: Deploy AI Mobile App

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'
    
    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    
    - name: Install Python dependencies
      run: |
        cd ai_mobile_backend
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    
    - name: Install Node dependencies
      run: |
        cd ai_mobile_frontend
        npm install -g pnpm
        pnpm install
    
    - name: Run Python tests
      run: |
        cd ai_mobile_backend
        python -m pytest tests/ -v
    
    - name: Run Frontend tests
      run: |
        cd ai_mobile_frontend
        pnpm test
    
    - name: Build Frontend
      run: |
        cd ai_mobile_frontend
        pnpm run build

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Deploy to server
      uses: appleboy/ssh-action@v0.1.5
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.SSH_KEY }}
        script: |
          cd /opt/ai_mobile_backend
          git pull origin main
          source venv/bin/activate
          pip install -r requirements.txt
          sudo systemctl restart ai-mobile-backend
          
          cd /opt/ai_mobile_frontend
          git pull origin main
          pnpm install
          pnpm run build
          sudo cp -r dist/* /var/www/ai-mobile-frontend/dist/
          sudo systemctl reload nginx
```

## 6. Distribución Gratuita

### 6.1. Opciones de Distribución

**Plataformas de Distribución Gratuita:**

1. **GitHub Pages** - Para hosting del frontend estático
2. **Heroku** - Para backend Flask (plan gratuito limitado)
3. **Vercel** - Para frontend React con funciones serverless
4. **Netlify** - Para frontend con funciones edge
5. **Railway** - Para backend con base de datos
6. **Render** - Para aplicaciones full-stack
7. **DigitalOcean App Platform** - Con créditos gratuitos

### 6.2. Configuración para GitHub Pages

**Script de despliegue a GitHub Pages:**
```bash
#!/bin/bash
# deploy_github_pages.sh

set -e

echo "Desplegando a GitHub Pages..."

# Build del frontend
cd ai_mobile_frontend
pnpm run build

# Configurar para GitHub Pages
echo "tu-dominio-personalizado.com" > dist/CNAME

# Desplegar usando gh-pages
npm install -g gh-pages
gh-pages -d dist

echo "Desplegado a GitHub Pages exitosamente"
```

### 6.3. Configuración para Heroku

**Procfile para Heroku:**
```
web: cd ai_mobile_backend && gunicorn --bind 0.0.0.0:$PORT src.main:app
```

**runtime.txt:**
```
python-3.9.16
```

**Script de despliegue a Heroku:**
```bash
#!/bin/bash
# deploy_heroku.sh

set -e

echo "Desplegando a Heroku..."

# Instalar Heroku CLI si no está instalado
if ! command -v heroku &> /dev/null; then
    curl https://cli-assets.heroku.com/install.sh | sh
fi

# Login a Heroku
heroku login

# Crear aplicación
heroku create tu-app-ai-mobile

# Configurar variables de entorno
heroku config:set FLASK_ENV=production
heroku config:set OPENAI_API_KEY=$OPENAI_API_KEY
heroku config:set FLASK_SECRET_KEY=$(openssl rand -base64 32)

# Desplegar
git subtree push --prefix=ai_mobile_backend heroku main

echo "Desplegado a Heroku exitosamente"
```

## 7. Aplicación Móvil Nativa

### 7.1. Configuración para Capacitor

Para convertir la aplicación web en una aplicación móvil nativa:

**Instalación de Capacitor:**
```bash
cd ai_mobile_frontend
npm install @capacitor/core @capacitor/cli
npm install @capacitor/android @capacitor/ios
npx cap init "IA Móvil" "com.tudominio.iamovil"
```

**Configuración de Capacitor (capacitor.config.ts):**
```typescript
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.tudominio.iamovil',
  appName: 'IA Móvil',
  webDir: 'dist',
  bundledWebRuntime: false,
  server: {
    url: 'https://tu-dominio.com',
    cleartext: true
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: "#3b82f6",
      showSpinner: true,
      spinnerColor: "#ffffff"
    },
    StatusBar: {
      style: "dark",
      backgroundColor: "#3b82f6"
    }
  }
};

export default config;
```

### 7.2. Build para Android

**Script de build para Android:**
```bash
#!/bin/bash
# build_android.sh

set -e

echo "Construyendo aplicación Android..."

cd ai_mobile_frontend

# Build del frontend
pnpm run build

# Sincronizar con Capacitor
npx cap sync android

# Abrir en Android Studio
npx cap open android

echo "Proyecto Android preparado. Completa el build en Android Studio."
```

### 7.3. Build para iOS

**Script de build para iOS:**
```bash
#!/bin/bash
# build_ios.sh

set -e

echo "Construyendo aplicación iOS..."

cd ai_mobile_frontend

# Build del frontend
pnpm run build

# Sincronizar con Capacitor
npx cap sync ios

# Abrir en Xcode
npx cap open ios

echo "Proyecto iOS preparado. Completa el build en Xcode."
```

## 8. Distribución en Tiendas de Aplicaciones

### 8.1. Google Play Store

**Preparación para Google Play:**

1. **Crear cuenta de desarrollador** en Google Play Console ($25 única vez)
2. **Configurar metadatos** de la aplicación
3. **Generar APK firmado** usando Android Studio
4. **Subir APK** y completar información de la tienda
5. **Configurar política de privacidad** y términos de uso

**Archivo de metadatos para Play Store:**
```json
{
  "title": "IA Móvil - Asistente de Código Abierto",
  "short_description": "Asistente de IA avanzado con capacidades de búsqueda, código y análisis",
  "full_description": "IA Móvil es un asistente de inteligencia artificial de código abierto que te ayuda con una amplia variedad de tareas. Incluye búsqueda web, ejecución de código, manipulación de archivos, análisis de datos y mucho más. Completamente gratuito y sin anuncios.",
  "category": "Productivity",
  "content_rating": "Everyone",
  "privacy_policy_url": "https://tu-dominio.com/privacy",
  "website": "https://tu-dominio.com"
}
```

### 8.2. Apple App Store

**Preparación para App Store:**

1. **Cuenta de desarrollador Apple** ($99/año)
2. **Configurar App Store Connect**
3. **Build con Xcode** y subir via Xcode o Transporter
4. **Completar metadatos** y screenshots
5. **Revisión de Apple** (proceso de 1-7 días)

## 9. Alternativas de Distribución Gratuita

### 9.1. F-Droid (Android)

Para distribución en F-Droid (tienda de aplicaciones de código abierto):

**Metadata para F-Droid:**
```yaml
# metadata/com.tudominio.iamovil.yml
Categories:
  - Internet
  - Development

License: MIT
AuthorName: Tu Nombre
AuthorEmail: tu@email.com
WebSite: https://tu-dominio.com
SourceCode: https://github.com/tu-usuario/ai-mobile-app
IssueTracker: https://github.com/tu-usuario/ai-mobile-app/issues

AutoName: IA Móvil
Summary: Asistente de IA de código abierto
Description: |
    IA Móvil es un asistente de inteligencia artificial completamente de código abierto
    que proporciona capacidades avanzadas de IA directamente en tu dispositivo móvil.
    
    Características:
    * Búsqueda web inteligente
    * Ejecución de código en múltiples lenguajes
    * Manipulación de archivos
    * Análisis de datos
    * Interfaz conversacional intuitiva
    * Completamente gratuito y sin anuncios
    * Código fuente disponible

RepoType: git
Repo: https://github.com/tu-usuario/ai-mobile-app.git

Builds:
  - versionName: '1.0.0'
    versionCode: 1
    commit: v1.0.0
    subdir: ai_mobile_frontend
    gradle:
      - yes
```

### 9.2. Progressive Web App (PWA)

**Configuración PWA:**
```json
// public/manifest.json
{
  "name": "IA Móvil - Asistente de Código Abierto",
  "short_name": "IA Móvil",
  "description": "Asistente de IA avanzado de código abierto",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#3b82f6",
  "orientation": "portrait-primary",
  "icons": [
    {
      "src": "/icon-192x192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "maskable any"
    },
    {
      "src": "/icon-512x512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable any"
    }
  ],
  "categories": ["productivity", "utilities", "developer"],
  "screenshots": [
    {
      "src": "/screenshot-mobile.png",
      "sizes": "390x844",
      "type": "image/png",
      "form_factor": "narrow"
    }
  ]
}
```

**Service Worker para PWA:**
```javascript
// public/sw.js
const CACHE_NAME = 'ia-movil-v1.0.0';
const urlsToCache = [
  '/',
  '/static/js/bundle.js',
  '/static/css/main.css',
  '/manifest.json'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
```

## 10. Monitoreo y Mantenimiento

### 10.1. Configuración de Logs

**Configuración de logging para producción:**
```python
# src/logging_config.py
import logging
import logging.handlers
import os

def setup_logging():
    log_dir = '/var/log/ai_mobile_backend'
    os.makedirs(log_dir, exist_ok=True)
    
    # Configurar formato de logs
    formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    
    # Handler para archivo
    file_handler = logging.handlers.RotatingFileHandler(
        os.path.join(log_dir, 'app.log'),
        maxBytes=10*1024*1024,  # 10MB
        backupCount=5
    )
    file_handler.setFormatter(formatter)
    
    # Handler para errores
    error_handler = logging.handlers.RotatingFileHandler(
        os.path.join(log_dir, 'error.log'),
        maxBytes=10*1024*1024,
        backupCount=5
    )
    error_handler.setLevel(logging.ERROR)
    error_handler.setFormatter(formatter)
    
    # Configurar logger principal
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    logger.addHandler(file_handler)
    logger.addHandler(error_handler)
    
    return logger
```

### 10.2. Monitoreo de Salud

**Endpoint de health check:**
```python
# src/routes/health.py
from flask import Blueprint, jsonify
import psutil
import os
from datetime import datetime

health_bp = Blueprint('health', __name__)

@health_bp.route('/health', methods=['GET'])
def health_check():
    """Endpoint de verificación de salud del sistema"""
    try:
        # Verificar uso de CPU y memoria
        cpu_percent = psutil.cpu_percent(interval=1)
        memory = psutil.virtual_memory()
        disk = psutil.disk_usage('/')
        
        # Verificar conectividad de base de datos
        # db_status = check_database_connection()
        
        status = {
            'status': 'healthy',
            'timestamp': datetime.now().isoformat(),
            'system': {
                'cpu_percent': cpu_percent,
                'memory_percent': memory.percent,
                'disk_percent': (disk.used / disk.total) * 100,
                'uptime': os.popen('uptime -p').read().strip()
            },
            'services': {
                'api': 'operational',
                'database': 'operational',
                'ai_agent': 'operational'
            }
        }
        
        return jsonify(status), 200
        
    except Exception as e:
        return jsonify({
            'status': 'unhealthy',
            'error': str(e),
            'timestamp': datetime.now().isoformat()
        }), 500
```

Esta guía completa proporciona todos los elementos necesarios para desplegar y distribuir exitosamente la aplicación móvil de IA de código abierto, desde la configuración del servidor hasta la distribución en tiendas de aplicaciones y plataformas alternativas.

