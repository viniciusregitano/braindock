#!/bin/bash

echo "🔧 Criando atalhos do BrainDock..."

# Caminho para atalhos
TARGET_DIR="$HOME/.local/share/applications"
mkdir -p "$TARGET_DIR"

# Atalho do painel Streamlit
cat > "$TARGET_DIR/braindock-hub.desktop" <<EOF
[Desktop Entry]
Version=1.0
Name=BrainDock Hub
Comment=Abrir o painel principal do BrainDock (Streamlit)
Exec=xdg-open http://localhost:8501
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=Development;
EOF

# Atalho para o Python Shell
cat > "$TARGET_DIR/python-shell.desktop" <<EOF
[Desktop Entry]
Version=1.0
Name=Python Shell (BrainDock)
Comment=Entrar no container com ambiente Python do BrainDock
Exec=gnome-terminal -- bash -c "docker exec -it python-shell bash"
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=Development;
EOF

chmod +x "$TARGET_DIR/braindock-hub.desktop"
chmod +x "$TARGET_DIR/python-shell.desktop"

echo "✅ Atalhos criados com sucesso em $TARGET_DIR"
