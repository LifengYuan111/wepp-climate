from wepp_climate.scenarios import display_name

def test_scenario_labels():
    assert display_name("F1R4.5") == "RCP4.5 (2021-2050)"
    assert display_name("F2R8.5") == "RCP8.5 (2051-2080)"
