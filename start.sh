#!/bin/bash
echo "🚀 Iniciando BrainDock..."

# Subir serviços essenciais
docker-compose up -d jupyterlab python-shell braindock-hub clickhouse minio

echo "✅ Serviços essenciais ativos. Acesse o painel em http://localhost:8501"
