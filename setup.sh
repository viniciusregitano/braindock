#!/bin/bash
set -e

echo "🚀 Iniciando setup do BrainDock..."

# Carrega variáveis do .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "❌ Arquivo .env não encontrado! Certifique-se de que ele está presente no diretório."
    exit 1
fi

# Clona repositório compartilhado se necessário
if [ -n "$IMPORT_REPO" ]; then
    if [ ! -d "services/shared/shared_module" ]; then
        echo "🔄 Clonando repositório: $IMPORT_REPO"
        git clone $IMPORT_REPO services/shared/shared_module
    fi
else
    echo "⚠️ Variável IMPORT_REPO não definida ou vazia. Pulando clonagem do repositório."
fi

# Verifica se o requirements.txt existe antes de instalar dependências
if [ -f "requirements.txt" ]; then
    echo "📦 Instalando dependências Python no host..."
    if ! command -v poetry &> /dev/null; then
        echo "📥 Instalando Poetry..."
        curl -sSL https://install.python-poetry.org | python3 -
        export PATH="$HOME/.local/bin:$PATH"
    fi
else
    echo "⚠️ Arquivo requirements.txt não encontrado. Pulando instalação de dependências."
fi

# Verifica se o módulo compartilhado existe antes de instalar dependências
if [ -d "services/shared_module" ] && [ -f "services/shared_module/pyproject.toml" ]; then
    cd services/shared_module
    poetry install || pip install -e .
    cd -
else
    echo "⚠️ Módulo 'shared_module' não encontrado ou sem 'pyproject.toml'. Pulando instalação de dependências."
fi

echo "📦 Criando ambiente virtual do painel (./.venv-panel)..."
python3 -m venv .venv-panel
source .venv-panel/bin/activate
pip install --upgrade pip
export STREAMLIT_BROWSER_GATHER_USAGE_STATS=false
pip install streamlit prefect
deactivate


# Faz o build e sobe os containers
echo "🐳 Fazendo build dos containers com Docker Compose..."
docker-compose build || { echo "❌ Falha ao fazer o build dos containers! Verifique os logs acima."; exit 1; }

# Criar atalhos de sistema
bash ./scripts/create_shortcuts.sh

# Cria atalho de inicialização automática no boot com systemd user
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/braindock-start.service <<EOF
[Unit]
Description=Start BrainDock on user login
After=network.target

[Service]
ExecStart=${PWD}/start.sh
WorkingDirectory=${PWD}
Restart=always

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reexec
systemctl --user enable braindock-start.service

echo "✅ Setup inicial completo! O BrainDock será iniciado automaticamente no login."
echo "▶️ Você pode iniciar manualmente com: bash start.sh"
