#!/bin/bash

# Detecta a pasta da área de trabalho
DESKTOP_DIR=$(xdg-user-dir DESKTOP)
echo "🔧 Criando atalhos do BrainDock em $DESKTOP_DIR..."
mkdir -p "$DESKTOP_DIR"

# Atalho do painel Streamlit
cat > "$DESKTOP_DIR/braindock-hub.desktop" <<EOF
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
cat > "$DESKTOP_DIR/python-shell.desktop" <<EOF
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

chmod +x "$DESKTOP_DIR/braindock-hub.desktop"
chmod +x "$DESKTOP_DIR/python-shell.desktop"

echo "✅ Atalhos criados com sucesso em $DESKTOP_DIR"
