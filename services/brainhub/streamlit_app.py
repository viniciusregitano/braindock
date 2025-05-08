import streamlit as st
import os

st.set_page_config(page_title="BrainDock Hub", layout="centered")
st.title("🚢 BrainDock Hub")

st.markdown("""
Este painel centraliza os principais serviços do ambiente BrainDock.
Clique nos botões abaixo para abrir as ferramentas em novas abas do navegador.
""")

services = {
    "📘 JupyterLab": "http://localhost:8888",
    "📊 Superset": "http://localhost:8088",
    "📦 Airbyte": "http://localhost:8000",
    "📈 MLflow": "http://localhost:5000",
    "🧠 Neo4j": "http://localhost:7474",
    "🧮 ClickHouse": "http://localhost:8123",
    "📁 MinIO": "http://localhost:9001"
}

for name, url in services.items():
    st.markdown(f"[**{name}**]({url})", unsafe_allow_html=True)

st.divider()

st.subheader("⚙️ Utilitários")

if st.button("Abrir Terminal Python (docker exec)"):
    st.code("docker exec -it python-shell bash")

st.markdown("""
---
🧠 Projeto BrainGraphAI — Infraestrutura por **BrainDock**
""")
