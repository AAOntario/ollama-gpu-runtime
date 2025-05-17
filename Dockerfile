# Start with RunPod's latest CUDA + PyTorch image (Torch 2.7.2, CUDA 12.8)
FROM runpod/pytorch:2.7.2-cuda12.8.0-runtime

# Install utilities
RUN apt-get update && apt-get install -y curl

# Copy Ollama binary
COPY ollama /usr/local/bin/ollama
RUN chmod +x /usr/local/bin/ollama

# Copy your wrapped start.sh script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Environment variable for model discovery (optional, can also be set at runtime)
ENV OLLAMA_MODELS=/workspace/models

# Set your wrapped start script as the container's entrypoint
ENTRYPOINT ["/start.sh"]
