include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

difference () {
     merge_stl (file="stls/duck.stl", col=0, row=0, up=0, stl_z_offset_mm=0.5, shrink=0.7, scale=LUGO);
     block (col=-1.5, row=0, up=-1, width=4, length=2, height=HALF, nibbles_on_off=false, scale=LUGO);
}

doblo (col=-1.5, row=0, up=0, width=4, length=2, height=HALF, nibbles_on_off=false, scale=LUGO);
