#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export NUMEXPR_NUM_THREADS=1
export MALLOC_ARENA_MAX=2
export NCCL_ASYNC_ERROR_HANDLING=1
export TORCH_NCCL_BLOCKING_WAIT=1
export PYTORCH_CUDA_ALLOC_CONF="${PYTORCH_CUDA_ALLOC_CONF:-expandable_segments:True}"
export CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES:-0,1,2,3,4,5,6,7}"

DATA_CFG="configs/datasets/night_person_car_3k.yaml"
MODEL_CFG="configs/models/yolo26m-personcar-p2.yaml"
WEIGHTS="yolo26m.pt"

# shared: protect colocated web services
# dedicated: higher throughput when the machine is only for training
PROFILE="${PROFILE:-shared}"

case "$PROFILE" in
  dedicated)
    STAGE1_BATCH="${STAGE1_BATCH:-64}"
    STAGE1_IMGSZ="${STAGE1_IMGSZ:-640}"
    STAGE1_WORKERS="${STAGE1_WORKERS:-2}"
    STAGE2_BATCH="${STAGE2_BATCH:-40}"
    STAGE2_IMGSZ="${STAGE2_IMGSZ:-768}"
    STAGE2_WORKERS="${STAGE2_WORKERS:-2}"
    ;;
  shared|*)
    STAGE1_BATCH="${STAGE1_BATCH:-48}"
    STAGE1_IMGSZ="${STAGE1_IMGSZ:-640}"
    STAGE1_WORKERS="${STAGE1_WORKERS:-1}"
    STAGE2_BATCH="${STAGE2_BATCH:-32}"
    STAGE2_IMGSZ="${STAGE2_IMGSZ:-768}"
    STAGE2_WORKERS="${STAGE2_WORKERS:-1}"
    ;;
esac

echo "PROFILE=${PROFILE}"
echo "DATA_CFG=${DATA_CFG}"
echo "STAGE1 batch=${STAGE1_BATCH} imgsz=${STAGE1_IMGSZ} workers=${STAGE1_WORKERS}"
echo "STAGE2 batch=${STAGE2_BATCH} imgsz=${STAGE2_IMGSZ} workers=${STAGE2_WORKERS}"

python scripts/train.py \
  --model "$MODEL_CFG" \
  --weights "$WEIGHTS" \
  --data "$DATA_CFG" \
  --cfg configs/train_night_stage1_8gpu.yaml \
  --device 0,1,2,3,4,5,6,7 \
  --batch "$STAGE1_BATCH" \
  --imgsz "$STAGE1_IMGSZ" \
  --workers "$STAGE1_WORKERS" \
  --project runs \
  --name night3k_stage1

python scripts/train.py \
  --model "runs/night3k_stage1/weights/best.pt" \
  --weights "" \
  --data "$DATA_CFG" \
  --cfg configs/train_night_stage2_8gpu.yaml \
  --device 0,1,2,3,4,5,6,7 \
  --batch "$STAGE2_BATCH" \
  --imgsz "$STAGE2_IMGSZ" \
  --workers "$STAGE2_WORKERS" \
  --project runs \
  --name night3k_stage2
