#!/bin/bash
# Reassemble the model from chunks
# Usage: ./assemble.sh

set -e

OUTPUT="models/Qwen2.5-3B-Instruct-Q4_K_M.gguf"
CHUNKS_DIR="models/chunks"

if [ -f "$OUTPUT" ]; then
    echo "Model already assembled at $OUTPUT"
    exit 0
fi

echo "Assembling model from chunks..."
cat "$CHUNKS_DIR"/model_part_* > "$OUTPUT"

# Verify size (~1.9GB)
SIZE=$(wc -c < "$OUTPUT" | tr -d ' ')
if [ "$SIZE" -lt 1900000000 ]; then
    echo "ERROR: Assembled file is too small ($SIZE bytes). Something went wrong."
    rm -f "$OUTPUT"
    exit 1
fi

echo "Done! Model assembled at $OUTPUT ($SIZE bytes)"
echo ""
echo "To run with Ollama:"
echo "  ollama create qwen3b -f Modelfile"
echo "  ollama run qwen3b"
