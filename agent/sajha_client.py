"""Client for SAJHA MCP Server — discovers tools and executes them."""

import httpx
import logging
from typing import Any

logger = logging.getLogger(__name__)

SAJHA_BASE = "http://localhost:3002"
SAJHA_USER = "admin"
SAJHA_PASS = "admin123"


class SajhaClient:
    """Connects to SAJHA MCP Server, discovers tools, and executes them."""

    def __init__(self, base_url: str = SAJHA_BASE):
        self.base_url = base_url
        self.token: str | None = None
        self._client = httpx.Client(base_url=base_url, timeout=60.0)

    def login(self) -> str:
        resp = self._client.post(
            "/api/auth/login",
            json={"user_id": SAJHA_USER, "password": SAJHA_PASS},
        )
        resp.raise_for_status()
        self.token = resp.json()["token"]
        return self.token

    def _mcp_call(self, method: str, params: dict = None) -> dict:
        if not self.token:
            self.login()

        resp = self._client.post(
            "/api/mcp",
            headers={"Authorization": f"Bearer {self.token}"},
            json={
                "jsonrpc": "2.0",
                "id": "1",
                "method": method,
                "params": params or {},
            },
        )
        resp.raise_for_status()
        data = resp.json()
        if "error" in data:
            raise RuntimeError(f"MCP error: {data['error']}")
        return data.get("result", {})

    def list_tools(self) -> list[dict]:
        result = self._mcp_call("tools/list")
        return result.get("tools", [])

    def call_tool(self, tool_name: str, arguments: dict) -> Any:
        result = self._mcp_call(
            "tools/call",
            {"name": tool_name, "arguments": arguments},
        )
        # Extract text from content blocks
        content = result.get("content", [])
        parts = []
        for block in content:
            if isinstance(block, dict) and "text" in block:
                parts.append(block["text"])
            elif isinstance(block, str):
                parts.append(block)
        return "\n".join(parts) if parts else str(result)


# Singleton
sajha = SajhaClient()
