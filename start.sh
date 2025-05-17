#!/bin/bash
set -e

# (Keep all the original functions as-is)

# ---------------------------------------------------------------------------- #
#                               Main Program                                   #
# ---------------------------------------------------------------------------- #

start_nginx
execute_script "/pre_start.sh" "Running pre-start script..."

echo "Pod Started"

setup_ssh
start_jupyter
export_env_vars
execute_script "/post_start.sh" "Running post-start script..."

# ✅ Start Ollama with dynamic model detection (your logic here)
MODEL_DIR="/workspace/models/blobs"

if [ -n "$OLLAMA_MODEL_BLOB" ]; then
    SELECTED_MODEL="$MODEL_DIR/$OLLAMA_MODEL_BLOB"
    echo "Using model specified by OLLAMA_MODEL_BLOB: $SELECTED_MODEL"
else
    SELECTED_MODEL=$(find "$MODEL_DIR" -type f | head -n 1)
    if [ -z "$SELECTED_MODEL" ]; then
        echo "Error: No models found in $MODEL_DIR"
        exit 1
    fi
    echo "Auto-selected model: $SELECTED_MODEL"
fi

echo "Launching Ollama Runner..."
/usr/local/bin/ollama runner --ollama-engine --model "$SELECTED_MODEL" --ctx-size 8192 --batch-size 512 --n-gpu-layers 49 --threads 112 --parallel 2 --port 45889

# Prevent container from exiting
sleep infinity
