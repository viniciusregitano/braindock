#!/bin/bash

set -e

echo "📦 Criando deployment Prefect para o fluxo de notebook..."

prefect deployment build workflows/run_notebook_flow.py:executar_notebook \
  --name execucao-notebook-agendada \
  --cron "0 9 * * *" \
  --apply

echo "✅ Deployment agendado com sucesso para 09:00 todos os dias."
echo "🚀 Lembre-se de iniciar um agente Prefect com:"
echo "    prefect agent start"
