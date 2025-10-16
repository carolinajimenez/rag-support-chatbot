# ============================================
# RAG CHATBOT - SETUP COMPLETO
# Días 1-2: Fundamentos y Estructura
# ============================================

# ===== PASO 1: CREAR ESTRUCTURA DEL PROYECTO =====
echo "🚀 Creando estructura del proyecto..."

mkdir -p rag-support-chatbot && cd rag-support-chatbot

# Estructura completa de carpetas
mkdir -p data/{raw,processed,metadata}
mkdir -p src/{ingestion,retrieval,llm,api,etl,events,scheduler,channels}
mkdir -p src/ingestion/{loaders,chunkers,validators}
mkdir -p src/retrieval/{search,reranking}
mkdir -p src/llm/{chains,prompts,memory}
mkdir -p src/api/{routes,middleware,models}
mkdir -p src/etl/{connectors,transformers}
mkdir -p src/events/{store,handlers}
mkdir -p frontend
mkdir -p tests/{unit,integration,e2e}
mkdir -p docs/{architecture,api,user-guides}
mkdir -p scripts/{deployment,maintenance}
mkdir -p config

# Crear archivos __init__.py
find src -type d -exec touch {}/__init__.py \;

echo "✅ Estructura de carpetas creada"

# ===== PASO 2: CREAR requirements.txt =====
cat > requirements.txt << 'EOF'
# ============================================
# Core Dependencies
# ============================================
python-dotenv==1.0.0
pydantic==2.5.0
pydantic-settings==2.1.0

# ============================================
# LLM & RAG Framework
# ============================================
langchain==0.1.0
langchain-community==0.0.10
langchain-openai==0.0.2
openai==1.7.0
anthropic==0.8.0

# ============================================
# Vector Store
# ============================================
chromadb==0.4.22
# pinecone-client==3.0.0  # Uncomment si usas Pinecone

# ============================================
# Document Processing
# ============================================
pypdf==3.17.4
python-docx==1.1.0
python-pptx==0.6.23
unstructured==0.11.8
pillow==10.1.0
pytesseract==0.3.10  # Para OCR

# ============================================
# Data Processing
# ============================================
pandas==2.1.4
numpy==1.26.2
tiktoken==0.5.2  # Token counting

# ============================================
# API & Web
# ============================================
fastapi==0.109.0
uvicorn[standard]==0.25.0
python-multipart==0.0.6
pydantic[email]==2.5.0

# ============================================
# Frontend
# ============================================
streamlit==1.29.0
plotly==5.18.0

# ============================================
# ETL & Integrations
# ============================================
requests==2.31.0
atlassian-python-api==3.41.0  # Confluence
notion-client==2.2.1  # Notion
google-api-python-client==2.111.0  # Google Drive
slack-sdk==3.26.1  # Slack

# ============================================
# Database
# ============================================
sqlalchemy==2.0.25
alembic==1.13.1
psycopg2-binary==2.9.9  # PostgreSQL

# ============================================
# Monitoring & Logging
# ============================================
loguru==0.7.2
prometheus-client==0.19.0

# ============================================
# Scheduling
# ============================================
apscheduler==3.10.4

# ============================================
# Testing
# ============================================
pytest==7.4.3
pytest-asyncio==0.21.1
pytest-cov==4.1.0
httpx==0.26.0  # Para test de FastAPI

# ============================================
# Development
# ============================================
black==23.12.1
flake8==7.0.0
mypy==1.8.0
pre-commit==3.6.0

# ============================================
# Deployment
# ============================================
gunicorn==21.2.0
docker==7.0.0
EOF

echo "✅ requirements.txt creado"

# ===== PASO 3: CREAR .env.example =====
cat > .env.example << 'EOF'
# ============================================
# LLM API Keys
# ============================================
OPENAI_API_KEY=sk-your-openai-key-here
ANTHROPIC_API_KEY=sk-ant-your-anthropic-key-here

# ============================================
# Vector Store
# ============================================
CHROMA_PERSIST_DIR=./chroma_db
# PINECONE_API_KEY=your-pinecone-key
# PINECONE_ENV=us-west1-gcp

# ============================================
# Database
# ============================================
DATABASE_URL=postgresql://user:password@localhost:5432/rag_chatbot
REDIS_URL=redis://localhost:6379

# ============================================
# API Configuration
# ============================================
API_HOST=0.0.0.0
API_PORT=8000
API_RELOAD=True
CORS_ORIGINS=["http://localhost:3000","http://localhost:8501"]

# ============================================
# ETL Integrations
# ============================================
CONFLUENCE_URL=https://your-domain.atlassian.net
CONFLUENCE_USERNAME=your-email@company.com
CONFLUENCE_API_TOKEN=your-confluence-token

NOTION_TOKEN=secret_your-notion-integration-token

GOOGLE_CREDENTIALS_PATH=./config/google-credentials.json

SLACK_BOT_TOKEN=xoxb-your-slack-bot-token
SLACK_SIGNING_SECRET=your-signing-secret

# ============================================
# Application Settings
# ============================================
ENVIRONMENT=development
LOG_LEVEL=INFO
MAX_UPLOAD_SIZE=10485760  # 10MB

# ============================================
# RAG Configuration
# ============================================
CHUNK_SIZE=1000
CHUNK_OVERLAP=200
TOP_K_RESULTS=5
TEMPERATURE=0.0
MAX_TOKENS=500

# ============================================
# Rate Limiting
# ============================================
RATE_LIMIT_PER_MINUTE=100
RATE_LIMIT_PER_HOUR=1000
EOF

cp .env.example .env
echo "✅ .env.example y .env creados (EDITA .env con tus keys)"

# ===== PASO 4: CREAR .gitignore =====
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Environment
.env
.venv

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# Databases
*.db
*.sqlite
chroma_db/
*.log

# Data
data/raw/*
data/processed/*
!data/raw/.gitkeep
!data/processed/.gitkeep

# OS
.DS_Store
Thumbs.db

# Testing
.coverage
htmlcov/
.pytest_cache/

# Docker
docker-compose.override.yml
EOF

# Crear .gitkeep para mantener carpetas vacías
touch data/raw/.gitkeep
touch data/processed/.gitkeep
touch data/metadata/.gitkeep

echo "✅ .gitignore creado"

# ===== PASO 5: CREAR config/settings.py =====
cat > config/settings.py << 'EOF'
"""
Configuración centralizada de la aplicación
"""
from pydantic_settings import BaseSettings
from typing import List

class Settings(BaseSettings):
    """Configuración de la aplicación"""
    
    # LLM
    openai_api_key: str
    anthropic_api_key: str | None = None
    
    # Vector Store
    chroma_persist_dir: str = "./chroma_db"
    
    # Database
    database_url: str = "sqlite:///./rag_chatbot.db"
    
    # API
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    api_reload: bool = True
    cors_origins: List[str] = ["http://localhost:3000", "http://localhost:8501"]
    
    # Application
    environment: str = "development"
    log_level: str = "INFO"
    
    # RAG Configuration
    chunk_size: int = 1000
    chunk_overlap: int = 200
    top_k_results: int = 5
    temperature: float = 0.0
    max_tokens: int = 500
    
    # Rate Limiting
    rate_limit_per_minute: int = 100
    
    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()
EOF

echo "✅ config/settings.py creado"

# ===== PASO 6: CREAR README.md =====
cat > README.md << 'EOF'
# 🤖 RAG Support Chatbot

Sistema de chatbot de soporte técnico con Retrieval-Augmented Generation (RAG).

## 🎯 Características

- ✅ RAG con embeddings de OpenAI
- ✅ Vector store con ChromaDB
- ✅ API REST con FastAPI
- ✅ Frontend con Streamlit
- ✅ ETL automático de múltiples fuentes
- ✅ Event sourcing para auditoría
- ✅ API Gateway con autenticación
- ✅ Integración multi-canal (Slack, Teams)

## 🚀 Quick Start

### Prerrequisitos
- Python 3.11+
- Git
- API Key de OpenAI

### Instalación

```bash
# Clonar repositorio
git clone <tu-repo>
cd rag-support-chatbot

# Crear entorno virtual
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno
cp .env.example .env
# EDITAR .env con tus API keys
```

### Ejecutar

```bash
# 1. Ingestar documentos (primera vez)
python scripts/ingest_documents.py

# 2. Iniciar API
uvicorn src.api.main:app --reload

# 3. Iniciar Frontend (nueva terminal)
streamlit run frontend/app.py
```

Accede a:
- Frontend: http://localhost:8501
- API Docs: http://localhost:8000/docs

## 📁 Estructura del Proyecto

```
rag-support-chatbot/
├── data/                   # Documentos y datos
├── src/
│   ├── ingestion/         # Procesamiento de documentos
│   ├── retrieval/         # Búsqueda semántica
│   ├── llm/               # Integración con LLM
│   ├── api/               # FastAPI endpoints
│   ├── etl/               # Conectores externos
│   └── events/            # Event sourcing
├── frontend/              # Streamlit UI
├── tests/                 # Tests automatizados
├── config/                # Configuración
└── docs/                  # Documentación

```

## 🧪 Testing

```bash
pytest tests/ -v --cov=src
```

## 📚 Documentación

Ver carpeta `docs/` para:
- Arquitectura del sistema
- Guía de API
- Manual de usuario

## 🤝 Contribuir

1. Fork el proyecto
2. Crea tu feature branch
3. Commit tus cambios
4. Push al branch
5. Abre un Pull Request

## 📝 Licencia

MIT License
EOF

echo "✅ README.md creado"

# ===== PASO 7: CREAR PRIMER SCRIPT DE EJEMPLO =====
mkdir -p scripts
cat > scripts/verify_setup.py << 'EOF'
"""
Script de verificación de setup inicial
"""
import sys
from pathlib import Path

def verify_structure():
    """Verifica que la estructura de carpetas esté correcta"""
    required_dirs = [
        "data/raw",
        "data/processed",
        "src/ingestion",
        "src/retrieval",
        "src/llm",
        "src/api",
        "frontend",
        "tests",
        "config"
    ]
    
    print("🔍 Verificando estructura del proyecto...")
    all_good = True
    
    for dir_path in required_dirs:
        if Path(dir_path).exists():
            print(f"✅ {dir_path}")
        else:
            print(f"❌ {dir_path} - NO EXISTE")
            all_good = False
    
    return all_good

def verify_dependencies():
    """Verifica que las dependencias estén instaladas"""
    required_packages = [
        "langchain",
        "openai",
        "chromadb",
        "fastapi",
        "streamlit"
    ]
    
    print("\n🔍 Verificando dependencias...")
    all_good = True
    
    for package in required_packages:
        try:
            __import__(package)
            print(f"✅ {package}")
        except ImportError:
            print(f"❌ {package} - NO INSTALADO")
            all_good = False
    
    return all_good

def verify_env():
    """Verifica que el archivo .env exista"""
    print("\n🔍 Verificando configuración...")
    if Path(".env").exists():
        print("✅ Archivo .env encontrado")
        
        # Leer y verificar keys importantes
        with open(".env") as f:
            content = f.read()
            if "OPENAI_API_KEY=sk-" in content or "OPENAI_API_KEY=" in content:
                print("⚠️  Recuerda configurar tu OPENAI_API_KEY en .env")
            else:
                print("✅ Variables de entorno configuradas")
        return True
    else:
        print("❌ Archivo .env NO encontrado")
        print("   Ejecuta: cp .env.example .env")
        return False

if __name__ == "__main__":
    print("=" * 60)
    print("RAG CHATBOT - VERIFICACIÓN DE SETUP")
    print("=" * 60)
    
    structure_ok = verify_structure()
    deps_ok = verify_dependencies()
    env_ok = verify_env()
    
    print("\n" + "=" * 60)
    if structure_ok and deps_ok and env_ok:
        print("✅ ¡TODO LISTO! Puedes empezar a desarrollar")
        print("\nPróximos pasos:")
        print("1. Edita .env con tu OpenAI API key")
        print("2. Agrega documentos a data/raw/")
        print("3. Ejecuta scripts/ingest_documents.py")
        sys.exit(0)
    else:
        print("❌ Hay problemas con el setup")
        print("\nRevisa los errores arriba y corrígelos")
        sys.exit(1)
EOF

echo "✅ scripts/verify_setup.py creado"

# ===== PASO 8: INICIALIZAR GIT =====
git init
git add .
git commit -m "Initial commit: Project structure"

echo ""
echo "============================================"
echo "✅ ¡SETUP COMPLETO!"
echo "============================================"
echo ""
echo "📋 Próximos pasos:"
echo ""
echo "1. Crear entorno virtual:"
echo "   python -m venv venv"
echo "   source venv/bin/activate  # Windows: venv\\Scripts\\activate"
echo ""
echo "2. Instalar dependencias:"
echo "   pip install -r requirements.txt"
echo ""
echo "3. Configurar .env:"
echo "   nano .env  # o tu editor favorito"
echo "   # Agregar tu OPENAI_API_KEY"
echo ""
echo "4. Verificar setup:"
echo "   python scripts/verify_setup.py"
echo ""
echo "5. ¡Listo para el Día 3! 🚀"
echo ""
echo "============================================"