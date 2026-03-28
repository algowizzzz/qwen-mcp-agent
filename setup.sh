#!/bin/bash
# ============================================================
# Market Risk AI Tool - Mac/Linux Setup Script
# ============================================================
echo ""
echo "============================================================"
echo "  Market Risk AI Tool - Setup"
echo "============================================================"
echo ""

# Step 1: Check Python
echo "[1/5] Checking Python..."
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python3 is not installed."
    echo "Install with: brew install python3 (Mac) or apt install python3 (Linux)"
    exit 1
fi
python3 --version
echo ""

# Step 2: Check Ollama
echo "[2/5] Checking Ollama..."
if ! command -v ollama &> /dev/null; then
    echo "ERROR: Ollama is not installed."
    echo "Install from: https://ollama.com"
    exit 1
fi
ollama --version
echo ""

# Step 3: Create virtual environment
echo "[3/5] Creating Python virtual environment..."
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    echo "Created .venv"
else
    echo ".venv already exists, skipping"
fi
echo ""

# Step 4: Install dependencies
echo "[4/5] Installing Python dependencies..."
source .venv/bin/activate
pip install -r requirements.txt
echo ""

# Step 5: Pull Qwen model
echo "[5/5] Pulling Qwen 2.5 7B model from Ollama registry..."
echo "(This downloads ~4.4GB - may take a while)"
ollama pull qwen2.5:7b
echo ""

echo "============================================================"
echo "  Setup complete!"
echo "============================================================"
echo ""
echo "  To start the agent:"
echo "    1. Make sure SAJHA MCP Server is running on port 3002"
echo "    2. Run:  ./start.sh"
echo ""
