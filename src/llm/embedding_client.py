import os
from openai import OpenAI

class EmbeddingClient:
    def __init__(self, model: str = None):
        self.api_key = os.getenv("OPENAI_API_KEY")
        self.model = model or os.getenv("OPENAI_EMBEDDING_MODEL", "text-embedding-ada-002")
        self.client = OpenAI(api_key=self.api_key)

    def embed(self, text: str) -> list:
        text = text.replace("\n", " ")
        response = self.client.embeddings.create(
            input=[text],
            model=self.model
        )
        return response.data[0].embedding
