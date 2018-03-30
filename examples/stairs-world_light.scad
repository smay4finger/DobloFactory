include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

module stairs_world_light ()
{
     //    (col, row, up, width,length,height,nibbles_on_off) 
     color ("green") doblo (-5,  -5,   0,  10,   10,    1,     false, scale=DOBLO);
     
     //    staircase
     //                   (col, row, up, width,length,height,nibbles_on_off, SCALE) 
     color ("red")  block (1,   3,   1,  2,    2,     2,     false, DOBLO);
     color ("pink") block (-1,  3,   1,  2,    2,     4,     false, DOBLO);
     color ("red")  block (-3,  3,   1,  2,    2,     6,     false, DOBLO);
     color ("pink") block (-5,  3,   1,  2,    2,     8,     false, DOBLO);
     color ("red")  block (-5,  1,   1,  2,    2,    10,     false, DOBLO);
     color ("pink") block (-5, -1,   1,  2,    2,    12,     false, DOBLO);
     color ("red")  block (-5, -3,   1,  2,    2,    14,     false, DOBLO);
     color ("pink") block (-5, -5,   1,  2,    2,    16,     true, DOBLO);
     
     color ("blue") block (3, -5, 1, 2, 6, 1, true, scale=DOBLO);
}
// call the module, else it won't draw
stairs_world_light();
