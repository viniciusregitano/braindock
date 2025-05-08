FROM jupyter/base-notebook:python-3.11

USER root
RUN apt-get update && apt-get install -y \
    build-essential git curl libgl1-mesa-glx libglib2.0-0 \
    libsm6 libxrender1 libxext6 && \
    rm -rf /var/lib/apt/lists/*

USER jovyan
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

# Instala módulo importado (se presente)
COPY ../../services/shared_module /home/jovyan/app
RUN pip install -e /home/jovyan/app/brain_graph_core || true

EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''"]
