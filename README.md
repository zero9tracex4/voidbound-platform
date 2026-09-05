# VoidBound Platform

A small FastAPI service evolving into a complete DevOps learning project.

## Current endpoints

| Method | Path | Purpose |
|---|---|---|
| GET | `/health` | Reports whether the application is responding |
| GET | `/version` | Reports the configured application version |
| GET | `/hostname` | Reports the hostname of the current runtime |
| GET | `/greeting` | Returns `APP_GREETING`, or `Hello from VoidBound` when unset |

`APP_VERSION` controls the value returned by `/version`. If it is not set, the application uses its built-in version.

## Local development

Install the locked dependencies:

```bash
uv sync --locked --all-groups
```

Start the development server:

```bash
uv run fastapi dev
```

The API is available at <http://127.0.0.1:8000> and its interactive documentation at <http://127.0.0.1:8000/docs>.

## Validation

Run the same application checks used by CI:

```bash
uv run ruff check .
uv run ruff format --check .
uv run pytest -q
```

## Docker

Build the image:

```bash
docker build --tag voidbound-platform:dev .
```

Run the container:

```bash
docker run --detach \
  --name voidbound-platform \
  --publish 127.0.0.1:8000:8000 \
  --env APP_VERSION=container-dev \
  voidbound-platform:dev
```

Inspect and remove it:

```bash
docker logs voidbound-platform
docker stop voidbound-platform
docker rm voidbound-platform
```

## Docker Compose

Build and start the application:

```bash
docker compose up --build --detach
```

Inspect its state and logs:

```bash
docker compose ps
docker compose logs app
```

Override the application version:

```bash
APP_VERSION=compose-override docker compose up --detach
```

Stop and remove the Compose deployment:

```bash
docker compose down
```

## Continuous integration

GitHub Actions validates linting, formatting, tests, the Compose configuration, and the Docker image build for every pull request.
