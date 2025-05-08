import streamlit as st
import os
import subprocess

def get_status(service):
    try:
        cid = subprocess.check_output(
            ["docker-compose", "ps", "-q", service],
            stderr=subprocess.DEVNULL
        ).decode().strip()
        if not cid:
            return "⚪ não encontrado"
        result = subprocess.check_output(
            ["docker", "inspect", "-f", "{{.State.Status}}", cid],
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

st.set_page_config(page_title="BrainDock Hub", layout="centered")
st.title("BrainDock Hub")

st.markdown("""
Este painel centraliza os principais serviços do ambiente BrainDock.
Clique nos botões abaixo para abrir, iniciar ou parar os serviços conforme necessário.
""")

st.subheader("Acessar Serviços Ativos")

if st.button("Abrir JupyterLab"):
    st.markdown("[Abrir JupyterLab](http://localhost:8888)", unsafe_allow_html=True)

if st.button("Abrir ClickHouse"):
    st.markdown("[Abrir ClickHouse](http://localhost:8123)", unsafe_allow_html=True)

if st.button("Abrir MinIO"):
    st.markdown("[Abrir MinIO](http://localhost:9100)", unsafe_allow_html=True)

st.subheader("Serviços Sob Demanda")

def service_controls(name, label, port):
    status = get_status(name)
    cols = st.columns([2, 2, 2, 2, 2])
    cols[0].markdown(f"**{label}**")
    cols[1].markdown(f"{status}")

    if cols[2].button(f"Iniciar", key=f"iniciar-{label}"):
        try:
            result = subprocess.run(
                ["docker-compose", "up", "-d", name],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )
            st.success(f"{label} iniciado com sucesso.")
            st.rerun()  # 👈 força atualização da interface
        except subprocess.CalledProcessError as e:
            st.error(f"Erro ao iniciar {label}:\n\n{e.stderr}")

    if cols[3].button(f"Parar", key=f"parar-{name}"):
        subprocess.Popen(["docker-compose", "stop", name])
        st.warning(f"{label} parado.")

    if status == "🟢 ativo":
        cols[4].link_button("Abrir", f"http://localhost:{port}")
    else:
        cols[4].button(f"Abrir", key=f"abrir-{label}", disabled=True)

service_controls("superset", "Superset", 8088)
# service_controls("airbyte", "Airbyte", 8000)
service_controls("mlflow", "MLflow", 5000)
service_controls("neo4j", "Neo4j", 7474)

st.divider()

st.subheader("Utilitários")

if st.button("Abrir Terminal Python (docker exec)"):
    subprocess.Popen(["gnome-terminal", "--window", "--", "docker", "exec", "-it", "python-shell", "bash"])
    st.success("Terminal aberto para o python-shell.")

if st.button("Executar fluxo Prefect (Notebook)"):
    os.system("python workflows/run_notebook_flow.py")
    st.success("Fluxo executado com sucesso. Verifique a pasta outputs/.")

if st.button("Agendar fluxo Prefect diário (Notebook)"):
    os.system("bash scripts/prefect_deploy_notebook.sh")
    st.success("Agendamento diário criado com sucesso (09:00).")

st.markdown("""
---
Este painel faz parte do projeto **BrainDock**.
""")
