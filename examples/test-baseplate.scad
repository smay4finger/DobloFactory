include <../doblo-factory.scad>;

base_plate (4, -14, 0, 12,12,2,true, LUGO);
base_plate (2, 0, 0, 6, 6, 2,true, DOBLO);
base_plate(col=-8);

// A stack of doblos/lugos just for the fun of it.
// Note how DOBLOs and LUGOs have a different coordinate system
color ("red")    base_plate  (-4, -6,  0,   4,   4,  2,  false, DOBLO);
color ("orange") nibbles     (col=-4, row=-6,  up=2,  width=2, length=4, scale=DOBLO);	

color ("green")  doblo       (-2, -12,  4,   2,   2,    6,  true, false, LUGO);
color ("olive")  nibbles     (col=-2, row=-10,  up=4,  width=2, length=6, scale=LUGO);										
