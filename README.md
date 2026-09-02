# VoidBound Platform

A small Python service that will evolve into a complete DevOps learning project.

## Current endpoints

| Method | Path | Purpose |
|---|---|---|
| GET | `/health` | Reports whether the application is responding |

## Local development

Install the locked dependencies:

```bash
uv sync
```

Start the development server:

```bash
uv run fastapi dev
```

The API is available at <http://127.0.0.1:8000> and its interactive documentation at <http://127.0.0.1:8000/docs>.
