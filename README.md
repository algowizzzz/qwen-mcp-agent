# qwen-mcp-agent

A quantized LLM for local MCP ReAct agent testing. Contains **Qwen2.5-7B-Instruct** in Q4_K_M GGUF format (~4.4GB).

The model is split into 95MB chunks (no Git LFS required). After cloning, run the assemble script to combine them.

## Setup

### 1. Clone the repo

```bash
git clone https://github.com/algowizzzz/qwen-mcp-agent.git
cd qwen-mcp-agent
```

### 2. Assemble the model

**Mac / Linux:**
```bash
chmod +x assemble.sh
./assemble.sh
```

**Windows:**
```cmd
assemble.bat
```

This combines the 48 chunks in `models/chunks/` into the full model at `models/Qwen2.5-7B-Instruct-Q4_K_M.gguf`.

## Run with Ollama

```bash
# Import into Ollama
ollama create qwen7b -f Modelfile

# Run it
ollama run qwen7b "Hello, what can you do?"
```

## Run with llama.cpp

```bash
llama-cli -m models/Qwen2.5-7B-Instruct-Q4_K_M.gguf \
  -p "You are a helpful assistant." \
  --interactive \
  -c 4096 \
  -ngl 99
```

## System requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| RAM | 8 GB | 16 GB |
| Disk | 10 GB free | 14 GB free |
| GPU | Not required | Any Metal/CUDA GPU speeds up inference |

## Model details

| Property | Value |
|----------|-------|
| Base model | Qwen2.5-7B-Instruct |
| Quantization | Q4_K_M (4-bit, medium) |
| File size | ~4.4 GB (split into 48 chunks of ~95MB) |
| Context window | 32K tokens (default), 4K configured for agents |
| Source | [bartowski/Qwen2.5-7B-Instruct-GGUF](https://huggingface.co/bartowski/Qwen2.5-7B-Instruct-GGUF) |
| License | Apache 2.0 |
