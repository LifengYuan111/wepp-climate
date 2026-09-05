"""Portable WEPP batch runner reconstructed from historical research code.

Scientific intent is preserved from the historical PyLink_WEPP.py workflow:
iterate over management × climate combinations, provide WEPP's interactive
input sequence, and request water-balance, event, summary, and crop-yield
outputs. Historical hard-coded machine paths are intentionally removed.
"""

from __future__ import annotations

from dataclasses import dataclass
import logging
from pathlib import Path
import subprocess
from typing import Iterable

from .config import WeppConfig

LOGGER = logging.getLogger(__name__)


@dataclass(frozen=True)
class RunResult:
    management_file: Path
    climate_file: Path
    returncode: int
    stdout: str
    stderr: str


class WeppRunner:
    """Run WEPP for management × climate scenario combinations."""

    def __init__(self, config: WeppConfig) -> None:
        self.config = config

    @staticmethod
    def _files(directory: Path) -> list[Path]:
        if not directory.is_dir():
            raise FileNotFoundError(f"Directory not found: {directory}")
        return sorted(path for path in directory.iterdir() if path.is_file())

    def management_files(self) -> list[Path]:
        return self._files(self.config.management_dir)

    def climate_files(self) -> list[Path]:
        return self._files(self.config.climate_dir)

    def _output_path(self, prefix: str, management: Path, climate: Path) -> Path:
        name = f"{prefix}_{management.stem}_{climate.stem}.txt"
        return self.config.output_dir / name

    def build_interactive_input(self, management: Path, climate: Path) -> str:
        """Build the WEPP interactive-response stream used by the study.

        The sequence follows the historical research implementation. Any future
        scientific change to this sequence should be validated against the
        original code and documented.
        """
        output = self.config.output_dir
        output.mkdir(parents=True, exist_ok=True)

        answers = [
            "m",  # metric units
            "y",  # hillslope option
            "1",  # continuous simulation
            "1",  # hillslope version
            "n",  # no hillslope pass file
            "1",  # abbreviated annual output
            "n",  # no initial-condition scenario output
            str(self._output_path("sol", management, climate)),
            "y",  # water-balance output
            str(self._output_path("wat", management, climate)),
            "n",  # plant/residue output
            "n",  # soil output
            "n",  # distance/sediment-loss output
            "n",  # large graphics output
            "y",  # event output
            str(self._output_path("evt", management, climate)),
            "n",  # element output
            "y",  # final summary
            str(self._output_path("sum", management, climate)),
            "n",  # daily winter output
            "y",  # crop-yield output
            str(self._output_path("crp", management, climate)),
            str(management),
            str(self.config.slope_file),
            str(climate),
            str(self.config.soil_file),
            "0",  # no irrigation
            str(self.config.years),
            "0",  # route all events
        ]
        return "\n".join(answers) + "\n"

    def run_one(self, management: Path, climate: Path) -> RunResult:
        executable = self.config.wepp_executable
        if not executable.is_file():
            raise FileNotFoundError(
                f"WEPP executable not found: {executable}. "
                "The executable is not distributed by this repository."
            )

        LOGGER.info("Running WEPP: management=%s climate=%s", management.name, climate.name)
        completed = subprocess.run(
            [str(executable)],
            input=self.build_interactive_input(management, climate),
            text=True,
            capture_output=True,
            check=False,
        )
        return RunResult(
            management_file=management,
            climate_file=climate,
            returncode=completed.returncode,
            stdout=completed.stdout,
            stderr=completed.stderr,
        )

    def iter_scenarios(self) -> Iterable[tuple[Path, Path]]:
        for management in self.management_files():
            for climate in self.climate_files():
                yield management, climate

    def run_all(self, stop_on_error: bool = False) -> list[RunResult]:
        results: list[RunResult] = []
        for management, climate in self.iter_scenarios():
            result = self.run_one(management, climate)
            results.append(result)
            if result.returncode != 0:
                LOGGER.error(
                    "WEPP failed for %s × %s (return code %s)",
                    management.name,
                    climate.name,
                    result.returncode,
                )
                if stop_on_error:
                    break
        return results
