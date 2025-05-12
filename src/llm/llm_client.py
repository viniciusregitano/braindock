import os
import openai

class LLMClient:
    def __init__(self, model: str = None):
        openai.api_key = os.getenv("OPENAI_API_KEY")
        self.model = model or os.getenv("OPENAI_MODEL", "gpt-3.5-turbo")

    def chat(self, prompt: str, system: str = "Você é um assistente útil.") -> str:
        response = openai.chat.completions.create(
            model=self.model,
            messages=[
                {"role": "system", "content": system},
                {"role": "user", "content": prompt},
            ]
        )
        return response.choices[0].message.content.strip()
