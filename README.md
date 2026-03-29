# Market Risk AI Tool

A local AI-powered market risk research tool. Uses **Qwen2.5-7B** running on your machine connected to **SAJHA MCP Server** for real-time web search via Tavily.

No data leaves your network except Tavily web searches. The LLM runs 100% locally.

**Two LLM backends supported:**
- **llama.cpp** — for enterprise PCs where you can't install Ollama
- **Ollama** — simpler setup if Ollama is available

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
    +---> Qwen 2.5 7B (via llama.cpp OR Ollama, local)
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
| **llama.cpp** OR **Ollama** | Runs the Qwen LLM locally | `llama-server --version` or `ollama --version` |
| **SAJHA MCP Server** | Provides the Tavily search tools | Should be running on port 3002 |
| **8 GB RAM minimum** | Qwen 7B needs ~5GB RAM | |
| **10 GB free disk** | For model + dependencies | |
| **Git** | To clone this repo | `git --version` |

---

## Option A: Setup with llama.cpp (Enterprise / No Ollama)

Use this if your enterprise PC does not allow installing Ollama.

### Step 1: Clone the Repository

```cmd
git clone https://github.com/algowizzzz/qwen-mcp-agent.git
cd qwen-mcp-agent
```

This downloads everything including chunked model files (~4.5 GB total).

### Step 2: Assemble the Model

The model is split into 48 chunks of ~95MB each. You need to combine them.

**Windows:**
```cmd
assemble.bat
```

**Mac / Linux:**
```bash
chmod +x assemble.sh
./assemble.sh
```

This creates `models/Qwen2.5-7B-Instruct-Q4_K_M.gguf` (~4.4 GB).

### Step 3: Create Virtual Environment and Install Packages

**Windows:**
```cmd
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

**Mac / Linux:**
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Step 4: Make Sure SAJHA MCP Server is Running

The SAJHA MCP Server must be running on port 3002 before you start the agent.

Open your browser and go to `http://localhost:3002`. If you see the SAJHA web interface, you're good.

### Step 5: Start llama-server (Terminal / CMD Window 1)

**Windows:**
```cmd
llama-server.exe -m models\Qwen2.5-7B-Instruct-Q4_K_M.gguf -c 4096 -ngl 99 --port 8080
```

**Mac / Linux:**
```bash
llama-server -m models/Qwen2.5-7B-Instruct-Q4_K_M.gguf -c 4096 -ngl 99 --port 8080
```

Wait until you see `listening on http://0.0.0.0:8080`. **Keep this window open.**

### Step 6: Start the Agent (Terminal / CMD Window 2)

**Windows:**
```cmd
.venv\Scripts\activate
set LLM_BACKEND=llamacpp
python -m uvicorn agent.server:app --host 0.0.0.0 --port 8000
```

**Mac / Linux:**
```bash
source .venv/bin/activate
export LLM_BACKEND=llamacpp
python -m uvicorn agent.server:app --host 0.0.0.0 --port 8000
```

Or use the one-click script: `start-llamacpp.bat` (Windows) / `./start-llamacpp.sh` (Mac/Linux).

### Step 7: Open the Chat UI

Open your browser and go to:
```
http://localhost:8000
```

You'll see the **Market Risk AI Tool** chat interface. Type a question and hit Enter.

**That's it. You're done.**

---

## Option B: Setup with Ollama (Simpler)

Use this if you have Ollama installed.

### Step 1: Clone the Repository

```cmd
git clone https://github.com/algowizzzz/qwen-mcp-agent.git
cd qwen-mcp-agent
```

### Step 2: Run the Setup Script

**Windows:**
```cmd
setup.bat
```

**Mac / Linux:**
```bash
chmod +x setup.sh start.sh
./setup.sh
```

This script does 5 things automatically:
1. Checks Python is installed
2. Checks Ollama is installed
3. Creates a Python virtual environment (`.venv` folder)
4. Installs all Python packages (FastAPI, LangGraph, etc.)
5. Downloads the Qwen 2.5 7B model into Ollama (~4.4 GB download)

### Step 3: Make Sure SAJHA MCP Server is Running on port 3002

### Step 4: Start the Agent

**Windows:**
```cmd
start.bat
```

**Mac / Linux:**
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

### Switching LLM Backend

The backend is controlled by the `LLM_BACKEND` environment variable:

| Value | Backend | When to Use |
|-------|---------|-------------|
| `llamacpp` | llama.cpp server on port 8080 | Enterprise PCs, no Ollama |
| `ollama` | Ollama on port 11434 | Personal machines with Ollama |

Default is `llamacpp` if not set.

### Changing the SAJHA MCP Server Address

If SAJHA is running on a different machine or port, edit `agent/sajha_client.py`:

```python
SAJHA_BASE = "http://localhost:3002"   # <-- change this
SAJHA_USER = "admin"                    # <-- change if needed
SAJHA_PASS = "admin123"                 # <-- change if needed
```

### Changing the LLM Model

Edit `agent/graph.py`:

**For Ollama:**
```python
llm = ChatOllama(
    model="qwen2.5:7b",   # <-- change to any Ollama model
    temperature=0,
    num_ctx=4096,
)
```

**For llama.cpp:**
```python
llm = ChatOpenAI(
    base_url="http://localhost:8080/v1",   # <-- llama-server address
    api_key="not-needed",
    model="qwen2.5-7b",
    temperature=0,
    max_tokens=2048,
)
```

---

## Troubleshooting

### Server starts and shuts down immediately
Run it manually to see the error:
```cmd
.venv\Scripts\activate
set LLM_BACKEND=llamacpp
python -m uvicorn agent.server:app --host 0.0.0.0 --port 8000
```

Common causes:
- llama-server not running on port 8080 (start it first)
- SAJHA MCP Server not running on port 3002
- Missing Python packages (run `pip install -r requirements.txt`)

### "Connection refused" on port 8000
The agent server isn't running. Run `start-llamacpp.bat` or `start.bat`.

### "Connection refused" on port 8080
llama-server isn't running. Start it first:
```cmd
llama-server.exe -m models\Qwen2.5-7B-Instruct-Q4_K_M.gguf -c 4096 -ngl 99 --port 8080
```

### "Connection refused" on port 3002
SAJHA MCP Server isn't running. Start it first.

### "Model not found" error (Ollama mode)
```cmd
ollama pull qwen2.5:7b
```

### Model file not found (llama.cpp mode)
Run the assemble script first:
```cmd
assemble.bat
```

### Agent is very slow
This is normal for a 7B model on CPU. First response takes 30-60 seconds. If you have a GPU, both llama.cpp and Ollama will use it automatically.

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
|   |-- graph.py             # LangGraph ReAct agent (supports llama.cpp + Ollama)
|   |-- tools.py             # Tavily tool definitions
|   |-- sajha_client.py      # HTTP client for SAJHA MCP Server
|   |-- server.py            # FastAPI web server
|   |-- static/
|       |-- index.html       # Chat UI (Market Risk AI Tool)
|
|-- models/
|   |-- chunks/              # 48 x 95MB model chunks
|   |-- Qwen2.5-7B-Instruct-Q4_K_M.gguf  # Assembled model (after assemble script)
|
|-- requirements.txt             # Python dependencies
|-- setup.bat / setup.sh         # One-click setup (Ollama mode)
|-- start.bat / start.sh         # Start agent (Ollama mode)
|-- start-llamacpp.bat / .sh     # Start agent (llama.cpp mode)
|-- assemble.bat / assemble.sh   # Model assembly scripts
|-- Modelfile                    # Ollama model import config
|-- README.md                    # This file
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
