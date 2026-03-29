#!/bin/bash
echo ""
echo "============================================================"
echo "  Market Risk AI Tool - llama.cpp Mode"
echo "============================================================"
echo ""

# Check model exists
if [ ! -f "models/Qwen2.5-7B-Instruct-Q4_K_M.gguf" ]; then
    echo "ERROR: Model file not found! Run ./assemble.sh first."
    exit 1
fi

# Start llama-server in background
echo "Starting llama-server on port 8080..."
llama-server -m models/Qwen2.5-7B-Instruct-Q4_K_M.gguf -c 4096 -ngl 99 --port 8080 &
LLAMA_PID=$!

echo "Waiting 10 seconds for model to load..."
sleep 10

# Start the agent
echo "Starting Market Risk AI Tool on port 8000..."
echo "Open: http://localhost:8000"
echo ""
export LLM_BACKEND=llamacpp
source .venv/bin/activate
python -m uvicorn agent.server:app --host 0.0.0.0 --port 8000

# Cleanup
kill $LLAMA_PID 2>/dev/null
