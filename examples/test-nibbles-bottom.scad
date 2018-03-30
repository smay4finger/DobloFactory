include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

merge_stl (file="stls/duck.stl", col=0, row=0, up=HALF, stl_z_offset_mm=0, shrink=0.5, scale=LUGO);

// calibration brick
color ("pink") doblo (col=-6, row=0, up=0, width=2, length=2, height=HALF, scale=LUGO);

color ("green") nibbles_bottom (col=-2, row=-1, up=0, width=5, length=4, height=FULL, scale=LUGO);
color ("lime") nibbles_bottom (col=-3, row=0, up=0, width=1, length=1, height=FULL, scale=LUGO);
color ("olive") nibbles_bottom (col=-4, row=0, up=0, width=2, length=2, height=FULL, scale=LUGO);


