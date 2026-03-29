"""LangGraph ReAct agent using local Qwen 7B via llama.cpp or Ollama."""

import os
from langgraph.prebuilt import create_react_agent

from .tools import (
    tavily_web_search,
    tavily_news_search,
    tavily_domain_search,
    tavily_research_search,
)

TOOLS = [
    tavily_web_search,
    tavily_news_search,
    tavily_domain_search,
    tavily_research_search,
]


def build_agent():
    """Build and return the LangGraph ReAct agent.

    Supports two backends (set LLM_BACKEND env var):
      - "llamacpp" (default) — connects to llama-server on port 8080
      - "ollama" — connects to Ollama on port 11434
    """
    backend = os.environ.get("LLM_BACKEND", "llamacpp").lower()

    if backend == "ollama":
        from langchain_ollama import ChatOllama
        llm = ChatOllama(
            model="qwen2.5:7b",
            temperature=0,
            num_ctx=4096,
        )
    else:
        from langchain_openai import ChatOpenAI
        llm = ChatOpenAI(
            base_url="http://localhost:8080/v1",
            api_key="not-needed",
            model="qwen2.5-7b",
            temperature=0,
            max_tokens=2048,
        )

    agent = create_react_agent(
        model=llm,
        tools=TOOLS,
    )

    return agent


# Singleton agent instance
agent = build_agent()
