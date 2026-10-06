# Infraestructuras y Servicios en la Nube

![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-API-009688?logo=fastapi&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-4169E1?logo=postgresql&logoColor=white)
![uv](https://img.shields.io/badge/uv-0.8.22-DE5FE9)

Prácticas de la asignatura **Infraestructuras y Servicios en la Nube** (Universidad Alfonso X el Sabio).

Este repositorio contiene dos laboratorios:

| Laboratorio | Qué se construye | Tecnologías |
|---|---|---|
| [Lab 2](./cloud-lab) | API en Python empaquetada en un contenedor | uv, FastAPI, Docker |
| [Lab 3](./lab3-compose) | API de tareas con base de datos en dos contenedores | FastAPI, PostgreSQL, Docker Compose |

## Estructura

```text
.
├── cloud-lab/
│   ├── main.py
│   ├── src/cloud_lab/__init__.py
│   ├── pyproject.toml
│   ├── uv.lock
│   ├── .python-version
│   ├── Dockerfile
│   ├── .dockerignore
│   └── README.md
├── lab3-compose/
│   ├── app/main.py
│   ├── pyproject.toml
│   ├── uv.lock
│   ├── Dockerfile
│   ├── compose.yaml
│   ├── .env
│   ├── .env.example
│   └── .dockerignore
└── README.md
```

## Requisitos

- Docker Desktop (en marcha)
- Git
- uv (solo para ejecutar fuera de Docker)

```powershell
docker --version
docker compose version
uv --version
```

---

## Lab 2: contenedores con Docker y uv

API con dos rutas, gestionada con **uv** y empaquetada en una imagen Docker.

| Ruta | Respuesta |
|---|---|
| `GET /` | `{"message": "Hola desde Cloud!"}` |
| `GET /health` | `{"status": "ok"}` |

### Ejecutar

```powershell
cd cloud-lab
docker build -t cloud-lab .
docker run --name cloud-lab-container -p 8080:8000 cloud-lab
```

Abre `http://localhost:8080` o `http://localhost:8080/docs`.

### Detener y borrar el contenedor

```powershell
docker stop cloud-lab-container
docker rm cloud-lab-container
```

### Qué demuestra

- `pyproject.toml` declara dependencias; `uv.lock` fija las versiones exactas.
- Una imagen es una plantilla; un contenedor es esa imagen en ejecución.
- `-p 8080:8000` conecta el puerto 8080 del equipo con el 8000 del contenedor.
- Las dependencias se copian antes que el código para aprovechar la caché de capas.

---

## Lab 3: aplicación multicontenedor con Docker Compose

API de tareas (FastAPI) conectada a una base de datos PostgreSQL. Los datos se guardan en un volumen.

```text
PC LOCAL
┌──────────── Docker Compose ────────────┐
│ ┌──────────┐   red    ┌────────────┐   │
│ │   app    │ ───────▶ │     db     │   │
│ │ FastAPI  │          │ PostgreSQL │   │
│ └──────────┘          └─────┬──────┘   │
│                             │          │
│                          volumen       │
└────────────────────────────────────────┘
```

| Método | Ruta | Función |
|---|---|---|
| `GET` | `/health` | Estado de la API |
| `GET` | `/tasks` | Lista las tareas |
| `POST` | `/tasks` | Crea una tarea (`{"title": "..."}`) |
| `DELETE` | `/tasks/{id}` | Borra una tarea |

### Ejecutar

```powershell
cd lab3-compose
```

El repositorio incluye `.env` con los valores de prueba del laboratorio:

```text
POSTGRES_DB=tasks
POSTGRES_USER=labuser
POSTGRES_PASSWORD=labpass
```

Levanta los servicios:

```powershell
docker compose up --build
```

Abre `http://localhost:8000/docs`.

### Comandos útiles

| Comando | Función |
|---|---|
| `docker compose up -d` | Levanta en segundo plano |
| `docker compose ps` | Estado de los servicios |
| `docker compose logs -f app` | Logs de la API en directo |
| `docker compose down` | Elimina contenedores y red (conserva los datos) |
| `docker compose down -v` | Elimina también el volumen (borra los datos) |

### Qué demuestra

- `app` localiza a `db` por su nombre dentro de la red de Compose, no por `localhost`.
- `healthcheck` y `depends_on` hacen que `app` arranque solo cuando `db` acepta conexiones.
- El volumen `postgres_data` conserva las tareas tras `docker compose down`.
- `.env` guarda la configuración y `.env.example` documenta las variables. En un proyecto real, `.env` no se sube a Git.

---

## Conceptos clave

| Concepto | Definición |
|---|---|
| Imagen | Plantilla inmutable para crear contenedores |
| Contenedor | Instancia en ejecución de una imagen |
| Dockerfile | Instrucciones para construir una imagen |
| `RUN` / `CMD` | Se ejecuta al construir / al arrancar el contenedor |
| Compose | Define y levanta varios servicios con un archivo |
| Volumen | Almacenamiento fuera del contenedor |

## Autor

Ibay, estudiante de Computación e Inteligencia Artificial en la UAX.