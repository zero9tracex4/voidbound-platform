import os
import socket

from fastapi import FastAPI

app = FastAPI(
    title="VoidBound Platform",
    version="0.1.0",
)


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/version")
def version() -> dict[str, str]:
    return {"version": os.getenv("APP_VERSION", app.version)}


@app.get("/hostname")
def hostname() -> dict[str, str]:
    return {"hostname": socket.gethostname()}
