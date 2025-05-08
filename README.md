# BrainDock - Infraestrutura para Ciência de Dados e IA Cognitiva

**BrainDock** é um ambiente de trabalho modular e integrado que oferece tudo o que você precisa para desenvolver, testar e operar projetos de IA, ciência de dados, análise gráfica e raciocínio simbólico/vetorial. Ele foi pensado para ser simples de iniciar e poderoso o suficiente para escalar.

---

## Componentes principais

- **JupyterLab**: ambiente interativo com suporte a notebooks, AI e CUDA.
- **Streamlit Hub**: painel central para abrir e monitorar os serviços.
- **Superset**: visualização de dados e dashboards.
- **Airbyte**: integração e ingestão de dados.
- **MLflow**: rastreamento e versionamento de experimentos de ML.
- **ClickHouse**: banco de dados analítico de alta performance.
- **Neo4j**: grafo para raciocínio e memória.
- **Redis, FAISS, MinIO**: componentes auxiliares para caching, vetores e armazenamento.
- **Python Shell**: ambiente separado para testes e execuções com ou sem GPU.

---

## Instalação

### Pré-requisitos
- Docker + Docker Compose
- Python 3.11+ (opcional, se quiser rodar no host)

### Etapas

1. Clone o projeto:

```bash
git clone https://github.com/viniciusregitano/braindock.git
cd braindock
```

2. Edite o arquivo `.env` com seu repositório e chaves de API:

```
IMPORT_REPO=https://github.com/seu-usuario/seu-repositorio.git
OPENAI_API_KEY=...
HUGGINGFACEHUB_API_TOKEN=...
```

3. Execute o script de inicialização:

```bash
bash init.sh
```

Esse comando:
- Instala as dependências locais (com Poetry, se disponível)
- Clona o módulo principal para ser usado com import
- Sobe todos os serviços do BrainDock com Docker Compose

---

## Acesso aos serviços

| Serviço       | URL                         |
|---------------|------------------------------|
| JupyterLab    | http://localhost:8888        |
| Superset      | http://localhost:8088        |
| Airbyte       | http://localhost:8000        |
| MLflow        | http://localhost:5000        |
| Neo4j         | http://localhost:7474        |
| ClickHouse    | http://localhost:8123        |
| MinIO         | http://localhost:9001        |
| BrainDock Hub | http://localhost:8501        |

---

## Uso do Python Shell

Você pode acessar o container com ambiente Python isolado usando:

```bash
docker exec -it python-shell bash
```

---

## Estrutura do projeto

- `services/jupyterlab/`: ambiente do Jupyter com Dockerfile personalizado
- `services/brainhub/`: painel em Streamlit
- `services/shared_module/`: onde será clonado o módulo principal do BrainGraph
- `models/`, `data/`, `logs/`: diretórios de trabalho
- `scripts/`: scripts, como adicionar os atalhos ao menu do sistema

---

## Observações

- O suporte a GPU pode ser ativado via `USE_GPU=true` no `.env`.
- O sistema é extensível com novos serviços, agentes e fluxos.
- Ideal para projetos locais, em servidores ou em nuvem privada.

---

## Licença

Este projeto é aberto e livre para uso, modificação e expansão. Fique à vontade para adaptar ao seu fluxo de trabalho.
