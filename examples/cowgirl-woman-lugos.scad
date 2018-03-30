include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

/*
This should work with many noun project icons
https://thenounproject.com/

Credits:
* Cowgirl: https://thenounproject.com/search/?q=woman&i=31624 by Simon Child
* Womand: Public domain

*/ 

// Variants
// people_lugos("noun_cowgirl_31624_cleaned.dxf",5,1);
people_lugos("noun_woman-clean2.dxf",8.5,1);

unit = NBO(LUGO);

module people_lugos (DXF,x_off=5, y_off=1) {
     difference () {
	  union () {
	       color ("lightgrey") doblo (col=0,  row=-4, up=0,  
					  width=4,  length=4, height=HALF, 
					  nibbles_on_off=false,
					  diamonds_on_off=false,
					  scale=LUGO);
	       color ("lightgrey") block (col=0,  row=-4, up=HALF,  
					  width=4,  length=4, height=HALF, 
					  nibbles_on_off=false,
					  diamonds_on_off=false,
					  scale=LUGO);
	       }

	  translate ([x_off,y_off,FULL+THIRD]) {
	       color ("pink") linear_extrude(height = 5, center = true, convexity = 10)
	       import (file = DXF);
	  }
}

     translate ([6*unit,0,0]) {
	  color ("lightgrey") doblo (col=0,  row=-4, up=0,  
				     width=4,  length=4, height=HALF, 
				     nibbles_on_off=false,
				     diamonds_on_off=false,
				     scale=LUGO);
	  color ("lightgrey") block (col=0,  row=-4, up=HALF,  
				     width=4,  length=4, height=HALF, 
				     nibbles_on_off=false,
				     diamonds_on_off=false,
				     scale=LUGO);
	  translate ([x_off,y_off,FULL+HALF]) {
	       color ("pink") linear_extrude(height = 5, center = true, convexity = 10)
		    // cowgirl by Simon Child from the Noun Project
		    import (file = DXF);
	  }
     }

     }
