FROM pytorch/pytorch:2.11.0-cuda12.8-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV JUPYTER_PORT=8888
ENV PATH="/opt/conda/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    git-lfs \
    curl \
    wget \
    aria2 \
    nano \
    vim \
    unzip \
    zip \
    rsync \
    build-essential \
    pkg-config \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git lfs install

RUN python -m pip install --no-cache-dir --upgrade \
    pip \
    setuptools \
    wheel

RUN python -m pip install --no-cache-dir \
    jupyterlab \
    ipykernel \
    ipywidgets \
    tensorboard \
    huggingface_hub \
    uv

COPY start.sh /usr/local/bin/start-musubi

RUN chmod +x /usr/local/bin/start-musubi \
    && mkdir -p /notebooks \
    && mkdir -p /root/.cache/huggingface

WORKDIR /notebooks

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/start-musubi"]
