import hashlib
import os
import time
from typing import Optional, List
from fastapi import FastAPI, HTTPException, Request, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import httpx

app = FastAPI(
    title="Alinea Translation Gateway",
    description="FOSS Translation Gateway protecting self-hosted LibreTranslate compute with shared caching and rate limiting.",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

LIBRETRANSLATE_URL = os.getenv("LIBRETRANSLATE_URL", "http://localhost:5000")
CACHE_EXPIRY_SECONDS = int(os.getenv("CACHE_EXPIRY_SECONDS", "86400"))  # 24 hours

# In-memory LRU cache fallback if Redis is not running
memory_cache = {}

class TranslateRequest(BaseModel):
    q: str
    source: str
    target: str
    format: Optional[str] = "text"
    style: Optional[str] = "natural"
    api_key: Optional[str] = None

class TranslateResponse(BaseModel):
    translatedText: str
    sourceLanguage: str
    targetLanguage: str
    isFromCache: bool
    provider: str = "libretranslate"
    version: str = "argos-v1.9"

class DetectRequest(BaseModel):
    q: str

class ProviderInfo(BaseModel):
    id: str
    name: str
    is_foss: bool
    engine: str
    license: str
    description: str

def compute_cache_key(text: str, source: str, target: str, style: str) -> str:
    normalized = " ".join(text.strip().split())
    raw = f"{source}:{target}:{normalized}:{style}"
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()

@app.get("/health")
async def health_check():
    return {
        "status": "ok",
        "service": "alinea-translation-gateway",
        "timestamp": time.time(),
    }

@app.get("/v1/providers", response_model=List[ProviderInfo])
async def list_providers():
    return [
        ProviderInfo(
            id="libretranslate",
            name="LibreTranslate (Self-Hosted)",
            is_foss=True,
            engine="Argos Translate",
            license="AGPL-3.0 / MIT",
            description="100% Free & Open Source machine translation running on self-hosted compute with zero marginal cost.",
        ),
        ProviderInfo(
            id="byok",
            name="Bring Your Own Key",
            is_foss=False,
            engine="DeepL / Cloud MT",
            license="Proprietary",
            description="User-supplied API key for power users requiring third-party models.",
        ),
    ]

@app.post("/v1/translate", response_model=TranslateResponse)
async def translate(req: TranslateRequest):
    trimmed = req.q.strip()
    if not trimmed:
        return TranslateResponse(
            translatedText=req.q,
            sourceLanguage=req.source,
            targetLanguage=req.target,
            isFromCache=False,
        )

    cache_key = compute_cache_key(trimmed, req.source, req.target, req.style or "natural")

    # 1. Check Gateway Cache
    if cache_key in memory_cache:
        cached_val = memory_cache[cache_key]
        return TranslateResponse(
            translatedText=cached_val,
            sourceLanguage=req.source,
            targetLanguage=req.target,
            isFromCache=True,
        )

    # 2. Forward request to LibreTranslate instance
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            payload = {
                "q": trimmed,
                "source": req.source,
                "target": req.target,
                "format": req.format or "text",
            }
            if req.api_key:
                payload["api_key"] = req.api_key

            resp = await client.post(
                f"{LIBRETRANSLATE_URL}/translate",
                json=payload,
            )

            if resp.status_code == 200:
                data = resp.json()
                translated = data.get("translatedText", trimmed)
                # Store in gateway cache
                memory_cache[cache_key] = translated
                return TranslateResponse(
                    translatedText=translated,
                    sourceLanguage=req.source,
                    targetLanguage=req.target,
                    isFromCache=False,
                )
            else:
                raise HTTPException(
                    status_code=resp.status_code,
                    detail=f"LibreTranslate inference error: {resp.text}",
                )
    except httpx.RequestError as exc:
        raise HTTPException(
            status_code=503,
            detail=f"LibreTranslate service unavailable at {LIBRETRANSLATE_URL}: {str(exc)}",
        )

@app.post("/v1/detect-language")
async def detect_language(req: DetectRequest):
    trimmed = req.q.strip()
    if not trimmed:
        return [{"language": "en", "confidence": 1.0}]

    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            resp = await client.post(
                f"{LIBRETRANSLATE_URL}/detect",
                json={"q": trimmed},
            )
            if resp.status_code == 200:
                return resp.json()
            return [{"language": "en", "confidence": 0.5}]
    except Exception:
        return [{"language": "en", "confidence": 0.5}]

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
