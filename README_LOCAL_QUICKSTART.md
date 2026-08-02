# 本地训练快捷说明

这份说明用于在本地 GPU 机器上快速复现实验。请先在项目根目录执行：

```powershell
python -m pip install -r requirements.txt
```

## 阶段一：夜间领域适配

默认使用仓库内的 `weights/base_best.pt` 作为初始化权重：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\train_local_night_stage1_continue.ps1
```

如果要使用其他权重，可以显式传入路径：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\train_local_night_stage1_continue.ps1 `
  -BestWeights .\yolo26m.pt
```

输出目录：

```text
runs_local/night4060_stage1_continue
```

## 阶段二：CBAM 精修

阶段一完成并生成 `best.pt` 后执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\train_local_night_stage2_cbam.ps1
```

也可以显式指定阶段一权重：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\train_local_night_stage2_cbam.ps1 `
  -Stage1Best .\runs_local\night4060_stage1_continue\weights\best.pt
```

输出目录：

```text
runs_local/night4060_stage2_cbam
```

## 运行前检查

- PowerShell 中的 `python` 应指向已安装 PyTorch 和 Ultralytics 的环境。
- 训练前确认 `torch.cuda.is_available()` 为 `True`。
- 训练数据路径由仓库内相对配置解析，不依赖某一台电脑的盘符。
