from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def home():
    return {"message": "Hola desde Cloud!"}

@app.get("/health")
def health():
    return {"status": "ok"}