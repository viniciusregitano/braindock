#!/bin/bash

set -e

CONTAINER_NAME="braindock-superset-1"

# Carrega variáveis do .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "❌ Arquivo .env não encontrado!"
  exit 1
fi

USERNAME="${SUPERSET_USER:-admin}"
PASSWORD="${SUPERSET_PASSWORD:-senhaForte123}"
EMAIL="${SUPERSET_EMAIL:-admin@example.com}"

# Verifica se o container está ativo
if ! docker ps | grep -q "$CONTAINER_NAME"; then
  echo "❌ O container $CONTAINER_NAME não está rodando. Pulando criação de usuário Superset."
  exit 0
fi

# Executa os comandos dentro do container Superset
echo "🛠️ Inicializando Superset e criando usuário administrador..."
docker exec -i $CONTAINER_NAME superset db upgrade || true
docker exec -i $CONTAINER_NAME superset fab create-admin \
  --username "$USERNAME" \
  --firstname "Admin" \
  --lastname "User" \
  --email "$EMAIL" \
  --password "$PASSWORD" || true
docker exec -i $CONTAINER_NAME superset init || true

echo "✅ Superset inicializado. Acesse http://localhost:8088 com usuário: $USERNAME"
exit 0
