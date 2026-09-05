"""Configuration objects for WEPP batch simulations."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml


@dataclass(frozen=True)
class WeppConfig:
    """Paths and fixed model settings used by a WEPP batch experiment."""

    wepp_executable: Path
    management_dir: Path
    climate_dir: Path
    output_dir: Path
    slope_file: Path
    soil_file: Path
    years: int = 100

    @classmethod
    def from_mapping(cls, data: dict[str, Any]) -> "WeppConfig":
        return cls(
            wepp_executable=Path(data["wepp_executable"]).expanduser(),
            management_dir=Path(data["management_dir"]).expanduser(),
            climate_dir=Path(data["climate_dir"]).expanduser(),
            output_dir=Path(data["output_dir"]).expanduser(),
            slope_file=Path(data["slope_file"]).expanduser(),
            soil_file=Path(data["soil_file"]).expanduser(),
            years=int(data.get("years", 100)),
        )


def load_config(path: str | Path) -> WeppConfig:
    """Load one YAML configuration file."""
    config_path = Path(path)
    with config_path.open("r", encoding="utf-8") as handle:
        data = yaml.safe_load(handle)
    if not isinstance(data, dict):
        raise ValueError("Configuration must be a YAML mapping.")
    return WeppConfig.from_mapping(data)
