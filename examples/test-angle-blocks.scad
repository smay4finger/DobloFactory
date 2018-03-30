include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

// calibration block

color ("pink")  block  (-5,-3, 0,      20,2,HALF,false,LUGO);
color ("red") block  (-5,-3, HALF,   20,2,HALF,false,LUGO);
color ("pink")  block  (-5,-3, FULL,   20,2,HALF,false,LUGO);
color ("red") block  (-5,-3, 3*HALF, 20,2,HALF,false,LUGO);
color ("pink")  block  (-5,-3, 2*FULL,   20,2,HALF,false,LUGO);
color ("red")  doblo  (-5,-3, 2*FULL+HALF,   20,2,HALF,true,false,LUGO);

// from left to right

color ("lime") doblo_angle (col=-5, row=0, up=0, 
	     width=1, length=4, 
	     height=THIRD, a_height=FULL,
	     nibbles_on_off=false,
	     scale=LUGO);

color ("green") doblo_angle (col=-3);

color ("olive") doblo_angle (col=-1, row=0, up=0, 
	     width=1, length=4,
	     height=THIRD, a_height=HALF,
	     nibbles_on_off=true,
	     scale=LUGO);

color ("darkgreen") doblo_angle (col=1, row=0, up=0, 
	     width=4, length=2,
	     height=HALF, a_height=FULL,
	     nibbles_on_off=true,
	     scale=LUGO);

color ("blue") block_angle (col=6, row=0, up=0,
			    width=2,length=4,height=HALF, a_height=FULL,
			    nibbles_on_off=true, scale=LUGO);  

color ("darkblue") block_angle (col=9, row=0, up=0,
			    width=2,length=4,height=FULL,
			    nibbles_on_off=false, scale=LUGO);  

color ("skyblue") block_angle (col=12, row=0, up=0,
			       width=2,length=4,height=3*FULL,
			       nibbles_on_off=true, scale=LUGO);  
