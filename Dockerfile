FROM pytorch/pytorch:2.11.0-cuda12.8-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV JUPYTER_PORT=8888
ENV PATH="/opt/conda/bin:/root/.local/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    git-lfs \
    curl \
    wget \
    aria2 \
    nano \
    unzip \
    build-essential \
    pkg-config \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install

# uvはpip経由ではなく、公式の単体バイナリをコピー
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Jupyterだけをコンテナ内の既存Pythonへ導入
RUN python -m pip install \
    --break-system-packages \
    --no-cache-dir \
    jupyterlab \
    ipykernel \
    ipywidgets

COPY start.sh /usr/local/bin/start-musubi

RUN chmod +x /usr/local/bin/start-musubi \
    && mkdir -p /notebooks

WORKDIR /notebooks

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/start-musubi"]
