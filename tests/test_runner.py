from pathlib import Path
from wepp_climate.config import WeppConfig
from wepp_climate.runner import WeppRunner

def test_interactive_input_has_29_answers(tmp_path):
    cfg = WeppConfig(tmp_path/"wepp.exe", tmp_path/"management",
        tmp_path/"climate", tmp_path/"output", tmp_path/"site.slp",
        tmp_path/"site.sol", 100)
    text = WeppRunner(cfg).build_interactive_input(
        tmp_path/"management"/"crop.man", tmp_path/"climate"/"gcm.cli")
    answers = text.rstrip("\n").split("\n")
    assert len(answers) == 29
    assert answers[:7] == ["m","y","1","1","n","1","n"]
    assert answers[-3:] == ["0","100","0"]
