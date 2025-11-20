import numpy as np

import os

import swami
from swami.mcm_wrapper import mcm, dtm


def test_instantiation_mcm():

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

    res = mcm(
        doy, lt, al, lat, lon, f107, f107a, kps, data_um, data_dtm)

    # Check if all values are returned
    assert np.all(np.isfinite(res))


def test_instantiation_dtm():

    doy = 1. # day of year
    lt = 16. # local time in hours
    al = 250. # height in km
    lat = 60. # latitude in deg
    lon = 60.  # longitude in deg
    f107 = 150. # F10.7 index
    f107a = 150. # F10.7 index (averaged)
    kps = 6. # Kp index

    res = dtm(
        doy,
        lt,
        al,
        lat,
        lon,
        (f107, 0.),
        (f107a, 0.),
        (kps, 0., 0., 0.))

    # Check if all values are returned
    assert np.all(np.isfinite(res))


if __name__ == "__main__":

    test_instantiation_mcm()

    test_instantiation_dtm()
