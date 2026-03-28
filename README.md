# Market Risk AI Tool

A local AI-powered market risk research tool. Uses **Qwen2.5-7B** running on your machine (via Ollama) connected to **SAJHA MCP Server** for real-time web search via Tavily.

No data leaves your network except Tavily web searches. The LLM runs 100% locally.

---

## Architecture

```
Browser (localhost:8000)
    |
    v
FastAPI Server (Python)
    |
    v
LangGraph ReAct Agent
    |
    +---> Qwen 2.5 7B (via Ollama, local)
    |
    +---> SAJHA MCP Server (localhost:3002)
              |
              +---> tavily_web_search
              +---> tavily_news_search
              +---> tavily_domain_search
              +---> tavily_research_search
```

---

## What You Need Before Starting

| Requirement | Why | How to Check |
|------------|-----|-------------|
| **Python 3.10+** | Runs the agent server | `python --version` |
| **Ollama** | Runs the Qwen LLM locally | `ollama --version` |
| **SAJHA MCP Server** | Provides the Tavily search tools | Should be running on port 3002 |
| **8 GB RAM minimum** | Qwen 7B needs ~5GB RAM | |
| **10 GB free disk** | For model + dependencies | |
| **Git** | To clone this repo | `git --version` |

---

## Step-by-Step Setup (Windows)

### Step 1: Clone the Repository

Open **Command Prompt** (or PowerShell) and run:

```cmd
git clone https://github.com/algowizzzz/qwen-mcp-agent.git
cd qwen-mcp-agent
```

This will download everything including the chunked model files (~4.5 GB total). It will take a while depending on your internet speed.

### Step 2: Run the Setup Script

```cmd
setup.bat
```

This script does 5 things automatically:
1. Checks Python is installed
2. Checks Ollama is installed
3. Creates a Python virtual environment (`.venv` folder)
4. Installs all Python packages (FastAPI, LangGraph, etc.)
5. Downloads the Qwen 2.5 7B model into Ollama (~4.4 GB download)

**If the script fails at any step, it will tell you what's missing.**

### Step 3: Make Sure SAJHA MCP Server is Running

The SAJHA MCP Server must be running on port 3002 before you start the agent.

To verify it's running, open your browser and go to:
```
http://localhost:3002
```

If you see the SAJHA web interface, you're good. If not, start it first.

### Step 4: Start the Agent

```cmd
start.bat
```

You should see output like:
```
INFO:     Uvicorn running on http://0.0.0.0:8000
INFO:     Application startup complete.
```

### Step 5: Open the Chat UI

Open your browser and go to:

```
http://localhost:8000
```

You'll see the **Market Risk AI Tool** chat interface. Type a question and hit Enter.

**That's it. You're done.**

---

## Step-by-Step Setup (Mac / Linux)

### Step 1: Clone the Repository

```bash
git clone https://github.com/algowizzzz/qwen-mcp-agent.git
cd qwen-mcp-agent
```

### Step 2: Run the Setup Script

```bash
chmod +x setup.sh start.sh
./setup.sh
```

### Step 3: Make Sure SAJHA MCP Server is Running on port 3002

### Step 4: Start the Agent

```bash
./start.sh
```

### Step 5: Open http://localhost:8000 in your browser

---

## Available Tools

The agent has 4 Tavily-powered search tools:

| Tool | What it Does | Example Question |
|------|-------------|-----------------|
| `tavily_web_search` | General web search | "What is the current S&P 500 level?" |
| `tavily_news_search` | Recent news search | "Latest news on Federal Reserve interest rates" |
| `tavily_domain_search` | Search specific websites | "Find BMO earnings on reuters.com" |
| `tavily_research_search` | Deep research on a topic | "Comprehensive analysis of 2024 banking sector risks" |

---

## Configuration

### Changing the SAJHA MCP Server Address

If SAJHA is running on a different machine or port, edit `agent/sajha_client.py`:

```python
SAJHA_BASE = "http://localhost:3002"   # <-- change this
SAJHA_USER = "admin"                    # <-- change if needed
SAJHA_PASS = "admin123"                 # <-- change if needed
```

### Changing the LLM Model

If you want to use a different Ollama model, edit `agent/graph.py`:

```python
llm = ChatOllama(
    model="qwen2.5:7b",   # <-- change to any Ollama model
    temperature=0,
    num_ctx=4096,          # <-- context window size
)
```

---

## Troubleshooting

### "Connection refused" on port 8000
The agent server isn't running. Run `start.bat` (or `start.sh`).

### "Connection refused" on port 3002
SAJHA MCP Server isn't running. Start it first.

### "Model not found" error
Ollama doesn't have the model. Run:
```cmd
ollama pull qwen2.5:7b
```

### Agent is very slow
This is normal for a 7B model on CPU. First response takes 30-60 seconds. If you have a GPU, Ollama will use it automatically.

### "Invalid API key" from Tavily
The Tavily API key is configured inside SAJHA MCP Server's `config/application.properties`, not in this project. Check that file has a valid `tavily.api.key`.

### Python package errors
Make sure you're in the virtual environment:
```cmd
.venv\Scripts\activate    (Windows)
source .venv/bin/activate  (Mac/Linux)
pip install -r requirements.txt
```

---

## File Structure

```
qwen-mcp-agent/
|-- agent/
|   |-- __init__.py          # Package marker
|   |-- graph.py             # LangGraph ReAct agent setup
|   |-- tools.py             # Tavily tool definitions
|   |-- sajha_client.py      # HTTP client for SAJHA MCP Server
|   |-- server.py            # FastAPI web server
|   |-- static/
|       |-- index.html       # Chat UI (Market Risk AI Tool)
|
|-- models/
|   |-- chunks/              # 48 x 95MB model chunks
|   |-- Qwen2.5-7B-Instruct-Q4_K_M.gguf  # Assembled model (after running assemble script)
|
|-- requirements.txt         # Python dependencies
|-- setup.bat / setup.sh     # One-click setup scripts
|-- start.bat / start.sh     # One-click start scripts
|-- assemble.bat / assemble.sh  # Model assembly scripts
|-- Modelfile                # Ollama model import config
|-- README.md                # This file
```

---

## System Requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| RAM | 8 GB | 16 GB |
| Disk | 10 GB free | 14 GB free |
| GPU | Not required | Any Metal/CUDA GPU speeds up inference |
| Python | 3.10+ | 3.12+ |
| OS | Windows 10+, macOS 12+, Linux | |

---

## Model Details

| Property | Value |
|----------|-------|
| Base model | Qwen2.5-7B-Instruct |
| Quantization | Q4_K_M (4-bit, medium) |
| File size | ~4.4 GB (split into 48 chunks of ~95MB) |
| Context window | 32K tokens (default), 4K configured for agents |
| License | Apache 2.0 |
