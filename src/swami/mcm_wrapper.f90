subroutine mcm(day_of_year, local_time, altitude, latitude, longitude, f107, f107m, kps, data_um, data_dtm, res_arr)

    use m_mcm, only: get_mcm, init_mcm, t_mcm_out

    implicit none

    real(8), intent(in) :: altitude     ! height in km
    real(8), intent(in) :: day_of_year  ! in [0, 365]
    real(8), intent(in) :: local_time   ! in [0, 24] hours
    real(8), intent(in) :: latitude     ! in [-90, 90] degrees
    real(8), intent(in) :: longitude    ! [0, 360] degrees
    real(8), intent(in) :: f107         ! F10.7 index
    real(8), intent(in) :: f107m        ! F10.7 index (average)
    real(8), intent(in) :: kps(2)       ! Kp indexes, 3h delayed, and 24h mean
    character(len=4096), intent(in) :: data_um ! Path where to find the UM netCDF files in folders 2002, 2004, 2008-2009
    character(len=4096), intent(in) :: data_dtm ! Path where to find the "DTM_2020_F107_Kp.dat" file

    real(8), dimension(17), intent(out) :: res_arr  ! output array

    type(t_mcm_out) :: res_mcm


    ! Initialise/load the model
    call init_mcm(trim(data_um), trim(data_dtm))

    ! Call MCM
    call get_mcm(mcm_out=res_mcm, &
                 alti=altitude, lati=latitude, longi=longitude, &
                 loct=local_time, doy=day_of_year, &
                 f107=f107, f107m=f107m, kps=kps, &
                 get_unc=.true., get_winds=.true.)

    ! Convert everything to Python-readable array
    res_arr(1) = res_mcm%dens
    res_arr(2) = res_mcm%temp
    res_arr(3) = res_mcm%wmm
    res_arr(4) = res_mcm%d_H
    res_arr(5) = res_mcm%d_He
    res_arr(6) = res_mcm%d_O
    res_arr(7) = res_mcm%d_N2
    res_arr(8) = res_mcm%d_O2
    res_arr(9) = res_mcm%d_N

    res_arr(10) = res_mcm%tinf
    res_arr(11) = res_mcm%dens_unc
    res_arr(12) = res_mcm%dens_std
    res_arr(13) = res_mcm%temp_std
    res_arr(14) = res_mcm%xwind
    res_arr(15) = res_mcm%ywind
    res_arr(16) = res_mcm%xwind_std
    res_arr(17) = res_mcm%ywind_std

end subroutine mcm_wrapper
