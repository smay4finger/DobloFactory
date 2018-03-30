/* Castle kit, Lego and duplo compatible
Daniel.schneider@unige.ch
sept./dec. 2012
minor adaptions sept 2015 / feb 2017

Version 1.9
- modified into an extension to doblo-factory v2.0 by:
dmtaub@cemi.org
oct. 2012

Version 1.10
- All models re-calibrated for height. Usability improved, i.e. lego persona will fit into "rooms"
- added a new version of support (maybe move to doblo-factory ?)
daniel.schneider@unige.ch
dec. 2012

Version 1.11
- Made floors a bit higher since the 1.10 ones were too difficult to print correctly
- feb 2017

Instructions:
- print calibration first. If the piece doesn't fit, then act, i.e. cope with it or adjust the doblo-factory-x-y parameters
- print a chosen module by uncommenting (see below)

*/

/* DIMENSIONS and global parameters

* First floor height = 7*FULL (from base plate)
* Battlements        = 2*FULL
* Simple towers      = 9*FULL + THIRD
* Thickness (height) of base plates = 2*THIRD. With a good printer, THIRD can do.
*/

FLOOR_BOTTOM = 6*FULL+2*THIRD;    // bottom of a floor, typically add a THIRD platform
FLOOR_TOP    = 7*FULL;            // e.g. nibbles go here
WALL_BOTTOM  = 8*FULL+THIRD;      // this is wall_top - the base plate height
WALL_TOP     = 9*FULL;            // e.g. nibbles go here
INNER_WALL_TOP = FLOOR_BOTTOM-THIRD;  // e.g. inside of walls, nibbles go here
BASE_HEIGHT  = 2*THIRD;           // Height of the base plaform.

// -------------- support block (triangle )

// Support block for building platforms
// so bad ... :(
// NOTE: make the support block stick into something, else it may not print

module support_triangle (col,row,up,height,angle,thickness, scale)
// changed DKS, added easier strings
{
    if (angle == 0 || angle == "right") {
	translate ([0, 0, 0]) {
	    support_triangle1 (col,row,up,height,0,thickness, scale);
	}
    }
    else if (angle == 90 || angle == "back") {
	translate ([0, -PART_WIDTH(scale) , 0]) {
	    support_triangle1 (col,row,up,height,90,thickness, scale);
	}
    }
    else if (angle == 180 || angle == "left") {
	translate ([PART_WIDTH(scale), -PART_WIDTH(scale) - PART_WIDTH(scale)* (thickness-1) , 0]) {
	    support_triangle1 (col,row,up,height,180,thickness, scale);
	}
    }
    else if (angle == 270 || angle == "fore") {
	translate ([PART_WIDTH(scale) + PART_WIDTH(scale) * (thickness-1), 0 , 0]) {
	    support_triangle1 (col,row,up,height,270,thickness, scale);
	}
    }
    else {
	echo (str ("WARNING: Bad angle for the doblo support_triangle block", angle)) ;
    }
}

module support_triangle1 (col,row,up,height,angle,thickness, scale)
{
    // changed DKS
    // height_mm = height * PART_HEIGHT(scale) ;
    height_mm = height * (PART_HEIGHT(scale) + PART_HEIGHT(scale)/2 ) ;
    length_mm = height * PART_WIDTH(scale) / 4;
    width_mm  = PART_WIDTH(scale)*thickness; 
    x_0         = col      * PART_WIDTH(scale); 
    y_0         = - (row   * PART_WIDTH(scale)); 
    // z_0         = up       * PART_HEIGHT(scale);
    z_0         = up       * PART_HEIGHT(scale) ;

    translate ([x_0, y_0 , z_0]) {    		
	rotate (a=angle, v=[0,0,1]) {
	polyhedron ( points = [[0, -width_mm, height_mm], [0, 0, height_mm], [0, 0, 0], [0, -width_mm, 0], [length_mm, -width_mm, height_mm], [length_mm, 0, height_mm]], faces = [[0,3,2], [0,2,1], [3,0,4], [1,2,5], [0,5,4], [0,1,5],  [5,2,4], [4,2,3], ]);
	}
    }
}

// --------------- combi models -----------------

// if you got a really large print bed and a printer that can print for days
// Starts upper left corner (seen from top), then row by row

function BLOCK_SIZE(SCALE) = 8*PART_WIDTH(SCALE);
module large_example ()
{
    translate([-BLOCK_SIZE(SCALE), BLOCK_SIZE(SCALE), 0]) {
	 rotate (a=90, v=[0,0,1]) { corner_thin (); }};
    translate([0, BLOCK_SIZE(SCALE), 0]) { portal (); };
    translate([BLOCK_SIZE(SCALE), BLOCK_SIZE(SCALE), 0]) { wall_thin (); };
    translate([2*BLOCK_SIZE(SCALE), BLOCK_SIZE(SCALE), 0]) { corner_tower (SCALE); };
    // row 2
    translate([-BLOCK_SIZE(SCALE), 0, 0]) {
	rotate (a=90, v=[0,0,1]) wall_thin (); };
    base (SCALE);	
    translate([BLOCK_SIZE(SCALE), 0 ,0]) { base (); };
    translate([2*BLOCK_SIZE(SCALE), 0, 0]) {
	rotate (a=270, v=[0,0,1]) { wall_thin(); }};

    // row 3
    translate([-BLOCK_SIZE(SCALE), -BLOCK_SIZE(SCALE), 0]) {
	rotate (a=90, v=[0,0,1]) { wall_thin(); }};
    translate([0, -BLOCK_SIZE(SCALE), 0]) { pool (); };
    translate([BLOCK_SIZE(SCALE), -BLOCK_SIZE(SCALE), 0]) { tower(); };
    translate([2*BLOCK_SIZE(SCALE), -BLOCK_SIZE(SCALE), 0]) {
	rotate (a=270, v=[0,0,1]) { wall_thin (); }};
	
    // row 4
    translate([-BLOCK_SIZE(SCALE), -2*BLOCK_SIZE(SCALE), 0]) {
	rotate (a=180, v=[0,0,1]) { corner_thin (); }};
    translate([BLOCK_SIZE(SCALE)/2, -2*BLOCK_SIZE(SCALE), 0]) {
	rotate (a=180, v=[0,0,1]) wall_stairs_16_8 (); };
    # translate([2*BLOCK_SIZE(SCALE), -2*BLOCK_SIZE(SCALE), 0]) {
	rotate (a=270, v=[0,0,1]) corner_thin (); };

}

// ---------------- Models ----------------------


// --------------------------------------------------------------------------------
// --- Building and calibration aids

// to calibrate heights. I suggest to build with multiples of FULL + THIRD
// remove this for printing
module vert_scale (SCALE=SCALE) {
    translate ([0,0,0]) {
	//     (col, row, up,    width,length,height,nibbles_on_off, scale) 
	# doblo  (-7,  -1,  0,     2,  4,   BASE_HEIGHT,  true,  scale=SCALE);
	doblo  (-7,  -1,  0+BASE_HEIGHT,     1,  1,     FULL,  true,  scale=SCALE);
	doblo  (-7,  -1,  FULL+BASE_HEIGHT,  2,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  2*FULL+BASE_HEIGHT,1,  1,     FULL,  true,  scale=SCALE);
	doblo  (-7,  -1,  3*FULL+BASE_HEIGHT,2,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  4*FULL+BASE_HEIGHT,1,  1,     FULL,  true,  scale=SCALE);
	doblo  (-7,  -1,  5*FULL+BASE_HEIGHT,2,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  6*FULL+BASE_HEIGHT,1,  1,     FULL,  true,  scale=SCALE);
	# doblo  (-7,  -1,  FLOOR_TOP+BASE_HEIGHT,4,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  8*FULL+BASE_HEIGHT,1,  1,     FULL,  true,  scale=SCALE);
	# doblo  (-7,  -1,  WALL_TOP+BASE_HEIGHT, 4,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  10*FULL+BASE_HEIGHT,1,  1,     FULL,  true,  scale=SCALE);
	doblo  (-7,  -1,  11*FULL+BASE_HEIGHT,2,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  12*FULL+BASE_HEIGHT,1,  1,     FULL,  true,  scale=SCALE);
	doblo  (-7,  -1,  13*FULL+BASE_HEIGHT,2,  1,      FULL,  true, false, scale=SCALE );
	# doblo  (-7,  -1,  14*FULL+BASE_HEIGHT,4,  1,      FULL,  true, false, scale=SCALE );
    }
}

module vert_scale_full (SCALE=SCALE) {
    translate ([0,0,0]) {
	//     (col, row, up,    width,length,height,nibbles_on_off, scale) 
	# doblo  (-7,  -1,  0,     2,  4,   FULL,  true,  scale=SCALE);
	doblo  (-7,  -1,  FULL,  2,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  2*FULL,1,  1,     FULL,  true,  scale=SCALE);
	doblo  (-7,  -1,  3*FULL,2,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  4*FULL,1,  1,     FULL,  true,  scale=SCALE);
	doblo  (-7,  -1,  5*FULL,2,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  6*FULL,1,  1,     FULL,  true,  scale=SCALE);
	# doblo  (-7,  -1,  FLOOR_TOP,4,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  8*FULL,1,  1,     FULL,  true,  scale=SCALE);
	# doblo  (-7,  -1,  WALL_TOP, 4,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  10*FULL,1,  1,     FULL,  true,  scale=SCALE);
	doblo  (-7,  -1,  11*FULL,2,  1,      FULL,  true, false, scale=SCALE );
	doblo  (-7,  -1,  12*FULL,1,  1,     FULL,  true,  scale=SCALE);
	doblo  (-7,  -1,  13*FULL,2,  1,      FULL,  true, false, scale=SCALE );
	# doblo  (-7,  -1,  14*FULL,4,  1,      FULL,  true, false, scale=SCALE );
    }
}


// --- simple 4x2 lego brick
module calibration (SCALE=SCALE)
{
    //     (col, row, up, width,length,height,nibbles_on_off) 
    doblo   (0,   0,   0,   4,   2,    FULL,  true, false, scale=SCALE );
}

// --------------------------------------------------------------------------------
// --- base plates, both flat and legobase

module base (SCALE=SCALE)
{
    base_plate  (-4,  -4,   0,  8,   8,   BASE_HEIGHT,   false, scale=SCALE);
    nibbles  (-4,  -4,  BASE_HEIGHT,  8,   2, scale=SCALE);
    nibbles  (-4,  -2,  BASE_HEIGHT,  2,   4, scale=SCALE);
    nibbles  (-4,  2,   BASE_HEIGHT,  8,   2, scale=SCALE);
    nibbles  (2,  -2,   BASE_HEIGHT,  2,   4, scale=SCALE);
}

module base_legobase (SCALE=SCALE)
{
    doblo    (-4,  -4,  0,  8,   8,   BASE_HEIGHT,  false, scale=SCALE);
    nibbles  (-4,  -4,  BASE_HEIGHT,  8,   2, scale=SCALE);
    nibbles  (-4,  -2,  BASE_HEIGHT,  2,   4, scale=SCALE);
    nibbles  (-4,   2,  BASE_HEIGHT,  8,   2, scale=SCALE);
    nibbles  (2,   -2,  BASE_HEIGHT,  2,   4, scale=SCALE);
    nibbles  (-1,  -1,  BASE_HEIGHT,  2,   2, scale=SCALE);
}


module base_24 (SCALE=SCALE)
{
    base_plate (-12,  -12,   0,  24,   24,   BASE_HEIGHT,     true, scale=SCALE);
}

module base_16 (SCALE=SCALE)
{
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles  (-8,  -8,   BASE_HEIGHT,  16,   2, scale=SCALE);
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-8,  6,   BASE_HEIGHT,  16,   2, scale=SCALE);
    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-4,  -4,   BASE_HEIGHT,  8,   8, scale=SCALE);
}

// --------------------------------------------------------------------------------
// --- square towers
// The roof design is as ugly as it could get, but the printed result is fairly nice ;)

// --- Tower structure 
//     has to be put on a base or lego-base platform
//     zcorr allows to make lego-based towers a THIRD smaller

module tower_structure (SCALE=SCALE) {    

    // corner towers
    cyl_block   (-4, -4,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=SCALE) ;
    cyl_block   (2,  -4,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=SCALE) ;
    cyl_block   (-4,  2,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=SCALE) ;
    cyl_block   (2,   2,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=SCALE) ;

    // nibbles on top of corner towers
    nibbles (-4,  -4, WALL_TOP,  2,   2, scale=SCALE);
    nibbles (2,  2,   WALL_TOP,   2,   2, scale=SCALE);
    nibbles (2,  -4,  WALL_TOP,  2,   2, scale=SCALE);
    nibbles (-4, 2,   WALL_TOP,  2,   2, scale=SCALE);

    // platform on top
    block       (-3,  -3, FLOOR_BOTTOM,  6,   6,  THIRD,  false, scale=SCALE);
    nibbles     (-2,  -2, FLOOR_TOP,  4,   4, scale=SCALE);
    nibbles     (-4,  -1, FLOOR_TOP,  2,   2, scale=SCALE);

    // walls on top and support_triangle underneath
    block       (-4, -3, FLOOR_BOTTOM,  1,   2,  2*FULL+THIRD,  false, scale=SCALE);
    block       (-4,  1, FLOOR_BOTTOM,  1,   2,  2*FULL+THIRD,  false, scale=SCALE);
    block       (-4, -1, FLOOR_BOTTOM,  1,   2,  THIRD,  false, scale=SCALE);

    color ("green") support_triangle   (-4.5,-3, FLOOR_BOTTOM-HALF,  2,  180, 6, scale=SCALE);
    nibbles     (-4, -2, WALL_TOP,  1,  1, scale=SCALE);
    nibbles     (-4,  1, WALL_TOP,  1,  1, scale=SCALE);

    block       (3,  -3, FLOOR_BOTTOM,  1,   6,    2*FULL+THIRD,     false, scale=SCALE);
    support_triangle     (3.5,  -3, FLOOR_BOTTOM-HALF,  2,    0, 6, scale=SCALE);
    nibbles     (3,  -2, WALL_TOP,  1,   4, scale=SCALE);

    block       (-3, -4, FLOOR_BOTTOM,  6,  1.01,    2*FULL+THIRD,     false, scale=SCALE);
    support_triangle     (-3, -4.5, FLOOR_BOTTOM-HALF,  2,  90, 6, scale=SCALE);
    nibbles     (-2, -4, WALL_TOP,  4,   1, scale=SCALE);

    # block       (-3, 3, FLOOR_BOTTOM,  6,  1.01,    2*FULL+THIRD,     false, scale=SCALE);
    support_triangle   (-3, 3.5, FLOOR_BOTTOM-HALF,  2,  270, 6, scale=SCALE);
    nibbles     (-2, 3, WALL_TOP,  4,   1, scale=SCALE);

    // towers for 2 walls
    cyl_block  (-1, 2,  BASE_HEIGHT,  2,  2,  FLOOR_BOTTOM-THIRD,     false, scale=SCALE);
    cyl_block  (-1, -4, BASE_HEIGHT,  2,  2, FLOOR_BOTTOM-THIRD,     false, scale=SCALE);

    // support_triangle for the platform on top
    //        (col, row, up, height,degrees) 

    // support_triangle along y axis

    color ("yellow") support_triangle (-3.5, -2.5, FLOOR_BOTTOM-2.5*FULL,   10,   "fore", 1, scale=SCALE) ;
    support_triangle (-3.5, 1.5,  FLOOR_BOTTOM-2.5*FULL,   10,   "back", 1, scale=SCALE) ;

    support_triangle (-0.75, -2.5, FLOOR_BOTTOM-2.5*FULL,   10,   "fore", 1.5, scale=SCALE) ;
    support_triangle (-0.75, 1.5,  FLOOR_BOTTOM-2.5*FULL,   10,   "back", 1.5, scale=SCALE) ;

    support_triangle (2.5, -2.5, FLOOR_BOTTOM-2.5*FULL,   10,   "fore", 1, scale=SCALE) ;
    support_triangle (2.5, 1.5,  FLOOR_BOTTOM-2.5*FULL,   10,   "back", 1, scale=SCALE) ;

    // diagonal support_triangle
    support_triangle1 (-2.25, -3,  FLOOR_BOTTOM-2.5*FULL,   10,   315, 1, scale=SCALE) ;
    support_triangle1 (-3,   2.25, FLOOR_BOTTOM-2.5*FULL,   10,   45, 1, scale=SCALE) ;
    support_triangle1 (3.0, -2.25, FLOOR_BOTTOM-2.5*FULL,   10,   225, 1, scale=SCALE) ;
    support_triangle1 (2.25, 3.0,  FLOOR_BOTTOM-2.5*FULL,   10,   135, 1, scale=SCALE) ;
    // support_triangle along x-axis - non-standard width to avoid non-simple models
    support_triangle1 (-2.4, -3.5, FLOOR_BOTTOM-2.5*FULL+0.1,   10.2,   0, 1.1, scale=SCALE) ;
    support_triangle1 (-2.4, 2.4,  FLOOR_BOTTOM-2.5*FULL+0.1,   10.2,   0, 1.1, scale=SCALE) ;
    support_triangle1 (2.6, -2.4,  FLOOR_BOTTOM-2.5*FULL+0.1,   10.2,   180, 1.1, scale=SCALE) ;
    support_triangle1 (2.6, 3.5,   FLOOR_BOTTOM-2.5*FULL+0.1,   10.2,   180, 1.1, scale=SCALE) ;
}

// ---- tower on 8x8 basis
module tower (SCALE=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles     (-4,  -2,  BASE_HEIGHT,  8,   4, scale=SCALE);
    tower_structure (SCALE=SCALE);
}


// ---- tower on 16x16 basis
module tower_16 (SCALE=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles  (-8,  -8,   BASE_HEIGHT,  16,   2, scale=SCALE);
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-8,  6,   BASE_HEIGHT,  16,   2, scale=SCALE);
    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-6,  -2,   BASE_HEIGHT,  2,   4, scale=SCALE);
    nibbles  (4,  -2,   BASE_HEIGHT,  2,   4, scale=SCALE);
    nibbles  (-4,  -2,  BASE_HEIGHT,  8,   4, scale=SCALE);
    tower_structure (SCALE=SCALE);
}


// ---- Stackable tower, a bit more difficult to print correctly

module tower_legobase (SCALE=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles     (-4,  -2,  BASE_HEIGHT,  8,   4, scale=SCALE);
    tower_structure (SCALE);
}


// -------------------------------------------------------------------------------
// --- corner tower

module corner_tower_structure (SCALE=SCALE) 
{
    // corner towers
    cyl_block   (2,  -4,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=SCALE) ;
    cyl_block   (-4,  2,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=SCALE) ;

    // platform on top
    block       (-4,  -3, FLOOR_BOTTOM,  7,   7,  THIRD,  false, scale=SCALE);
    nibbles     (-2,  -1, FLOOR_TOP,  5,   5, scale=SCALE);
    nibbles     (-4,  -1, FLOOR_TOP,  2,   3, scale=SCALE);
    nibbles     (-4,  -3, FLOOR_TOP,  6,   2, scale=SCALE);

    // small support along top platform
    support_triangle   (-4.5,-3, 6*FULL+1,  2,  180, 7, scale=SCALE);
    support_triangle   (-4, 3.5, 6*FULL+1,  2,  270, 7, scale=SCALE);

    // wall right
    block       (3,  -3, BASE_HEIGHT,  1,   7,   WALL_BOTTOM,     false, scale=SCALE);
    nibbles     (3, -2, WALL_TOP,  1,   6, scale=SCALE);

    // wall back
    block       (-4, -4, BASE_HEIGHT,  7,  1,    WALL_BOTTOM,     false, scale=SCALE);
    nibbles     (-4, -4, WALL_TOP,  6,   1, scale=SCALE);

    // nibbles on top of "mini towers"
    nibbles (2,  -4,   WALL_TOP,   2,   2, scale=SCALE);
    nibbles (-4,  2,   WALL_TOP,   2,   2, scale=SCALE);

    // support_triangle for the platform on top
    //        (col, row, up, height,degrees) 

    // support_triangle along y axis
    support_triangle (-4, -3.5, 3*FULL+THIRD,   2*FULL+THIRD,   "fore", 1, scale=SCALE) ;
    support_triangle (-2, -3.5, 3*FULL+THIRD,   2*FULL+THIRD,   "fore", 1, scale=SCALE) ;
    support_triangle (0, -3.5, 3*FULL+THIRD,   2*FULL+THIRD,   "fore", 1, scale=SCALE) ;
    support_triangle (-4, 2,  3*FULL+THIRD,   2*FULL+THIRD,   "back", 1, scale=SCALE) ;

    // diagonal support_triangle - FIX THIS - TODO

    support_triangle1 (-3,   2.25, 3*FULL+THIRD,   2*FULL+THIRD,   45, 1, scale=SCALE) ;

    // support_triangle along x-axis
    support_triangle1 (-3, 3,  3*FULL+THIRD,   2*FULL+THIRD,   0, 1, scale=SCALE) ;
    support_triangle1 (3, 4,   3*FULL+THIRD,   2*FULL+THIRD,   180, 1, scale=SCALE) ;
    support_triangle1 (3, 2,   3*FULL+THIRD,   2*FULL+THIRD,   180, 1, scale=SCALE) ;
    support_triangle1 (3, 0,  3*FULL+THIRD,   2*FULL+THIRD,   180, 1, scale=SCALE) ;
    support_triangle1 (3, -2,  3*FULL+THIRD,   2*FULL+THIRD,   180, 1, scale=SCALE) ;
}


module corner_tower (SCALE=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles     (-4,  -2,  BASE_HEIGHT,  7,   4, scale=SCALE);
    nibbles     (-2,  2,  BASE_HEIGHT,  5,   2, scale=SCALE);
    corner_tower_structure (SCALE);
}

module corner_tower_legobase (SCALE=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles     (-4,  -2,  BASE_HEIGHT,  7,   4, scale=SCALE);
    nibbles     (-2,  2,  BASE_HEIGHT,  5,   2, scale=SCALE);
    corner_tower_structure (0);
}


// --------------------------------------------------------------------------------
// --- Round tower 


module tower_round_structure (SCALE=SCALE)
{
    $fs = 0.1;
    $fa = 4;

    difference () {
	// tower structure
	union () {
	    difference () {
		cyl_block   (-4,  -4,  BASE_HEIGHT,  8,    8,   WALL_BOTTOM,   false, scale=SCALE) ;
		// carve it out
		cyl_block (-3,    -3,   1,  6,    6,     15*FULL,   false, scale=SCALE) ;
		// holes in the wall on top
		block   (-6, -1,  FLOOR_TOP,  10,    2,     3*FULL,   false, scale=SCALE) ;
		block   (-1, -6,  8*FULL,  2,    10,     3*FULL,   false, scale=SCALE) ;
	    }
	    // platform on top
	    difference () {
		cyl_block (-3,  -3,  4*FULL,  6,    6,  3*FULL,   false, scale=SCALE) ;
		cyl_block (-3,  -3,  3.99*FULL,  6, 1,  3*FULL-THIRD,   false, scale=SCALE) ;
	    }
	}
	// windows
	house_fb   (-0.5, -5,  16,  1,    10,  2*FULL, scale=SCALE) ;
	// doors, uses a "house form"
	//         (col, row, up, width,length,height, scale) 
	house_lr   (-5, -1.5,   1,  10,    3,  5*FULL, scale=SCALE) ;
    }
    nibbles (-2,  -2, FLOOR_TOP,  4,   4, scale=SCALE);
    nibbles (-4,  -1, FLOOR_TOP,  2,   2, scale=SCALE);
    nibbles (2,  -1, FLOOR_TOP,  2,   2, scale=SCALE);
    nibbles (-3,  -3, WALL_TOP,  1,   1, scale=SCALE);
    nibbles (2,  2, WALL_TOP,  1,   1, scale=SCALE);
    nibbles (2,  -3, WALL_TOP,  1,   1, scale=SCALE);
    nibbles (-3, 2 , WALL_TOP,  1,   1, scale=SCALE);
}

// --- round tower
module tower_round (SCALE=SCALE) {
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    nibbles (-4,  -1, BASE_HEIGHT,  8,   2, scale=SCALE);
    nibbles (-4,  -4, BASE_HEIGHT,  1,   1, scale=SCALE);
    nibbles (-4,   3, BASE_HEIGHT,  1,   1, scale=SCALE);
    nibbles (3,    3, BASE_HEIGHT,  1,   1, scale=SCALE);
    nibbles (3,   -4, BASE_HEIGHT,  1,   1, scale=SCALE);
    tower_round_structure (SCALE) ;
}

module tower_round_16 (SCALE=SCALE) {
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles  (-8,  -8,   BASE_HEIGHT,  16,   2, scale=SCALE);
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-8,  6,   BASE_HEIGHT,  16,   2, scale=SCALE);
    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-6,  -2,   BASE_HEIGHT,  2,   4, scale=SCALE);
    nibbles  (4,  -2,   BASE_HEIGHT,  2,   4, scale=SCALE);
    nibbles  (-4,  -1,  BASE_HEIGHT,  8,   2, scale=SCALE);
    tower_round_structure (SCALE) ;
}

// --- round tower, legobase
module tower_round_legobase (SCALE=SCALE) {
    doblo       (-4,  -4,   0,      8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    nibbles (-4,  -1, BASE_HEIGHT,  8,   2, scale=SCALE);
    nibbles (-4,  -4, BASE_HEIGHT,  1,   1, scale=SCALE);
    nibbles (-4,   3, BASE_HEIGHT,  1,   1, scale=SCALE);
    nibbles (3,    3, BASE_HEIGHT,  1,   1, scale=SCALE);
    nibbles (3,   -4, BASE_HEIGHT,  1,   1, scale=SCALE);
    tower_round_structure (0) ;
}


// --------------------------------------------------------------------------------
// --- Round tower with corner towers, thinner walls than round tower

module tower_round_square_structure (SCALE=SCALE)
{
    $fs = 0.1;
    $fa = 4;

    // corner towers
    cyl_block   (-4, -4,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=SCALE) ;
    cyl_block   (2,  -4,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=SCALE) ;
    cyl_block   (-4,  2,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=SCALE) ;
    cyl_block   (2,   2,  BASE_HEIGHT,  2,     2,    WALL_BOTTOM,   false, scale=SCALE) ;

    difference () {
	// tower structure
	union () {
	    difference () {
		cyl_block   (-4,  -4,  BASE_HEIGHT,  8,    8,   WALL_BOTTOM,   false, scale=SCALE) ;
		// carve it out
		cyl_block (-3.5,  -3.5,   1,  7,    7,     15*FULL,   false, scale=SCALE) ;
		// holes in the wall on top
		block   (-6, -1,  FLOOR_TOP,  10,    2,     3*FULL,   false, scale=SCALE) ;
		block   (-1, -6,  8*FULL,  2,    10,     3*FULL,   false, scale=SCALE) ;
	    }
	    // platform on top
	    difference () {
		cyl_block (-3.5,  -3.5,  4*FULL,  7,    7,  3*FULL,   false, scale=SCALE) ;
		cyl_block (-3.5,  -3.5,  3.99*FULL,  7, 1,  3*FULL-THIRD,   false, scale=SCALE) ;
	    }
	}
	// windows
	house_fb   (-0.5, -5,  THIRD+2*FULL,  1,  10,  3*FULL, scale=SCALE) ;
	// doors, uses a "house form"
	//         (col, row, up, width,length,height, scale) 
	house_lr   (-5, -1.5,   1,  10,    3,  5*FULL, scale=SCALE) ;
    }
    nibbles (-2,  -2, FLOOR_TOP,  4,   4, scale=SCALE);
    nibbles (-4,  -1, FLOOR_TOP,  8,   2, scale=SCALE);
    nibbles (-1,  -3, FLOOR_TOP,  2,   6, scale=SCALE);

    nibbles (-4,  -4, WALL_TOP,  2,   2, scale=SCALE);
    nibbles (2,  2,   WALL_TOP,   2,   2, scale=SCALE);
    nibbles (2,  -4,  WALL_TOP,  2,   2, scale=SCALE);
    nibbles (-4, 2,   WALL_TOP,  2,   2, scale=SCALE);

}

module tower_round_square (SCALE=SCALE) {
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    nibbles (-4,  -1, BASE_HEIGHT,  8,   2, scale=SCALE);
    tower_round_square_structure (SCALE);
}

module tower_round_square_16 (SCALE=SCALE) {
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles  (-8,  -8,   BASE_HEIGHT,  16,   2, scale=SCALE);
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-8,  6,   BASE_HEIGHT,  16,   2, scale=SCALE);
    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-6,  -2,   BASE_HEIGHT,  2,   4, scale=SCALE);
    nibbles  (4,  -2,   BASE_HEIGHT,  2,   4, scale=SCALE);
    nibbles  (-4,  -1,  BASE_HEIGHT,  8,   2, scale=SCALE);
    tower_round_square_structure (SCALE);
}


module tower_round_square_legobase (SCALE=SCALE) {
    doblo       (-4,  -4,   0,      8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    nibbles (-4,  -1, BASE_HEIGHT,  8,   2, scale=SCALE);
    tower_round_square_structure (0);
}



// --------------------------------------------------------------------------------
// --- To stack on tower-round_square above or on a plate

module tower_round_square_element (SCALE=SCALE)
{
    $fs = 0.1;
    $fa = 4;

    // corner towers
    cyl_block   (-4, -4,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=SCALE) ;
    cyl_block   (2,  -4,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=SCALE) ;
    cyl_block   (-4,  2,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=SCALE) ;
    cyl_block   (2,   2,  BASE_HEIGHT,  2,     2,    WALL_BOTTOM,   false, scale=SCALE) ;

    # doblo (-4, -4,  0,  2,    2,     BASE_HEIGHT,   false, scale=SCALE) ;
    doblo   (2,  -4,  0,  2,    2,     BASE_HEIGHT,   false, scale=SCALE) ;
    doblo   (-4,  2,  0,  2,    2,     BASE_HEIGHT,   false, scale=SCALE) ;
    doblo   (2,   2,  0,  2,     2,    BASE_HEIGHT,   false, scale=SCALE) ;

    
    difference () {
	// tower structure
	union () {
	    difference () {
		cyl_block   (-4,  -4,  0,  8,    8,   WALL_BOTTOM+BASE_HEIGHT,   false, scale=SCALE) ;
		// carve it out
		cyl_block (-3.5,  -3.5,   -1,  7,    7,     15*FULL,   false, scale=SCALE) ;
		// holes in the wall on top
		block   (-6, -1,  FLOOR_TOP,  10,    2,     3*FULL,   false, scale=SCALE) ;
		block   (-1, -6,  8*FULL,  2,    10,     3*FULL,   false, scale=SCALE) ;


		// This will allow stacking the tower on a normal lego plate
		block (-4, -4,  -BASE_HEIGHT,  8,    8,     BASE_HEIGHT,   true, scale=SCALE) ;
		// Create space for inserting the blocks above
		block (-4, -4,  -0.01,  2,    2,     BASE_HEIGHT,   false, scale=SCALE) ;
		block   (2,  -4, -0.01,  2,    2,     BASE_HEIGHT,   false, scale=SCALE) ;
		block   (-4,  2,  -0.01,  2,    2,     BASE_HEIGHT,   false, scale=SCALE) ;
		block   (2,   2,  -0.01,  2,     2,    BASE_HEIGHT,   false, scale=SCALE) ;
	    }
	    // platform on top
	    difference () {
		cyl_block (-3.5,  -3.5,  4*FULL,  7,    7,  3*FULL,   false, scale=SCALE) ;
		cyl_block (-3.5,  -3.5,  3.99*FULL,  7, 1,  3*FULL-THIRD,   false, scale=SCALE) ;
	    }
	}
	// windows
	house_fb   (-0.5, -5,  THIRD+2*FULL,  1,  10,  3*FULL, scale=SCALE) ;
	// doors, uses a "house form"
	//         (col, row,   up,   width,length,height, scale) 
	# house_lr  (-5, -1.75,  -0.1,  10,    3.5,  5*FULL, scale=SCALE) ;
    }
    nibbles (-2,  -2, FLOOR_TOP,  4,   4, scale=SCALE);
    nibbles (-4,  -1, FLOOR_TOP,  8,   2, scale=SCALE);
    nibbles (-1,  -3, FLOOR_TOP,  2,   6, scale=SCALE);

    nibbles (-4,  -4, WALL_TOP,  2,   2, scale=SCALE);
    nibbles (2,  2,   WALL_TOP,   2,   2, scale=SCALE);
    nibbles (2,  -4,  WALL_TOP,  2,   2, scale=SCALE);
    nibbles (-4, 2,   WALL_TOP,  2,   2, scale=SCALE);

}

// ----------------------------------- Wizard tower

// similar but not same tower with legobase
module wizard_tower_structure (SCALE=SCALE)
{
    // bottom nibbles - see the functions that call

    // 2nd floor nibbles
    nibbles     (-3,  -1,  FLOOR_TOP,  6,   2, scale=SCALE);

    // top nibbles
    nibbles     (-2,  -1,  14*FULL,  4,  2, scale=SCALE);
    nibbles     (-1,  -2,  14*FULL,  2,  1, scale=SCALE);
    nibbles     (-1,  1,   14*FULL,  2,  1, scale=SCALE);

    // tower geometry
    height_top = 16*FULL * PART_HEIGHT(SCALE);
    up     = 2*PART_HEIGHT(SCALE);
    radius = 3*PART_WIDTH(SCALE);

    difference () {
	translate ([0,0,up]) {
	    linear_extrude(height=height_top, center = false, convexity = 5, twist = 360, slices=12) {
		// square ([length,width], center=true);
		circle (r=radius, center=true);
	    }   
	}
	//         (col, row,      up, width,length,height) 
	// bottom
	house_lr   (-5.5, -1.5,   THIRD,  10,    3,    5*FULL, scale=SCALE) ;
	# house_fb   (-1.5, -2,   THIRD,  3,     4,    5*FULL , scale=SCALE); // inside
	// bottom window
	# house_fb   (-0.5, -5.75,  2*FULL,  1,    10,   3*FULL, scale=SCALE) ;
	// 2nd floor
	house_lr   (-5.5, -1.5,   FLOOR_TOP,  10,   3,    5*FULL, scale=SCALE) ;
	house_fb   (-0.5, -5.75,  8*FULL,  1,    10,   3*FULL, scale=SCALE) ;
	house_fb   (-1.5, -2,   FLOOR_TOP,  3,     4,    5*FULL , scale=SCALE); // inside
	// top
	cyl_block (-2.25, -2.25,   14*FULL,  4.5,    4.5,   24,   false, scale=SCALE) ;
	house_lr   (-5.5, -0.75,  14*FULL,  10,    1.5,    15, scale=SCALE) ;
	house_fb (-0.5, -5.75,  14*FULL,  1,    10,    15, scale=SCALE) ;
    }
}

module wizard_tower (SCALE=SCALE)
{
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles     (-4,  -1,   BASE_HEIGHT,  8,   2, scale=SCALE);
    nibbles  (-4, -4,   BASE_HEIGHT,  2,   2, scale=SCALE);
    nibbles  (2,  -4,   BASE_HEIGHT,  2,   2, scale=SCALE);
    nibbles  (2,   2,   BASE_HEIGHT,  2,   2, scale=SCALE);
    nibbles  (-4,  2,   BASE_HEIGHT,  2,   2, scale=SCALE);
    wizard_tower_structure (SCALE);
}


module wizard_tower_legobase (SCALE=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-3,  -3,   0,  6,   6,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles     (-3,  -1,   BASE_HEIGHT,  6,   2, scale=SCALE);
    nibbles  (-3,  -3, BASE_HEIGHT,  1,   1, scale=SCALE);
    nibbles  (2,  -3,  BASE_HEIGHT,  1,   1, scale=SCALE);
    nibbles  (2,  2,   BASE_HEIGHT,  1,   1, scale=SCALE);
    nibbles  (-3,  2,  BASE_HEIGHT,  1,   1, scale=SCALE);
    wizard_tower_structure (0);
}

// ------------------ bricks for tower building

// --- tower floor module, can be stacked, also on base

module tower_floor_legobase (SCALE=SCALE)
{
    //       (col, row, up, width,length,height,nibbles_on_off) 
    block    (-4,  -4, FLOOR_BOTTOM-THIRD,  8,   8,    THIRD+THIRD,     true, scale=SCALE);

    // towers, 3 on two sides
    block   (-4, -4,  2,  2,    2,     FLOOR_BOTTOM,   false, scale=SCALE) ;
    doblo   (-4, -4,  0,  2,    2,     2,   false, scale=SCALE) ;

    block   (-1, -4,  2,  2,    2,     FLOOR_BOTTOM,   false, scale=SCALE) ;
    doblo   (-1, -4,  0,  2,    2,     2,   false, scale=SCALE) ;

    block   (2,  -4,  2,  2,    2,     FLOOR_BOTTOM,   false, scale=SCALE) ;
    doblo   (2,  -4,  0,  2,    2,     2,   false, scale=SCALE) ;

    block   (-4,  2,  2,  2,    2,     FLOOR_BOTTOM,   false, scale=SCALE) ;
    doblo   (-4,  2,  0,  2,    2,     2,   false, scale=SCALE) ;

    block   (-1,  2,  2,  2,    2,     FLOOR_BOTTOM,   false, scale=SCALE) ;
    doblo   (-1,  2,  0,  2,    2,     2,   false, scale=SCALE) ;

    block   (2,   2,  2,  2,    2,     FLOOR_BOTTOM,   false, scale=SCALE) ;
    doblo   (2,   2,  0,  2,    2,     2,   false, scale=SCALE) ;

    // support_triangle
    support_triangle (-4, 1, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,    90, 2, scale=SCALE);
    support_triangle (-1, 1, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,    90, 2, scale=SCALE);
    support_triangle (2, 1, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,     90, 2, scale=SCALE);
    support_triangle (-4, -2, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,    270, 2, scale=SCALE);
    support_triangle (-1, -2, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,    270, 2, scale=SCALE);
    support_triangle (2, -2, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,     270, 2, scale=SCALE);

    support_triangle1 (-2.5, -4, 1*FULL,   8,   0, 2, scale=SCALE) ;
    support_triangle1 (-2.5, 2, 1*FULL,   8,   0, 2, scale=SCALE) ;
    support_triangle1 (2.5, -2, 1*FULL,   8,   180, 2, scale=SCALE) ;
    support_triangle1 (2.5, 4, 1*FULL,   8,   180, 2, scale=SCALE) ;

    // small support_triangles
    support_triangle1 (-2.5, -4, 5*FULL,   7,   0, 2, scale=SCALE) ;
    support_triangle1 (-2.5, 2, 5*FULL,   7,   0, 2, scale=SCALE) ;
    support_triangle1 (2.5, -2, 5*FULL,   7,   180, 2, scale=SCALE) ;
    support_triangle1 (2.5, 4, 5*FULL,   7,   180, 2, scale=SCALE) ;

}

// --- tower floor module, can be stacked, also on base

module tower_roof_legobase (SCALE=SCALE)
{
    //       (col, row, up, width,length,height,nibbles_on_off) 

    // towers, 3 on two sides

    difference () {
	union () {
	    doblo   (-4, -4,  0,  8,    2,     BASE_HEIGHT,   true, scale=SCALE) ;
	    block  (-4, -4,  BASE_HEIGHT,  8,    1,     2*FULL,   false, scale=SCALE) ;
	    
	    doblo   (-4,  2,  0,  8,    2,     BASE_HEIGHT,   true, scale=SCALE) ;
	    block   (-4,  3,  BASE_HEIGHT,  8,    1,     2*FULL,   false, scale=SCALE) ;
	    
	    // house on top
	    difference () {
		//         (col, row, up, width,length,height) 
		 color ("yellow") house_lr  (-4, -4,  1*FULL,  8,    8,  3*FULL-THIRD, scale=SCALE) ;
		 house_lr  (-5, -3,  0.5*FULL,  10,   6,  3*FULL-THIRD, scale=SCALE) ;
	    }
	}
	// windows
	color ("green") house_fb  (-2, -5, BASE_HEIGHT,  1,  10,   2*FULL , scale=SCALE);
	house_fb  (1, -5,  BASE_HEIGHT,  1,  10,    2*FULL , scale=SCALE);
    }
    block   (-4,  -1,  FLOOR_BOTTOM-FULL,  8,   2,  FULL+THIRD,   true, scale=SCALE) ;
    
    // pillar in the middle - takes too much space
    /*
      doblo   (-1,  -1,  0 ,  2,   2,  2,   true, scale=SCALE) ;
      support_triangle (-1,  1 , 11,  8,     270, 2, scale=SCALE);
      support_triangle (-1,  -2 , 11,  8,     90, 2, scale=SCALE);
      block   (-1,  -1,  2 ,  2,   2,  26,   true, scale=SCALE) ;
    */
}

// --- floor_pillars, stackable plate with pillars
// print the first layer real slow and calibrate openscad first !

module pillars_legobase (SCALE=SCALE)
{
    //       (col, row, up, width,length,height,nibbles_on_off) 
    doblo    (-4,  -4, 0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles  (-4,  -2, BASE_HEIGHT,  8,   4, scale=SCALE);
    nibbles  (-2,  -4, BASE_HEIGHT,  4,   2, scale=SCALE);
    nibbles  (-2,  2, BASE_HEIGHT,  4,   2, scale=SCALE);

    // towers, in four corners
    block   (-4, -4,  BASE_HEIGHT,  2,    2,     FLOOR_TOP-BASE_HEIGHT,   true, scale=SCALE) ;
    block   (2,  -4,  BASE_HEIGHT,  2,    2,     FLOOR_TOP-BASE_HEIGHT,   true, scale=SCALE) ;
    block   (-4,  2,  BASE_HEIGHT,  2,    2,     FLOOR_TOP-BASE_HEIGHT,   true, scale=SCALE) ;
    block   (2,   2,  BASE_HEIGHT,  2,    2,     FLOOR_TOP-BASE_HEIGHT,   true, scale=SCALE) ;

}


// -------------------------------- Walls and corners

// -------- battlements go on top of various walls
module battlements (SCALE=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    block       (-4,  -4,   INNER_WALL_TOP,  8,   2,   4 ,     false, scale=SCALE);
    block       (-4,  -4,   FLOOR_TOP,  8,   1,   FULL ,     false, scale=SCALE);	
    block       (-4,  -4,   FLOOR_TOP,  2,   1,   2*FULL ,     true, scale=SCALE);
    block       (-1,  -4,   FLOOR_TOP,  2,   1,   2*FULL ,     true, scale=SCALE);
    block       ( 2,  -4,   FLOOR_TOP,  2,   1,   2*FULL ,     true, scale=SCALE);
    nibbles     (-2,  -4,   FLOOR_TOP+FULL,  1,   1, scale=SCALE);
    nibbles     (1,  -4,    FLOOR_TOP+FULL,  1,   1, scale=SCALE);
    nibbles     (-4,  -3,   FLOOR_TOP,  8,   1, scale=SCALE);
}

// ----------------- Simple wall

module wall_structure (SCALE=SCALE)
{
    // the wall
    block       (-4,  -4,   BASE_HEIGHT,  8,   2,   FLOOR_BOTTOM-THIRD,     false, scale=SCALE);
    battlements (SCALE);
}

module wall (SCALE=SCALE) {
   //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles     (-4,  -2,   BASE_HEIGHT,  8,   6, scale=SCALE);
    wall_structure (SCALE);
}

module wall_legobase (SCALE=SCALE) {
   //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-4,  -4,   0,  8,   2,    BASE_HEIGHT,     false, scale=SCALE);
    wall_structure (0);
}


// ----------------- wall

module wall_thin_structure (SCALE=SCALE)
{
    // the wall
    block       (-4,  -4,   BASE_HEIGHT,  8,   1,   FLOOR_TOP+2*THIRD ,     false, scale=SCALE); // long outer wall
    // pillars for the wall
    block       (-4,  -3,   BASE_HEIGHT,  1,   1,   FLOOR_BOTTOM-THIRD ,     false, scale=SCALE);
    block       (-1,  -3,   BASE_HEIGHT,  2,   1,   FLOOR_BOTTOM-THIRD ,     false, scale=SCALE);
    block       (3,  -3,   BASE_HEIGHT,  1,   1,   FLOOR_BOTTOM-THIRD ,     false, scale=SCALE);
    support_triangle     (-3,  -3,   32,  4,   270,   2, scale=SCALE) ;
    support_triangle     (1,  -3,   32,  4,   270,   2, scale=SCALE) ;
    // small blocks on top
    battlements (SCALE);
}

module wall_thin (SCALE=SCALE) {
   //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles     (-4,  -2,   BASE_HEIGHT,  8,   6, scale=SCALE);
    wall_thin_structure (SCALE);
}

module wall_thin_legobase (SCALE=SCALE) {
   //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles     (-4,  -2,   BASE_HEIGHT,  8,   6, scale=SCALE);
    wall_thin_structure (0);
}


// ----------------- wall on a 16x16 base

module wall_thin_16 (SCALE=SCALE)
{
   //          (col, row, up, width,length,height,nibbles_on_off, scale=SCALE) 
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=SCALE);
    // 2* the small wall
    translate ([-4*PART_WIDTH(SCALE),4*PART_WIDTH(SCALE),0]) {
	wall_thin_structure (SCALE);
    }
    translate ([4*PART_WIDTH(SCALE),4*PART_WIDTH(SCALE),0]) {
	wall_thin_structure (SCALE);
    }

    // nibbles on the plate
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-8,  6,   BASE_HEIGHT,  16,   2, scale=SCALE);
    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-4,  -4,   BASE_HEIGHT,  8,   8, scale=SCALE);
}

// --------- Wall with stairs - 16 long

module wall_stairs_16_8_structure (SCALE=SCALE)
{
    // the wall
    block       (-8,  -4,   BASE_HEIGHT,   16,   1,   FLOOR_TOP+2*THIRD,     false, scale=SCALE);
    // inner block on top
    block       (-8,  -3,   FLOOR_BOTTOM,  16,   1,   THIRD ,     false, scale=SCALE);
    nibbles     (-8,  -3,   FLOOR_TOP,  16,   1, scale=SCALE);

    // stairs
    // 1
    block       (-6,  -3,   BASE_HEIGHT,  2,   2,   THIRD ,     true, scale=SCALE);

    //2
    block       (-4,  -3,   FULL+2*THIRD,  2,   2,   THIRD,     true, scale=SCALE);
    block       (-4,  -2,   BASE_HEIGHT,  2,   1,   FULL+THIRD,     false, scale=SCALE);
    //          col  row   up  height, deg, width
    support_triangle     (-4,  -3,   FULL+.01,  3,   270,   2, scale=SCALE) ;

    // 3
    block       (-2,  -3,   2*FULL+2*THIRD,  2,   3,  THIRD,     true, scale=SCALE);
    block       (-2,  -2,   BASE_HEIGHT,  2,   1,   2*FULL+THIRD ,     false, scale=SCALE);
    support_triangle     (-2,  -3,   2*FULL+.01,  3,   270,   2, scale=SCALE) ;
    support_triangle     (-2,  -1,   FULL+2*THIRD,  4,   270,   2, scale=SCALE) ;

    // that should get me into architecture school
    // 4
    block       (0,  -3,   3*FULL+2*THIRD,  2,   3,   THIRD,     true, scale=SCALE);
    block       (0,  -2,   BASE_HEIGHT,  2,   1,   3*FULL+THIRD,     false, scale=SCALE);
    support_triangle     (0,  -3,   3*FULL+.01,  3,   270,   2, scale=SCALE) ;
    support_triangle     (0,  -1,   2*FULL+2*THIRD+0.1,  4,   270,   2, scale=SCALE) ;

    // 5
    block       (2,  -3,   4*FULL+2*THIRD,  2,   3,   THIRD,     true, scale=SCALE);
    block       (2,  -2,   BASE_HEIGHT,  2,   1,   4*FULL+THIRD ,     false, scale=SCALE);
    support_triangle     (2,  -3,   4*FULL+0.1,  3,   270,   2, scale=SCALE) ;
    support_triangle     (2,  -1,   3*FULL+2*THIRD,  4,   270,   2, scale=SCALE) ;

    // 6
    block       (4,  -3,   5*FULL+2*THIRD,  2,   3,   THIRD,     false, scale=SCALE);
    nibbles     (4,  -2,   6*FULL,  2,   2,  scale=SCALE);
    block       (4,  -2,   BASE_HEIGHT,   2,   1,   5*FULL+THIRD ,     false, scale=SCALE);
    support_triangle     (4,  -3,   5*FULL+0.1,  3,   270,   2, scale=SCALE) ;
    support_triangle     (4,  -1,   4*FULL+2*THIRD+0.1,  4,   270,   2, scale=SCALE) ;

    // last step
    block       (6,  -3,   6*FULL+2*THIRD,  2,   3,   THIRD,     true, scale=SCALE);
    block       (6,  -2,   BASE_HEIGHT,   2,   1,   6*FULL+THIRD ,     false, scale=SCALE);
    // support_triangle     (6,  -3,   6*FULL+0.1,  3,   270,   2, scale=SCALE) ;
    support_triangle     (6,  -1,   5*FULL+2*THIRD+0.1,  4,   270,   2, scale=SCALE) ;

    // pillar and support for the wall
    block       (-8,  -3,   BASE_HEIGHT,  1,   1,   FLOOR_BOTTOM-THIRD ,     false, scale=SCALE);
    support_triangle     (-7.5,  -3,  FLOOR_BOTTOM-FULL+.01,  4,   270,   15.5, scale=SCALE) ;
    // small blocks on top
    block       (-8,  -4,   FLOOR_TOP+FULL,  2,   1,   FULL,     true, scale=SCALE);
    block       (-5,  -4,   FLOOR_TOP+FULL,  2,   1,   FULL,     true, scale=SCALE);
    block       (-2,  -4,   FLOOR_TOP+FULL,  4,   1,   FULL,     true, scale=SCALE);
    block       ( 3,  -4,   FLOOR_TOP+FULL,  2,   1,   FULL,     true, scale=SCALE);
    block       ( 6,  -4,   FLOOR_TOP+FULL,  2,   1,   FULL,     true, scale=SCALE);
}


module wall_stairs_legobase (SCALE=SCALE)
{
    wall_stairs_16_8_structure (0);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo  (-8,  -4,   0,  16,   3,   BASE_HEIGHT,     false, scale=SCALE);
}

module wall_stairs_16_8 (SCALE=SCALE)
{
    wall_stairs_16_8_structure (SCALE);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-8,  -4,   0,  16,   8,    BASE_HEIGHT,     false, scale=SCALE);

    // nibbles on the plate
    nibbles  (-8,  -2,  BASE_HEIGHT,  2,   6, scale=SCALE);
    nibbles  (6,  -2,   BASE_HEIGHT,  2,   6, scale=SCALE);
    nibbles  (-6,  2,   BASE_HEIGHT,  12,   2, scale=SCALE);
}

module wall_stairs_16_16 (SCALE=SCALE)
{
    wall_stairs_16_8_structure (SCALE);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-8,  -4,   0,  16,   16,    BASE_HEIGHT,     false, scale=SCALE);

    // nibbles on the plate
    nibbles  (-8,  -2,  BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (6,  -2,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-6,  -1,   BASE_HEIGHT,  12,   2, scale=SCALE);
    nibbles  (-6,  3,   BASE_HEIGHT,  12,   2, scale=SCALE);
    nibbles  (-6,  8,   BASE_HEIGHT,  12,   4, scale=SCALE);
}


module wall_connector (SCALE=SCALE)
{
    doblo       (-4,  -4,   0,  8,   1,    FULL,     true, scale=SCALE);
}

// ----------------- portal

module portal_structure (SCALE=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    // the wall
    block       (-4,  -4,   BASE_HEIGHT,   2,   2,   FLOOR_BOTTOM-THIRD ,     false, scale=SCALE);
    block       (2,  -4,   BASE_HEIGHT,  2,   2,   FLOOR_BOTTOM-THIRD ,     false, scale=SCALE);
    // top of door - 8.5 to avoid manifold
    support_triangle     (1,  -4,   4*FULL,  10,   180,   2, scale=SCALE) ;
    support_triangle     (-2,  -4,   4*FULL,  10,   0,   2, scale=SCALE) ;
    battlements (SCALE);
}

module portal (SCALE=SCALE)
{
   base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
   nibbles     (-4,  -2,   BASE_HEIGHT,  2,   6, scale=SCALE);
   nibbles     (2,  -2,   BASE_HEIGHT,  2,   6, scale=SCALE);
   nibbles     (-2,  -4,   BASE_HEIGHT,  4,   2, scale=SCALE);
   nibbles     (-2,  2,   BASE_HEIGHT,  4,   2, scale=SCALE);
   portal_structure (SCALE=SCALE);
}

// ------------------ corner, just two walls

module corner (SCALE=SCALE) 
{
    wall_structure (BASE_HEIGHT);
    translate ([0*PART_WIDTH(SCALE),0*PART_WIDTH(SCALE),0]) {
	rotate (a=[0,0,270]) wall_structure (BASE_HEIGHT);
    }
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles     (-4,  -2,   BASE_HEIGHT,  6,   6, scale=SCALE);
}

module corner_legobase (SCALE=SCALE) 
{
    wall_structure (0);
    // no translation
    translate ([0*PART_WIDTH(SCALE),0*PART_WIDTH(SCALE),0]) {
	rotate (a=[0,0,270]) wall_structure (0);
    }
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-4,  -4,   0,  8,   2,    BASE_HEIGHT,  false, scale=SCALE);
    doblo       (2,  -2,   0,  2,   6,    BASE_HEIGHT,  false, scale=SCALE);
}


// ------------------ corner, just two walls

module corner_thin (SCALE=SCALE) 
{
    wall_thin_structure (BASE_HEIGHT);
    translate ([0*PART_WIDTH(SCALE),0*PART_WIDTH(SCALE),0]) {
	rotate (a=[0,0,270]) wall_thin_structure (BASE_HEIGHT);
    }
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles     (-4,  -2,   BASE_HEIGHT,  6,   6, scale=SCALE);
}

module corner_thin_legobase (SCALE=SCALE) 
{
    wall_thin_structure (0);
    // no translation
    translate ([0*PART_WIDTH(SCALE),0*PART_WIDTH(SCALE),0]) {
	rotate (a=[0,0,270]) wall_thin_structure (0);
    }
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-4,  -4,   0,  8,   2,    BASE_HEIGHT,  false, scale=SCALE);
    doblo       (2,  -2,   0,  2,   6,    BASE_HEIGHT,  false, scale=SCALE);
}


// ----------------- thin corner on a 16x16 base

module corner_thin_16_structure (SCALE=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off, scale=SCALE) 
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=SCALE);
    // 2* the small wall
    translate ([-4*PART_WIDTH(SCALE),4*PART_WIDTH(SCALE),0]) {
	wall_thin_structure (BASE_HEIGHT);
    }
    translate ([4*PART_WIDTH(SCALE),4*PART_WIDTH(SCALE),0]) {
	wall_thin_structure (BASE_HEIGHT);
    }
    // walls on the right
    translate ([4*PART_WIDTH(SCALE),-4*PART_WIDTH(SCALE),0]) {
	rotate (a=[0,0,270]) wall_thin_structure (BASE_HEIGHT);
    }
    translate ([4*PART_WIDTH(SCALE),4*PART_WIDTH(SCALE),0]) {
	rotate (a=[0,0,270]) wall_thin_structure (BASE_HEIGHT);
    }

}

module corner_thin_16 (SCALE=SCALE)
{
    corner_thin_16_structure (BASE_HEIGHT) ;
    // nibbles on the plate
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-8,  6,   BASE_HEIGHT,  14,   2, scale=SCALE);
    //    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=SCALE);
    nibbles  (-4,  -4,   BASE_HEIGHT,  8,   8, scale=SCALE);
}

// ---------------------- pool, any castly must have one
// includes some openscad code

module pool_structure (SCALE=SCALE) {
    difference () {
	hull () {
	    cyl_block   (-3, -2,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=SCALE) ;   
	    cyl_block   (-0.5,   -3,  BASE_HEIGHT,    2,    2,   2*FULL,   false, scale=SCALE) ;   
	    cyl_block   (1,  -2,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=SCALE) ;   
	    cyl_block   (-2,    1,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=SCALE) ;   
	    cyl_block   (1.5,   0,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=SCALE) ;   
	}
	hull () {
	    cyl_block   (-2, -1.5,  BASE_HEIGHT,  1,    2,   2*FULL,   false, scale=SCALE) ;   
	    cyl_block  (-0.5,  -2,  BASE_HEIGHT,    1,    2,   2*FULL,   false, scale=SCALE) ;   
	    cyl_block   (-1.5,    0.5,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=SCALE) ;   
	    cyl_block   (1,   -0.5,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=SCALE) ;   
	    cyl_block   (0.5,  -1.5,  BASE_HEIGHT,  1,    2,   2*FULL,   false, scale=SCALE) ;   
	}
    }
}

module pool (SCALE=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles  (-4,  -4,   BASE_HEIGHT,  2,   2, scale=SCALE);
    nibbles  (2,  -4,   BASE_HEIGHT,  2,   2, scale=SCALE);
    nibbles  (2,  2,   BASE_HEIGHT,  2,   2, scale=SCALE);
    nibbles  (-4,  2,   BASE_HEIGHT,  2,   2, scale=SCALE);
    pool_structure(SCALE);
}

// ---------------------- pool, stackable any castly must have one
// includes some openscad code

module pool_legobase (SCALE=SCALE)
{
    //       (col, row, up, width,length,height,nibbles_on_off) 
    doblo    (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=SCALE);
    nibbles  (-4,  -4,   BASE_HEIGHT,  2,   2, scale=SCALE);
    nibbles  (2,  -4,   BASE_HEIGHT,  2,   2, scale=SCALE);
    nibbles  (2,  2,   BASE_HEIGHT,  2,   2, scale=SCALE);
    nibbles  (-4,  2,   BASE_HEIGHT,  2,   2, scale=SCALE);
    
    pool_structure(0);
}

// ---- some legos/duplos

module bricks (SCALE=SCALE) {
    //    (col, row, up, width,length,height,nibbles_on_off, diamonds) 
    doblo (0,   0,   0,   4,   2,    FULL,  true, false , scale=SCALE);
    doblo (5,   0,   0,   1,   2,    FULL,  true, false , scale=SCALE);
    doblo (7,   0,   0,   1,   2,    FULL,  true, false , scale=SCALE);
    doblo (0,   3,   0,   2,   2,    FULL,  true, false , scale=SCALE);
    doblo (-3,   3,   0,   2,   2,    FULL,  true, false , scale=SCALE);
    doblo (3,   3,   0,   2,   2,    2*THIRD,  false, false , scale=SCALE);
    block (3,   3,   2*THIRD,   2,   2,  2*FULL+THIRD,  true, false , scale=SCALE);
    doblo (6,   3,   0,   2,   2,    2*THIRD,  false, false , scale=SCALE);
    block (6,   3,   2*THIRD,   2,   2,    2*FULL+THIRD,  true, false , scale=SCALE);
    doblo (0,   -3,   0,  8,  2,    FULL,  true, false , scale=SCALE);
    doblo (-5,   -3,   0,  4,  4,    2,  true, false , scale=SCALE);
 }

// for connecting base plates
module bricks_flat (SCALE=SCALE) {
    //    (col, row, up, width,length,height,nibbles_on_off, diamonds) 
    doblo (0,   3,   0,   2,   4,    THIRD,  false, false , scale=SCALE);
    doblo (3,   3,   0,   2,   4,    THIRD,  true, false , scale=SCALE);
    doblo (0,   0,  0,    8,   2,    THIRD,  true, false , scale=SCALE);
    doblo (0,  -3,  0,    8,   2,    THIRD,  false, false , scale=SCALE);
    doblo (6,  3,  0,     2,   4,    THIRD,  true, false , scale=SCALE);
}
