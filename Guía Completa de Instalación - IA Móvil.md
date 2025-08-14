# Guía Completa de Instalación - IA Móvil

## 📋 Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Instalación Rápida](#instalación-rápida)
3. [Instalación Manual Detallada](#instalación-manual-detallada)
4. [Configuración de Desarrollo](#configuración-de-desarrollo)
5. [Configuración de Producción](#configuración-de-producción)
6. [Solución de Problemas](#solución-de-problemas)
7. [Verificación de la Instalación](#verificación-de-la-instalación)

## 🔧 Requisitos Previos

### Sistema Operativo Soportado

**Linux (Recomendado)**
- Ubuntu 20.04 LTS o superior
- Debian 11 o superior
- CentOS 8 o superior
- Fedora 34 o superior

**macOS**
- macOS 11 Big Sur o superior
- Homebrew instalado

**Windows**
- Windows 10/11 con WSL2
- Docker Desktop para Windows

### Software Requerido

#### Herramientas Básicas

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y curl wget git build-essential

# CentOS/RHEL
sudo yum update
sudo yum groupinstall -y "Development Tools"
sudo yum install -y curl wget git

# macOS
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Python 3.8+

```bash
# Ubuntu/Debian
sudo apt install -y python3 python3-pip python3-venv python3-dev

# CentOS/RHEL
sudo yum install -y python3 python3-pip python3-devel

# macOS
brew install python@3.11

# Verificar instalación
python3 --version
pip3 --version
```

#### Node.js 16+

```bash
# Usando NodeSource (Ubuntu/Debian)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Usando NVM (Recomendado para desarrollo)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 18
nvm use 18

# macOS
brew install node@18

# Verificar instalación
node --version
npm --version
```

#### pnpm (Gestor de Paquetes)

```bash
# Instalar pnpm globalmente
npm install -g pnpm

# Verificar instalación
pnpm --version
```

## ⚡ Instalación Rápida

### Opción 1: Docker Compose (Recomendado)

```bash
# 1. Clonar el repositorio
git clone https://github.com/tu-usuario/ia-movil.git
cd ia-movil

# 2. Configurar variables de entorno
cp .env.example .env

# 3. Editar configuración (usar tu editor preferido)
nano .env

# 4. Iniciar servicios
docker-compose up -d

# 5. Verificar estado
docker-compose ps

# 6. Acceder a la aplicación
echo "Frontend: http://localhost:80"
echo "Backend API: http://localhost:5000"
```

### Opción 2: Script de Instalación Automática

```bash
# Descargar y ejecutar script de instalación
curl -fsSL https://raw.githubusercontent.com/tu-usuario/ia-movil/main/install.sh | bash

# O descargar primero y revisar
wget https://raw.githubusercontent.com/tu-usuario/ia-movil/main/install.sh
chmod +x install.sh
./install.sh
```

## 🔨 Instalación Manual Detallada

### Paso 1: Preparar el Entorno

```bash
# Crear directorio de trabajo
mkdir -p ~/ia-movil-dev
cd ~/ia-movil-dev

# Clonar repositorio
git clone https://github.com/tu-usuario/ia-movil.git
cd ia-movil

# Verificar estructura del proyecto
ls -la
```

### Paso 2: Configurar Backend

#### 2.1 Crear Entorno Virtual

```bash
cd ai_mobile_backend

# Crear entorno virtual
python3 -m venv venv

# Activar entorno virtual
# Linux/macOS:
source venv/bin/activate

# Windows (WSL):
source venv/bin/activate

# Verificar activación (debe mostrar (venv) en el prompt)
which python
```

#### 2.2 Instalar Dependencias

```bash
# Actualizar pip
pip install --upgrade pip

# Instalar dependencias del proyecto
pip install -r requirements.txt

# Verificar instalación
pip list
```

#### 2.3 Configurar Variables de Entorno

```bash
# Crear archivo de configuración
cp .env.example .env

# Editar configuración
nano .env
```

**Contenido mínimo del archivo .env:**

```bash
# Configuración básica
FLASK_ENV=development
FLASK_SECRET_KEY=tu-clave-secreta-muy-segura-cambiar-en-produccion
OPENAI_API_KEY=sk-tu-clave-openai-aqui

# Base de datos
DATABASE_URL=sqlite:///app.db

# CORS (para desarrollo)
CORS_ORIGINS=http://localhost:5173,http://localhost:3000

# Directorio temporal
TEMP_DIR=/tmp/ai_agent_workspace
```

#### 2.4 Inicializar Base de Datos

```bash
# Crear directorio de base de datos
mkdir -p src/database

# Ejecutar migraciones (si las hay)
python -c "from src.main import app; from src.models.user import db; app.app_context().push(); db.create_all()"
```

#### 2.5 Probar Backend

```bash
# Iniciar servidor de desarrollo
python src/main.py

# En otra terminal, probar API
curl http://localhost:5000/api/ai/status
```

### Paso 3: Configurar Frontend

#### 3.1 Instalar Dependencias

```bash
# Abrir nueva terminal y navegar al frontend
cd ai_mobile_frontend

# Instalar dependencias
pnpm install

# Verificar instalación
pnpm list
```

#### 3.2 Configurar Variables de Entorno

```bash
# Crear archivo de configuración para desarrollo
cat > .env.local <<EOF
VITE_API_BASE_URL=http://localhost:5000/api
VITE_APP_NAME=IA Móvil
VITE_APP_VERSION=1.0.0
EOF
```

#### 3.3 Probar Frontend

```bash
# Iniciar servidor de desarrollo
pnpm run dev

# Debería mostrar:
# Local:   http://localhost:5173/
# Network: use --host to expose
```

### Paso 4: Verificar Integración

```bash
# Con ambos servidores ejecutándose:
# Backend: http://localhost:5000
# Frontend: http://localhost:5173

# Abrir navegador y probar la aplicación
```

## 🛠️ Configuración de Desarrollo

### Configuración de IDE

#### Visual Studio Code

```bash
# Instalar extensiones recomendadas
code --install-extension ms-python.python
code --install-extension bradlc.vscode-tailwindcss
code --install-extension esbenp.prettier-vscode
code --install-extension ms-vscode.vscode-typescript-next

# Abrir proyecto
code .
```

**Configuración de workspace (.vscode/settings.json):**

```json
{
  "python.defaultInterpreterPath": "./ai_mobile_backend/venv/bin/python",
  "python.terminal.activateEnvironment": true,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.organizeImports": true
  },
  "tailwindCSS.includeLanguages": {
    "javascript": "javascript",
    "html": "HTML"
  },
  "files.associations": {
    "*.css": "tailwindcss"
  }
}
```

#### PyCharm

1. Abrir proyecto en PyCharm
2. Configurar intérprete Python: `ai_mobile_backend/venv/bin/python`
3. Marcar `ai_mobile_backend/src` como Sources Root
4. Configurar run configuration para `src/main.py`

### Configuración de Git

```bash
# Configurar hooks de pre-commit
pip install pre-commit
pre-commit install

# Configurar .gitignore adicional para desarrollo
cat >> .gitignore <<EOF
# Desarrollo local
.vscode/
.idea/
*.log
.DS_Store
Thumbs.db

# Variables de entorno locales
.env.local
.env.development
EOF
```

### Scripts de Desarrollo

**Crear script de inicio rápido (start-dev.sh):**

```bash
#!/bin/bash
set -e

echo "🚀 Iniciando IA Móvil en modo desarrollo..."

# Función para limpiar procesos al salir
cleanup() {
    echo "🛑 Deteniendo servicios..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
    exit 0
}

trap cleanup SIGINT SIGTERM

# Iniciar backend
echo "📡 Iniciando backend..."
cd ai_mobile_backend
source venv/bin/activate
python src/main.py &
BACKEND_PID=$!

# Esperar a que el backend esté listo
sleep 5

# Iniciar frontend
echo "🎨 Iniciando frontend..."
cd ../ai_mobile_frontend
pnpm run dev &
FRONTEND_PID=$!

echo "✅ Servicios iniciados:"
echo "   Backend:  http://localhost:5000"
echo "   Frontend: http://localhost:5173"
echo ""
echo "Presiona Ctrl+C para detener todos los servicios"

# Esperar indefinidamente
wait
```

```bash
# Hacer ejecutable
chmod +x start-dev.sh

# Usar
./start-dev.sh
```

## 🏭 Configuración de Producción

### Preparar Servidor

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependencias del sistema
sudo apt install -y nginx certbot python3-certbot-nginx

# Crear usuario para la aplicación
sudo useradd -m -s /bin/bash iamovil
sudo usermod -aG sudo iamovil
```

### Configurar Aplicación

```bash
# Cambiar a usuario de aplicación
sudo su - iamovil

# Crear directorio de aplicación
mkdir -p /home/iamovil/ia-movil
cd /home/iamovil/ia-movil

# Clonar código
git clone https://github.com/tu-usuario/ia-movil.git .

# Configurar backend
cd ai_mobile_backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install gunicorn

# Configurar variables de entorno de producción
cp .env.example .env
# Editar con valores de producción
```

### Configurar Servicios del Sistema

**Crear servicio systemd (/etc/systemd/system/ia-movil-backend.service):**

```ini
[Unit]
Description=IA Móvil Backend
After=network.target

[Service]
Type=simple
User=iamovil
Group=iamovil
WorkingDirectory=/home/iamovil/ia-movil/ai_mobile_backend
Environment=PATH=/home/iamovil/ia-movil/ai_mobile_backend/venv/bin
EnvironmentFile=/home/iamovil/ia-movil/ai_mobile_backend/.env
ExecStart=/home/iamovil/ia-movil/ai_mobile_backend/venv/bin/gunicorn --bind 127.0.0.1:5000 --workers 3 src.main:app
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
```

```bash
# Habilitar y iniciar servicio
sudo systemctl daemon-reload
sudo systemctl enable ia-movil-backend
sudo systemctl start ia-movil-backend
sudo systemctl status ia-movil-backend
```

### Configurar Nginx

**Crear configuración (/etc/nginx/sites-available/ia-movil):**

```nginx
server {
    listen 80;
    server_name tu-dominio.com www.tu-dominio.com;

    # Redirigir HTTP a HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name tu-dominio.com www.tu-dominio.com;

    # Certificados SSL (configurar con certbot)
    ssl_certificate /etc/letsencrypt/live/tu-dominio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tu-dominio.com/privkey.pem;

    # Configuración SSL moderna
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;
    ssl_prefer_server_ciphers off;

    # Headers de seguridad
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;

    # Proxy para backend
    location /api/ {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Servir frontend
    location / {
        root /home/iamovil/ia-movil/ai_mobile_frontend/dist;
        try_files $uri $uri/ /index.html;
        
        # Cache para archivos estáticos
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
}
```

```bash
# Habilitar sitio
sudo ln -s /etc/nginx/sites-available/ia-movil /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Configurar SSL con Let's Encrypt
sudo certbot --nginx -d tu-dominio.com -d www.tu-dominio.com
```

## 🐛 Solución de Problemas

### Problemas Comunes del Backend

#### Error: "ModuleNotFoundError"

```bash
# Verificar que el entorno virtual esté activado
which python
# Debe mostrar: /path/to/venv/bin/python

# Reinstalar dependencias
pip install -r requirements.txt
```

#### Error: "Permission denied" en /tmp/ai_agent_workspace

```bash
# Crear directorio con permisos correctos
sudo mkdir -p /tmp/ai_agent_workspace
sudo chown -R $USER:$USER /tmp/ai_agent_workspace
chmod 755 /tmp/ai_agent_workspace
```

#### Error: "OpenAI API key not found"

```bash
# Verificar variable de entorno
echo $OPENAI_API_KEY

# Si está vacía, configurar en .env
echo "OPENAI_API_KEY=sk-tu-clave-aqui" >> .env
```

### Problemas Comunes del Frontend

#### Error: "EACCES: permission denied"

```bash
# Limpiar cache de npm/pnpm
pnpm store prune
rm -rf node_modules
pnpm install
```

#### Error: "Network Error" al conectar con backend

```bash
# Verificar que el backend esté ejecutándose
curl http://localhost:5000/api/ai/status

# Verificar configuración de proxy en vite.config.js
```

#### Error: "Module not found" en componentes UI

```bash
# Reinstalar componentes de shadcn/ui
npx shadcn@latest add button card input
```

### Problemas de Docker

#### Error: "Port already in use"

```bash
# Encontrar proceso usando el puerto
sudo lsof -i :5000
sudo lsof -i :80

# Detener contenedores existentes
docker-compose down
```

#### Error: "Build failed"

```bash
# Limpiar cache de Docker
docker system prune -a

# Reconstruir imágenes
docker-compose build --no-cache
```

### Logs y Debugging

#### Ver logs del backend

```bash
# En desarrollo
tail -f ai_mobile_backend/app.log

# En producción con systemd
sudo journalctl -u ia-movil-backend -f

# Con Docker
docker-compose logs -f backend
```

#### Ver logs del frontend

```bash
# En desarrollo (consola del navegador)
# F12 -> Console

# Con Docker
docker-compose logs -f frontend
```

## ✅ Verificación de la Instalación

### Script de Verificación

**Crear verify-installation.sh:**

```bash
#!/bin/bash

echo "🔍 Verificando instalación de IA Móvil..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para verificar comando
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✅ $1 está instalado${NC}"
        $1 --version 2>/dev/null || echo "  Versión no disponible"
    else
        echo -e "${RED}❌ $1 NO está instalado${NC}"
        return 1
    fi
}

# Función para verificar servicio
check_service() {
    if curl -f -s $1 > /dev/null; then
        echo -e "${GREEN}✅ Servicio en $1 está funcionando${NC}"
    else
        echo -e "${RED}❌ Servicio en $1 NO responde${NC}"
        return 1
    fi
}

echo "📋 Verificando dependencias del sistema..."
check_command python3
check_command node
check_command npm
check_command pnpm
check_command git

echo ""
echo "🔧 Verificando estructura del proyecto..."

if [ -d "ai_mobile_backend" ]; then
    echo -e "${GREEN}✅ Directorio backend encontrado${NC}"
else
    echo -e "${RED}❌ Directorio backend NO encontrado${NC}"
fi

if [ -d "ai_mobile_frontend" ]; then
    echo -e "${GREEN}✅ Directorio frontend encontrado${NC}"
else
    echo -e "${RED}❌ Directorio frontend NO encontrado${NC}"
fi

if [ -f "ai_mobile_backend/requirements.txt" ]; then
    echo -e "${GREEN}✅ requirements.txt encontrado${NC}"
else
    echo -e "${RED}❌ requirements.txt NO encontrado${NC}"
fi

if [ -f "ai_mobile_frontend/package.json" ]; then
    echo -e "${GREEN}✅ package.json encontrado${NC}"
else
    echo -e "${RED}❌ package.json NO encontrado${NC}"
fi

echo ""
echo "🌐 Verificando servicios (si están ejecutándose)..."
check_service "http://localhost:5000/api/ai/status"
check_service "http://localhost:5173"

echo ""
echo "📝 Verificando configuración..."

if [ -f "ai_mobile_backend/.env" ]; then
    echo -e "${GREEN}✅ Archivo .env del backend encontrado${NC}"
    
    if grep -q "OPENAI_API_KEY=" ai_mobile_backend/.env; then
        if grep -q "OPENAI_API_KEY=sk-" ai_mobile_backend/.env; then
            echo -e "${GREEN}✅ OPENAI_API_KEY configurada${NC}"
        else
            echo -e "${YELLOW}⚠️  OPENAI_API_KEY parece estar vacía${NC}"
        fi
    else
        echo -e "${RED}❌ OPENAI_API_KEY NO configurada${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Archivo .env del backend NO encontrado${NC}"
fi

echo ""
echo "🎯 Resumen de la verificación completado"
echo "Si hay errores, consulta la documentación de instalación"
```

```bash
# Hacer ejecutable y usar
chmod +x verify-installation.sh
./verify-installation.sh
```

### Pruebas Funcionales

#### Probar Backend

```bash
# Probar endpoint de estado
curl -X GET http://localhost:5000/api/ai/status

# Probar endpoint de chat
curl -X POST http://localhost:5000/api/ai/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Hola, ¿cómo estás?"}'

# Probar herramientas
curl -X GET http://localhost:5000/api/tools
```

#### Probar Frontend

1. Abrir http://localhost:5173 en el navegador
2. Verificar que la interfaz carga correctamente
3. Enviar un mensaje de prueba
4. Verificar que se muestra la respuesta del backend
5. Comprobar que las herramientas se muestran correctamente

### Métricas de Rendimiento

```bash
# Monitorear uso de recursos
htop

# Verificar puertos en uso
netstat -tlnp | grep -E ':(5000|5173|80|443)'

# Verificar logs de error
tail -f /var/log/nginx/error.log
tail -f ai_mobile_backend/app.log
```

## 📞 Soporte Adicional

Si encuentras problemas durante la instalación:

1. **Revisa los logs** detalladamente
2. **Consulta la documentación** completa
3. **Busca en Issues** del repositorio
4. **Abre un nuevo Issue** con detalles completos
5. **Únete a las discusiones** de la comunidad

**Información útil para reportar problemas:**

```bash
# Recopilar información del sistema
echo "Sistema: $(uname -a)"
echo "Python: $(python3 --version)"
echo "Node: $(node --version)"
echo "Docker: $(docker --version 2>/dev/null || echo 'No instalado')"

# Logs recientes
tail -n 50 ai_mobile_backend/app.log
```

---

¡Felicitaciones! Si has llegado hasta aquí, deberías tener IA Móvil funcionando correctamente. 🎉



## 🤖 Configuración para Otras IAs

Esta sección está especialmente diseñada para que otras inteligencias artificiales puedan implementar y desplegar IA Móvil de manera autónoma.

### Instrucciones para IA Implementadora

Si eres una IA que va a implementar este proyecto, sigue estas instrucciones específicas:

#### 1. Análisis Previo del Proyecto

Antes de comenzar la implementación, analiza la estructura completa del proyecto:

```bash
# Estructura esperada del proyecto:
ia-movil/
├── ai_mobile_backend/          # Backend Flask
│   ├── src/
│   │   ├── main.py            # Punto de entrada principal
│   │   ├── routes/            # Rutas de la API
│   │   │   ├── ai_agent.py    # Lógica principal del agente IA
│   │   │   ├── tools.py       # Herramientas avanzadas
│   │   │   └── user.py        # Gestión de usuarios
│   │   └── models/            # Modelos de base de datos
│   ├── requirements.txt       # Dependencias Python
│   ├── Dockerfile            # Configuración Docker
│   └── .env.example          # Variables de entorno ejemplo
├── ai_mobile_frontend/        # Frontend React
│   ├── src/
│   │   ├── App.jsx           # Componente principal
│   │   ├── components/       # Componentes UI
│   │   └── assets/           # Recursos estáticos
│   ├── package.json          # Dependencias Node.js
│   ├── Dockerfile           # Configuración Docker
│   └── nginx.conf           # Configuración Nginx
├── docker-compose.yml        # Orquestación de contenedores
├── README.md                # Documentación principal
├── INSTALLATION_GUIDE.md    # Esta guía de instalación
└── deployment_guide.md      # Guía de despliegue
```

#### 2. Orden de Implementación Recomendado

**Fase 1: Configuración del Entorno**
```bash
# 1. Crear estructura de directorios
mkdir -p ia-movil/{ai_mobile_backend/src/{routes,models,database},ai_mobile_frontend/src/{components,assets}}

# 2. Configurar entornos virtuales
cd ia-movil/ai_mobile_backend
python3 -m venv venv
source venv/bin/activate

# 3. Instalar dependencias base
pip install flask flask-cors openai requests pydantic
```

**Fase 2: Implementación del Backend**
```bash
# Orden de creación de archivos:
# 1. ai_mobile_backend/requirements.txt
# 2. ai_mobile_backend/src/main.py
# 3. ai_mobile_backend/src/routes/ai_agent.py
# 4. ai_mobile_backend/src/routes/tools.py
# 5. ai_mobile_backend/src/models/user.py
```

**Fase 3: Implementación del Frontend**
```bash
# 1. Inicializar proyecto React
cd ai_mobile_frontend
npm create vite@latest . -- --template react
npm install

# 2. Instalar dependencias adicionales
npm install @radix-ui/react-button @radix-ui/react-card lucide-react

# 3. Crear componentes principales
# - src/App.jsx (interfaz principal)
# - src/components/ui/ (componentes UI)
```

**Fase 4: Configuración de Docker**
```bash
# 1. Crear Dockerfiles
# 2. Configurar docker-compose.yml
# 3. Configurar nginx.conf
```

#### 3. Variables de Entorno Críticas

Asegúrate de configurar estas variables antes del despliegue:

```bash
# Backend (.env)
FLASK_ENV=production                    # OBLIGATORIO
FLASK_SECRET_KEY=clave-muy-segura      # OBLIGATORIO - Generar aleatoria
OPENAI_API_KEY=sk-...                  # OBLIGATORIO - Clave válida de OpenAI
OPENAI_API_BASE=https://api.openai.com/v1  # Opcional
DATABASE_URL=sqlite:///app.db          # OBLIGATORIO
CORS_ORIGINS=*                         # Ajustar según necesidades
TEMP_DIR=/tmp/ai_agent_workspace       # OBLIGATORIO
```

#### 4. Puntos de Validación

Durante la implementación, valida estos puntos críticos:

**Backend:**
- [ ] El servidor Flask inicia sin errores en puerto 5000
- [ ] Endpoint `/api/ai/status` responde con JSON válido
- [ ] Endpoint `/api/ai/chat` acepta POST con mensaje
- [ ] Las herramientas en `/api/tools/` funcionan correctamente
- [ ] CORS está configurado para permitir requests del frontend

**Frontend:**
- [ ] La aplicación React compila sin errores
- [ ] La interfaz de chat se renderiza correctamente
- [ ] Los requests al backend se envían correctamente
- [ ] Los componentes UI (botones, inputs) funcionan
- [ ] El diseño es responsivo para móviles

**Integración:**
- [ ] Frontend puede comunicarse con backend
- [ ] Los mensajes se envían y reciben correctamente
- [ ] Las herramientas se ejecutan y muestran resultados
- [ ] No hay errores de CORS en la consola del navegador

#### 5. Comandos de Verificación Automatizada

Usa estos comandos para verificar cada componente:

```bash
# Verificar backend
curl -X GET http://localhost:5000/api/ai/status
curl -X POST http://localhost:5000/api/ai/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "test"}'

# Verificar frontend (después de build)
cd ai_mobile_frontend
npm run build
ls -la dist/  # Debe contener index.html y assets/

# Verificar Docker
docker-compose config  # Validar sintaxis
docker-compose up --dry-run  # Verificar configuración
```

#### 6. Solución de Problemas Comunes para IAs

**Error: "ModuleNotFoundError" en Python**
```bash
# Solución: Verificar que el entorno virtual esté activado
source venv/bin/activate
pip install -r requirements.txt
```

**Error: "CORS policy" en navegador**
```bash
# Solución: Verificar configuración CORS en main.py
# Debe incluir: CORS(app, origins="*")
```

**Error: "Cannot connect to backend"**
```bash
# Solución: Verificar que el backend esté ejecutándose
ps aux | grep python  # Buscar proceso Flask
netstat -tlnp | grep 5000  # Verificar puerto
```

**Error: "OpenAI API key not found"**
```bash
# Solución: Configurar variable de entorno
export OPENAI_API_KEY="sk-tu-clave-aqui"
# O agregar al archivo .env
```

#### 7. Configuración Específica para Despliegue

**Para despliegue local (desarrollo):**
```bash
# Terminal 1 - Backend
cd ai_mobile_backend
source venv/bin/activate
python src/main.py

# Terminal 2 - Frontend
cd ai_mobile_frontend
npm run dev
```

**Para despliegue con Docker:**
```bash
# Configurar variables de entorno
cp .env.example .env
# Editar .env con valores reales

# Iniciar servicios
docker-compose up -d

# Verificar estado
docker-compose ps
docker-compose logs -f
```

**Para despliegue en producción:**
```bash
# Seguir deployment_guide.md para configuración completa
# Incluye: Nginx, SSL, systemd, monitoreo
```

#### 8. Lista de Verificación Final

Antes de considerar la implementación completa, verifica:

- [ ] **Funcionalidad básica**: El chat funciona end-to-end
- [ ] **Herramientas**: Al menos búsqueda web y ejecución de código funcionan
- [ ] **Interfaz**: La UI es responsiva y usable en móviles
- [ ] **Seguridad**: No hay credenciales hardcodeadas en el código
- [ ] **Documentación**: README.md está actualizado con instrucciones específicas
- [ ] **Docker**: Los contenedores se construyen y ejecutan correctamente
- [ ] **Logs**: No hay errores críticos en los logs de aplicación
- [ ] **Performance**: La aplicación responde en menos de 5 segundos

#### 9. Recursos Adicionales para IA Implementadora

**Archivos de referencia críticos:**
- `ai_mobile_backend/src/routes/ai_agent.py` - Lógica principal del agente
- `ai_mobile_frontend/src/App.jsx` - Interfaz principal
- `docker-compose.yml` - Configuración de servicios
- `.env.example` - Variables de entorno requeridas

**APIs externas necesarias:**
- OpenAI API (obligatoria) - Para capacidades de IA
- DuckDuckGo API (opcional) - Para búsqueda web
- Ninguna otra API externa es estrictamente necesaria

**Puertos utilizados:**
- 5000: Backend Flask
- 5173: Frontend desarrollo (Vite)
- 80/443: Frontend producción (Nginx)
- 6379: Redis (opcional)

#### 10. Personalización Recomendada

Una vez que la implementación básica funcione, considera estas mejoras:

**Funcionalidades adicionales:**
- Integración con más modelos de IA (Anthropic, Cohere)
- Soporte para más herramientas (generación de imágenes, análisis de documentos)
- Sistema de plugins extensible
- Interfaz de voz (speech-to-text/text-to-speech)

**Mejoras de UI/UX:**
- Temas personalizables (claro/oscuro)
- Soporte para múltiples idiomas
- Atajos de teclado
- Historial de conversaciones persistente

**Optimizaciones técnicas:**
- Cache de respuestas frecuentes
- Compresión de assets
- Service Workers para funcionalidad offline
- Métricas y analytics

### Notas Importantes para la IA Implementadora

1. **Prioriza la funcionalidad básica** antes que las características avanzadas
2. **Testea cada componente** individualmente antes de la integración
3. **Mantén los logs detallados** durante el desarrollo para debugging
4. **Usa las configuraciones de ejemplo** como punto de partida
5. **Verifica la compatibilidad** de versiones de dependencias
6. **Documenta cualquier cambio** significativo que hagas
7. **Considera la seguridad** en cada paso de la implementación

¡Buena suerte con la implementación! Este proyecto está diseñado para ser lo más claro y directo posible para facilitar la implementación automatizada.

