include <../doblo-factory.scad>;
include <../lib/doblo-params-repl.scad>;
include <../ext/connectors.scad>;

// minimum dimension for hinge side is 2

color ("brown")     hinge_y   (0,  0,  0,   1,  4, 3, true, LUGO);
color ("chocolate") hinge_y  (2,  0,  0,   1,  4, 3, true, LUGO);


//default settings have a large tolerance 
// and a pin that is a complete cylinder (may need sanding)
// so that it is less likely to break

color ("grey")   hinge_z_hole (0,5,  0,   4,  2, HALF, true, LUGO);
color ("silver") hinge_z_pin (0,8,  0,   4,  2, HALF, true, LUGO,slit=false);

color ("brown")     hinge_y   (0,  0,  0,   1,  4, 3, true, LUGO);
