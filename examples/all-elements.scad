include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

SCALE = 0.5;

// ----- Demoes all the different kind of bricks
exhibit (); 
doblo_board ();

// ------ simple board

module doblo_board () {
     //    (col, row, up, width,length,height,nibbles_on_off) 
     color ("lightgrey") doblo   (0,   -20,   0,   10,  12,  THIRD,   false, false, LUGO);
     //     (col, row, up, width, length)
     nibbles (0,   -20,   THIRD,   4,   11, LUGO);
     nibbles (3,   -20,   THIRD,   1,   11, LUGO);
     nibbles (6,   -20,   THIRD,   1,   11, LUGO);
     nibbles (9,   -20,   THIRD,   1,   11, LUGO);
     nibbles (1,   -20,   THIRD,   9,   1, LUGO);
     nibbles (0,  -9,   THIRD,   10,  1, LUGO);
}

// ----- exhibit
// not really for printing, displays all (most?) bricks.

module exhibit ()
{
     // duplo compatible brick with nibbles
     //    (col, row, up, width,length,height,nibbles_on_off) 
     color ("green") doblo (col=-7, row=-4, up=0, width=2, length=4, height=FULL, nibbles_on_off=true);

     // cylinder
     //          (col, row, up, bottom_r, top_r, height, nibbles_on_off) 
     cyl_block   (col=-12, row=-12, bottom_r=3, top_r=4, height=4*FULL);
     
/*
   A doblo (pink) + 2 support blocks, 2 towers + block with nibbles on top
*/
     color ("pink") doblo      (9,   -4,   0,  7,    1,     THIRD,  false);
     color("grey")       support (col=10, row=-4, up=THIRD, height=2*FULL, angle=0, thickness=1, scale=LUGO) ;
     color("lightblue")  support (14,   -4,   THIRD,   2*FULL,   180) ;
     color ("blue") block       (10,   -4,   2*FULL+THIRD,  5,    1,    THIRD,     true);
     color ("grey") block       (9,   -4,  THIRD,  1,    1,    4*FULL,     true);
     color ("grey") block       (15,   -4, THIRD,  1,    1,    4*FULL,     true);

/*
building blocks with and without nibbles
*/
     //          (col, row, up, width,length,height,nibbles_on_off) 
     color ([.6,0,0]) doblo (col=2,row=-4,up=0,   width=3,length=4,height=HALF);
     color ("grey") block (col=2,row=-4,up=HALF,width=3,length=3,height=HALF);
     color ([1,0,0])  block (col=4,row=-4,up=FULL,width=1,length=3,height=FULL);
     color ([1,0,0])  block (col=2,row=-4,up=FULL,width=2,length=1,height=FULL);
     
     //             (col, row, up, width, length)
     nibbles        (1,   1,   0,  2,     2      );
     //             (col, row, up, width, length)
     nibbles_bottom (-1,  1,   0,  1,     1,   3);
     
/*
  duplo compatible brick without nibbles + block + stl + nibbles on top
*/
     color ("red") doblo (-6, -10,   0,  5,   4,    HALF,    false);
     color ("orange") block (-6, -10,  HALF,  5,   4,    HALF,    false);
     // position in between the usual grid
     //        (stl_file, col, row, height, stl_lift);
     merge_stl ("../stls/duckator-reduced.stl", col=-3.4, row=-9, up=FULL);

     color("lime") nibbles  (col=-6.4, row=-8.55, up=21, width=1, length=1, hscale=3 );
     
/*
  ramps
*/
     ramp  (col=-5, row=4, up=0, height=FULL,angle=180);
     ramp  (col=-5, row=4, up=0, height=FULL,angle=0);

/* 
   doblo_angle
*/
     color ("lime") doblo_angle (col=-12, row=0, up=0, 
				      width=4, length=4,
				      height=HALF, a_height=FULL,
				      nibbles_on_off=true,
				      scale=LUGO);

     // doblo_angle should have rotation built-in but it doesn't ;)
     units = PART_WIDTH(LUGO);
     translate ([-8*units,0,0])
	  rotate (180)
	  color ("lightgreen") doblo_angle (width=4, length=4,
					    height=HALF, a_height=FULL,
					    nibbles_on_off=false,
					    scale=LUGO);
     
/*     
  text on a 6x2 doblo
*/
     color ("lightblue") doblo (col=4,row=2,up=0,length=2,width=6,height=THIRD,nibbles_on_off=false); 
     color ("black") write (text="DOBLO !",col=4.2,row=2.5,up=THIRD);

     //           (col, row, up, width,length,height,nibbles_on_off) 
     base_plate    (1,   6,   0,   8,   8,     2,    false); 
}

