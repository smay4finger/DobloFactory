include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;
include <../ext/stl-merge-display.scad>;

// One in front
merge_brick(stl_file="stls/duck.stl");

// A second one in the back
translate([0,40,0])
 merge_brick (doblo_width=3, doblo_length=2, doblo_height=2, doblo_nibbles=false,
	      stl_file="stls/duck.stl", stl_lift=-1, stl_shrink=1.66,
	      STL_col=1, STL_row=0,
	      block_height=2, block_width=3, block_length=2);

// A simple merge without brick and block using the doblo-factory module
translate([0,80,0]) scale (0.5) merge_stl ("stls/duck.stl", shrink=0.8);
