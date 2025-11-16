import numpy as np

from swami import MCM


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
