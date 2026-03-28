# qwen-mcp-agent

A small, quantized LLM for local MCP ReAct agent testing. Contains **Qwen2.5-3B-Instruct** in Q4_K_M GGUF format (~1.8GB).

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

This combines the 20 chunks in `models/chunks/` into the full model at `models/Qwen2.5-3B-Instruct-Q4_K_M.gguf`.

## Run with Ollama

```bash
# Import into Ollama
ollama create qwen3b -f Modelfile

# Run it
ollama run qwen3b "Hello, what can you do?"
```

## Run with llama.cpp

```bash
llama-cli -m models/Qwen2.5-3B-Instruct-Q4_K_M.gguf \
  -p "You are a helpful assistant." \
  --interactive \
  -c 4096 \
  -ngl 99
```

## System requirements

| Resource | Minimum | Recommended |
|----------|---------|-------------|
| RAM | 8 GB | 16 GB |
| Disk | 4 GB free | 6 GB free |
| GPU | Not required | Any Metal/CUDA GPU speeds up inference |

The Q4_K_M quantization runs fine on CPU-only machines — expect ~5-10 tokens/sec on Apple Silicon without GPU offload, ~20-30 tokens/sec with Metal.

## Model details

| Property | Value |
|----------|-------|
| Base model | Qwen2.5-3B-Instruct |
| Quantization | Q4_K_M (4-bit, medium) |
| File size | ~1.8 GB (split into 20 chunks of ~95MB) |
| Context window | 32K tokens (default), 4K recommended for agents |
| Source | [bartowski/Qwen2.5-3B-Instruct-GGUF](https://huggingface.co/bartowski/Qwen2.5-3B-Instruct-GGUF) |
| License | Apache 2.0 |
