from __future__ import annotations

import os
from typing import Any

import httpx
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(title="KoreaMate API", version="0.1.0")

allowed_origins = os.getenv("ALLOWED_ORIGINS", "*")
origins = [origin.strip() for origin in allowed_origins.split(",") if origin.strip()]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins if origins else ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


MOCK_DICTIONARY_DATA: dict[str, list[dict[str, Any]]] = {
    "사랑": [
        {"word": "사랑", "meaning": "cinta, kasih sayang", "part_of_speech": "kata benda"},
        {"word": "사랑", "meaning": "kehidupan romantis; kehangatan", "part_of_speech": "kata benda"},
    ],
    "공부": [
        {"word": "공부", "meaning": "belajar; studi", "part_of_speech": "kata benda"},
    ],
    "한국어": [
        {"word": "한국어", "meaning": "bahasa Korea", "part_of_speech": "kata benda"},
    ],
    "도시": [
        {"word": "도시", "meaning": "kota", "part_of_speech": "kata benda"},
    ],
}


class DictionaryResult(BaseModel):
    query: str
    entries: list[dict[str, Any]] = []
    source: str = "krdict"


class KrdictError(Exception):
    pass


async def fetch_krdict_data(query: str) -> list[dict[str, Any]]:
    api_key = os.getenv("KRDICT_API_KEY")
    base_url = os.getenv("KRDICT_BASE_URL")
    timeout_seconds = float(os.getenv("REQUEST_TIMEOUT_SECONDS", "15"))

    if api_key and base_url:
        headers = {
            "Accept": "application/json",
            "Authorization": f"Bearer {api_key}",
        }
        params: dict[str, Any] = {"q": query, "limit": 10}

        try:
            async with httpx.AsyncClient(timeout=timeout_seconds) as client:
                response = await client.get(base_url, headers=headers, params=params)
                response.raise_for_status()
                payload = response.json()
        except httpx.HTTPError as exc:
            raise HTTPException(status_code=502, detail=f"Dictionary service request failed: {exc}") from exc

        if isinstance(payload, dict):
            entries = payload.get("entries")
            if entries is None:
                entries = payload.get("items", [])
            if not isinstance(entries, list):
                entries = []
            return entries

        if isinstance(payload, list):
            return payload

        raise KrdictError("Unsupported payload format returned by the dictionary provider.")

    normalized_query = query.strip()
    fallback = MOCK_DICTIONARY_DATA.get(normalized_query)
    if fallback:
        return fallback

    if normalized_query:
        return [
            {
                "word": normalized_query,
                "meaning": "Data dari kamus resmi belum terhubung; ini adalah data contoh aman untuk pengujian awal.",
                "part_of_speech": "kata benda",
            }
        ]

    return []


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/api/dictionary/search", response_model=DictionaryResult)
async def search_dictionary(q: str = Query(..., min_length=1)) -> DictionaryResult:
    try:
        entries = await fetch_krdict_data(q)
    except KrdictError as exc:
        raise HTTPException(status_code=502, detail=str(exc)) from exc

    source = "mock" if not os.getenv("KRDICT_API_KEY") or not os.getenv("KRDICT_BASE_URL") else "krdict"
    return DictionaryResult(
        query=q,
        entries=entries,
        source=source,
    )
