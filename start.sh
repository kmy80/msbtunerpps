#!/usr/bin/env bash
set -e

export PATH="/opt/conda/bin:${PATH}"
export HF_HUB_ENABLE_HF_TRANSFER=1
export PYTHONUNBUFFERED=1

echo "=========================================="
echo " Musubi Tuner - Paperspace"
echo "=========================================="

echo
echo "[GPU]"
nvidia-smi || true

echo
echo "[Python / PyTorch]"
python - <<'PY'
import sys
import torch

print("Python :", sys.version.split()[0])
print("PyTorch:", torch.__version__)
print("CUDA   :", torch.version.cuda)
print("CUDA available:", torch.cuda.is_available())

if torch.cuda.is_available():
    print("GPU    :", torch.cuda.get_device_name(0))
    print(
        "VRAM   :",
        round(torch.cuda.get_device_properties(0).total_memory / 1024**3, 1),
        "GB",
    )
PY

mkdir -p /notebooks

echo
echo "JupyterLab starting on 0.0.0.0:${JUPYTER_PORT:-8888}"

exec jupyter lab \
    --allow-root \
    --ip=0.0.0.0 \
    --port="${JUPYTER_PORT:-8888}" \
    --no-browser \
    --ServerApp.token="" \
    --ServerApp.password="" \
    --ServerApp.allow_origin="*" \
    --ServerApp.root_dir="/notebooks"
