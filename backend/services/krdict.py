from __future__ import annotations

import os
from typing import Any

import httpx


class KrdictClient:
    def __init__(self, api_key: str | None = None, base_url: str | None = None, timeout_seconds: float = 15.0):
        self.api_key = api_key or os.getenv("KRDICT_API_KEY")
        self.base_url = base_url or os.getenv("KRDICT_BASE_URL")
        self.timeout_seconds = timeout_seconds

    async def search(self, query: str, *, limit: int = 10) -> list[dict[str, Any]]:
        if not self.api_key or not self.base_url:
            raise ValueError("KRDICT_API_KEY and KRDICT_BASE_URL must be configured on the server.")

        headers = {
            "Accept": "application/json",
            "Authorization": f"Bearer {self.api_key}",
        }
        params: dict[str, Any] = {"q": query, "limit": limit}

        async with httpx.AsyncClient(timeout=self.timeout_seconds) as client:
            response = await client.get(self.base_url, headers=headers, params=params)
            response.raise_for_status()
            payload = response.json()

        if isinstance(payload, dict):
            entries = payload.get("entries") or payload.get("items") or []
            if not isinstance(entries, list):
                return []
            return entries

        if isinstance(payload, list):
            return payload

        return []
