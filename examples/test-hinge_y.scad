include <../doblo-factory.scad>;
include <../lib/doblo-params-repl.scad>;
include <../ext/connectors.scad>;

// minimum dimension for hinge side is 2

color ("brown")     hinge_y   (0,  0,  0,   1,  4, 3, true, LUGO);
color ("chocolate") hinge_y   (3,  0,  0,   2,  4, 3, true, LUGO);

// create a hinge on top of a stackable block
color ("cyan")       doblo     (-3,  0,  0,      2,  4, HALF, false, false, LUGO);
color ("lightcyan")  block     (-3,  0,  HALF,   2,  4, HALF+FULL, false, LUGO);
color ("darkgrey")       support   (col=-1, row=0, up=FULL+HALF, height=HALF, angle=0, thickness=4, scale=LUGO);
color ("blue")       hinge_y   (-3,  0,  2*FULL,   2,  4, HALF, true, LUGO);

// rotate, then translate a hinge with OpenSCAD functions
unit = PART_WIDTH(LUGO);
translate ([8*unit, -4*unit, 0]) {
     rotate (180) {
	  color ("green") hinge_y (xoff=0, yoff= 0, zoff= 0, length=2, width=4, height=3, nibbles=true, size=LUGO);
     }
     }
