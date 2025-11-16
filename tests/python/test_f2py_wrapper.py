import numpy as np

import os

import swami
from swami.mcm_wrapper import mcm_wrapper


def test_instantiation():

    doy = 1.
    lt = 16.
    al = 250.
    lat = 60.
    lon = 60.
    f107 = 150.
    f107a = 150.
    kps = 6., 6.

    data_um = os.path.dirname(swami.__file__) + "/data/um/"
    data_dtm = os.path.dirname(swami.__file__) + "/data/"

    res = mcm_wrapper(
        doy, lt, al, lat, lon, f107, f107a, kps, data_um, data_dtm)

    # Check if all values are returned
    assert np.all(np.isfinite(res))
