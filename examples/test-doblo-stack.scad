include <../doblo-factory.scad>;
include <../lib/doblo-params-repl.scad>;

color ("yellow") doblo (col=0,  row=0, up=0,  
		       width=4,  length=6, height=FULL, 
		       nibbles_on_off=false,
		       diamonds_on_off=false,
		       scale=LUGO);

color ("red") doblo   (col=0,  row=0, up=FULL,  
		       width=4,  length=2, height=FULL, 
		       nibbles_on_off=true,
		       diamonds_on_off=false,
		       scale=LUGO);

color ("blue") doblo   (col=0,  row=5, up=FULL,  
		       width=1,  length=1, height=3*FULL, 
		       nibbles_on_off=true,
		       diamonds_on_off=false,
		       scale=LUGO);

color ("green") doblo  (col=-3,  row=0, up=0,  
		       width=2,  length=3, height=FULL, 
		       nibbles_on_off=true,
		       diamonds_on_off=false,
		       scale=DOBLO);


