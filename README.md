# 015 夜间人车检测 | Night Person/Car

> 针对夜间画面训练和复现 person/car 检测模型，并提供批量推理工具。
>
> **English:** A practical, runnable project with a documented workflow for the problem described above.

## 项目展示 / Demo

![夜间测试样本](datasets/night_person_car_3k/images/test/00cee0e0-5e25daa7_jpg.rf.a52bc2eff09a18dd60d763beaff6cfd7.jpg)

## 解决什么问题 / Problem

解决通用目标检测模型在夜间、低照度和小目标场景下漏检较多的问题。

**English:** This project addresses the problem above with a reproducible local workflow.

## 有什么用 / Use

使用夜间标注数据训练、评估和推理，输出人/车检测框及可视化结果。

**English:** Run the workflow locally, inspect the output, and extend the project from the provided source.

## 高光亮点 / Highlights

- YOLO26m-P2 夜间领域微调
- 约 3000 张标注图
- 训练、评估、独立测试和批量推理
- 支持 GPU/CPU 及 Windows 工具构建

## 技术名词 / Tech

`Python · Ultralytics YOLO · PyTorch · OpenCV · CUDA/CPU`

## 从 ZIP 开始复现 / Reproduce from ZIP

1. 下载 ZIP 并解压。
2. 创建虚拟环境并安装 requirements.txt。
3. 先运行 python -c "import torch; print(torch.cuda.is_available())" 检查训练 GPU。
4. 按 README_LOCAL_QUICKSTART 执行训练或测试命令。
5. 使用推理入口处理 datasets/night_person_car_3k/images/test 中的样本。

**Expected result:** 测试后得到 person/car 标注结果和评估指标；训练权重、数据集和配置按仓库说明管理。

## 目录提示 / Notes

- 先阅读本 README，再按项目内更详细的中文/英文文档补充配置。
- 不要把真实密码、Token、数据库业务数据和本机运行结果提交回仓库。
- 下载 ZIP 后的第一次运行应使用测试数据或示例图片，确认链路正常后再接入自己的环境。

[English documentation](README.en.md)
