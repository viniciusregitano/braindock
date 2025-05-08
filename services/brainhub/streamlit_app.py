import streamlit as st
import os
import subprocess

st.set_page_config(page_title="BrainDock Hub", layout="centered")
st.title("BrainDock Hub")

st.markdown("""
Este painel centraliza os principais serviços do ambiente BrainDock.
Clique nos botões abaixo para abrir, iniciar ou parar os serviços conforme necessário.
""")

def get_status(service):
    try:
        result = subprocess.check_output(
            ["docker", "inspect", "-f", "{{.State.Status}}", service],
            stderr=subprocess.DEVNULL
        ).decode().strip()
        if result == "running":
            return "🟢 ativo"
        elif result == "exited":
            return "🔴 parado"
        else:
            return f"🟡 {result}"
    except:
        return "⚪ não encontrado"

# Serviços ativos no init.sh
st.subheader("Acessar Serviços Ativos")

if st.button("Abrir JupyterLab"):
    st.markdown("[Abrir JupyterLab](http://localhost:8888)", unsafe_allow_html=True)

if st.button("Abrir ClickHouse"):
    st.markdown("[Abrir ClickHouse](http://localhost:8123)", unsafe_allow_html=True)

if st.button("Abrir MinIO"):
    st.markdown("[Abrir MinIO](http://localhost:9100)", unsafe_allow_html=True)

# Serviços sob demanda
st.subheader("Serviços Sob Demanda")

def service_controls(name, label, port):
    status = get_status(name)
    cols = st.columns([2, 2, 2, 3])
    cols[0].markdown(f"**{label}**")
    cols[1].markdown(f"{status}")

    if cols[2].button(f"Iniciar {label}"):
        os.system(f"docker compose up -d {name}")
        st.success(f"{label} iniciado.")
    if cols[3].button(f"Parar {label}"):
        os.system(f"docker compose stop {name}")
        st.warning(f"{label} parado.")
    if status == "🟢 ativo":
        st.markdown(f"[Abrir {label}](http://localhost:{port})", unsafe_allow_html=True)

service_controls("superset", "Superset", 8088)
service_controls("airbyte", "Airbyte", 8000)
service_controls("mlflow", "MLflow", 5000)
service_controls("neo4j", "Neo4j", 7474)

st.divider()

st.subheader("Utilitários")

if st.button("Abrir Terminal Python (docker exec)"):
    st.code("docker exec -it python-shell bash")

if st.button("Executar fluxo Prefect (Notebook)"):
    os.system("python flows/run_notebook_flow.py")
    st.success("Fluxo executado com sucesso. Verifique a pasta outputs/.")

if st.button("Agendar fluxo Prefect diário (Notebook)"):
    os.system("bash scripts/prefect_deploy_notebook.sh")
    st.success("Agendamento diário criado com sucesso (09:00).")

st.markdown("""
---
Este painel faz parte do projeto **BrainDock**.
""")
