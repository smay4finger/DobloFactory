/*
  ---------------------------- merge_brick standard module ----------------------

  * This is an example that shows how to merge doblos with other STL
  * It will merge a doblo brick, a STL file, and a presentation brick underneath the STL model

  Change the parameters of this module
  * Instead of using these parameters you also can create your own union and call modules (see below)
  * You can use any number you like, but size of width/length parameters should be integers
  * Just try :)

Call this like that:
 include <doblo-factory.scad>;
 include <lib/doblo-params.scad>;
 include <ext/stl-merge-display-scad>;
 merge_brick(stl_file="duck.stl");

*/

module merge_brick (doblo_width=4, doblo_length=2, doblo_height=3, doblo_nibbles=false,
		    stl_file="duck.stl", stl_lift=-2, stl_shrink=1,
		    STL_col=1.6, STL_row=0,
		    block_height=3, block_width=4, block_length=2)
{
    /* ------------------------ parameter doc ------

    BASE Brick PARAMETERS:

    doblo_width =4  standard doblo with (i.e. 16mm on the x axis)
    doblo_length=2  standard 4x4 doblo length (i.e. 16mm on the y axis)
    doblo_height=3  minimal doblo height (i.e. 4.8 mm on the z axis)
    doblo_nibbles=false   true or false - show not really be used ...
    
    STL file PARAMETERS:
    
    stl_file = "duck.stl"   filename (a string), middle of object should be x,y ~ 0 !!
    stl_lift = -2;          mm - how much move the STL up/down with respect to the presentation block - TRY !
    if the STL sits on z=0 then about half height. Just try until it's ok ;)
    Positioning - moves STL and support block right and forward/backward by columns and rows. 
    STL_col = 1.6;     pos in N doblo_width/2.  0 = left border of base plate
    STL_row = 0;       pos in N doblo_length/2. 0 = upper border of base plate
    
    PRESENTATION BLOCK params:
    block_height = 3 height of the presentation block in terms of doblo_height, can be 0
    block_width = 4  width of presentation block in N doblo_width, e.g. 2 means 2 nibbles
    block_length = 2 length of presentation block in N doblo_ width, e.g. 2 means 2 nibbles
     */

    // unite the three pieces
     translate ([0,0,0]) {
	  // the doblo brick
	  doblo (col=0, row=0,up=0,
		 width=doblo_width, length=doblo_length, height=doblo_height,
		 nibbles_on_off=false, 
		 diamons_on_off=false, scale=LUGO);
	  // A presentation brick underneath the STL
	  block (0, 0, doblo_height, block_width, block_length, block_height, false, scale=LUGO);
	  // the presentation brick plus the STL
	  merge_stl (stl_file, 
		     STL_col,
		     STL_row,
		     doblo_height+block_height,
		     stl_lift, 
		     stl_shrink,
		     LUGO);
     }
}

