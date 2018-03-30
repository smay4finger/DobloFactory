include <../doblo-factory.scad>;
include <../lib/doblo-params-repl.scad>;

// short notation
//      col row   up  width length height
doblo   (0,   0,   0,   4,   2,    FULL,  true, false, LUGO);

// long notation
doblo   (col=0,  row=3, up=0,  
	 width=4,  length=2, height=FULL, 
	 nibbles_on_off=true,
	 diamonds_on_off=false,
	 scale=LUGO);
