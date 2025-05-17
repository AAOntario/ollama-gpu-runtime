#!/bin/bash
set -e

# ---------------------------------------------------------------------------- #
#                               Pre-Start Routines                             #
# ---------------------------------------------------------------------------- #
start_nginx
execute_script "/pre_start.sh" "Running pre-start script..."
setup_ssh
export_env_vars

echo "Pod Started. Mode: ${SERVICE_MODE:-ollama}"

# ---------------------------------------------------------------------------- #
#                               Dynamic Runtime Logic                          #
# ---------------------------------------------------------------------------- #
case "${SERVICE_MODE}" in
  jupyter)
    echo "Starting Jupyter Notebook Server..."
    start_jupyter
    ;;

  webui)
    echo "Starting Pre-Baked Open WebUI..."
    cd /opt/open-webui
    python3 app.py
    echo "Open WebUI started successfully"
    ;;

  ollama | *)
    echo "Starting Ollama Runner..."
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

    /usr/local/bin/ollama runner --ollama-engine --model "$SELECTED_MODEL" --ctx-size 8192 --batch-size 512 --n-gpu-layers 49 --threads 112 --parallel 2 --port 11434
    ;;
esac

# ---------------------------------------------------------------------------- #
#                               Post-Start Routines                            #
# ---------------------------------------------------------------------------- #
execute_script "/post_start.sh" "Running post-start script..."

# Prevent container from exiting
sleep infinity
