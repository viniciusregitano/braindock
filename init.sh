#!/bin/bash

set -e

echo "🚀 Iniciando setup do BrainDock..."

# Carrega variáveis do .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Arquivo .env não encontrado!"
    exit 1
fi

# Clona o repositório principal do projeto se ainda não existir
if [ -n "$IMPORT_REPO" ] && [ ! -d "services/shared_module" ]; then
    echo "🔄 Clonando repositório: $IMPORT_REPO"
    git clone $IMPORT_REPO services/shared_module
elif [ -z "$IMPORT_REPO" ]; then
    echo "⚠️ Variável IMPORT_REPO não definida ou vazia. Pulando clonagem do repositório."
fi

# Instala dependências locais com poetry (ambiente nativo opcional)
echo "📦 Instalando dependências Python no host..."
if ! command -v poetry &> /dev/null; then
    echo "📥 Instalando Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
fi

cd services/shared_module
poetry install || pip install -e .
cd -

# Sobe os containers
echo "🐳 Subindo containers com Docker Compose..."
docker-compose up --build -d

# Cria atalhos no sistema
bash ./scripts/create_shortcuts.sh

# Exibe os serviços
echo "✅ BrainDock está rodando!"
echo "🔗 Painel central: http://localhost:8501"
echo "📊 Superset:        http://localhost:8088"
echo "📦 Airbyte:         http://localhost:8000"
echo "📈 MLflow:          http://localhost:5000"
echo "🧠 Neo4j:           http://localhost:7474"
echo "🧮 ClickHouse:      http://localhost:8123"
echo "📁 MinIO:           http://localhost:9001"
echo "📘 JupyterLab:      http://localhost:8888"
echo "🐍 Python Shell:    docker exec -it python-shell bash"
