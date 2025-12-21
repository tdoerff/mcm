subroutine mcm(day_of_year, local_time, altitude, latitude, longitude, f107, f107m, kps, res_arr, get_unc, get_winds)

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

    real(8), dimension(17), intent(out) :: res_arr  ! output array

    logical, intent(in), optional :: get_unc
    logical, intent(in), optional :: get_winds

    type(t_mcm_out) :: res_mcm

    logical :: b_get_unc = .True.
    logical :: b_get_winds = .True.

    if (present(get_unc)) b_get_unc = get_unc
    if (present(get_winds)) b_get_winds = get_winds

    ! Call MCM
    call get_mcm(mcm_out=res_mcm, &
                 alti=altitude, lati=latitude, longi=longitude, &
                 loct=local_time, doy=day_of_year, &
                 f107=f107, f107m=f107m, kps=kps, &
                 get_unc=b_get_unc, get_winds=b_get_winds)

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

end subroutine mcm


subroutine init_mcm(data_um, data_dtm)

    use m_mcm, only : init_mcm0 => init_mcm

    implicit none
    character(*), intent(in) :: data_um     ! Path to UM files
    character(*), intent(in) :: data_dtm    ! Path directory where to find DTM2020 data file

    call init_mcm0(data_um, data_dtm)

end subroutine init_mcm


subroutine dtm(doy, loct, alti, lati, longi, f, fbar, akp, res_arr)

    implicit none

    ! input
    real(8), intent(in) :: lati, alti, doy, loct, longi
    real(8), dimension(2), intent(in) :: f, fbar
    real(8), dimension(4), intent(in) :: akp

    ! output
    real(8), dimension(10), intent(out) :: res_arr  ! output array

    ! return values of dtm3
    real :: d(6), wmm, tinf, temp, dens

    ! DTM uses coordinates in rad, hence the conversion factors.
    real(8), parameter :: PI = acos(-1d0)
    real(8), parameter :: DEG2RAD = PI/180d0
    real(8), parameter :: HOUR2RAD = PI/12d0

    call dtm3(                  &
        real(doy),              &
        real(f),                &
        real(fbar),             &
        real(akp),              &
        real(alti),             &
        real(loct) * HOUR2RAD,  &
        real(lati) * DEG2RAD,   &
        real(longi) * DEG2RAD,  &
        temp,                   &
        tinf,                   &
        dens,                   &
        d,                      &
        wmm)

    res_arr(1) = dens

    res_arr(2) = temp

    res_arr(3) = wmm

    res_arr(4) = d(1) ! H
    res_arr(5) = d(2) ! He
    res_arr(6) = d(3) ! O
    res_arr(7) = d(4) ! N2
    res_arr(8) = d(5) ! O2
    res_arr(9) = d(6) ! N

    res_arr(10) = tinf

end subroutine dtm


subroutine init_dtm(data_dtm)

    use m_dtm, only : init_dtm2020, DTM2020_DATA_FILENAME

    implicit none

    character(*), intent(in) :: data_dtm

    character(len=4096) :: data_file

    data_file = trim(data_dtm)//trim(DTM2020_DATA_FILENAME)

    call init_dtm2020(trim(data_file))

end subroutine init_dtm
