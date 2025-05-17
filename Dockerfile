# Start with NVIDIA CUDA 12.2 Runtime on Ubuntu 22.04
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

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

