from prefect import flow, task
import papermill as pm
from datetime import datetime

@task
def rodar_notebook(input_path: str, output_path: str, parameters: dict = {}):
    pm.execute_notebook(
    input_path=input_path,
    output_path=output_path,
    parameters=parameters,
    kernel_name="python"  # ou o nome exato do seu kernel
)


@flow(name="Fluxo_Notebook_Jupyter")
def executar_notebook():
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    rodar_notebook(
        input_path="notebooks/for_workflows/exemplo_pipeline.ipynb",
        output_path=f"outputs/executado_{timestamp}.ipynb",
        parameters={"param1": "valor", "param2": 42}
    )

if __name__ == "__main__":
    executar_notebook()
