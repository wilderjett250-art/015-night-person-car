param(
    [string]$Stage1Best = "runs_local/night4060_stage1_continue/weights/best.pt",
    [string]$Python = "python"
)

$ErrorActionPreference = "Stop"
$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo

$pythonCommand = Get-Command $Python -ErrorAction SilentlyContinue
if (!$pythonCommand) {
    throw "Python command not found: $Python"
}
$stage1BestPath = Resolve-Path -LiteralPath $Stage1Best -ErrorAction SilentlyContinue
if (!$stage1BestPath) {
    throw "Stage1 best not found: $Stage1Best"
}

& $pythonCommand.Source scripts/train.py `
  --model "configs/models/yolo26m-personcar-p2-cbam.yaml" `
  --weights $stage1BestPath.Path `
  --data "configs/datasets/night_person_car_3k.yaml" `
  --cfg "configs/train_local_4060_night_stage2_cbam.yaml" `
  --device "0" `
  --project "runs_local" `
  --name "night4060_stage2_cbam"
