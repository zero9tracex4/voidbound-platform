from fastapi.testclient import TestClient

from voidbound_platform.main import app

client = TestClient(app)


def test_greeting_uses_default(monkeypatch) -> None:
    monkeypatch.delenv("APP_GREETING", raising=False)

    response = client.get("/greeting")

    assert response.status_code == 200
    assert response.json() == {"message": "Hello from VoidBound"}


def test_greeting_uses_environment_variable(monkeypatch) -> None:
    monkeypatch.setenv("APP_GREETING", "Hello from the lab")

    response = client.get("/greeting")

    assert response.status_code == 200
    assert response.json() == {"message": "Hello from the lab"}
