#!/bin/bash
echo "🚀 Iniciando BrainDock..."

# Subir serviços essenciais
docker-compose up -d jupyterlab python-shell clickhouse minio # braindock-hub

echo "✅ Serviços essenciais ativos. Acesse o painel em http://localhost:8501"

# Iniciar painel Streamlit localmente
echo "🚀 Iniciando painel Streamlit (BrainDock Hub)..."
source .venv-panel/bin/activate
streamlit run services/brainhub/streamlit_app.py &
deactivate
