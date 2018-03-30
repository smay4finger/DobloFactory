include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

stairs_world ();

module stairs_world ()
{
     //      (col, row, up, width, length)
     nibbles (-1,   -1,   1,   6,     4      , scale=DOBLO);
     nibbles (-1,   -5,   1,   4,     3      , scale=DOBLO);
     
     difference () {
	  union () {
	       //    Base plate, for faster printing replace by block
	       //    (col, row, up, width,length,height,nibbles_on_off, diamonds) 
	       color ("green") base_plate (-5,  -5,   0,  10,   10,    1,     false, false, scale=DOBLO);
     	       //    staircase
	       //    (col, row, up, width,length,height,nibbles_on_off) 
	       color("red") block (1,   3,   1,  2,    2,     2,     false, scale=DOBLO);
	       block (-1,  3,   1,  2,    2,     4,     false, scale=DOBLO);
	       color("red") block (-3,  3,   1,  2,    2,     6,     false, scale=DOBLO);
	       block (-5,  3,   1,  2,    2,     8,     false, scale=DOBLO);
	       color("red") block (-5,  1,   1,  2,    2,    10,     false, scale=DOBLO);
	       block (-5, -1,   1,  2,    2,    12,     false, scale=DOBLO);
	       }
	  # house_lr (-6.01, 0.01, 1.01, 4.01, 2.01, 3.01, DOBLO);
	  }
     //   platform and support
     //          (col,row,up,height,angle, width)
     color ("blue") support (-5, -5,  6,  7,   270, 1, scale=DOBLO) ;
     block   (-5, -5,  1,  1,    1,     8,   false, scale=DOBLO);
     
     color ("blue") support (-3, -5,  6,  7,   270, 1, scale=DOBLO) ;
     block   (-3, -5,  1,  1,    1,     8,   false, scale=DOBLO);
     
     color ("blue") support (-5, -2,  6,  7,   90, 1, scale=DOBLO) ;
     block   (-5, -2,  1,  1,    1,     8,   false, scale=DOBLO);
     
     color ("blue") support (-3, -2,  6,  7,   90, 1, scale=DOBLO) ;
     block   (-3, -2,  1,  1,    1,     8,   false, scale=DOBLO);
     
     block   (-5, -5,  13,  3,    4,     2,   true, scale=DOBLO);
     
     // support block + duck
     block   (-4, -5,  15,  2,    2,     2,     false, scale=DOBLO);
     merge_stl ("../stls/duck.stl", -4, -5, 15, 3, scale=DOBLO);
     nibbles (-3.9, -4.5, 19.7, 1, 1, scale=DOBLO);
     nibbles (-3.9, -4.5, 19, 1, 1, scale=DOBLO);
     
}

