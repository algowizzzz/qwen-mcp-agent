# qwen-mcp-agent

A small, quantized LLM for local MCP ReAct agent testing. Contains **Qwen2.5-3B-Instruct** in Q4_K_M GGUF format (~1.8GB), stored via Git LFS.

## Clone & pull the model

```bash
# Make sure git-lfs is installed
git lfs install

# Clone (this will automatically pull the LFS files)
git clone https://github.com/saadahmed/qwen-mcp-agent.git
cd qwen-mcp-agent

# If the .gguf file shows as a pointer, pull it manually:
git lfs pull
```

## Run with Ollama

```bash
# Create a Modelfile
cat > Modelfile <<EOF
FROM ./models/Qwen2.5-3B-Instruct-Q4_K_M.gguf
PARAMETER temperature 0
PARAMETER num_ctx 4096
EOF

# Import into Ollama
ollama create qwen3b -f Modelfile

# Run it
ollama run qwen3b "Hello, what can you do?"
```

## Run with llama.cpp

```bash
# If you have llama.cpp installed:
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
| Disk | 2 GB free | 4 GB free |
| GPU | Not required | Any Metal/CUDA GPU speeds up inference |

The Q4_K_M quantization runs fine on CPU-only machines — expect ~5-10 tokens/sec on Apple Silicon without GPU offload, ~20-30 tokens/sec with Metal.

## Model details

| Property | Value |
|----------|-------|
| Base model | Qwen2.5-3B-Instruct |
| Quantization | Q4_K_M (4-bit, medium) |
| File size | ~1.8 GB |
| Context window | 32K tokens (default), 4K recommended for agents |
| Source | [bartowski/Qwen2.5-3B-Instruct-GGUF](https://huggingface.co/bartowski/Qwen2.5-3B-Instruct-GGUF) |
| License | Apache 2.0 |
