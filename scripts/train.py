import argparse
from pathlib import Path
from typing import Optional

import yaml
from ultralytics import YOLO

PROJECT_ROOT = Path(__file__).resolve().parents[1]


def load_cfg(cfg_path: Optional[str]) -> dict:
    if not cfg_path:
        return {}
    cfg_file = resolve_path(cfg_path)
    with open(cfg_file, "r", encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


def resolve_path(path_str: str) -> Path:
    path = Path(path_str)
    if path.is_absolute():
        return path
    cwd_candidate = Path.cwd() / path
    if cwd_candidate.exists():
        return cwd_candidate
    project_candidate = PROJECT_ROOT / path
    return project_candidate


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", default="configs/models/yolo26m-personcar-p2.yaml")
    parser.add_argument("--weights", default="yolo26m.pt")
    parser.add_argument("--data", default="configs/datasets/night_person_car_3k.yaml")
    parser.add_argument("--cfg", default="configs/train_night_stage1_8gpu.yaml")
    parser.add_argument("--device", default="0")
    parser.add_argument("--batch", type=int, default=None)
    parser.add_argument("--imgsz", type=int, default=None)
    parser.add_argument("--epochs", type=int, default=None)
    parser.add_argument("--workers", type=int, default=None)
    parser.add_argument("--project", default="runs_local")
    parser.add_argument("--name", default="night3k_stage1")
    parser.add_argument("--resume", action="store_true")
    args = parser.parse_args()

    train_cfg = load_cfg(args.cfg)
    train_cfg["data"] = str(resolve_path(args.data))
    train_cfg["device"] = args.device
    train_cfg["project"] = args.project
    train_cfg["name"] = args.name
    train_cfg["exist_ok"] = True
    train_cfg["resume"] = args.resume

    if args.batch is not None:
        train_cfg["batch"] = args.batch
    if args.imgsz is not None:
        train_cfg["imgsz"] = args.imgsz
    if args.epochs is not None:
        train_cfg["epochs"] = args.epochs
    if args.workers is not None:
        train_cfg["workers"] = args.workers

    model_path = resolve_path(args.model)
    weights_path = resolve_path(args.weights) if args.weights else None

    if model_path.suffix == ".pt":
        model = YOLO(str(model_path))
    else:
        model = YOLO(str(model_path))
        if weights_path:
            model = model.load(str(weights_path))

    model.train(**train_cfg)


if __name__ == "__main__":
    main()
