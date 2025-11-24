program test_dtm

    use m_dtm, only : get_dtm2020

    implicit none

    real(8), parameter :: altitude = 150.0d0   ! km
    real(8), parameter :: day_of_year = 53.0d0 ! days
    real(8), parameter :: local_time = 12.0d0  ! hours
    real(8), parameter :: latitude = 0d0       ! degrees
    real(8), parameter :: longitude = 15d0     ! degrees
    real(8), parameter :: f107 = 140d0         ! F10.7
    real(8), parameter :: f107m = 139d0        ! F10.7 average
    real(8), parameter :: kps(2) = [1d0, 1d0]  ! Kp

    real(8), dimension(10) :: res_arr
    real(8) :: f107_arr(2) = [f107, 0d0]
    real(8) :: f107m_arr(2) = [f107m, 0d0]
    real(8) :: akp(4) = [kps(1), 0d0, kps(2), 0d0]

    ! return values of dtm3
    real(8) :: d(6), wmm, tinf, temp, dens
    real :: sd(6), swmm, stinf, stemp, sdens

    ! DTM uses coordinates in rad, hence the conversion factors.
    real(8), parameter :: PI = acos(-1d0)
    real(8), parameter :: DEG2RAD = PI/180d0
    real(8), parameter :: HOUR2RAD = PI/12d0

    call dtm(        &
        day_of_year, &
        local_time,  &
        altitude,    &
        latitude,    &
        longitude,   &
        f107_arr,    &
        f107m_arr,   &
        akp,         &
        res_arr)

    write (*,*) res_arr

    call dtm3(                        &
        real(day_of_year),            &
        real(f107_arr),               &
        real(f107m_arr),              &
        real(akp),                    &
        real(altitude),               &
        real(local_time) * HOUR2RAD,  &
        real(latitude) * DEG2RAD,     &
        real(longitude) * DEG2RAD,    &
        stemp,                         &
        stinf,                         &
        sdens,                         &
        sd,                            &
        swmm )

    write (*,*) sdens, stemp, swmm, sd, stinf

    ! Get the temperature (K) density (g/cm3) using the DTM2020 model
    call get_dtm2020( &
        dens,         &
        temp,         &
        altitude,     &
        latitude,     &
        longitude,    &
        local_time,   &
        day_of_year,  &
        f107,         &
        f107m,        &
        kps )

    write (*,*) temp, dens

end program test_dtm
