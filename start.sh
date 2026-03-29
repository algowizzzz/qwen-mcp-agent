#!/bin/bash
echo ""
echo "============================================================"
echo "  Market Risk AI Tool - Ollama Mode"
echo "============================================================"
echo ""
echo "  Open your browser at: http://localhost:8000"
echo "  Press Ctrl+C to stop."
echo ""
export LLM_BACKEND=ollama
source .venv/bin/activate
python -m uvicorn agent.server:app --host 0.0.0.0 --port 8000
