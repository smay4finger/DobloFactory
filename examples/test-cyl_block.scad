include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

color ("purple") cyl_block ();
color ("purple") cyl_block (col=2);
color ("purple") cyl_block (col=4, nibbles_on_off=false);

color ("fuchsia") cyl_block (col=-6, bottom_r=4, top_r=3, height=2*FULL);

// An ugly antique pilar
color ("gold")    cyl_block (row=-6, col=0, up=0,      
			     bottom_r=4, top_r=2, height=FULL, nibbles_on_off=false);
color ("cornsilk") cyl_block (row=-5, col=1, up=FULL,   
			      bottom_r=2, top_r=2, height=2*FULL, nibbles_on_off=false);
color ("khaki")    cyl_block (row=-5, col=1, up=3*FULL,
			      bottom_r=2, top_r=4, height=FULL, nibbles_on_off=true);
