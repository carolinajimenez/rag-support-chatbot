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
