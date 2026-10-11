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

    if not api_key or not base_url:
        raise HTTPException(
            status_code=500,
            detail="Dictionary provider configuration is missing. Add KRDICT_API_KEY and KRDICT_BASE_URL in the server environment.",
        )

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


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/api/dictionary/search", response_model=DictionaryResult)
async def search_dictionary(q: str = Query(..., min_length=1)) -> DictionaryResult:
    try:
        entries = await fetch_krdict_data(q)
    except KrdictError as exc:
        raise HTTPException(status_code=502, detail=str(exc)) from exc

    return DictionaryResult(
        query=q,
        entries=entries,
        source="krdict",
    )
