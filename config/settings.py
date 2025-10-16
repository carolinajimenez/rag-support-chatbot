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
