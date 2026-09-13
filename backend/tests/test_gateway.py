import pytest
from fastapi.testclient import TestClient
import sys
import os

# Add backend/app to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "app")))

from main import app, compute_cache_key

client = TestClient(app)

def test_health_endpoint():
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "ok"
    assert data["service"] == "alinea-translation-gateway"

def test_providers_transparency():
    response = client.get("/v1/providers")
    assert response.status_code == 200
    providers = response.json()
    assert len(providers) >= 2
    # Verify FOSS provider is default
    foss_provider = next(p for p in providers if p["id"] == "libretranslate")
    assert foss_provider["is_foss"] is True
    assert "Argos" in foss_provider["engine"]

def test_cache_key_normalization():
    key1 = compute_cache_key("  Hello   world!  \n", "en", "id", "natural")
    key2 = compute_cache_key("Hello world!", "en", "id", "natural")
    assert key1 == key2

def test_translate_empty_text():
    response = client.post(
        "/v1/translate",
        json={"q": "   ", "source": "en", "target": "id"},
    )
    assert response.status_code == 200
    assert response.json()["translatedText"].strip() == ""
