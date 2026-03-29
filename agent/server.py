"""FastAPI server for the ReAct agent chatbot."""

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel

from .graph import agent

app = FastAPI()


class ChatRequest(BaseModel):
    message: str


class Step(BaseModel):
    type: str  # "think", "act", "observe", "answer"
    content: str
    tool: str = ""
    tool_input: dict = {}


class ChatResponse(BaseModel):
    reply: str
    steps: list[Step] = []
    tool_calls: list[dict] = []


@app.post("/chat", response_model=ChatResponse)
async def chat(req: ChatRequest):
    """Send a message to the agent and get a response."""
    steps = []
    tool_calls_log = []

    result = await agent.ainvoke(
        {"messages": [("user", req.message)]},
    )

    for msg in result["messages"]:
        # Skip the user message
        if msg.type == "human":
            continue

        # AI message with tool calls = Think + Act
        if msg.type == "ai" and hasattr(msg, "tool_calls") and msg.tool_calls:
            # Thought (if the model produced reasoning text)
            if msg.content:
                steps.append(Step(type="think", content=msg.content))

            # Tool calls = Act
            for tc in msg.tool_calls:
                steps.append(Step(
                    type="act",
                    content=f"Calling {tc['name']}",
                    tool=tc["name"],
                    tool_input=tc["args"],
                ))
                tool_calls_log.append({
                    "tool": tc["name"],
                    "input": tc["args"],
                })

        # Tool message = Observe
        elif msg.type == "tool":
            steps.append(Step(
                type="observe",
                content=msg.content[:500] if msg.content else "",
                tool=msg.name if hasattr(msg, "name") else "",
            ))
            if tool_calls_log:
                tool_calls_log[-1]["output"] = msg.content

        # Final AI message (no tool calls) = Answer
        elif msg.type == "ai" and not (hasattr(msg, "tool_calls") and msg.tool_calls):
            steps.append(Step(type="answer", content=msg.content))

    # Last AI message is the final answer
    final = result["messages"][-1].content

    return ChatResponse(reply=final, steps=steps, tool_calls=tool_calls_log)


# Serve static files (HTML UI)
app.mount("/", StaticFiles(directory="agent/static", html=True), name="static")
