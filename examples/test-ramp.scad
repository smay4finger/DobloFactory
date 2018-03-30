include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

color ("lavender") doblo (col=-0, row=0, height=FULL, width=2, nibbles_on_off=false);
// ramp                (col, row, up, height, angle,width,scale)
color ("fuchsia") ramp  (2,  0,   0,  FULL,   0,    2, LUGO);
color ("plum")    ramp  (0,  0,   0,  FULL,   180,  2, LUGO);
color ("purple")  ramp  (-0.5,  0,   0,  8,      90,   3, LUGO);
color ("indigo")  ramp  (0,  2,   0,  FULL,   270,  2, LUGO);

doblo (col=-4, row=4,height=THIRD);
color ("blue")  ramp  (col=-1, row=6, up=0, height=THIRD, angle=270, width=0.5, scale=LUGO);
