from __future__ import annotations

import os
from typing import Any

import httpx
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(title="KoreaMate API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class DictionaryResult(BaseModel):
    query: str
    entries: list[dict[str, Any]] = []


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/api/dictionary/search", response_model=DictionaryResult)
async def search_dictionary(q: str = Query(..., min_length=1)) -> DictionaryResult:
    api_key = os.getenv("KRDICT_API_KEY")
    base_url = os.getenv("KRDICT_BASE_URL")

    if not api_key or not base_url:
        raise HTTPException(
            status_code=500,
            detail="Dictionary provider configuration is missing. Set KRDICT_API_KEY and KRDICT_BASE_URL.",
        )

    # This is intentionally a safe scaffold.
    # Replace this block with the exact official Krdict endpoint and request format
    # from the provider's documentation.
    headers = {"Authorization": f"Bearer {api_key}"}
    params: dict[str, Any] = {"q": q, "limit": 10}

    try:
        async with httpx.AsyncClient(timeout=15.0) as client:
            response = await client.get(base_url, headers=headers, params=params)
            response.raise_for_status()
            payload = response.json()
    except httpx.HTTPError as exc:
        raise HTTPException(status_code=502, detail=f"Dictionary service request failed: {exc}") from exc

    # Normalize the payload before returning to the Flutter app.
    return DictionaryResult(
        query=q,
        entries=payload.get("entries", []),
    )
