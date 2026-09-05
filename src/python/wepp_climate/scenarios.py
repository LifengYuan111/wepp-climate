"""Scenario metadata used by the climate-impact experiments."""

from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class ClimateScenario:
    code: str
    pathway: str
    period: str


SCENARIOS = {
    "F1R4.5": ClimateScenario("F1R4.5", "RCP4.5", "2021-2050"),
    "F1R8.5": ClimateScenario("F1R8.5", "RCP8.5", "2021-2050"),
    "F2R4.5": ClimateScenario("F2R4.5", "RCP4.5", "2051-2080"),
    "F2R8.5": ClimateScenario("F2R8.5", "RCP8.5", "2051-2080"),
}


def display_name(code: str) -> str:
    scenario = SCENARIOS.get(code)
    return f"{scenario.pathway} ({scenario.period})" if scenario else code
