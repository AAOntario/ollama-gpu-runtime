# Ollama GPU Runtime for RunPod

## Overview

This repository contains a clean, CUDA-12 compatible Docker runtime for deploying [Ollama](https://ollama.com) on [RunPod.io](https://runpod.io), specifically designed for high-performance environments like NVIDIA H100 GPUs.

It optionally pairs with [Open WebUI](https://github.com/open-webui/open-webui) for a web-based chat interface.

## Features

- ✅ CUDA 12.2 Runtime (Ubuntu 22.04)
- ✅ Preinstalled Ollama Runtime
- ✅ GPU-Accelerated Model Serving
- ✅ Optional Open WebUI Support (via Docker Compose)
- ✅ Ready for RunPod Custom Image Deployment

## Usage

### 1. **Local Build**

```bash
docker build -t custom-ollama-runtime .
