from swami.mcm_wrapper import dtm

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

print(res)
