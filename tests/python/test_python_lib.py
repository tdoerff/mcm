import numpy as np

from swami import MCM
from swami import MCMOutput

def test_instantiation():

    mcm = MCM()

    doy = 1.
    lt = 16.
    al = 250.
    lat = 60.
    lon = 60.
    f107 = 150.
    f107a = 150.
    kp1 = 6.
    kp2 = 6.

    res = mcm.run(
        al, doy, lt, lat, lon, f107, f107a, kp1, kp2)

    # Check if all values are returned
    assert np.all(np.isfinite(mcm.mcm_output_to_array(res)))


def test_array_to_mcm_output():

    data_out_array = np.linspace(1, 17, 17)
    data_in_array = np.linspace(-1, -9, 9)

    mcm_ref = MCMOutput(*data_out_array, *data_in_array)

    mcm_out = MCM.array_to_mcm_output(data_in_array, data_out_array)

    assert mcm_ref == mcm_out


def test_mcm_output_to_array():

    out_array = np.linspace(1, 17, 17)
    in_array = np.linspace(-1, -9, 9)

    mcm_out = MCMOutput(*out_array, *in_array)

    data_out_array = MCM.mcm_output_to_array(mcm_out)
    data_out_ref_array = np.array([*out_array, *in_array])

    np.testing.assert_allclose(data_out_array, data_out_ref_array)
