import socket

from fastapi.testclient import TestClient

from voidbound_platform.main import app

client = TestClient(app)


def test_version_uses_default(monkeypatch) -> None:
    monkeypatch.delenv("APP_VERSION", raising=False)

    response = client.get("/version")

    assert response.status_code == 200
    assert response.json() == {"version": "0.1.0"}


def test_version_uses_environment_variable(monkeypatch) -> None:
    monkeypatch.setenv("APP_VERSION", "9.9.9")

    response = client.get("/version")

    assert response.status_code == 200
    assert response.json() == {"version": "9.9.9"}


def test_hostname() -> None:
    response = client.get("/hostname")

    assert response.status_code == 200
    assert response.json() == {"hostname": socket.gethostname()}
