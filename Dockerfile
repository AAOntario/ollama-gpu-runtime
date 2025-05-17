# Start with NVIDIA CUDA 12.2 Runtime on Ubuntu 22.04
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

# Install utilities
RUN apt-get update && apt-get install -y curl

# Dynamically install Ollama at build time
RUN curl -fsSL https://ollama.com/install.sh | sh

# Copy your wrapped start.sh script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Environment variable for model discovery
ENV OLLAMA_MODELS=/workspace/models

# Set your wrapped start script as the container's entrypoint
ENTRYPOINT ["/start.sh"]
