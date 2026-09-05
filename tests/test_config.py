from pathlib import Path
from wepp_climate.config import WeppConfig

def test_from_mapping():
    cfg = WeppConfig.from_mapping({
        "wepp_executable":"model.exe","management_dir":"managements",
        "climate_dir":"climates","output_dir":"results","slope_file":"site.slp",
        "soil_file":"site.sol","years":100})
    assert cfg.years == 100
    assert cfg.management_dir == Path("managements")
