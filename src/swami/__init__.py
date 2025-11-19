# ---------------------------------------------------------------------
# – Project : SWAMI
# – Customer : N/A
# ---------------------------------------------------------------------
# – Author : Daniel Lubián Arenillas
# – Issue : 1.0
# – Date : 2021-03-31
# – Purpose : Python functions for SWAMI
# - Component : swami python library
# ---------------------------------------------------------------------
# – © Copyright Deimos Space SLU, 2021
# – All rights reserved
# ---------------------------------------------------------------------

import numpy as np
import os
from pathlib import Path
from typing import NamedTuple

from swami.mcm_wrapper import mcm

__version__ = "swami-1.0.rc"

_PWD = Path(__file__).absolute().parent
_NONE = -999999

_PATH_DEFAULT_DATA = _PWD / "data"


class MCMOutput(NamedTuple):
    # output
    dens: float
    temp: float
    wmm: float
    d_H: float
    d_He: float
    d_O: float
    d_N2: float
    d_O2: float
    d_N: float
    tinf: float
    dens_unc: float
    dens_std: float
    temp_std: float
    xwind: float
    ywind: float
    xwind_std: float
    ywind_std: float
    # input
    alti: float
    lati: float
    longi: float
    loct: float
    doy: float
    f107: float
    f107m: float
    kp1: float
    kp2: float


class MCM:
    """MCM Model wrapper.

    Args:
        exec_swami (os.PathLike, optional): Path to the executable. Defaults to the one included.
        path_to_data (os.PathLike, optional): Path to the data. Defaults to the included package.
    """

    path_to_data: Path = _PATH_DEFAULT_DATA

    def __init__(
        self,
        exec_swami: Path | str | None = None,
        path_to_data: Path | str | None = None,
    ):
        """Initialiser

        Args:
            exec_swami (os.PathLike, optional): Path to the executable. Defaults to the one included.
            path_to_data (os.PathLike, optional): Path to the data. Defaults to the included package.
        """

        if exec_swami is not None:
            self.path_to_bin = Path(exec_swami)
        if path_to_data is not None:
            self.path_to_data = Path(path_to_data)

    @staticmethod
    def array_to_mcm_output(input: np.ndarray, output: np.ndarray) -> MCMOutput:

        mcm_output = MCMOutput(
            *output, *input
        )

        return mcm_output

    @staticmethod
    def mcm_output_to_array(
        mcm_output: MCMOutput) -> np.ndarray:

        dict_output = mcm_output._asdict()

        return np.array([val for val in dict_output.values()])

    def run(
        self,
        altitude: float,
        day_of_year: float,
        local_time: float,
        latitude: float,
        longitude: float,
        f107: float,
        f107m: float,
        kp1: float,
        kp2: float,
        get_uncertainty: bool = False,
        get_winds: bool = False,
    ) -> MCMOutput:
        """Run the model

        Returns a MCMOutput object with the results as attributes.

        Args:
            altitude (float): Altitude in km
            day_of_year (float): Day of the year [0-366]
            local_time (float): Local time, h [0-24]
            latitude (float): Latitude, deg [-90 to 90]
            longitude (float): Longitude, deg [0-360]
            f107 (float): F10.7, instantaneous flux at (t - 24hr)
            f107m (float): F10.7, average of the last 81 days
            kp1 (float): Kp, delayed by 3 hours
            kp2 (float): Kp, mean of previous 24 hours
            get_uncertainty (bool, optional): Uncertainties will be returned. Defaults to False.
            get_winds (bool, optional): Winds will be returned. Defaults to False.

        Returns:
            MCMOutput: NamedTuple with the results
        """

        # Sanitize paths
        data_dtm = str(self.path_to_data)
        data_dtm = data_dtm + "/" if data_dtm[-1] != "/" else data_dtm
        data_um = str(os.path.join(self.path_to_data, "um"))
        data_um = data_um + "/" if data_um[-1] != "/" else data_um

        out = mcm(
            day_of_year,
            local_time,
            altitude,
            latitude,
            longitude,
            f107,
            f107m,
            (kp1, kp2),
            data_um,
            data_dtm)

        input = np.array([
            altitude, day_of_year, local_time, latitude, longitude, f107, f107m, kp1 ,kp2])

        mcm_out = self.array_to_mcm_output(input, out)

        return mcm_out
