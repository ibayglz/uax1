import os
import psycopg
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI(title="Lab 3 - Tasks API")

DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("POSTGRES_DB", "tasks")
DB_USER = os.getenv("POSTGRES_USER", "labuser")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD", "labpass")


def connection():
    return psycopg.connect(
        host=DB_HOST, port=DB_PORT, dbname=DB_NAME,
        user=DB_USER, password=DB_PASSWORD,
    )


@app.on_event("startup")
def startup():
    with connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "CREATE TABLE IF NOT EXISTS tasks "
                "(id SERIAL PRIMARY KEY, title TEXT NOT NULL)"
            )
        conn.commit()


class Task(BaseModel):
    title: str


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/tasks")
def list_tasks():
    with connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, title FROM tasks ORDER BY id")
            rows = cur.fetchall()
    return [{"id": r[0], "title": r[1]} for r in rows]


@app.post("/tasks", status_code=201)
def create_task(task: Task):
    with connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO tasks (title) VALUES (%s) RETURNING id",
                (task.title,),
            )
            task_id = cur.fetchone()[0]
        conn.commit()
    return {"id": task_id, "title": task.title}


@app.delete("/tasks/{task_id}")
def delete_task(task_id: int):
    with connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "DELETE FROM tasks WHERE id = %s RETURNING id", (task_id,)
            )
            deleted = cur.fetchone()
        conn.commit()
    if not deleted:
        raise HTTPException(status_code=404, detail="Task not found")
    return {"deleted": task_id}