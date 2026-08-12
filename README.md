# 015 夜间人车检测 / Night Person and Car Detection

> 面向低照度场景微调人/车检测模型，提供训练、评估、独立测试和批量推理流程。
>
> **English:** A low-light person/car detection workflow with domain fine-tuning, evaluation, independent testing, and batch inference.

## 解决什么问题 / Problem

通用目标检测模型在夜间、低照度和小目标场景下容易漏检，直接部署难以复现效果。

**English:** General detectors can miss people and vehicles at night or at small scale, while direct deployment is hard to reproduce.

## 项目展示 / Demo

![夜间测试样本 / Night test sample](datasets/night_person_car_3k/images/test/00cee0e0-5e25daa7_jpg.rf.a52bc2eff09a18dd60d763beaff6cfd7.jpg)

对夜间图片执行推理，查看人/车检测框和置信度。

数据、权重、评估和批量推理脚本放在同一套可追溯目录中。

**English:** Data, weights, evaluation, and batch-inference scripts live in one traceable project layout.

## 高光亮点 / Highlights

- YOLO26m-P2 夜间领域微调。
  **English:** YOLO26m-P2 fine-tuned for night scenes.
- 约 3000 张夜间标注图。
  **English:** About 3,000 labeled night images.
- 训练、评估、独立测试和批量推理。
  **English:** Training, evaluation, independent testing, and batch inference.
- 支持 GPU/CPU 推理及 Windows 工具构建。
  **English:** Supports GPU/CPU inference and Windows tooling.

## 技术名词 / Tech

`Python · Ultralytics YOLO · PyTorch · OpenCV · CUDA/CPU`

## 从 ZIP 开始复现 / Reproduce from ZIP

1. 解压 ZIP，创建虚拟环境并安装 `requirements.txt`。
2. 先执行 `python -c "import torch; print(torch.cuda.is_available())"` 检查训练 GPU。
3. 按 `README_LOCAL_QUICKSTART` 运行测试或训练命令。
4. 先用仓库测试图片做推理，再评估自己的夜间数据。

**Expected result:** 完成上述步骤后，应能看到项目的页面、窗口、设备输出或测试结果。

**Expected result:** After these steps, you should see the project's page, window, device output, or test result.

## 范围与安全 / Scope and Safety

训练需要 GPU；公开仓库中的数据和权重只代表当前实验范围，不等于所有夜间道路都能达到相同效果。

**English:** Training requires a GPU; the included data and weights represent this experiment and do not guarantee the same result for every night road scene.

## 交流 / Contact

欢迎交流技术。

Open to technical exchange.

[English full version](README.en.md)
