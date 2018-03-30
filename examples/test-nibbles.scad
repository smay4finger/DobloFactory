include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

doblo (col=-4, row=-2, up=0,  
	width=4,  length=4, height=HALF, 
	nibbles_on_off=false,
	diamonds_on_off=false,
	scale=DOBLO);

color ("red") nibbles (col=-4, row=0, up=HALF, width=1, length=2,
		       scale=DOBLO, extra =false, filled=false, hscale=1);
color ("pink") nibbles (col=-4, row=-2, up=HALF, width=1, length=2,
			scale=DOBLO, extra =false, filled=true, hscale=1);
color ("orange") nibbles (col=-3, row=-2, up=HALF, width=1, length=2,
			  scale=DOBLO, extra =false, filled=true, hscale=3);

doblo (col=2, row=0, up=0,  
	width=4,  length=4, height=HALF, 
	nibbles_on_off=false,
	diamonds_on_off=false,
	scale=LUGO);

color ("green") nibbles (col=2, row=0, up=HALF, width=1, length=2,
			 scale=LUGO, extra =false, filled=false, hscale=1);
color ("lightgreen") nibbles (col=2, row=2, up=HALF, width=1, length=2,
			      scale=LUGO, extra =false, filled=true, hscale=1);
color ("lime") nibbles (col=3, row=0, up=HALF, width=3, length=2,
			scale=LUGO, extra =false, filled=true, hscale=1);
 
merge_stl (file="stls/duck.stl", col=-15, row=-4, up=0, stl_z_offset_mm=0, shrink=0.5, scale=LUGO);

color ("blue") nibbles (col=-15.5, row=-4, up=17, width=2, length=2,
			scale=LUGO, extra =false, filled=true, hscale=3);

color ("cyan") nibbles (col=-12.5, row=-3.5, up=31, width=1, length=1,
			scale=LUGO, extra =false, filled=true, hscale=3);
