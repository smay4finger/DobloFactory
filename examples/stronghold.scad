// ------------------- A stronghold

include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

// SCALE=LUGO;
SCALE=DOBLO;

stronghold();

module stronghold ()
{
     union()
     {
	  doblo (col=-6, row=-6, up=0, width=12, length=12, height=THIRD, nibbles_on_off=false, diamonds=false, scale=SCALE);
	  nibbles (col=3, row=-6, up=THIRD, width=3, length=3, scale=SCALE, extra=false, filled=false, hscale=1);
	  nibbles (col=1, row=3, up=THIRD, width=5, length=3, scale=SCALE, extra=false, filled=false, hscale=1);
	  nibbles (col=-6, row=3, up=THIRD, width=3, length=3, scale=SCALE, extra=false, filled=false, hscale=1);

	  //back
	  ramp  (0, -5, 1, 2, 0, scale=SCALE);
	  block (col=-5, row=-5, up=THIRD, width=1, length=1, height=6*FULL, nibbles_on_off=false, scale=SCALE);	    
	  color ("grey")  ramp  (-4, -5, 1, 2, 0, scale=SCALE);
	  color ("black") ramp  (-2.5, -5, 1, 2, 180, scale=SCALE);
	  block (col=-3, row=-5, up=THIRD, width=1, length=1, height=6*FULL, nibbles_on_off=false, scale=SCALE);	    
	  ramp  (-2, -5, 1, 2, 0, scale=SCALE);
	  ramp  (-0.5, -5, 1, 2, 180, scale=SCALE);
	  block (col=-1, row=-5, up=THIRD, width=1, length=1, height=6*FULL, nibbles_on_off=false, scale=SCALE);	    
	  ramp  (1.5, -5, 1, 2, 180, scale=SCALE);
	  block (col=1, row=-5, up=THIRD, width=1, length=1, height=6*FULL, nibbles_on_off=false, scale=SCALE);	    
	  // left
	  block (col=-5, row=-3, up=THIRD, width=1, length=1, height=6*FULL, nibbles_on_off=false, scale=SCALE);
	  block (col=-5, row=-1, up=THIRD, width=1, length=1, height=6*FULL, nibbles_on_off=false, scale=SCALE);
	  // front
	  ramp  (-4, 1, 1, 2, 0, scale=SCALE);
	  block (col=-5, row=1, up=THIRD, width=1, length=1, height=6*FULL, nibbles_on_off=false, scale=SCALE);	    

	  ramp  (-2, 1, 1, 2, 0, scale=SCALE);
	  ramp  (-2.5, 1, 1, 2, 180, scale=SCALE);
	  block (col=-3, row=1, up=THIRD, width=1, length=1, height=6*FULL, nibbles_on_off=false, scale=SCALE);	    

	  ramp  (-0, 1, 1, 2, 0, scale=SCALE);
	  ramp  (-0.5, 1, 1, 2, 180, scale=SCALE);
	  block (col=-1, row=1, up=THIRD, width=1, length=1, height=6*FULL, nibbles_on_off=false, scale=SCALE);	    

	  ramp  (1.5, 1, 1, 2, 180, scale=SCALE);
	  block (col=1, row=1, up=THIRD, width=1, length=1, height=6*FULL, nibbles_on_off=false, scale=SCALE);	    
	  // right
	  // big arc
	  color("blue") support (col=-5, row=-5, up=3*FULL, height=3*FULL, angle=270, thickness=1, scale=SCALE) ;
	  color ("red") support (col=-4.1, row=-5, up=6*FULL-THIRD, height=2.2, angle=0, thickness=7, scale=SCALE);
	  support (col=-3.9, row=-5, up=6*FULL-THIRD, height=2.2, angle=180, thickness=7, scale=SCALE);

	  support (col=-3, row=-5, up=3*FULL, height=3*FULL, angle=270, thickness=1, scale=SCALE) ;
	  color ("red")  support (col=-2.1, row=-5, up=6*FULL-THIRD, height=2.2, angle=0, thickness=7, scale=SCALE);
	  support (col=-1.9, row=-5, up=6*FULL-THIRD, height=2.2, angle=180, thickness=7, scale=SCALE);

	  support (col=-1, row=-5, up=3*FULL, height=3*FULL, angle=270, thickness=1, scale=SCALE) ;
	  support (col=-0.1, row=-5, up=6*FULL-THIRD, height=2.2, angle=0, thickness=7, scale=SCALE);
	  support (col=0.1, row=-5, up=6*FULL-THIRD, height=2.2, angle=180, thickness=7, scale=SCALE);

	  support (col=1, row=-5, up=3*FULL, height=3*FULL, angle=270, thickness=1, scale=SCALE) ;
	  support (col=-5, row=1, up=3*FULL, height=3*FULL, angle=90, thickness=1, scale=SCALE) ;

	  support (col=-3, row=1, up=3*FULL, height=3*FULL, angle=90, thickness=1, scale=SCALE) ;

	  support (col=-1, row=1, up=3*FULL, height=3*FULL, angle=90, thickness=1, scale=SCALE) ;

	  support (col=1, row=1, up=3*FULL, height=3*FULL, angle=90, thickness=1, scale=SCALE) ;
	    
	  // Roof
	  block   (col=-5, row=-5, up=6*FULL, width=7, length=7, height=1, nibbles_on_off=false, scale=SCALE);
	  nibbles (col=-3, row=-3, up=6*FULL+1, width=3, length=3, scale=SCALE, extra=false, filled=false, hscale=1);

	  color ("green") block   (col=-5, row=-5, up=6*FULL, width=7, length=1, height=FULL, nibbles_on_off=false, scale=SCALE);
	  nibbles (col=-4, row=-5, up=7*FULL, width=5, length=1, scale=SCALE, extra=false, filled=false, hscale=1);

	  color ("green") 	  block   (col=-5, row=1, up=6*FULL, width=7, length=1, height=FULL, nibbles_on_off=false, scale=SCALE);
	  nibbles (col=-5, row=-4, up=7*FULL, width=1, length=5, scale=SCALE, extra=false, filled=false, hscale=1);

	  color ("green") 	  block   (col=-5, row=-4, up=6*FULL, width=1, length=5, height=FULL, nibbles_on_off=false, scale=SCALE);
	  nibbles (col=-4, row=1, up=7*FULL, width=5, length=1, scale=SCALE, extra=false, filled=false, hscale=1);

	  color ("green") 	  block   (col=1, row=-4, up=6*FULL, width=1, length=5, height=FULL, nibbles_on_off=false, scale=SCALE);
	  nibbles (col=1, row=-4, up=7*FULL, width=1, length=5, scale=SCALE, extra=false, filled=false, hscale=1);

	  cyl_block   (col=-6,row= -6,up=THIRD,bottom_r= 2,top_r= 2,height= 8*FULL,nibbles_on_off= true, scale=SCALE) ;
	  cyl_block   (col=1,row= -6,up=THIRD,bottom_r= 2,top_r= 2,height= 8*FULL,nibbles_on_off= true, scale=SCALE) ;
	  cyl_block   (col=-6,row= 1,up=THIRD,bottom_r= 2,top_r= 2,height= 8*FULL,nibbles_on_off= true, scale=SCALE) ;
	  cyl_block   (col=1,row= 1,up=THIRD,bottom_r= 2,top_r= 2,height= 8*FULL,nibbles_on_off= true, scale=SCALE) ;
     }
}
