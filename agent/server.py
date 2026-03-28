"""FastAPI server for the ReAct agent chatbot."""

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel

from .graph import agent

app = FastAPI()


class ChatRequest(BaseModel):
    message: str


class ChatResponse(BaseModel):
    reply: str
    tool_calls: list[dict] = []


@app.post("/chat", response_model=ChatResponse)
async def chat(req: ChatRequest):
    """Send a message to the agent and get a response."""
    tool_calls_log = []

    result = await agent.ainvoke(
        {"messages": [("user", req.message)]},
    )

    # Extract tool calls and final answer from message history
    for msg in result["messages"]:
        if hasattr(msg, "tool_calls") and msg.tool_calls:
            for tc in msg.tool_calls:
                tool_calls_log.append({
                    "tool": tc["name"],
                    "input": tc["args"],
                })
        if hasattr(msg, "content") and msg.type == "tool":
            tool_calls_log[-1]["output"] = msg.content if tool_calls_log else msg.content

    # Last AI message is the final answer
    final = result["messages"][-1].content

    return ChatResponse(reply=final, tool_calls=tool_calls_log)


# Serve static files (HTML UI)
app.mount("/", StaticFiles(directory="agent/static", html=True), name="static")
