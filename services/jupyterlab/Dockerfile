FROM jupyter/base-notebook:python-3.11

USER root
RUN apt-get update && apt-get install -y \
    build-essential git curl libgl1-mesa-glx libglib2.0-0 \
    libsm6 libxrender1 libxext6 && \
    rm -rf /var/lib/apt/lists/*

USER jovyan
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

# Verifica se o módulo compartilhado existe antes de copiá-lo
ARG SHARED_MODULE_PATH=../../services/shared_module
RUN if [ -d "$SHARED_MODULE_PATH" ]; then \
        cp -r $SHARED_MODULE_PATH /home/jovyan/app && \
        pip install -e /home/jovyan/app/ || true; \
    fi

EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''"]