include <../doblo-factory.scad>;

base_plate (4, -14, 0, 12,12,2,true, LUGO);
base_plate (2, 0, 0, 6, 6, 2,true, DOBLO);
base_plate(col=-8);

// A stack of doblos/lugos just for the fun
doblo    (-1,   -3,   0,   10,   2,    6,  false, false, DOBLO);
doblo    (0,   -6,   FULL/LUGO,   2,   2,    6,  true, false, LUGO);
nibbles  (-1,  -3,   FULL,  1,   2, DOBLO);	
nibbles  (0,  -4,   FULL/LUGO,  2,   2, LUGO);										
color("yellow") doblo(length=4, up=0);
color("red") doblo(length=4, up=FULL);
