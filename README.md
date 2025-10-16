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
