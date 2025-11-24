program point

    use m_um
    use m_dtm
    use m_mcm

    implicit none

    character (len=255) :: cwd

    ! Path where to find the UM netCDF files in folders 2002, 2004, 2008-2009
    character(len=255) :: data_um
    ! Path where to find the "DTM_2020_F107_Kp.dat" file
    character(len=255) :: data_dtm

    real(8), parameter :: altitude = 120.0d0   ! km
    real(8), parameter :: day_of_year = 53.0d0    ! days
    real(8), parameter :: local_time = 12.0d0    ! hours
    real(8), parameter :: latitude = 0d0       ! degrees
    real(8), parameter :: longitude = 15d0      ! degrees
    real(8), parameter :: f107 = 140d0     ! F10.7
    real(8), parameter :: f107m = 139d0     ! F10.7 average
    real(8), parameter :: kps(2) = [1d0, 1d0]      ! Kp

    real(8) :: temp, dens, std_dens, std_temp, unc

    real :: sd(6), swmm, stinf, stemp, sdens

    real(8) :: f107_arr(2) = [f107, 0d0]
    real(8) :: f107m_arr(2) = [f107m, 0d0]
    real(8) :: akp(4) = [kps(1), 0d0, kps(2), 0d0]

    call getcwd(cwd)

    data_um = trim(cwd)//"/data/um/"
    data_dtm = trim(cwd)//"/data/"

    ! Initialise/load the model
    call init_mcm(data_um, data_dtm)

    ! DTM2020 (above 120 km)

    ! Get the temperature (K) density (g/cm3) using the DTM2020 model
    call get_dtm2020(dens, temp, altitude, latitude, longitude, local_time, day_of_year, &
                     f107, f107m, kps)

    print *, temp, dens

    call dtm3(real(day_of_year), &
              real(f107_arr), &
              real(f107m_arr), &
              real(akp), &
              real(altitude), &
              real(local_time), &
              real(latitude), &
              real(longitude), &
              temp, stinf, dens, sd, swmm)

    print *, temp, dens

end program point
