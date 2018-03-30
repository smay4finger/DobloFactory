/*

 Copyright (c) 2013 Daniel M. Taub
 Copyright (c) 2010 Daniel K. Schneider
 Copyright (c) 2017 Daniel K. Schneider
 
 This file is part of DobloFactory VERSION 2.2

 DobloFactory is free source: you can redistribute it and/or modify
    modify it under the terms of the CC BY-NC-SA 3.0 License:
    CreativeCommons Attribution-NonCommerical-ShareAlike 3.0
    as published by Creative Commons. 

    You should have received a copy of the CC BY-NC-SA 3.0 License 
    with this source package. 
    If not, see <http://creativecommons.org/licenses/by-nc-sa/3.0/>
*/

// may change this include based on printer types
include <lib/doblo-params.scad>;
NUDGE = .001;  // slight amount to make sure interfaces touch

// -------------------------------- DOBLO and STL merging ------------------------------

// Import an STL and place it using the positioning system

module merge_stl (file="stls/placeholder.stl", col=0, row=0, up=10,stl_z_offset_mm=-3, shrink=1, scale=LUGO) {

  // Move STOL right and forward - origin is x=leftmost and y=backmost
  x_offset_mm       =  col * PART_WIDTH(scale) + PART_WIDTH(scale) ;
  y_offset_mm       =  - (row * PART_WIDTH(scale) + PART_WIDTH(scale)) ;
  z_offset_mm       =  up * PART_HEIGHT(scale) + stl_z_offset_mm ;
  // the STL
  echo(str("shrink factor=", shrink));
  translate([x_offset_mm, y_offset_mm, z_offset_mm])
  {
       scale([1/shrink,1/shrink,1/shrink]) import(file);
       // scale(0.5) import(file);
  }
}

// ----------------------------------- DOBLO bricks making code -------------------------------
// all of these can be used in custom modules, i.e. they respect the grid model

module doblo (col=0, row=0, up=0, width=4,length=2,height=FULL,
	      nibbles_on_off=true,diamonds_on_off=false,scale=LUGO) 
  /* Use cases:
     - typical Doblo block, use only once to create the first layer, e.g. a small or larger plate
     that can fit on top of another doblo or Duplo(TM) block.
     - See also "block", it doesn't have nibbles underneath and it should be used to build 3D structures
   */
{
  // build the cube from its center
  x_0 = col    * PART_WIDTH(scale)  + width  * PART_WIDTH(scale) / 2.0;
  y_0 = - (row * PART_WIDTH(scale) + length * PART_WIDTH(scale) / 2.0) ;
  z_0 = up      * PART_HEIGHT(scale)  + height * PART_HEIGHT(scale) / 2.0;

  // User info
  echo(str("DOBLO brick width(x)=", width * PART_WIDTH(scale), "mm, length=", length*PART_WIDTH(scale), "mm, height=", height*PART_HEIGHT(scale), "mm" ));
  // the cube is drawn at absolute x,y,z = 0 then moved
  translate ([x_0, y_0, z_0]) {
    //the doblo
    union () {
      if (diamonds_on_off && (width > 1 && length > 1)) {
        difference () {
          difference() {
            // the cube
            cube([width*PART_WIDTH(scale), length*PART_WIDTH(scale), height*PART_HEIGHT(scale)], true);
            // inner emptiness, a bit smaller and shifted down
            translate([0,0,-DOBLOWALL(scale)]) 	
              #cube([width*PART_WIDTH(scale) - 2*DOBLOWALL(scale), length*PART_WIDTH(scale)-2*DOBLOWALL(scale), height*PART_HEIGHT(scale)], true);
          }
          // diamonds
          diamonds (width, length, height, scale=scale);
        }
      }
      else {
        difference() {
          // the cube
          cube([width*PART_WIDTH(scale), length*PART_WIDTH(scale), height*PART_HEIGHT(scale)], true);
          // inner emptiness, a bit smaller and shifted down
          translate([0,0,-DOBLOWALL(scale)]) 	
            cube([width*PART_WIDTH(scale) - 2*DOBLOWALL(scale), length*PART_WIDTH(scale)-2*DOBLOWALL(scale), height*PART_HEIGHT(scale)], true);
        }
      }
      // nibbles on top
      if  (nibbles_on_off)
      {
        //           (col,  row,      up,       width, length)
        nibbles (-width/2, -length/2, height/2, width, length, scale = scale);
      }

      // nibbles underneath - only for Lego or bigger AND if x or y is bigger than 1 
      if (scale > 0.3) {
	   if (width > 1 && length > 1)
	   {
		// big nibbles underneath
		bottom_nibbles(width, length, height, scale = scale);
		// lattice (for low resolution printers - e.g. 0.35 layers - this is not needed)
		if (LATTICE_TYPE > 0 )
		{ 
		     color ("green") bottom_lattice (width, length, height, scale = scale);
		}
	   }
	   else {
		// big nibbles underneath
		if (USE_INSET(scale))
		     bottom_nibbles_part (width, length, height, scale = scale);
		// lattice (for low resolution printers - e.g. 0.35 layers - this is not needed)
		/*if (LATTICE_TYPE > 0 )
		  { 
		  bottom_lattice (width, length, height, scale = scale);
		  }
		*/
	   }
	   if ((scale < 0.6) && (!USE_INSET(scale)))
	   {
		bottom_nibbles_thin (width, length, height,scale=scale);
	   }
	   //little walls inside (insets)
	   if (USE_INSET(scale))
		difference() 
		{
		     union()
		     {
			  for(j=[1:length])
			       translate([0,-PART_WIDTH(scale)*length/2+j*2*NO(scale)-2*NO(scale)/2,0]) cube([width*PART_WIDTH(scale), INSET_WIDTH(scale), height*PART_HEIGHT(scale)],true);
			  for (i = [1:width])
			       translate([-PART_WIDTH(scale)*width/2+i*2*NO(scale)-2*NO(scale)/2,00]) cube([INSET_WIDTH(scale), length*PART_WIDTH(scale), height*PART_HEIGHT(scale)],true);
		     }
		     cube([width*PART_WIDTH(scale)-INSET_LENGTH(scale), length*PART_WIDTH(scale)-INSET_LENGTH(scale), height*PART_HEIGHT(scale)+2], true);
		}
      }
      else
	   // scale is nano (<0.3). No nibbles
      {
	   if (width > 1 && length > 1)
		bottom_nano_lattice (width, length, height, scale = scale);
	   
      }
    }
  }
}

module nibbles (col=0, row=0, up=FULL, width=1, length=1, scale=LUGO, extra =false, filled=false, hscale=1)
  /* Use cases:
     - needed by the doblo and the block modules
     - can also be stuck on top on parts of a nibble-less doblo or block
   */
{
  // Uses a local coordinate system left/back = 0,0
  // E.g. nibbles (-2,    -2,      0,    4,       4      );
  // echo ("PART_WIDTH(scale)", PART_WIDTH(scale), "NO(scale)", NO(scale));
  x_start =           col    * PART_WIDTH(scale) +  NO(scale) ;
  // echo ("x_start", x_start, "col", col);
  y_start =  - (  row * PART_WIDTH(scale) + NO(scale));
  // echo ("y_start", y_start, "row", row);
  z_local = up * PART_HEIGHT(scale) + NH(scale) / 2;
  translate ([x_start , y_start, z_local]) {
    // 0,0 is left/back corner. Draw to the right (x) and forward (-y)
    for(j=[1:length])
    {
      for (i = [1:width])
      {
        translate([(i-1) * PART_WIDTH(scale), -(1) * (j-1) * PART_WIDTH(scale), 0]) doblonibble(scale = scale,extra=extra,filled=filled,heightscale=hscale);
      }
    }
  }
}

module diamonds (width, length, height)
{
  x_start = -width/2  * PART_WIDTH(scale) + NBO(scale);
  y_start = -length/2 * PART_WIDTH(scale) + NBO(scale);
  z_pos   = -height * PART_HEIGHT(scale)/2+DIAMOND;
  echo (str ("height = ", height, "z_pos= ", z_pos));
  translate ([0, y_start, z_pos]) {
    // holes along y-axis
    for (i = [0:length-2]) {
      // echo (str ("diamond y offset=", i*PART_WIDTH(scale)+PART_WIDTH(scale)));
      translate([0, i* NBO(scale), 0]) 
        rotate (a=45, v=[1,0,0]) { cube([width*PART_WIDTH(scale)+PART_WIDTH(scale),DIAMOND,DIAMOND],true); }
    }
  }
  translate ([x_start, 0, z_pos]) {
    // holes along x-axis
    for (j = [0:width-2]) {
      // echo (str ("diamond x offset=", j*PART_WIDTH(scale)-PART_WIDTH(scale)));
      translate([j * NBO(scale), 0, 0]) 
        rotate (a=45, v=[0,1,0]) { cube([DIAMOND,length*PART_WIDTH(scale)+PART_WIDTH(scale),DIAMOND],true); }
    }
  }
}

// produces a wider spaced lattice (not used currently)
module bottom_lattice_wide (width, length, height)
{
  x_start = -width/2  * PART_WIDTH(scale) + NBO(scale);
  y_start = -length/2 * PART_WIDTH(scale) + NBO(scale);
  z_pos   = height * PART_HEIGHT(scale)/2 - LATTICE_WIDTH(scale) - LATTICE_WIDTH(scale)/2;
  translate ([0, y_start, z_pos]) {
    // grid along y-axis
    for (i = [0:length-2]) {
      translate([0, i* NBO(scale), 0])
      { cube([width*PART_WIDTH(scale), LATTICE_WIDTH(scale), LATTICE_WIDTH(scale)],true); }
    }
  }
  // grid along x-axis
  translate ([x_start, 0, z_pos]) {
    // holes along x-axis
    for (j = [0:width-2]) {
      translate([j * NBO(scale), 0, 0]) 
      { cube([LATTICE_WIDTH(scale),length*PART_WIDTH(scale),LATTICE_WIDTH(scale)],true); }
    }
  }
}

module bottom_lattice (width, length, height)
{
  spacing = NBO(scale)/LATTICE_TYPE;
  x_start = -width/2  * PART_WIDTH(scale) + spacing;
  y_start = -length/2 * PART_WIDTH(scale) + spacing;
  z_pos   = height * PART_HEIGHT(scale)/2 - LATTICE_WIDTH(scale) - LATTICE_WIDTH(scale)/2;
  translate ([0, y_start, z_pos]) {
    // grid along y-axis
    for (i = [0:LATTICE_TYPE*length-2]) {
      translate([0, i* spacing, 0])
      { cube([width*PART_WIDTH(scale), LATTICE_WIDTH(scale), LATTICE_WIDTH(scale)],true); }
    }
  }
  // grid along x-axis
  translate ([x_start, 0, z_pos]) {
    // holes along x-axis
    for (j = [0:LATTICE_TYPE*width-2]) {
      translate([j * spacing, 0, 0]) 
      { cube([LATTICE_WIDTH(scale),length*PART_WIDTH(scale),LATTICE_WIDTH(scale)],true); }
    }
  }
}

module bottom_nano_lattice (width, length, height)
{
  spacing = NBO(scale)/LATTICE_TYPE;
  x_start = -width/2  * PART_WIDTH(scale) + spacing;
  y_start = -length/2 * PART_WIDTH(scale) + spacing;
  z_pos   = 0;
  translate ([0, y_start, z_pos]) {
    // grid along y-axis
    for (i = [0:LATTICE_TYPE*length-2]) {
      translate([0, i* spacing, 0])
      {color ("green") cube([width*PART_WIDTH(scale), LATTICE_WIDTH(scale), height*PART_HEIGHT(scale)],center=true); }
    }
  }
  // grid along x-axis
  translate ([x_start, 0, z_pos]) {
    // holes along x-axis
    for (j = [0:LATTICE_TYPE*width-2]) {
      translate([j * spacing, 0, 0]) 
      { color ("blue") cube([LATTICE_WIDTH(scale),length*PART_WIDTH(scale),height*PART_HEIGHT(scale)],center=true); }
    }
  }
}



module bottom_nibbles_thin (width, length, height, scale)
  /* Use cases:
     - needed by the doblo module
   */
{
  x_start = -width/2 * PART_WIDTH(scale) + NBO(scale);
  y_start = -length/2 * PART_WIDTH(scale) + NBO(scale);
  z_local = 0;
  translate ([x_start , y_start, z_local]) {
    if (width == 1){
      for(j=[0:length-2])
      {
        translate([-NBO(scale)/2, j * NBO(scale), 0]) doblobottomnibble_thin(height*PART_HEIGHT(scale),scale=scale);
      }
    }
    else if (length == 1){
      for (i = [0:width-2])
      {
        translate([i * NBO(scale), -NBO(scale)/2, 0]) doblobottomnibble_thin(height*PART_HEIGHT(scale),scale=scale);
      }
    }
  }
}

module bottom_nibbles_part (width, length, height, scale)
  /* Use cases:
     - needed by the doblo module for h or w == 1
   */
{
  SUPPORT_HEIGHT = height * PART_HEIGHT(scale);

  x_start = -width/2 * PART_WIDTH(scale) + NBO(scale);
  y_start = -length/2 * PART_WIDTH(scale) + NBO(scale);
  z_local = 0;
  translate ([x_start , y_start, z_local]) {
    if(width == 1){
      for(j=[0:length-1]){
        translate([0-ALONG_LEN(scale)/4,j*2*NO(scale)-NO(scale),0])
          cube([ALONG_LEN(scale)/2, INSET_WIDTH(scale), SUPPORT_HEIGHT],true);
        translate([-2*NO(scale)+ALONG_LEN(scale)/4,j*2*NO(scale)-NO(scale),0])
          cube([ALONG_LEN(scale)/2, INSET_WIDTH(scale), SUPPORT_HEIGHT],true);
        if (j!= length-1)
          translate([-NO(scale),j*2*NO(scale),0]){
            union(){
              cube([INSET_WIDTH(scale), ALONG_LEN(scale), SUPPORT_HEIGHT],true);
              cube([CROSS_LEN(scale), INSET_WIDTH(scale), SUPPORT_HEIGHT],true);
            }
          }
      }
    }
    else if (length == 1) {
      for(i=[0:width-1]) {
        translate([i*2*NO(scale)-NO(scale),0-ALONG_LEN(scale)/4,0])
          cube([INSET_WIDTH(scale), ALONG_LEN(scale)/2, SUPPORT_HEIGHT],true);
        translate([i*2*NO(scale)-NO(scale),-2*NO(scale)+ALONG_LEN(scale)/4,0])
          cube([INSET_WIDTH(scale), ALONG_LEN(scale)/2, SUPPORT_HEIGHT],true);
        if (i != width-1)
          translate([i*2*NO(scale),-NO(scale),0])
            union(){
              cube([INSET_WIDTH(scale), CROSS_LEN(scale), SUPPORT_HEIGHT],true);
              cube([ALONG_LEN(scale), INSET_WIDTH(scale), SUPPORT_HEIGHT],true);
            }
      }
    }
  }
}

module bottom_nibbles (width, length, height, scale)
  /* Use cases:
     - needed by the doblo module
     - for an end-user module: see nibbles_bottom !
   */
{
  x_start = -width/2 * PART_WIDTH(scale) + NBO(scale);
  y_start = -length/2 * PART_WIDTH(scale) + NBO(scale);
  z_local = 0;
  translate ([x_start , y_start, z_local]) {
    for(j=[0:length-2])
    {
      for (i = [0:width-2])
      {
        translate([i * NBO(scale), j * NBO(scale), 0]) 
	     doblobottomnibble(height*PART_HEIGHT(scale),scale=scale);
      }
    }
  }
}

// To be used by end users for sticking a bottom nible on an object
module nibbles_bottom (col, row, up, width, length, height, scale=LUGO)
{
     width_  = (width==1)  ? 2 : width;
     length_ = (length==1) ? 2 : length;
     x_0 =    col * PART_WIDTH(scale) + width_  * PART_WIDTH(scale) / 2.0;
     y_0 = - (row * PART_WIDTH(scale) + length_ * PART_WIDTH(scale) / 2.0) ;
     z_0 = up      * PART_HEIGHT(scale)  + height * PART_HEIGHT(scale) / 2.0;
     echo(str("bottom_nibble_col=", col));
     echo(str("bottom_nibble_x_pos=", x_0));
     translate ([x_0, y_0, z_0]) {
	  bottom_nibbles (width_, length_, height, scale);
     }
}


// use by angle bricks
module tri_prism(top,side,end)
{
  translate([side/2,-end/2,-top/6-NUDGE])rotate([0,-90,0])linear_extrude(height=side) 
    polygon(points=[[0,0],[top,end],[0,end]],paths=[[0,1,2]]);

}

// Made by DT
module angle_doblo(col,row,up,width,length,width,height,nibbles_on_off,scale){
  doblo(col,row,up,width,length,height,false,false,scale);
  angle_block(col,row,up+2,width,length,height,nibbles_on_off,scale);
}

// Added by DKS sept. 2015 - added a parameter for the height of the angle block
// quite back hack
module doblo_angle (col=0,row=0,up=0,width=2,length=4,height=FULL,a_height=FULL,nibbles_on_off=true,scale=LUGO){
     # doblo    (col,row,up,width,length,height,false,false,scale);
     if (scale==LUGO) {
	  block_angle (col,row,height+height*0.6,width,length,a_height,nibbles_on_off,scale);
     }
     else
     {
	  block_angle (col,row,4*height,width,length,a_height,nibbles_on_off,scale);
     }
}

// DKS, sept. 2015 - hacks by trial and error to make it sit on z=0
// just a dump hack, sort of ok with lego size, but not duplo
module block_angle (col, row, up, width,length,height,nibbles_on_off, scale) 
{
  // build the cube from its center
  x_0 = col    * PART_WIDTH(scale)  + width  * PART_WIDTH(scale) / 2.0;
  y_0 = - (row * PART_WIDTH(scale) + length * PART_WIDTH(scale) / 2.0) ;
  z_0 = up + height/4; // found through trial and error :( / DKS
  top = PART_HEIGHT(scale)*height;
  side = PART_WIDTH(scale)*width;
  end = PART_WIDTH(scale)*length;
  ang = atan(top/end);
  hyp = top/sin(ang);
  off_y = (hyp-end)/2;
  off_z = -NUDGE  ;//-top/6-NUDGE;
  oy = (hyp-end)/2;
  oz=-top/FULL-NUDGE;
  // the cube is drawn at absolute x,y,z = 0 then moved
  translate ([x_0, y_0, z_0]) {
    tri_prism(top,side,end);
    // nibbles on top
    if  (nibbles_on_off)
    {
      //      (col, row, up, width, length)
      translate([0,oy,oz])rotate([ang,0,0])translate([0,off_y,off_z])nibbles (-width/2, -length/2, height/2, width, length, scale=scale);
    }
  }
}

module angle_block (col, row, up, width,length,height,nibbles_on_off, scale) 
{
  // build the cube from its center
  x_0 = col    * PART_WIDTH(scale)  + width  * PART_WIDTH(scale) / 2.0;
  y_0 = - (row * PART_WIDTH(scale) + length * PART_WIDTH(scale) / 2.0) ;
  z_0 = up      * PART_HEIGHT(scale)  + height * PART_HEIGHT(scale) / 2.0;
  top = PART_HEIGHT(scale)*height;
  side = PART_WIDTH(scale)*width;
  end = PART_WIDTH(scale)*length;
  ang = atan(top/end);
  hyp = top/sin(ang);
  off_y = (hyp-end)/2;
  off_z = -NUDGE  ;//-top/6-NUDGE;
  oy = (hyp-end)/2;
  oz=-top/FULL-NUDGE;
  // the cube is drawn at absolute x,y,z = 0 then moved
  translate ([x_0, y_0, z_0]) {
    tri_prism(top,side,end);
    // nibbles on top
    if  (nibbles_on_off)
    {
      //      (col, row, up, width, length)
      translate([0,oy,oz])rotate([ang,0,0])translate([0,off_y,off_z])nibbles (-width/2, -length/2, height/2, width, length, scale=scale);
    }
  }
}



module block (col=0, row=0, up=0, width=2,length=4,height=FULL,nibbles_on_off=false, scale=LUGO) 
  /* Use cases:
     - building blocks for 3D structures (saves times and plastic, use a light fill in skeinforge)
     - movable blocks for games (printed apart)
   */
{
  // build the cube from its center
  x_0 = col    * PART_WIDTH(scale)  + width  * PART_WIDTH(scale) / 2.0;
  y_0 = - (row * PART_WIDTH(scale) + length * PART_WIDTH(scale) / 2.0) ;
  z_0 = up      * PART_HEIGHT(scale)  + height * PART_HEIGHT(scale) / 2.0;

  // the cube is drawn at absolute x,y,z = 0 then moved
  translate ([x_0, y_0, z_0]) {
    //the cube
    cube([width*PART_WIDTH(scale), length*PART_WIDTH(scale), height*PART_HEIGHT(scale)], true);
    // nibbles on top
    if  (nibbles_on_off)
    {
      //      (col, row, up, width, length)
      nibbles (-width/2, -length/2, height/2, width, length, scale=scale);
    }
  }
}


// Added a fix to shave off the bottom. But height is not correct, the roof (half of the length is not counted).
// DKS sept. 2015
module house_lr (col, row, up, width, length, height, scale) 
  /* Use cases:
     - create doors with openscad difference operator
     - a hack, only work along x axis and with a min. height and width
   */
{
  // build the cube from its center
  x_0 = col    * PART_WIDTH(scale)  + width  * PART_WIDTH(scale) / 2.0;
  y_0 = - (row * PART_WIDTH(scale) + length * PART_WIDTH(scale) / 2.0) ;
  z_0 = up      * PART_HEIGHT(scale)  + height * PART_HEIGHT(scale) / 2.0;
  roof_l = sqrt ( (length*PART_WIDTH(scale)*length*PART_WIDTH(scale)) + (length*PART_WIDTH(scale)*length*PART_WIDTH(scale) ) ) / 2;

  // the cube is drawn at absolute x,y,z = 0 then moved
  translate ([x_0, y_0, z_0]) {
    //the cube
    cube([width*PART_WIDTH(scale), length*PART_WIDTH(scale), height*PART_HEIGHT(scale)], true);
    //the "roof"
    translate ([0,0,height*PART_HEIGHT(scale)/2]) {
	 difference () {
	      rotate ([45,0,0]) {
		   cube([width*PART_WIDTH(scale), roof_l, roof_l], true);
		   }
	      translate ([0,0,-4*height*PART_HEIGHT(scale)/2]) {
		   cube([width*PART_WIDTH(scale)+2, length*PART_WIDTH(scale)+2, height*2*PART_HEIGHT(scale)], true);
	      }
	 }
    }		
  }
}

module house_fb (col, row, up, width,length,height, scale) 
  /* Use cases:
     - create doors with openscad difference operator
     - a hack, only work along y axis and with a min. height and length ... try ;)
   */
{
  // build the cube from its center
  x_0 = col    * PART_WIDTH(scale)  + width  * PART_WIDTH(scale) / 2.0;
  y_0 = - (row * PART_WIDTH(scale) + length * PART_WIDTH(scale) / 2.0) ;
  z_0 = up      * PART_HEIGHT(scale)  + height * PART_HEIGHT(scale) / 2.0;
  // That was 40 years ago
  roof_l = sqrt ( (width*PART_WIDTH(scale)*width*PART_WIDTH(scale)) + (width*PART_WIDTH(scale)*width*PART_WIDTH(scale) ) ) / 2;

  // the cube is drawn at absolute x,y,z = 0 then moved
  translate ([x_0, y_0, z_0]) {
    //the cube
    cube([width*PART_WIDTH(scale), length*PART_WIDTH(scale), height*PART_HEIGHT(scale)], true);
    translate ([0,0,height*PART_HEIGHT(scale)/2]) {
      rotate ([0,45,0]) {
        cube([roof_l, length*PART_WIDTH(scale), roof_l], true);
      }
    }
  }		
}

module base_plate (col=0, row=0, up=0, width=8,length=8,height=THIRD,nibbles_on_off, scale=LUGO) 
  /* Use cases:
     - Creating a base plate for showing off your prints. I believe that buying one in a shop is more efficient ....
     - to do: fix the lattice to match other small typical height,
     - an other version that has round holes allowing to stack it.
   */

{
  // construction of the grid underneath
  // spacing = (scale < 0.6) ? NBO(scale)/LATTICE_TYPE*2 : NBO(scale)/LATTICE_TYPE;
  spacing = (scale > 0.6) ? NBO(scale) : NBO(scale)*2;
  offset  = NBO(scale);
  x_start = - width/2  * PART_WIDTH(scale) + NBO(scale);
  y_start = - length/2 * PART_WIDTH(scale) + NBO(scale);
  z_pos   = LATTICE_WIDTH(scale) / 2 -0.01;
  n_rows  = (scale > 0.6) ? length-2 : (length-2)/2 ;  // Need less for legos
  n_cols  = (scale > 0.6) ? width-2 :  (width-2)/2;

  // positioning of the grid with respect to the cube
  x_0 = col    * PART_WIDTH(scale)  + width  * PART_WIDTH(scale) / 2.0;
  y_0 = - (row * PART_WIDTH(scale) + length * PART_WIDTH(scale) / 2.0) ;

  difference () {
    block (col, row, up, width,length,height,nibbles_on_off, scale) ;

    union () {
	 translate ([x_0, y_0, z_pos])
	 {
	      translate ([0, y_start, 0]) {
		   // grid along y-axis
		   for (i = [0:n_rows]) {
			translate([0, i* spacing, 0])
			{ cube([width*PART_WIDTH(scale)-offset*2, LATTICE_WIDTH(scale), LATTICE_WIDTH(scale)],true); }
		   }
	      }
	      // grid along x-axis
	      translate ([x_start, 0, 0]) {
		   // holes along x-axis
		   for (j = [0:n_cols]) {
			translate([j * spacing, 0, 0]) 
			{ cube([LATTICE_WIDTH(scale),length*PART_WIDTH(scale)-offset*2,LATTICE_WIDTH(scale)],true); }
		   }
	      }
	 }
    }
  }
}


// ------ Cylinder block

module cyl_block (col=0, row=0, up=0, bottom_r=2, top_r=2, height=FULL, nibbles_on_off=true, scale=LUGO) 
{
  bottom_r_mm = bottom_r * NO(scale);
  top_r_mm    = top_r * NO(scale);
  x_0         = col    * PART_WIDTH(scale)   + bottom_r_mm;
  y_0         = - (row * PART_WIDTH(scale)   + bottom_r_mm);
  z_0         = up     * PART_HEIGHT(scale);

  // the cylinder is drawn at absolute x,y,z = 0 then moved
  translate ([x_0, y_0, z_0]) {
    cylinder(h= height*PART_HEIGHT(scale), r1 = bottom_r_mm, r2 = top_r_mm, center = false, $fs = CYL_FS);
    if  (nibbles_on_off)
    {
      //      (col, row,  up,  width, length)
      // circle is a bit different from cube
      nibbles (-top_r/2+0.5, -top_r/2+0.5, height, top_r-1, top_r-1, scale);
    }
  }
}

// -------------- support block (triangle )

// Support block for building platforms
// so bad ... :(
// NOTE: make the support block stick into something, else it won't print

module support (col=0,row=0,up=0,height=FULL,angle=0,thickness=1, scale=LUGO)
{
  if (angle == 0) {
    translate ([0, 0, 0]) {
      support1 (col,row,up,height,angle,thickness, scale);
    }
  }
  if (angle == 90) {
    translate ([0, -PART_WIDTH(scale) , 0]) {
      support1 (col,row,up,height,angle,thickness, scale);
    }
  }
  if (angle == 180) {
    translate ([PART_WIDTH(scale), -PART_WIDTH(scale) - PART_WIDTH(scale)* (thickness-1) , 0]) {
      support1 (col,row,up,height,angle,thickness, scale);
    }
  }
  if (angle == 270) {
    translate ([PART_WIDTH(scale) + PART_WIDTH(scale) * (thickness-1), 0 , 0]) {
      support1 (col,row,up,height,angle,thickness, scale);
    }
  }
}


module support1 (col,row,up,height,angle,thickness, scale)
{
  height_mm = height * PART_HEIGHT(scale) ;
  length_mm = height * PART_WIDTH(scale) / 4;
  width_mm  = PART_WIDTH(scale)*thickness; 
  x_0         = col      * PART_WIDTH(scale); 
  y_0         = - (row   * PART_WIDTH(scale)); 
  z_0         = up       * PART_HEIGHT(scale);

  translate ([x_0, y_0 , z_0]) {    		
    rotate (a=angle, v=[0,0,1]) {
      polyhedron ( points = [[0, -width_mm, height_mm], [0, 0, height_mm], [0, 0, 0], [0, -width_mm, 0], [length_mm, -width_mm, height_mm], [length_mm, 0, height_mm]], faces = [[0,3,2], [0,2,1], [3,0,4], [1,2,5], [0,5,4], [0,1,5],  [5,2,4], [4,2,3], ]);
    }
  }
}


// --------------------- ramp

module ramp (col=0,row=0,up=0,height=FULL,angle=0,width=1,scale=LUGO)
{
     
     width_mm  = width * NO (scale);     
     if (angle == 0) {
	  translate ([0, -width_mm, 0]) {
	       ramp1 (col,row,up,height,angle,width,scale);
	  }
     }
     if (angle == 90) {
	  translate ([width_mm, 0 , 0]) {
	       ramp1 (col,row,up,height,angle,width,scale);
	  }
     }
     if (angle == 180) {
	  translate ([(width*width_mm)-2*width_mm, -width_mm , 0]) {
	       ramp1 (col,row,up,height,angle,width,scale);
	  }
     }
     if (angle == 270) {
	  translate ([width_mm, 0 , 0]) {
	       ramp1 (col,row,up,height,angle,width,scale);
	  }
     }
}

module ramp1 (col=0,row=0,up=0,height=HALF,angle=0,width=1,scale=LUGO)
{
  height_mm = height * PART_HEIGHT(scale);
  length_mm = height * PART_WIDTH(scale);
  width_mm  = width * NO (scale);
  x_0         = col      * PART_WIDTH(scale); 
  y_0         = - (row   * PART_WIDTH(scale)); 
  z_0         = up       * PART_HEIGHT(scale);

  translate ([x_0, y_0 , z_0]) {    		
    rotate (a=angle, v=[0,0,1]) {
      polyhedron ( points = [[0, -width_mm, height_mm], [0, width_mm, height_mm], [0, width_mm, 0], [0, -width_mm, 0], [length_mm, -width_mm, 0], [length_mm, width_mm, 0]], faces = [[0,3,2], [0,2,1], [3,0,4], [1,2,5], [0,5,4], [0,1,5],  [5,2,4], [4,2,3], ]);
    }
  }
}

// ------------------------------- Text module

module write (text="hello", col=0, row=0, up=0, rot=0, height=1, size=8, valign="top", halign="left", font="Liberation Sans,style=bold", scale=LUGO) {
     x_0 = col    * PART_WIDTH(scale);
     y_0 = - (row * PART_WIDTH(scale));
     z_0 = up     * PART_HEIGHT(scale);

     translate ([x_0, y_0, z_0]) {
	  rotate (rot) {
	       linear_extrude (height=height) {
		    text (text, font = font, size=size, valign=valign, halign=halign);
	       }
	  }
     }
}



//  ---------------------------------- Auxiliary modules ---------------------

module doblonibble(extra=false,filled=false,heightscale=1) {
  // Lego size does not have holes in the nibbles
   nb_r = NB_RADIUS(scale) + (extra ? DOBLOWALL(scale)/2.2 : 0);
   nb_r_i = NB_RADIUS_INSIDE(scale) + (extra ? DOBLOWALL(scale)/2.2 : 0);
  if (scale < 0.6 || filled) {
    cylinder(r=nb_r,           h=heightscale*NH(scale),  center=true,  $fs = NIBBLE_FS);
  } else {
    difference() {
      cylinder(r=nb_r,       h=heightscale*NH(scale),  center=true,  $fs = NIBBLE_FS);
      cylinder(r=nb_r_i,h=heightscale*NH(scale)+1,center=true,  $fs = NIBBLE_FS);
    }
  }
}

module doblobottomnibble(height_mm)
{
  difference() {
    cylinder(r=NB_BOTTOM_RADIUS(scale),        h=height_mm,  center=true,$fs = NIBBLE_FS);
    cylinder(r=NB_BOTTOM_RADIUS_INSIDE(scale), h=height_mm+1,center=true,$fs = NIBBLE_FS);
  }

}

module doblobottomnibble_thin(height_mm)
{
  cylinder(r=NB_BOTTOM_RADIUS_THIN(scale),        h=height_mm,  center=true,$fs = NIBBLE_FS);
  //cylinder(r=NB_BOTTOM_RADIUS_INSIDE(scale)/4, h=height_mm+1,center=true,$fs = NIBBLE_FS);

}

/*
  Hackey--should build shell separately and then insert bottom nibbles
  currently, has some holes. Even CW is duplo compatible, odd is offset .5
*/
module doblo_curve_down(col,row,up,width,length,height,nibbles,size,cw=1){
  difference(){
    block_curve_down(col,row,up,width,length,height,nibbles,size,cw=cw);
    translate([0,0,-0.01])difference(){
     block(col-cw/2,row,up,width+cw,length,height*2/3,false,size);
     doblo(col-cw/2,row,up,width+cw,length,height*2/3,false,false,size);
    }
  }
}

module doblo_curve_up(col,row,up,width,length,height,nibbles,size,cw=2,bottom_holes=true){
  difference(){
    union(){
      translate([-0.01,0,0])curve(col+width,row,up,cw,length,height,false,true,size);
      translate([0.01,0,0])curve(col-1,row,up,cw,length,height,true,true,size);
      doblo(col,row,up,width,length,height,nibbles,false,size);
     if(nibbles && cw>1){
        nibbles(col-floor(cw/2),row,up+height,floor(cw/2),length,size);
        nibbles(col+width,row,up+height,cw/2,length,size); 
      }
    }
    if (bottom_holes){
      nibbles(col+width,row,up,ceil(cw),length,DOBLO,filled=true,hscale=1.5);
      nibbles(col-ceil(cw),row,up,ceil(cw),length,DOBLO,filled=true,hscale=1.5);
    }
  }
}

module block_curve_down(col,row,up,width,length,height,nibbles,size,cw=1){
  //intersection(){
    union(){
      curve(col-1,row,up,cw,length,height,blockType=size);
      block(col,row,up,width,length,height,nibbles,size);
      curve(col+width,row,up,cw,length,height,blockType=size,xflip=false);
    }
  //  doblo(col,row,up,width,length,height,nibbles,false,size);
 // }

}

module curve(x=0,y=0,z=0,w=1,h=1,d=FULL,xflip=true,yflip=false,blockType=DOBLO){
  bwidth = DOBLOWIDTH(blockType)/blockType;
  bheight = PART_HEIGHT(blockType);
  offset = xflip ? -bwidth/2 : 0;
  boxoffset = xflip ? (1-w)*bwidth/2 : 0;
  zoff = yflip ? bheight*d : 0;

  translate([(x/2)*bwidth-offset,(-y/2)*bwidth,(z)*bheight])
    intersection(){
      translate([0,0,zoff])rotate([90,0,0])scale([1,bheight*d*2/(bwidth*w/2) ,1])cylinder(h=bwidth/2*h,r=w*bwidth/4);
      translate([boxoffset+offset,-bwidth/2*h-.05,0])cube([(w)*bwidth/2,h*bwidth/2+.1,bheight*d]);
    }
}
