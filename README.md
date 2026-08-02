# 015 · 夜间人车检测模型训练项目

一个面向夜间道路场景的目标检测训练项目。项目以 YOLO26m-P2 为基础，针对低照度、目标较小、遮挡较多的画面整理了 `person` 和 `car` 两类数据，并提供数据集、模型结构、训练配置、权重与可复现脚本。

## 项目定位

本项目解决的是“夜间画面里哪里有人、哪里有车”的目标检测问题，重点放在模型训练和实验复现，不包含车牌文字识别、车辆属性识别或交通违法判定。

## 已包含内容

| 模块 | 内容 |
| --- | --- |
| 数据集 | 3000 张夜间图片，按 train/val/test 划分为 2400/300/300 |
| 类别 | `person`、`car` |
| 标注 | YOLO 检测格式，合计 3520 个行人框、26099 个车辆框 |
| 模型 | YOLO26m-P2 人车检测结构；另含轻量 CBAM 夜间增强结构 |
| 权重 | `yolo26m.pt` 基础权重、`weights/base_best.pt` 迁移学习候选权重 |
| 训练入口 | `scripts/train.py` |
| 训练策略 | 通用夜间适配阶段 + 高分辨率精修阶段 |

## 目录结构

```text
015-yolocar-night-person-car/
├─ configs/
│  ├─ datasets/              数据集配置
│  ├─ models/                YOLO26m-P2 与 CBAM 模型结构
│  └─ train_*.yaml           训练超参数
├─ datasets/night_person_car_3k/
│  ├─ images/{train,val,test}
│  └─ labels/{train,val,test}
├─ scripts/
│  ├─ train.py               通用训练入口
│  ├─ train_night_best_8gpu.sh
│  └─ train_local_night_stage*.ps1
├─ weights/base_best.pt      已整理的候选初始化权重
├─ yolo26m.pt                YOLO26m 基础权重
├─ DATASET_SUMMARY.txt
└─ requirements.txt
```

## 环境准备

建议使用 Python 3.10 或更高版本，并准备可用的 NVIDIA CUDA/PyTorch 环境。安装 Python 依赖：

```bash
python -m pip install -r requirements.txt
```

训练前可先确认 GPU：

```bash
python -c "import torch; print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'CPU')"
```

## 快速开始

### 单卡或本地调试

使用仓库内的候选权重进行夜间适配：

```powershell
python scripts/train.py `
  --model configs/models/yolo26m-personcar-p2.yaml `
  --weights weights/base_best.pt `
  --data configs/datasets/night_person_car_3k.yaml `
  --cfg configs/train_local_4060_night_stage1_continue.yaml `
  --device 0 `
  --project runs_local `
  --name night4060_stage1_continue
```

完成第一阶段后，可使用 CBAM 结构继续精修：

```powershell
python scripts/train.py `
  --model configs/models/yolo26m-personcar-p2-cbam.yaml `
  --weights runs_local/night4060_stage1_continue/weights/best.pt `
  --data configs/datasets/night_person_car_3k.yaml `
  --cfg configs/train_local_4060_night_stage2_cbam.yaml `
  --device 0 `
  --project runs_local `
  --name night4060_stage2_cbam
```

### 多卡训练

在 Linux 服务器上执行：

```bash
bash scripts/bootstrap_night_8gpu.sh
```

默认脚本使用共享服务器安全配置：限制数据加载线程、关闭数据缓存，并将训练分为两个阶段。如果机器没有其他业务服务，可按需使用：

```bash
PROFILE=dedicated bash scripts/train_night_best_8gpu.sh
```

训练结果默认写入：

```text
runs/night3k_stage1/
runs/night3k_stage2/
```

## 设计思路

1. 保留 P2 检测头，提高小目标和远距离目标的可见性。
2. 先用夜间三千图数据完成领域适配，再用更高输入分辨率进行精修。
3. CBAM 只放在关键检测路径，控制额外计算量，同时增强低对比度目标的特征选择。
4. 训练脚本默认限制 CPU 线程和数据缓存，适合与其他服务共用 GPU 服务器。

## 数据说明

数据集只保留两类目标：`pedestrian` 映射为 `person`，`car` 保持为 `car`。每张图片对应 YOLO 格式标签，具体数量见 [DATASET_SUMMARY.txt](DATASET_SUMMARY.txt)。如将数据集用于公开分发或商业用途，请按原始数据来源的许可要求执行。

## 结果与后续方向

当前仓库提供可复现的训练基线和夜间增强实验路线。后续可以在同一测试集上统一比较基础模型、夜间迁移模型和 CBAM 精修模型，并补充 mAP、Recall、Precision、推理速度及可视化结果。

## English summary

This repository contains a reproducible YOLO26m-P2 training project for night-time person and car detection. It includes a 3,000-image YOLO-format dataset, model definitions, training configurations, initialization weights, and scripts for single-GPU and multi-GPU training. The two-stage pipeline first adapts the detector to the night domain and then applies a lightweight CBAM refinement stage for low-contrast targets.

The project focuses on object detection only. License-plate OCR, vehicle attributes, and traffic-rule analysis are outside this repository's scope.

## License and attribution

The source code in this repository is organized for research, learning, and reproducible engineering practice. Check the upstream licenses of Ultralytics, PyTorch, and the original dataset before redistribution.
