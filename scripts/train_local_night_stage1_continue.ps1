param(
    [string]$BestWeights = "",
    [string]$Python = "python"
)

$ErrorActionPreference = "Stop"
$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo

if ([string]::IsNullOrWhiteSpace($BestWeights)) {
    $BestWeights = Join-Path $repo "weights\base_best.pt"
}
$pythonCommand = Get-Command $Python -ErrorAction SilentlyContinue
if (!$pythonCommand) {
    throw "Python command not found: $Python"
}
$bestWeightsPath = Resolve-Path -LiteralPath $BestWeights -ErrorAction SilentlyContinue
if (!$bestWeightsPath) {
    throw "Best weights not found: $BestWeights"
}

& $pythonCommand.Source scripts/train.py `
  --model "configs/models/yolo26m-personcar-p2.yaml" `
  --weights $bestWeightsPath.Path `
  --data "configs/datasets/night_person_car_3k.yaml" `
  --cfg "configs/train_local_4060_night_stage1_continue.yaml" `
  --device "0" `
  --project "runs_local" `
  --name "night4060_stage1_continue"
