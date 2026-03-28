"""LangGraph ReAct agent using local Qwen 7B via Ollama + SAJHA MCP tools."""

from langchain_ollama import ChatOllama
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
    """Build and return the LangGraph ReAct agent."""
    llm = ChatOllama(
        model="qwen2.5:7b",
        temperature=0,
        num_ctx=4096,
    )

    agent = create_react_agent(
        model=llm,
        tools=TOOLS,
    )

    return agent


# Singleton agent instance
agent = build_agent()
