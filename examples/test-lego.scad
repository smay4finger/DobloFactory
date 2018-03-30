include <../doblo-factory.scad>;
include <../lib/doblo-params-repl.scad>;


// Each brick is defined in a module that takes x/y position and color as parameter

module lego_brick_for_mashups (x,y,fill) {
     color (fill)
     doblo   (col=x,  row=y, up=0,  
	      width=4,  length=4, height=HALF, 
	      nibbles_on_off=false, diamonds_on_off=false,
	      scale=LUGO);
}

module lego_compat_standard_brick  (x,y,fill) {
     color (fill)
     doblo (x,y, 0, 4, 2, FULL, true, false, LUGO);
}

module duplo_compat_2x2xHALF_brick  (x,y,fill) {
     color (fill) {
	  doblo (x,y, 0, 2, 2, FULL, true, false, DOBLO);
	  }
}

// display each module, position and color each

lego_brick_for_mashups (x=0, y=0, fill="red");
lego_compat_standard_brick (-4,-3,"blue");
duplo_compat_2x2xHALF_brick (-3,1, "green");

/* Other bricks

doblo   (0,   0,   0,   4,   1,    FULL,  true, false, LUGO);

doblo   (col=0,  row=2, up=0,  
	 width=4,  length=1, height=FULL, 
	 nibbles_on_off=true, diamonds_on_off=false,
	 scale=LUGO);

doblo   (0,   0,   0,   2,   2,    FULL,  true, false, DOBLO);
doblo   (0,   0,   0,   2,   2,    FULL,  true, false, LUGO);

*/
