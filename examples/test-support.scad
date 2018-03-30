include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

// (col=0,row=0,up=0,height=FULL,angle=0,thickness=1, scale)

color ("pink") support    (col=0, row=-6, up=0, height=2*FULL, angle=270, thickness=1, scale=LUGO) ;
color ("pink") support    (col=0, row=-6, up=0, height=2*FULL, angle=90, thickness=1, scale=LUGO) ;

color ("red") support     (0,     0,     0,    2*FULL,        0,       1,           LUGO) ;
color ("yellow") support   (5,  0,   0,   2*FULL,   180, 1, LUGO) ;
color ("lime") block      (0,  0,   2*FULL,  6,    1,   1, true, LUGO);
