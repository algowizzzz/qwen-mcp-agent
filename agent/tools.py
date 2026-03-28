"""Tools for the ReAct agent — Tavily search tools via SAJHA MCP."""

from langchain_core.tools import tool


@tool
def tavily_web_search(query: str) -> str:
    """Search the web using Tavily AI-powered search engine. Use this for current events, recent news, or any web information.

    Args:
        query: Search query to find web information
    """
    from .sajha_client import sajha
    return sajha.call_tool("tavily_web_search", {"query": query, "max_results": 5, "include_answer": True})


@tool
def tavily_news_search(query: str) -> str:
    """Search for recent news articles using Tavily with news-optimized results and recency prioritization.

    Args:
        query: News topic or event to search for
    """
    from .sajha_client import sajha
    return sajha.call_tool("tavily_news_search", {"query": query, "max_results": 5})


@tool
def tavily_domain_search(query: str, domains: str) -> str:
    """Search within specific domains using Tavily for targeted information retrieval.

    Args:
        query: Search query
        domains: Comma-separated list of domains to search within, e.g. 'reuters.com,bloomberg.com'
    """
    from .sajha_client import sajha
    return sajha.call_tool("tavily_domain_search", {"query": query, "domains": domains, "max_results": 5})


@tool
def tavily_research_search(query: str) -> str:
    """Perform comprehensive deep research search with advanced depth and analysis. Use this for in-depth research on complex topics.

    Args:
        query: Research topic or question requiring thorough analysis
    """
    from .sajha_client import sajha
    return sajha.call_tool("tavily_research_search", {"query": query, "max_results": 5})
