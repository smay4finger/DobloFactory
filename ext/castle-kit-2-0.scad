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

Basic parameters are below. If you change these, most element will adjust correctly, but some won't, i.e. need some manual adjustment. Height of chambers have been calibrated to be able to put a Lego person inside. Parameters are different for Lego and Duplo compatible. Legos work in "third" sizes and Duplos in "half". Length below are not absolute heights, but just length as defined in our Lego conventions. Therefore, they must be multiplied with either PART_WIDTH or PART_HEIGHT if do some openscad coding (e.g. see wizard_tower).
*/

UNIT = (SCALE < 0.6) ? THIRD : HALF; // Lego vs. Duplo small height units
BASE_HEIGHT  = (SCALE < 0.6) ? 2*THIRD : HALF;  // Height of the base plaform.
FLOOR_TOP    = 8*FULL;  // Height of the first floor, e.g. nibbles go here
FLOOR_BOTTOM = FLOOR_TOP-UNIT;  // bottom of a floor
WALL_TOP     = 10*FULL;            // e.g. nibbles go here
WALL_BOTTOM  = WALL_TOP-BASE_HEIGHT; // this is wall_top - the base plate height
INNER_WALL_TOP = FLOOR_BOTTOM-BASE_HEIGHT;  // e.g. inside of walls, needs a BASE_HEIGHT on top

// -------------- support block (triangle )

// Support block for building platforms
// so bad ... :(
// NOTE: make the support block stick into something, else it may not print

module support_triangle (col,row,up,height,angle,thickness, scale=SCALE)
// changed DKS, added easier strings
{
    if (angle == 0 || angle == "right") {
	translate ([0, 0, 0]) {
	    support_triangle1 (col,row,up,height,0,thickness, scale=scale);
	}
    }
    else if (angle == 90 || angle == "back") {
	translate ([0, -PART_WIDTH(scale) , 0]) {
	    support_triangle1 (col,row,up,height,90,thickness, scale=scale);
	}
    }
    else if (angle == 180 || angle == "left") {
	translate ([PART_WIDTH(scale), -PART_WIDTH(scale) - PART_WIDTH(scale)* (thickness-1) , 0]) {
	    support_triangle1 (col,row,up,height,180,thickness, scale=scale);
	}
    }
    else if (angle == 270 || angle == "fore") {
	translate ([PART_WIDTH(scale) + PART_WIDTH(scale) * (thickness-1), 0 , 0]) {
	    support_triangle1 (col,row,up,height,270,thickness, scale=scale);
	}
    }
    else {
	echo (str ("WARNING: Bad angle for the doblo support_triangle block", angle)) ;
    }
}

module support_triangle1 (col,row,up,height,angle,thickness, scale=SCALE)
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

function BLOCK_SIZE(scale) = 8*PART_WIDTH(scale);
module large_example (scale=SCALE)
{
     color ("red") translate([-BLOCK_SIZE(scale), BLOCK_SIZE(scale), 0]) {
	 rotate (a=90, v=[0,0,1]) { corner_thin_8x8 (scale); }};
     color ("darkred") translate([0, BLOCK_SIZE(scale), 0]) { portal_8x8 (scale); };
     color ("firebrick") translate([BLOCK_SIZE(scale), BLOCK_SIZE(scale), 0]) { wall_thin_8x8 (scale); };
     color ("crimson") translate([2*BLOCK_SIZE(scale), BLOCK_SIZE(scale), 0]) { corner_tower (scale); };
    // row 2
     color ("indianred") translate([-BLOCK_SIZE(scale), 0, 0]) {
	rotate (a=90, v=[0,0,1]) wall_thin_8x8 (scale); };
     // hacky stacking here
     color ("gold") tower_round_square(scale);
     color ("yellow") translate([0, 0, WALL_TOP * PART_HEIGHT(scale)]) {
	  tower_round_square_element (scale);
     }
    color ("darkgreen") translate([BLOCK_SIZE(scale), 0 ,0]) { base (scale); };
    color ("orange") translate([2*BLOCK_SIZE(scale), 0, 0]) {
	rotate (a=270, v=[0,0,1]) { wall_thin_8x8(scale); }};

    // row 3
    color ("darkorange") translate([-BLOCK_SIZE(scale), -BLOCK_SIZE(scale), 0]) {
	rotate (a=90, v=[0,0,1]) { wall_thin_8x8(scale); }};
    color ("palegreen") translate([0, -BLOCK_SIZE(scale), 0]) { pool (scale); };
    color ("khaki") translate([BLOCK_SIZE(scale), -BLOCK_SIZE(scale), 0]) { tower(scale); };
    color ("tomato") translate([2*BLOCK_SIZE(scale), -BLOCK_SIZE(scale), 0]) {
	rotate (a=270, v=[0,0,1]) { wall_thin_8x8 (scale); }};
	
    // row 4
    color ("salmon") translate([-BLOCK_SIZE(scale), -2*BLOCK_SIZE(scale), 0]) {
	rotate (a=180, v=[0,0,1]) { corner_thin_8x8 (scale); }};
    color ("darksalmon") translate([BLOCK_SIZE(scale)/2, -2*BLOCK_SIZE(scale), 0]) {
	rotate (a=180, v=[0,0,1]) wall_stairs_16_8 (scale); };
    color ("lightcoral")  translate([2*BLOCK_SIZE(scale), -2*BLOCK_SIZE(scale), 0]) {
	rotate (a=270, v=[0,0,1]) corner_thin_8x8 (scale); };

}

// ---------------- Models ----------------------


// --------------------------------------------------------------------------------
// --- Building and calibration aids

// to calibrate heights. I suggest to build with multiples of FULL + THIRD
// remove this for printing
module vert_scale (scale=SCALE) {
    translate ([0,0,0]) {
	//     (col, row, up,    width,length,height,nibbles_on_off, scale=scale) 
	# doblo  (-7,  -1,  0,     2,  4,   BASE_HEIGHT,  true,  scale=scale);
	doblo  (-7,  -1,  0+BASE_HEIGHT,     1,  1,     FULL,  true,  scale=scale);
	doblo  (-7,  -1,  FULL+BASE_HEIGHT,  2,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  2*FULL+BASE_HEIGHT,1,  1,     FULL,  true,  scale=scale);
	doblo  (-7,  -1,  3*FULL+BASE_HEIGHT,2,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  4*FULL+BASE_HEIGHT,1,  1,     FULL,  true,  scale=scale);
	doblo  (-7,  -1,  5*FULL+BASE_HEIGHT,2,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  6*FULL+BASE_HEIGHT,1,  1,     FULL,  true,  scale=scale);
	doblo  (-7,  -1,  7*FULL+BASE_HEIGHT,2,  1,     FULL,  true,  scale=scale);
	color("green") doblo  (-7,  -1,  FLOOR_TOP+BASE_HEIGHT,4,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  9*FULL+BASE_HEIGHT,1,  1,     FULL,  true,  scale=scale);
	color("red") doblo  (-7,  -1,  WALL_TOP+BASE_HEIGHT, 4,  1,      FULL,  true, false, scale );
	color ("green") doblo  (-7,  -1,  WALL_TOP+BASE_HEIGHT,1,  1,     FULL,  true,  scale=scale);
	doblo  (-7,  -1,  11*FULL+BASE_HEIGHT,2,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  12*FULL+BASE_HEIGHT,1,  1,     FULL,  true,  scale=scale);
	doblo  (-7,  -1,  13*FULL+BASE_HEIGHT,2,  1,      FULL,  true, false, scale );
	color("green") doblo  (-7,  -1,  14*FULL+BASE_HEIGHT,4,  1,      FULL,  true, false, scale );
    }
}

module vert_scale_full (scale=SCALE) {
    translate ([0,0,0]) {
	//     (col, row, up,    width,length,height,nibbles_on_off, scale) 
	# doblo  (-7,  -1,  0,     2,  4,   FULL,  true,  scale=scale);
	doblo  (-7,  -1,  FULL,  2,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  2*FULL,1,  1,     FULL,  true,  scale=scale);
	doblo  (-7,  -1,  3*FULL,2,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  4*FULL,1,  1,     FULL,  true,  scale=scale);
	doblo  (-7,  -1,  5*FULL,2,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  6*FULL,1,  1,     FULL,  true,  scale=scale);
	doblo  (-7,  -1,  7*FULL,2,  1,     FULL,  true,  scale=scale);
	color ("green") doblo  (-7,  -1,  FLOOR_TOP,4,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  9*FULL,2,  1,     FULL,  true,  scale=scale);
	color ("pink") doblo  (-7,  -1,  WALL_TOP, 4,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  10*FULL,1,  1,     FULL,  true,  scale=scale);
	doblo  (-7,  -1,  11*FULL,2,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  12*FULL,1,  1,     FULL,  true,  scale=scale);
	doblo  (-7,  -1,  13*FULL,2,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  14*FULL,1,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  15*FULL,2,  1,      FULL,  true, false, scale );
	color ("blue")doblo  (-7,  -1,  16*FULL,4,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  17*FULL,2,  1,      FULL,  true, false, scale );
	color ("yellow") doblo  (-7,  -1,  18*FULL,2,  1,      FULL,  true, false, scale );
	doblo  (-7,  -1,  19*FULL,4,  1,      FULL,  true, false, scale );
    }
}

module man_scale (scale=SCALE) {
     color ("green") doblo  (7,  -2,  BASE_HEIGHT,  1,  4,     5*FULL,  true, false, scale );
     }

// --- simple 4x2 lego brick
module calibration (scale=SCALE)
{
    //     (col, row, up, width,length,height,nibbles_on_off) 
    doblo   (0,   0,   0,   4,   2,    FULL,  true, false, scale );
}

// --------------------------------------------------------------------------------
// --- base plates, both flat and legobase

module base (scale=SCALE)
{
    base_plate  (-4,  -4,   0,  8,   8,   BASE_HEIGHT,   false, scale=scale);
    nibbles  (-4,  -4,  BASE_HEIGHT,  8,   2, scale=scale);
    nibbles  (-4,  -2,  BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (-4,  2,   BASE_HEIGHT,  8,   2, scale=scale);
    nibbles  (2,  -2,   BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (-1,  -1,  BASE_HEIGHT,  2,   2, scale=scale);
}

module base_legobase (scale=SCALE)
{
    doblo    (-4,  -4,  0,  8,   8,   BASE_HEIGHT,  false, scale=scale);
    nibbles  (-4,  -4,  BASE_HEIGHT,  8,   2, scale=scale);
    nibbles  (-4,  -2,  BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (-4,   2,  BASE_HEIGHT,  8,   2, scale=scale);
    nibbles  (2,   -2,  BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (-1,  -1,  BASE_HEIGHT,  2,   2, scale=scale);
}


module base_24 (scale=SCALE)
{
    base_plate (-12,  -12,   0,  24,   24,   THIRD,     true, scale=scale);
}

module base_16 (scale=SCALE)
{
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=scale);
    nibbles  (-8,  -8,   BASE_HEIGHT,  16,   2, scale=scale);
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-8,  6,   BASE_HEIGHT,  16,   2, scale=scale);
    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    // nibbles  (-4,  -4,   BASE_HEIGHT,  8,   8, scale=scale);
    color ("blue") nibbles  (-4,  -4,   BASE_HEIGHT,  8,   2, scale=scale);
    nibbles  (-4,  2,   BASE_HEIGHT,  8,   2, scale=scale);
    nibbles  (-4,  -1,   BASE_HEIGHT,  8,   2, scale=scale);
}

// --------------------------------------------------------------------------------
// --- square towers
// The roof design is as ugly as it could get, but the printed result is fairly nice ;)

// --- Tower structure 
//     has to be put on a base or lego bricks or lego-base platform

module tower_structure (scale=SCALE, up=0) {    

    // corner towers
    cyl_block   (-4, -4,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=scale) ;
    cyl_block   (2,  -4,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=scale) ;
    cyl_block   (-4,  2,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=scale) ;
    cyl_block   (2,   2,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=scale) ;

    // nibbles on top of corner towers
    nibbles (-4,  -4, WALL_TOP,  2,   2, scale=scale);
    nibbles (2,  2,   WALL_TOP,   2,   2, scale=scale);
    nibbles (2,  -4,  WALL_TOP,  2,   2, scale=scale);
    nibbles (-4, 2,   WALL_TOP,  2,   2, scale=scale);

    // platform on top
    color ("grey") block (-3,  -3, FLOOR_BOTTOM,  6,   6,  UNIT,  false, scale=scale);
    color ("green") nibbles     (-2,  -3, FLOOR_TOP,  4,   6, scale=scale);
    nibbles     (-4,  -1, FLOOR_TOP,  2,   2, scale=scale);
    nibbles     (2,  -1, FLOOR_TOP,  2,   2, scale=scale);
    color ("lime") nibbles (-1,  -4, FLOOR_TOP,  2,   1, scale=scale);
    color ("lime") nibbles (-1,  3, FLOOR_TOP,  2,   1, scale=scale);

    // walls on top and support_triangle underneath
    // left
    color ("orange") block       (-4, -3, FLOOR_BOTTOM,  1,   2,  2*FULL+UNIT,  false, scale=scale);
    color ("orange") block       (-4,  1, FLOOR_BOTTOM,  1,   2,  2*FULL+UNIT,  false, scale=scale);
    block       (-4, -1, FLOOR_BOTTOM,  1,   2,  UNIT,  false, scale=scale);

    color ("green") support_triangle   (-4.5,-3, FLOOR_BOTTOM-HALF,  2,  180, 6, scale=scale);
    nibbles     (-4, -2, WALL_TOP,  1,  1, scale=scale);
    nibbles     (-4,  1, WALL_TOP,  1,  1, scale=scale);

    // right
    color ("orangered") block       (3, -3, FLOOR_BOTTOM,  1,   2,  2*FULL+UNIT,  false, scale=scale);
    color ("orangered") block       (3,  1, FLOOR_BOTTOM,  1,   2,  2*FULL+UNIT,  false, scale=scale);
    block (3, -1, FLOOR_BOTTOM,  1,   2,  UNIT,  false, scale=scale);
    support_triangle     (3.5,  -3, FLOOR_BOTTOM-HALF,  2,    0, 6, scale=scale);
    nibbles     (3, -2, WALL_TOP,  1,  1, scale=scale);
    nibbles     (3,  1, WALL_TOP,  1,  1, scale=scale);

    // back
    color ("salmon") block (-3, -4, FLOOR_BOTTOM,  2,  1.01,  2*FULL+UNIT,     false, scale=scale);
    color ("salmon") block (1, -4, FLOOR_BOTTOM,  2,  1.01,  2*FULL+UNIT,     false, scale=scale);
    block (-1, -4, FLOOR_BOTTOM,  2,  1.01,  UNIT,     false, scale=scale);
    support_triangle     (-3, -4.5, FLOOR_BOTTOM-HALF,  2,  90, 6, scale=scale);
    nibbles     (-2, -4, WALL_TOP,  1,   1, scale=scale);
    nibbles     (1, -4, WALL_TOP,  1,   1, scale=scale);

    // front
    color ("darksalmon") block (-3, 3, FLOOR_BOTTOM,  2,  1.01,  2*FULL+UNIT,     false, scale=scale);
    color ("darksalmon") block (1, 3, FLOOR_BOTTOM,  2,  1.01,  2*FULL+UNIT,     false, scale=scale);
    block (-1, 3, FLOOR_BOTTOM,  2,  1.01,  UNIT,     false, scale=scale);
    support_triangle   (-3, 3.5, FLOOR_BOTTOM-HALF,  2,  270, 6, scale=scale);
    nibbles     (-2, 3, WALL_TOP,  1,   1, scale=scale);
    nibbles     (1, 3, WALL_TOP,  1,   1, scale=scale);

    // towers for 2 walls
    cyl_block  (-1, 2,  BASE_HEIGHT,  2,  2,  FLOOR_BOTTOM-UNIT,     false, scale=scale);
    cyl_block  (-1, -4, BASE_HEIGHT,  2,  2, FLOOR_BOTTOM-UNIT,     false, scale=scale);

    // support_triangle for the platform on top
    //        (col, row, up, height,degrees) 

    // support_triangle along y axis

    color ("yellow") support_triangle (-3.5, -2.5, FLOOR_BOTTOM-2.5*FULL,   10,   "fore", 1, scale=scale) ;
    support_triangle (-3.5, 1.5,  FLOOR_BOTTOM-2.5*FULL,   10,   "back", 1, scale=scale) ;

    support_triangle (-0.75, -2.5, FLOOR_BOTTOM-2.5*FULL,   10,   "fore", 1.5, scale=scale) ;
    color ("orange")support_triangle (-0.75, 1.5,  FLOOR_BOTTOM-2.5*FULL,   10,   "back", 1.5, scale=scale) ;

    support_triangle (2.5, -2.5, FLOOR_BOTTOM-2.5*FULL,   10,   "fore", 1, scale=scale) ;
    support_triangle (2.5, 1.5,  FLOOR_BOTTOM-2.5*FULL,   10,   "back", 1, scale=scale) ;

    // diagonal support_triangle
    support_triangle1 (-2.25, -3,  FLOOR_BOTTOM-2.5*FULL,   10,   315, 1, scale=scale) ;
    support_triangle1 (-3,   2.25, FLOOR_BOTTOM-2.5*FULL,   10,   45, 1, scale=scale) ;
    support_triangle1 (3.0, -2.25, FLOOR_BOTTOM-2.5*FULL,   10,   225, 1, scale=scale) ;
    support_triangle1 (2.25, 3.0,  FLOOR_BOTTOM-2.5*FULL,   10,   135, 1, scale=scale) ;
    // support_triangle along x-axis - non-standard width to avoid non-simple models
    color ("blue") support_triangle1 (-2.4, -3.5, FLOOR_BOTTOM-2.5*FULL+0.1,   10.2,   0, 1.1, scale=scale) ;
    support_triangle1 (-2.6, 2.4,  FLOOR_BOTTOM-2.5*FULL+0.1,   10.2,   0, 1.1, scale=scale) ;
    support_triangle1 (2.6, -2.4,  FLOOR_BOTTOM-2.5*FULL+0.1,   10.2,   180, 1.1, scale=scale) ;
    support_triangle1 (2.6, 3.5,   FLOOR_BOTTOM-2.5*FULL+0.1,   10.2,   180, 1.1, scale=scale) ;
}

// ---- tower on 8x8 basis
module tower (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles     (-4,  -2,  BASE_HEIGHT,  8,   4, scale=scale);
    tower_structure (scale=scale);
}


// ---- tower on 16x16 basis
module tower_16 (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=scale);
    nibbles  (-8,  -8,   BASE_HEIGHT,  16,   2, scale=scale);
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-8,  6,   BASE_HEIGHT,  16,   2, scale=scale);
    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-6,  -2,   BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (4,  -2,   BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (-4,  -2,  BASE_HEIGHT,  8,   4, scale=scale);
    tower_structure (scale=scale);
}


// ---- Tower with Lego comp. baseplate, a bit more difficult to print correctly

module tower_legobase (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles     (-4,  -2,  BASE_HEIGHT,  8,   4, scale=scale);
    tower_structure (scale=scale);
}

// ---- Stackable tower, a bit more difficult to print correctly

module tower_stackable (scale=SCALE, up=FULL)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-4,  -4,   0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
    doblo       (-4,  2,   0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
    tower_structure (scale=scale);
}


// -------------------------------------------------------------------------------
// --- corner tower

module corner_tower_structure (scale=SCALE) 
{
    // corner towers
    cyl_block   (2,  -4,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=scale) ;
    cyl_block   (-4,  2,  BASE_HEIGHT,  2,  2,  WALL_BOTTOM,   false, scale=scale) ;

    // platform on top
    block       (-4,  -3, FLOOR_BOTTOM,  7,   7,  UNIT,  false, scale=scale);
    nibbles     (-2,  -1, FLOOR_TOP,  5,   5, scale=scale);
    nibbles     (-4,  -1, FLOOR_TOP,  2,   3, scale=scale);
    nibbles     (-4,  -3, FLOOR_TOP,  6,   2, scale=scale);

    // small support along top platform
    support_triangle   (-4.5,-3, FLOOR_BOTTOM-3,  2,  180, 7, scale=scale);
    support_triangle   (-4, 3.5, FLOOR_BOTTOM-3,  2,  270, 7, scale=scale);

    // wall right
    block       (3,  -3, BASE_HEIGHT,  1,   7,   WALL_BOTTOM,     false, scale=scale);
    nibbles     (3, -2, WALL_TOP,  1,   6, scale=scale);

    // wall back
    block       (-4, -4, BASE_HEIGHT,  7,  1,    WALL_BOTTOM,     false, scale=scale);
    nibbles     (-4, -4, WALL_TOP,  6,   1, scale=scale);

    // nibbles on top of "mini towers"
    nibbles (2,  -4,   WALL_TOP,   2,   2, scale=scale);
    nibbles (-4,  2,   WALL_TOP,   2,   2, scale=scale);

    // support_triangle for the platform on top
    //        (col, row, up, height,degrees) 

    // support_triangle along y axis
    support_triangle (-4, -3.5, FLOOR_BOTTOM-3.5*FULL,   2*FULL+UNIT,   "fore", 1, scale=scale) ;
    support_triangle (-2, -3.5, FLOOR_BOTTOM-3.5*FULL,   2*FULL+UNIT,   "fore", 1, scale=scale) ;
    support_triangle (0, -3.5, FLOOR_BOTTOM-3.5*FULL,   2*FULL+UNIT,   "fore", 1, scale=scale) ;
    support_triangle (-4, 2,  FLOOR_BOTTOM-3.5*FULL,   2*FULL+UNIT,   "back", 1, scale=scale) ;

    // diagonal support_triangle - FIX THIS - TODO

    support_triangle1 (-3,   2.25, FLOOR_BOTTOM-3.5*FULL,   2*FULL+UNIT,   45, 1, scale=scale) ;

    // support_triangle along x-axis
    support_triangle1 (-3, 3,  FLOOR_BOTTOM-3.5*FULL,   2*FULL+UNIT,   0, 1, scale=scale) ;
    support_triangle1 (3, 4,   FLOOR_BOTTOM-3.5*FULL,   2*FULL+UNIT,   180, 1, scale=scale) ;
    support_triangle1 (3, 2,   FLOOR_BOTTOM-3.5*FULL,   2*FULL+UNIT,   180, 1, scale=scale) ;
    support_triangle1 (3, 0,  FLOOR_BOTTOM-3.5*FULL,   2*FULL+UNIT,   180, 1, scale=scale) ;
    support_triangle1 (3, -2,  FLOOR_BOTTOM-3.5*FULL,   2*FULL+UNIT,   180, 1, scale=scale) ;
}


module corner_tower (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles     (-4,  -2,  BASE_HEIGHT,  7,   4, scale=scale);
    nibbles     (-2,  2,  BASE_HEIGHT,  5,   2, scale=scale);
    corner_tower_structure (scale=scale);
}

module corner_tower_legobase (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles     (-4,  -2,  BASE_HEIGHT,  7,   4, scale=scale);
    nibbles     (-2,  2,  BASE_HEIGHT,  5,   2, scale=scale);
    corner_tower_structure (scale=scale);
}

module corner_tower_stackable (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo  (-4,  -4,   0,  6,   1,    BASE_HEIGHT,     false, scale=scale);
    doblo  (3,  -2,   0,  1,   6,    BASE_HEIGHT,     false, scale=scale);
    // underneath front and back pillars
    doblo  (2,  -4,   0,  2,   2,    BASE_HEIGHT,     false, scale=scale);
    # doblo  (-4,  2,   0,  2,   2,    BASE_HEIGHT,     false, scale=scale);

    corner_tower_structure (scale=scale);
}

// --------------------------------------------------------------------------------
// --- Round tower 


module tower_round_structure (scale=SCALE)
{
    $fs = 0.1;
    $fa = 4;

    difference () {
	// tower structure
	union () {
	    difference () {
		cyl_block (col=-4, row=-4, up=BASE_HEIGHT, 
			   bottom_r=8, top_r=8, 
			   height=WALL_BOTTOM, nibbles_on_off=false,
			   scale=scale) ;
		// carve it out
		cyl_block (col=-3, row=-3, up=1,
			   bottom_r=6, top_r=6, height=15*FULL,
			   nibbles_on_off=false, scale=scale) ;
		// holes in the wall on top, the first is larger
		block   (-6, -2,  FLOOR_TOP,  10,    4,     3*FULL,   false, scale=scale) ;
		block   (-1, -6,  FLOOR_TOP,  2,    10,     3*FULL,   false, scale=scale) ;
	    }
	    // platform on top
	    difference () {
		color ("yellow") cyl_block (-3,  -3,  5*FULL,  6,    6,  3*FULL,   false, scale=scale) ;
		cyl_block (col=-3.1, row=-3.1, up=4.79*FULL,
			   bottom_r=6.2, top_r=1,  height=3*FULL,
			   nibbles_on_off=false, scale=scale) ;
	    }
	}
	// windows
	house_fb   (-1, -5,  2.5*FULL,  2,    10,  3*FULL, scale=scale) ;
	// doors, uses a "house form"
	//         (col, row, up, width,length,height, scale=scale) 
	house_lr   (-5, -2,   BASE_HEIGHT-0.01,  10,    4,  4.5*FULL, scale=scale) ;
    }
    nibbles (-3,  -2, FLOOR_TOP,  6,   4, scale=scale);
    nibbles (-4,  -1, FLOOR_TOP,  1,   2, scale=scale);
    nibbles (3,  -1, FLOOR_TOP,  1,   2, scale=scale);
    nibbles (-1,  -4, FLOOR_TOP,  2,   2, scale=scale);
    nibbles (-1,  2, FLOOR_TOP,  2,   2, scale=scale);
    // nibbles on very top
    color ("red") nibbles (-3,  -3, WALL_TOP,  1,   1, scale=scale);
    nibbles (2,  2, WALL_TOP,  1,   1, scale=scale);
    nibbles (2,  -3, WALL_TOP,  1,   1, scale=scale);
    nibbles (-3, 2 , WALL_TOP,  1,   1, scale=scale);
}

// --- round tower
module tower_round (scale=SCALE) {
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    nibbles (-4,  -2, BASE_HEIGHT,  8,   4, scale=scale);
    // one by one outside
    nibbles (-4,  -4, BASE_HEIGHT,  1,   1, scale=scale);
    nibbles (-4,   3, BASE_HEIGHT,  1,   1, scale=scale);
    nibbles (3,    3, BASE_HEIGHT,  1,   1, scale=scale);
    nibbles (3,   -4, BASE_HEIGHT,  1,   1, scale=scale);
    tower_round_structure (scale=scale) ;
}

module tower_round_16 (scale=SCALE) {
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=scale);
    nibbles  (-8,  -8,   BASE_HEIGHT,  16,   2, scale=scale);
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-8,  6,   BASE_HEIGHT,  16,   2, scale=scale);
    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-6,  -2,   BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (4,  -2,   BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (-4,  -1,  BASE_HEIGHT,  8,   2, scale=scale);
    tower_round_structure (scale=scale) ;
}

// --- round tower, legobase
module tower_round_legobase (scale=SCALE) {
    doblo       (-4,  -4,   0,      8,   8,    BASE_HEIGHT,     false, scale=scale);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    nibbles (-4,  -2, BASE_HEIGHT,  8,   4, scale=scale);
    nibbles (-4,  -4, BASE_HEIGHT,  1,   1, scale=scale);
    nibbles (-4,   3, BASE_HEIGHT,  1,   1, scale=scale);
    nibbles (3,    3, BASE_HEIGHT,  1,   1, scale=scale);
    nibbles (3,   -4, BASE_HEIGHT,  1,   1, scale=scale);
    tower_round_structure (scale=scale) ;
}

module tower_round_stackable (scale=SCALE) {
    doblo       (-4,  -4,   0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
    doblo       (-4,  2,   0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    nibbles (-4,  -4, BASE_HEIGHT,  1,   1, scale=scale);
    nibbles (-4,   3, BASE_HEIGHT,  1,   1, scale=scale);
    nibbles (3,    3, BASE_HEIGHT,  1,   1, scale=scale);
    nibbles (3,   -4, BASE_HEIGHT,  1,   1, scale=scale);
    tower_round_structure (scale=scale) ;
}


// --------------------------------------------------------------------------------
// --- Round tower with corner towers, thinner walls than round tower

module tower_round_square_structure (scale=SCALE)
{
    $fs = 0.1;
    $fa = 4;

    // corner towers
    cyl_block   (-4, -4,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=scale) ;
    cyl_block   (2,  -4,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=scale) ;
    cyl_block   (-4,  2,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=scale) ;
    cyl_block   (2,   2,  BASE_HEIGHT,  2,     2,    WALL_BOTTOM,   false, scale=scale) ;

    tower_round_structure (scale);

    nibbles (-4,  -4, WALL_TOP,  2,   2, scale=scale);
    nibbles (2,  2,   WALL_TOP,   2,   2, scale=scale);
    nibbles (2,  -4,  WALL_TOP,  2,   2, scale=scale);
    nibbles (-4, 2,   WALL_TOP,  2,   2, scale=scale);

}

module tower_round_square (scale=SCALE) {
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    nibbles (-4,  -2, BASE_HEIGHT,  8,   4, scale=scale);
    tower_round_square_structure (scale=scale);
}

module tower_round_square_16 (scale=SCALE) {
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=scale);
    nibbles  (-8,  -8,   BASE_HEIGHT,  16,   2, scale=scale);
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-8,  6,   BASE_HEIGHT,  16,   2, scale=scale);
    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-6,  -2,   BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (4,  -2,   BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (-4,  -1,  BASE_HEIGHT,  8,   2, scale=scale);
    tower_round_square_structure (scale=scale);
}


module tower_round_square_legobase (scale=SCALE) {
    doblo       (-4,  -4,   0,      8,   8,    BASE_HEIGHT,     false, scale=scale);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    nibbles (-4,  -2, BASE_HEIGHT,  8,   4, scale=scale);
    tower_round_square_structure (scale=scale);
}

module tower_round_square_stackable (scale=SCALE) {
    doblo       (-4,  2,   0,      8,   2,    BASE_HEIGHT,     false, scale=scale);
    doblo       (-4,  -4,   0,      8,   2,    BASE_HEIGHT,     false, scale=scale);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    tower_round_square_structure (scale=scale);
}

// --------------------------------------------------------------------------------
// --- To stack on tower-round_square above or on a plate
// fairly ugly differences

module tower_round_square_element (scale=SCALE)
{
     // minimum fragment size
     $fs = 2;
     // minimum fragment angle (higher = coarser)
     $fa = 2;
     
    // corner towers
    cyl_block   (-4, -4,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=scale) ;
    cyl_block   (2,  -4,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=scale) ;
    cyl_block   (-4,  2,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=scale) ;
    cyl_block   (2,   2,  BASE_HEIGHT,  2,     2,    WALL_BOTTOM,   false, scale=scale) ;

    doblo (-4, -4,  0,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;
    doblo   (2,  -4,  0,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;
    doblo   (-4,  2,  0,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;
    doblo   (2,   2,  0,  2,     2,    BASE_HEIGHT,   false, scale=scale) ;
    
    difference () {
	// tower structure
	union () {
	    difference () {
		cyl_block   (-4,  -4,  0,  8,    8,   WALL_BOTTOM+BASE_HEIGHT,   false, scale=scale) ;
		// carve it out
		cyl_block (-3.5,  -3.5,   -1,  7,    7,     15*FULL,   false, scale=scale) ;
		// holes in the wall on top
		block   (-6, -2,  FLOOR_TOP,  10,    4,     3*FULL,   false, scale=scale) ;
		block   (-1, -6,  8*FULL,  2,    10,     3*FULL,   false, scale=scale) ;


		// This will allow stacking the tower on a normal lego plate
		block (-4, -4,  -BASE_HEIGHT,  8,    8,     BASE_HEIGHT,   true, scale=scale) ;
		// Create space for inserting the blocks above
		block (-4, -4,  -0.01,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;
		block   (2,  -4, -0.01,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;
		block   (-4,  2,  -0.01,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;
		block   (2,   2,  -0.01,  2,     2,    BASE_HEIGHT,   false, scale=scale) ;
	    }
	    // platform on top
	    difference () {
		cyl_block (-3.5,  -3.5,  5*FULL,  7,    7,  3*FULL,   false, scale=scale) ;
		cyl_block (-3.5,  -3.5,  4.99*FULL,  7, 1,  3*FULL-THIRD,   false, scale=scale) ;
	    }
	}
	// windows
	house_fb   (-1, -5,  -0.1,  2,  10,  5*FULL, scale=scale) ;
	// doors, uses a "house form"
	//         (col, row,   up,   width,length,height, scale=scale) 
	house_lr  (-5, -2,  -0.1,  10,    4,  5*FULL, scale=scale) ;
    }
    nibbles (-3,  -2, FLOOR_TOP,  6,   4, scale=scale);
    nibbles (-4,  -1, FLOOR_TOP,  1,   2, scale=scale);
    nibbles (3,  -1, FLOOR_TOP,  1,   2, scale=scale);
    nibbles (-1,  -4, FLOOR_TOP,  2,   2, scale=scale);
    nibbles (-1,  2, FLOOR_TOP,  2,   2, scale=scale);
    nibbles (-4,  -4, WALL_TOP,  2,   2, scale=scale);
    nibbles (2,  2,   WALL_TOP,   2,   2, scale=scale);
    nibbles (2,  -4,  WALL_TOP,  2,   2, scale=scale);
    nibbles (-4, 2,   WALL_TOP,  2,   2, scale=scale);

}

// ----------------------------------- Dungeon - no escape


module dungeon_round_structure (scale=SCALE)
{
    $fs = 10;
    $fa = 10;

    difference () {
	// tower structure
	 union () {
	     difference () {
		cyl_block (col=-4, row=-4, up=BASE_HEIGHT, 
			   bottom_r=8, top_r=8, 
			   height=WALL_BOTTOM, nibbles_on_off=false,
			   scale=scale) ;
		// carve it out
		cyl_block (col=-3, row=-3, up=1,
			   bottom_r=6, top_r=6, height=15*FULL,
			   nibbles_on_off=false, scale=scale) ;
		// holes in the wall on top, the first is larger
		block   (-6, -1,  FLOOR_TOP,  10,    2,     3*FULL,   false, scale=scale) ;
		block   (-1, -6,  FLOOR_TOP,  2,    10,     3*FULL,   false, scale=scale) ;
	    }
	    // platform on top
	    difference () {
		color ("yellow") cyl_block (-3,  -3,  4.1*FULL,  6,    6,  3.9*FULL,   false, scale=scale) ;
		cyl_block (col=-3.1, row=-3.1, up=4*FULL,
			   bottom_r=6.2, top_r=1,  height=9*FULL,
			   nibbles_on_off=false, scale=scale) ;
	    }
	}
	// windows
	//         (col, row, up, width,length,height, scale=scale) 
	 house_fb   (-0.25, -5,  4*FULL,  0.5,    10,  2*FULL, scale=scale) ;
	 house_lr   (-5, -0.25,   4*FULL,  10,    0.5,  2*FULL, scale=scale) ;
    }

    nibbles (-4,  -1, FLOOR_TOP,  2,   2, scale=scale);
    nibbles (2,  -1, FLOOR_TOP,  2,   2, scale=scale);
    nibbles (-1,  -4, FLOOR_TOP,  2,   2, scale=scale);
    nibbles (-1,  2, FLOOR_TOP,  2,   2, scale=scale);
}


module dungeon_structure (scale=SCALE)
{
     $fs = 0;
     $fa = 20;
     
     dungeon_round_structure (scale);

    // corner towers
     cyl_block   (-4, -4,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=scale) ;
     cyl_block   (2,  -4,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=scale) ;
     cyl_block   (-4,  2,  BASE_HEIGHT,  2,    2,     WALL_BOTTOM,   false, scale=scale) ;
     cyl_block   (2,   2,  BASE_HEIGHT,  2,     2,    WALL_BOTTOM,   false, scale=scale) ;
     nibbles (-4,  -4, WALL_TOP,  2,   2, scale=scale);
     nibbles (2,  2,   WALL_TOP,   2,   2, scale=scale);
     nibbles (2,  -4,  WALL_TOP,  2,   2, scale=scale);
     nibbles (-4, 2,   WALL_TOP,  2,   2, scale=scale);
}

module dungeon (scale=SCALE) {
     // remove this to inspect the inside
     base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
     //          (col, row, up, width,length,height,nibbles_on_off) 
    dungeon_structure (scale=scale);
}

module dungeon_stackable (scale=SCALE) {
     // remove this to inspect the inside
     doblo  (-4,  -4,   0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
     doblo  (-4,  2,   0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
     doblo  (-4,  -2,   0,  2,   4,    BASE_HEIGHT,     false, scale=scale);
     doblo  (2,  -2,   0,  2,   4,    BASE_HEIGHT,     false, scale=scale);
     //          (col, row, up, width,length,height,nibbles_on_off) 
    dungeon_structure (scale=scale);
}


// ----------------------------------- Wizard tower

module wizard_tower_structure (scale=SCALE,flat_roof=false)
{
    // tower geometry
     height_top = (flat_roof == false) ? WALL_TOP*PART_HEIGHT(scale) + FLOOR_BOTTOM*PART_HEIGHT(scale) : 2*FLOOR_TOP*PART_HEIGHT(scale)-BASE_HEIGHT*PART_HEIGHT(scale);
    up     = BASE_HEIGHT*PART_HEIGHT(scale);
    radius = 3*PART_WIDTH(scale);

    difference () {
	 translate ([0,0,up]) {
	      linear_extrude(height=height_top, center=false, convexity=20, twist=360, slices=12) {
		   // square ([length,width], center=true);
		   circle (r=radius, center=true);
	      }   
	 }
	 //         (col, row,      up, width,length,height) 
	 // bottom
	 house_lr   (-5.5, -1.5,   THIRD,  10,    3,    5*FULL, scale=scale) ;
	 house_fb   (-1.5, -2,   THIRD,  3,     4,    5*FULL , scale=scale); // inside
	 // bottom window
	 house_fb   (-0.5, -5.75,  2*FULL,  1,    10,   4*FULL, scale=scale) ;
	 // 2nd floor
	 house_lr   (-5.5, -1.5,   FLOOR_TOP,  10,   3,    5*FULL, scale=scale) ; //door-window
	 house_fb   (-0.5, -5.75,  FLOOR_TOP+FULL,  1,    10,   4*FULL, scale=scale) ; // window
	 house_fb   (-1.5, -2,   FLOOR_TOP,  3,     4,    5*FULL , scale=scale); // inside
	 // top
	 cyl_block (-2.25, -2.25,   FLOOR_TOP*2,  4.5,    4.5,   24,   false, scale=scale) ;
	 // bigger door
	 house_lr   (-5.5, -1.0,  FLOOR_TOP*2,  10,    2,    20, scale=scale) ;
	 // smaller - censored because the structure is a bit fragile
	 // house_fb (-0.5, -5.75,  FLOOR_TOP*2,  1,    10,    15, scale=scale) ;
    }
    // 2nd floor nibbles
    nibbles     (-3,  -1,  FLOOR_TOP,  6,   2, scale=scale);
    
    // top nibbles
    nibbles     (-3,  -1,  2*FLOOR_TOP,  6,  2, scale=scale);
    nibbles     (-1,  -3,  2*FLOOR_TOP,  2,  2, scale=scale); // not good on not flat roof
    nibbles     (-1,  1,   2*FLOOR_TOP,  2,  2, scale=scale);
    // very top nibbles, not possible to align
    // color ("red") nibbles     (-1,  2,   2*FLOOR_TOP+FULL+FULL ,  1,  1, scale=scale);
}

module wizard_tower (scale=SCALE)
{
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles     (-4,  -1,   BASE_HEIGHT,  8,   2, scale=scale);
    nibbles  (-4, -4,   BASE_HEIGHT,  2,   2, scale=scale);
    nibbles  (2,  -4,   BASE_HEIGHT,  2,   2, scale=scale);
    nibbles  (2,   2,   BASE_HEIGHT,  2,   2, scale=scale);
    nibbles  (-4,  2,   BASE_HEIGHT,  2,   2, scale=scale);
    wizard_tower_structure (scale=scale);
}


module wizard_tower_legobase (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-3,  -3,   0,  6,   6,    BASE_HEIGHT,     false, scale=scale);
    nibbles     (-3,  -1,   BASE_HEIGHT,  6,   2, scale=scale);
    nibbles  (-3,  -3, BASE_HEIGHT,  1,   1, scale=scale);
    nibbles  (2,  -3,  BASE_HEIGHT,  1,   1, scale=scale);
    nibbles  (2,  2,   BASE_HEIGHT,  1,   1, scale=scale);
    nibbles  (-3,  2,  BASE_HEIGHT,  1,   1, scale=scale);
    wizard_tower_structure (scale);
}

module wizard_tower_stackable (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-3,  -3,   0,  6,   2,    BASE_HEIGHT,     false, scale=scale);
    doblo       (-3,  1,   0,  6,   2,    BASE_HEIGHT,     false, scale=scale);
    // nibbles bottom outside
    nibbles  (-3,  -3, BASE_HEIGHT,  1,   1, scale=scale);
    nibbles  (2,  -3,  BASE_HEIGHT,  1,   1, scale=scale);
    nibbles  (2,  2,   BASE_HEIGHT,  1,   1, scale=scale);
    nibbles  (-3,  2,  BASE_HEIGHT,  1,   1, scale=scale);
    wizard_tower_structure (scale, flat_roof=true);
}

// ------------------ bricks for tower building

// --- tower floor module, can be stacked, also on base

module tower_floor_stackable (scale=SCALE)
{
    //       (col, row, up, width,length,height,nibbles_on_off) 
    color ("yellow") block    (-4,  -4, FLOOR_BOTTOM-THIRD,  8,   8,    THIRD+THIRD,     true, scale=scale);

    // towers, 3 on two sides
    block   (-4, -4,  BASE_HEIGHT,  2,    2,     FLOOR_BOTTOM-THIRD,   false, scale=scale) ;
    doblo   (-4, -4,  0,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;

    block   (-1, -4,  BASE_HEIGHT,  2,    2,     FLOOR_BOTTOM-THIRD,   false, scale=scale) ;
    doblo   (-1, -4,  0,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;

    block   (2,  -4,  BASE_HEIGHT,  2,    2,     FLOOR_BOTTOM-THIRD,   false, scale=scale) ;
    doblo   (2,  -4,  0,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;

    block   (-4,  2,  BASE_HEIGHT,  2,    2,     FLOOR_BOTTOM-THIRD,   false, scale=scale) ;
    doblo   (-4,  2,  0,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;

    block   (-1,  2,  BASE_HEIGHT,  2,    2,     FLOOR_BOTTOM-THIRD,   false, scale=scale) ;
    doblo   (-1,  2,  0,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;

    block   (2,   2,  BASE_HEIGHT,  2,    2,     FLOOR_BOTTOM-THIRD,   false, scale=scale) ;
    doblo   (2,   2,  0,  2,    2,     BASE_HEIGHT,   false, scale=scale) ;

    // support_triangle
    support_triangle (-4, 1, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,    90, 2, scale=scale);
    support_triangle (-1, 1, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,    90, 2, scale=scale);
    support_triangle (2, 1, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,     90, 2, scale=scale);
    support_triangle (-4, -2, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,    270, 2, scale=scale);
    support_triangle (-1, -2, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,    270, 2, scale=scale);
    support_triangle (2, -2, FLOOR_BOTTOM-2.5*FULL+THIRD,  8,     270, 2, scale=scale);

    support_triangle1 (-2.5, -4, 1*FULL,  10,   0, 2, scale=scale) ;
    support_triangle1 (-2.5, 2, 1*FULL,   10,   0, 2, scale=scale) ;
    support_triangle1 (2.5, -2, 1*FULL,   10,   180, 2, scale=scale) ;
    support_triangle1 (2.5, 4, 1*FULL,   10,   180, 2, scale=scale) ;

    // small support_triangles
    support_triangle1 (-2.5, -4, FLOOR_BOTTOM-2*FULL,   7,   0, 2, scale=scale) ;
    support_triangle1 (-2.5, 2, FLOOR_BOTTOM-2*FULL,   7,   0, 2, scale=scale) ;
    support_triangle1 (2.5, -2, FLOOR_BOTTOM-2*FULL,   7,   180, 2, scale=scale) ;
    support_triangle1 (2.5, 4, FLOOR_BOTTOM-2*FULL,   7,   180, 2, scale=scale) ;

}

// --- tower floor module, can be stacked, also on base

module tower_roof_legobase (scale=SCALE)
{
    //       (col, row, up, width,length,height,nibbles_on_off) 

    // towers, 3 on two sides

    difference () {
	union () {
	    doblo   (-4, -4,  0,  8,    1,     BASE_HEIGHT,   true, scale=scale) ;
	    block  (-4, -4,  BASE_HEIGHT,  8,    1,     2*FULL,   false, scale=scale) ;
	    
	    doblo   (-4,  3,  0,  8,    1,     BASE_HEIGHT,   true, scale=scale) ;
	    block   (-4,  3,  BASE_HEIGHT,  8,    1,     2*FULL,   false, scale=scale) ;
	    
	    // house on top
	    difference () {
		//         (col, row, up, width,length,height) 
		 color ("yellow") house_lr  (-4, -4,  1*FULL,  8,    8,  FLOOR_BOTTOM-4*FULL, scale=scale) ;
		 house_lr  (-5, -3,  0.5*FULL,  10,   6,  FLOOR_BOTTOM-3*FULL-2*THIRD, scale=scale) ;
	    }
	}
	// windows
	color ("green") house_fb  (-2, -5, BASE_HEIGHT,  1,  10,   3*FULL , scale=scale);
	house_fb  (1, -5,  BASE_HEIGHT,  1,  10,    3*FULL , scale=scale);
    }
    block   (-4,  -1,  FLOOR_BOTTOM-FULL,  8,   2,  FULL+UNIT,   true, scale=scale) ;
}

// --- floor_pillars, stackable plate with pillars
// print the first layer real slow and calibrate openscad first !

module pillars_legobase (scale=SCALE)
{
    //       (col, row, up, width,length,height,nibbles_on_off) 
    doblo    (-4,  -4, 0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles  (-4,  -2, BASE_HEIGHT,  8,   4, scale=scale);
    nibbles  (-2,  -4, BASE_HEIGHT,  4,   2, scale=scale);
    nibbles  (-2,  2, BASE_HEIGHT,  4,   2, scale=scale);

    // towers, in four corners
    block   (-4, -4,  BASE_HEIGHT,  2,    2,     FLOOR_TOP-BASE_HEIGHT,   true, scale=scale) ;
    block   (2,  -4,  BASE_HEIGHT,  2,    2,     FLOOR_TOP-BASE_HEIGHT,   true, scale=scale) ;
    block   (-4,  2,  BASE_HEIGHT,  2,    2,     FLOOR_TOP-BASE_HEIGHT,   true, scale=scale) ;
    block   (2,   2,  BASE_HEIGHT,  2,    2,     FLOOR_TOP-BASE_HEIGHT,   true, scale=scale) ;

}

module pillars_stackable (scale=SCALE)
{
    //       (col, row, up, width,length,height,nibbles_on_off) 
    doblo    (-4,  -4, 0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
    nibbles  (-2,  -4, BASE_HEIGHT,  4,   2, scale=scale);

    // towers, in four corners
        block   (-4, -4,  BASE_HEIGHT,  2,    2,     FLOOR_TOP-BASE_HEIGHT,   true, scale=scale) ;
    block   (2,  -4,  BASE_HEIGHT,  2,    2,     FLOOR_TOP-BASE_HEIGHT,   true, scale=scale) ;
}

module pillars_round_stackable (scale=SCALE)
{
    //       (col, row, up, width,length,height,nibbles_on_off) 
    doblo    (-4,  -4, 0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
    nibbles  (-2,  -4, BASE_HEIGHT,  4,   2, scale=scale);

    // towers, in four corners
    cyl_block   (-4, -4,  BASE_HEIGHT,  2,    2,    FLOOR_BOTTOM-UNIT,   false, scale=scale) ;
    nibbles   (-4, -4,  FLOOR_TOP,  2, 2, scale=scale) ;

    cyl_block   (2,  -4,  BASE_HEIGHT,  2,    2,    FLOOR_BOTTOM-UNIT,   false, scale=scale) ;
    nibbles   (2,  -4,  FLOOR_TOP,  2,    2,  BASE_HEIGHT,   false, scale=scale) ;
    }

module pillars_round_stackable_alt (scale=SCALE)
{
    //       (col, row, up, width,length,height,nibbles_on_off) 
    doblo    (-4,  -4, 0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
    nibbles  (-2,  -4, BASE_HEIGHT,  4,   2, scale=scale);

    // towers, in four corners
    hull () {
    cyl_block   (-4, -4,  BASE_HEIGHT,  2,    2,    FLOOR_BOTTOM-BASE_HEIGHT,   false, scale=scale) ;
    block   (-4, -4,  FLOOR_TOP-BASE_HEIGHT,  2,    2,  BASE_HEIGHT,   false, scale=scale) ;
    }
    hull () {
    cyl_block   (2,  -4,  BASE_HEIGHT,  2,    2,    FLOOR_BOTTOM-BASE_HEIGHT,   false, scale=scale) ;
    block   (2,  -4,  FLOOR_TOP-BASE_HEIGHT,  2,    2,  BASE_HEIGHT,   false, scale=scale) ;
    }
    block   (-4, -4,  FLOOR_TOP-BASE_HEIGHT,  2,    2,  BASE_HEIGHT,   true, scale=scale) ;
    block   (2,  -4,  FLOOR_TOP-BASE_HEIGHT,  2,    2,  BASE_HEIGHT,   true, scale=scale) ;
    }

// -------------------------------- Walls and corners

// -------- battlements go on top of various walls
module battlements (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
     // base of battlements
     block       (-4,  -4,   FLOOR_BOTTOM,  8,   2, UNIT, false, scale=scale);
     // outer wall first layer
     block       (-4,  -4,   FLOOR_TOP,  8,   1,   FULL ,     false, scale=scale);	
     // top three blocks
     block       (-4,  -4,   FLOOR_TOP,  2,   1,   2*FULL ,     true, scale=scale);
     block       (-1,  -4,   FLOOR_TOP,  2,   1,   2*FULL ,     true, scale=scale);
     block       ( 2,  -4,   FLOOR_TOP,  2,   1,   2*FULL ,     true, scale=scale);
     color ("blue") nibbles     (-2,  -4,   FLOOR_TOP+FULL,  1,   1, scale=scale);
     nibbles     (1,  -4,    FLOOR_TOP+FULL,  1,   1, scale=scale);
     nibbles     (-4,  -3,   FLOOR_TOP,  8,   1, scale=scale);
}

module battlements_16 (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
     // base of battlements
     block       (-8,  -4,   FLOOR_BOTTOM,  16,   2, UNIT, false, scale=scale);
     // outer wall first layer
     block       (-8,  -4,   FLOOR_TOP,  16,   1,   FULL ,     false, scale=scale);	
     // top three blocks
     block       (-8,  -4,   FLOOR_TOP,  2,   1,   2*FULL ,     true, scale=scale);
     block       (-5,  -4,   FLOOR_TOP,  2,   1,   2*FULL ,     true, scale=scale);
     block       ( -2,  -4,   FLOOR_TOP,  4,   1,   2*FULL ,     true, scale=scale);
     block       ( 3,  -4,   FLOOR_TOP,  2,   1,   2*FULL ,     true, scale=scale);
     block       ( 6,  -4,   FLOOR_TOP,  2,   1,   2*FULL ,     true, scale=scale);
     color ("blue") nibbles     (-6,  -4,   FLOOR_TOP+FULL,  1,   1, scale=scale);
     nibbles     (-3,  -4,    FLOOR_TOP+FULL,  1,   1, scale=scale);
     nibbles     (2,  -4,    FLOOR_TOP+FULL,  1,   1, scale=scale);
     nibbles     (5,  -4,    FLOOR_TOP+FULL,  1,   1, scale=scale);
     // inner top row
     nibbles     (-8,  -3,   FLOOR_TOP,  16,   1, scale=scale);
}


// ----------------- Simple wall

module wall_structure (scale=SCALE)
{
    // the wall
    color ("grey") block  (-4, -4, BASE_HEIGHT,  8, 2, FLOOR_BOTTOM-BASE_HEIGHT, false, scale=scale);
    color ("magenta") battlements (scale=scale);
}

module wall_8x8 (scale=SCALE) {
   //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles     (-4,  -2,   BASE_HEIGHT,  8,   6, scale=scale);
    wall_structure (scale=scale);
}

module wall_legobase (scale=SCALE) {
   //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-4,  -4,   0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
    wall_structure (scale);
}

module wall_stackable (scale=SCALE) {
   //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-4,  -4,   0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
    color ("lightgreen") block  (-4, -4, BASE_HEIGHT,  8, 2, WALL_TOP-BASE_HEIGHT, true, scale=scale);
}

// ----------------- wall

module wall_thin_structure (scale=SCALE)
{
    // the wall
     block       (-4,  -4,   BASE_HEIGHT,  8,   1,   FLOOR_TOP ,     false, scale=scale); // long outer wall
    // pillars for the wall
    block       (-4,  -3,   BASE_HEIGHT,  1,   1,   FLOOR_BOTTOM-UNIT ,     false, scale=scale);
    block       (-1,  -3,   BASE_HEIGHT,  2,   1,   FLOOR_BOTTOM-UNIT ,     false, scale=scale);
    block       (3,  -3,   BASE_HEIGHT,  1,   1,   FLOOR_BOTTOM-THIRD ,     false, scale=scale);
    support_triangle     (-3,  -3,   FLOOR_BOTTOM-BASE_HEIGHT-UNIT,  4,   270,   2, scale=scale) ;
    support_triangle     (1,  -3,   FLOOR_BOTTOM-BASE_HEIGHT-UNIT,  4,   270,   2, scale=scale) ;
    // small blocks on top
    battlements (scale=scale);
}

module wall_thin_8x8 (scale=SCALE) {
   //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles     (-4,  -2,   BASE_HEIGHT,  8,   6, scale=scale);
    wall_thin_structure (scale=scale);
}

module wall_thin_legobase (scale=SCALE) {
   //      (col, row, up, width,length,height,nibbles_on_off) 
    doblo  (-4,  -4,   0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
    // nibbles     (-4,  -2,   BASE_HEIGHT,  8,   6, scale=scale);
    wall_thin_structure (scale);
}

module wall_thin_legobase (scale=SCALE) {
   //      (col, row, up, width,length,height,nibbles_on_off) 
    doblo  (-4,  -4,   0,  8,   2,    BASE_HEIGHT,     false, scale=scale);
    // nibbles     (-4,  -2,   BASE_HEIGHT,  8,   6, scale=scale);
    wall_thin_structure (scale);
}

// ----------------- wall on a 16x8 base

module wall_thin_16_8 (scale=SCALE)
{
   //          (col, row, up, width,length,height,nibbles_on_off, scale=scale) 
    base_plate  (-8,  -8,   0,  16,   8,    BASE_HEIGHT,     false, scale=scale);
    // 2* the small wall
    translate ([-4*PART_WIDTH(scale),4*PART_WIDTH(scale),0]) {
	wall_thin_structure (scale=scale);
    }
    translate ([4*PART_WIDTH(scale),4*PART_WIDTH(scale),0]) {
	wall_thin_structure (scale=scale);
    }

    // nibbles on the plate
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (-8,  -2,   BASE_HEIGHT,  16,   2, scale=scale);
    nibbles  (6,  -6,   BASE_HEIGHT,  2,   4, scale=scale);
    nibbles  (-4,  -6,   BASE_HEIGHT,  8,   4, scale=scale);
}

// ----------------- wall on a 16x16 base

module wall_thin_16x16 (scale=SCALE)
{
   //          (col, row, up, width,length,height,nibbles_on_off, scale=scale) 
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=scale);
    // 2* the small wall
    translate ([-4*PART_WIDTH(scale),4*PART_WIDTH(scale),0]) {
	wall_thin_structure (scale=scale);
    }
    translate ([4*PART_WIDTH(scale),4*PART_WIDTH(scale),0]) {
	wall_thin_structure (scale=scale);
    }

    // nibbles on the plate
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-8,  6,   BASE_HEIGHT,  16,   2, scale=scale);
    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-4,  -4,   BASE_HEIGHT,  8,   8, scale=scale);
}

// --------- Wall with stairs - 16 long

module wall_stairs_16_8_structure (scale=SCALE)
{
    // the wall
    block       (-8,  -4,   BASE_HEIGHT,   16,   1,   FLOOR_TOP,     false, scale=scale);
      
    // stairs
    // 1
    block       (-6,  -3,   BASE_HEIGHT,  2,   2,   THIRD ,     true, scale=scale);

    //2
    block       (-4,  -3,   FULL+BASE_HEIGHT,  2,   2,   THIRD,     true, scale=scale);
    block       (-4,  -2,   BASE_HEIGHT,  2,   1,   FULL+THIRD,     false, scale=scale);
    //          col  row   up  height, deg, width
    support_triangle     (-4,  -3,   FULL+.01,  3,   270,   2, scale=scale) ;

    // 3
    block       (-2,  -3,   2*FULL+BASE_HEIGHT,  2,   3,  THIRD,     true, scale=scale);
    block       (-2,  -2,   BASE_HEIGHT,  2,   1,   2*FULL+THIRD ,     false, scale=scale);
    support_triangle     (-2,  -3,   2*FULL+.01,  3,   270,   2, scale=scale) ;
    support_triangle     (-2,  -1,   FULL+BASE_HEIGHT,  4,   270,   2, scale=scale) ;

    // that should get me into architecture school
    // 4
    block       (0,  -3,   3*FULL+BASE_HEIGHT,  2,   3,   THIRD,     true, scale=scale);
    block       (0,  -2,   BASE_HEIGHT,  2,   1,   3*FULL+THIRD,     false, scale=scale);
    support_triangle     (0,  -3,   3*FULL+.01,  3,   270,   2, scale=scale) ;
    support_triangle     (0,  -1,   2*FULL+BASE_HEIGHT+0.1,  4,   270,   2, scale=scale) ;

    // 5
    block       (2,  -3,   4*FULL+BASE_HEIGHT,  2,   3,   THIRD,     true, scale=scale);
    block       (2,  -2,   BASE_HEIGHT,  2,   1,   FLOOR_BOTTOM-3.5*FULL ,     false, scale=scale);
    support_triangle     (2,  -3,   4*FULL+0.1,  3,   270,   2, scale=scale) ;
    support_triangle     (2,  -1,   3*FULL+BASE_HEIGHT,  4,   270,   2, scale=scale) ;

    // 6
    block       (4,  -3,   5*FULL+BASE_HEIGHT,  2,   3,   THIRD,     false, scale=scale);
    nibbles     (4,  -2,   6*FULL,  2,   2,  scale=scale);
    block       (4,  -2,   BASE_HEIGHT,   2,   1,   5*FULL+THIRD ,     false, scale=scale);
    support_triangle     (4,  -3,   5*FULL+0.1,  3,   270,   2, scale=scale) ;
    support_triangle     (4,  -1,   4*FULL+BASE_HEIGHT+0.1,  4,   270,   2, scale=scale) ;

    // last step
    block       (6,  -3,   6*FULL+BASE_HEIGHT,  2,   3,   THIRD,     true, scale=scale);
    block       (6,  -2,   BASE_HEIGHT,   2,   1,   6*FULL+THIRD ,     false, scale=scale);
    // support_triangle     (6,  -3,   6*FULL+0.1,  3,   270,   2, scale=scale) ;
    support_triangle     (6,  -1,   5*FULL+BASE_HEIGHT+0.1,  4,   270,   2, scale=scale) ;

    // pillar and support for the wall
    block       (-8,  -3,   BASE_HEIGHT,  1,   1,   FLOOR_BOTTOM-THIRD ,     false, scale=scale);
    support_triangle     (-7.5,  -3,  FLOOR_BOTTOM-FULL+.01,  4,   270,   15.5, scale=scale) ;
    battlements_16(scale=scale);
}


module wall_stairs_stackable (scale=SCALE)
{
    wall_stairs_16_8_structure (scale);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo  (-8,  -4,   0,  16,   3,   BASE_HEIGHT,     false, scale=scale);
}

module wall_stairs_16_8 (scale=SCALE)
{
    wall_stairs_16_8_structure (scale=scale);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-8,  -4,   0,  16,   8,    BASE_HEIGHT,     false, scale=scale);

    // nibbles on the plate
    nibbles  (-8,  -2,  BASE_HEIGHT,  2,   6, scale=scale);
    nibbles  (6,  -2,   BASE_HEIGHT,  2,   6, scale=scale);
    nibbles  (-6,  2,   BASE_HEIGHT,  12,   2, scale=scale);
}

module wall_stairs_16_16 (scale=SCALE)
{
    wall_stairs_16_8_structure (scale=scale);
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-8,  -4,   0,  16,   16,    BASE_HEIGHT,     false, scale=scale);

    // nibbles on the plate
    nibbles  (-8,  -2,  BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (6,  -2,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-6,  -1,   BASE_HEIGHT,  12,   2, scale=scale);
    nibbles  (-6,  3,   BASE_HEIGHT,  12,   2, scale=scale);
    nibbles  (-6,  8,   BASE_HEIGHT,  12,   4, scale=scale);
}


module wall_connector (scale=SCALE)
{
    doblo       (-4,  -4,   0,  8,   1,    FULL,     true, scale=scale);
}

// ---------------- gatehouse tower 

module gatehouse_structure (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    // the outer wall
    block       (-4,  -4,   BASE_HEIGHT,   2,   2,   FLOOR_BOTTOM-THIRD ,     false, scale=scale);
    block       (2,  -4,   BASE_HEIGHT,  2,   2,   FLOOR_BOTTOM-THIRD ,     false, scale=scale);
    // top of door - 8.5 to avoid manifold
    support_triangle     (1,  -4,   FLOOR_BOTTOM-2.7*FULL,  12.01,   180,   2, scale=scale) ;
    support_triangle     (-2,  -4,   FLOOR_BOTTOM-2.7*FULL,  12.01,   0,   2, scale=scale) ;

    // middle
    block       (-4,  -2,   BASE_HEIGHT,   1,   4,   FLOOR_BOTTOM-THIRD ,     false, scale=scale);
    block       (3,  -2,   BASE_HEIGHT,  1,   4,   FLOOR_BOTTOM-THIRD ,     false, scale=scale);
    // top of door - 8.5 to avoid manifold
    support_triangle     (-3,  -1,   FLOOR_BOTTOM-2.7*FULL,  12.01,   0,   2, scale=scale) ;
    support_triangle     (2,  -1,   FLOOR_BOTTOM-2.7*FULL,  12.01,   180,   2, scale=scale) ;

    // inwards
    block       (-4,  2,   BASE_HEIGHT,   2,   2,   FLOOR_BOTTOM-THIRD ,     false, scale=scale);
    block       (2,  2,   BASE_HEIGHT,  2,   2,   FLOOR_BOTTOM-THIRD ,     false, scale=scale);

    support_triangle     (1,  2,   FLOOR_BOTTOM-2.7*FULL,  12.01,   180,   2, scale=scale) ;
    support_triangle     (-2,  2,   FLOOR_BOTTOM-2.7*FULL,  12.01,   0,   2, scale=scale) ;

    // roof
    block       (-4,  -3,   FLOOR_BOTTOM,   8,   4,  UNIT ,     false, scale=scale);    
    # block       (-4,  2,   FLOOR_BOTTOM,   8,   2,  UNIT ,     false, scale=scale);    
    battlements (scale=scale);
    color ("blue") nibbles     (-4,  -1,   FLOOR_TOP,  8,   2, scale=scale);
    color ("blue") nibbles     (-4,  2,   FLOOR_TOP,  8,   2, scale=scale);

}

module gatehouse_tower (scale=SCALE)
{
   base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
   nibbles     (-1,  -4,   BASE_HEIGHT,  2,   8, scale=scale);
   nibbles     (-3,  -1,   BASE_HEIGHT,  2,   2, scale=scale);
   nibbles     (1,  -1,   BASE_HEIGHT,  2,   2, scale=scale);
   gatehouse_structure (scale=scale);
}

module gatehouse_tower_stackable (scale=SCALE)
{
     doblo       (-4,  -4,   0,  2,   8,    BASE_HEIGHT,     false, scale=scale);
     doblo       (2,  -4,   0,  2,   8,    BASE_HEIGHT,     false, scale=scale);
     gatehouse_structure (scale=scale);
}


// ----------------- portal

module portal_structure (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    // the wall
    block       (-4,  -4,   BASE_HEIGHT,   2,   2,   FLOOR_BOTTOM-THIRD ,     false, scale=scale);
    block       (2,  -4,   BASE_HEIGHT,  2,   2,   FLOOR_BOTTOM-THIRD ,     false, scale=scale);
    // top of door - 8.5 to avoid manifold
    support_triangle     (1,  -4,   FLOOR_BOTTOM-2.5*FULL,  10,   180,   2, scale=scale) ;
    support_triangle     (-2,  -4,   FLOOR_BOTTOM-2.5*FULL,  10,   0,   2, scale=scale) ;
    battlements (scale=scale);
}

module portal_8x8 (scale=SCALE)
{
   base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
   nibbles     (-4,  -2,   BASE_HEIGHT,  2,   6, scale=scale);
   nibbles     (2,  -2,   BASE_HEIGHT,  2,   6, scale=scale);
   nibbles     (-2,  -4,   BASE_HEIGHT,  4,   2, scale=scale);
   nibbles     (-2,  2,   BASE_HEIGHT,  4,   2, scale=scale);
   portal_structure (scale=scale);
}

module portal_stackable (scale=SCALE)
{
     doblo       (-4,  -4,   0,  2,   2,    BASE_HEIGHT,     false, scale=scale);
     doblo       (2,  -4,   0,  2,   2,    BASE_HEIGHT,     false, scale=scale);
     portal_structure (scale=scale);
}

module portal_8x8_legobase (scale=SCALE)
{
     doblo  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
     nibbles     (-4,  -2,   BASE_HEIGHT,  2,   6, scale=scale);
     nibbles     (2,  -2,   BASE_HEIGHT,  2,   6, scale=scale);
     nibbles     (-2,  -4,   BASE_HEIGHT,  4,   2, scale=scale);
     nibbles     (-2,  2,   BASE_HEIGHT,  4,   2, scale=scale);
     portal_structure (scale=scale);
}

// ------------------ corner, just two walls

module corner_8x8 (scale=SCALE) 
{
    wall_structure (scale);
    translate ([0*PART_WIDTH(scale),0*PART_WIDTH(scale),0]) {
	rotate (a=[0,0,270]) wall_structure (scale);
    }
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles     (-4,  -2,   BASE_HEIGHT,  6,   6, scale=scale);
}

module corner_stackable (scale=SCALE) 
{
    wall_structure (scale);
    // no translation
    translate ([0*PART_WIDTH(scale),0*PART_WIDTH(scale),0]) {
	rotate (a=[0,0,270]) wall_structure (scale);
    }
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-4,  -4,   0,  8,   2,    BASE_HEIGHT,  false, scale=scale);
    doblo       (2,  -2,   0,  2,   6,    BASE_HEIGHT,  false, scale=scale);
}


// ------------------ corner, just two walls

module corner_thin_8x8 (scale=SCALE) 
{
    wall_thin_structure (scale);
    translate ([0*PART_WIDTH(scale),0*PART_WIDTH(scale),0]) {
	rotate (a=[0,0,270]) wall_thin_structure (scale);
    }
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles     (-4,  -2,   BASE_HEIGHT,  6,   6, scale=scale);
}

// somewhat stackable
module corner_thin_stackable (scale=SCALE) 
{
    wall_thin_structure (scale);
    // no translation
    translate ([0*PART_WIDTH(scale),0*PART_WIDTH(scale),0]) {
	rotate (a=[0,0,270]) wall_thin_structure (scale);
    }
    //          (col, row, up, width,length,height,nibbles_on_off) 
    doblo       (-4,  -4,   0,  8,   2,    BASE_HEIGHT,  false, scale=scale);
    doblo       (2,  -2,   0,  2,   6,    BASE_HEIGHT,  false, scale=scale);
}


// ----------------- thin corner on a 16x16 base

module corner_thin_16_structure (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off, scale=scale) 
    base_plate  (-8,  -8,   0,  16,   16,    BASE_HEIGHT,     false, scale=scale);
    // 2* the small wall
    translate ([-4*PART_WIDTH(scale),4*PART_WIDTH(scale),0]) {
	wall_thin_structure (scale);
    }
    translate ([4*PART_WIDTH(scale),4*PART_WIDTH(scale),0]) {
	wall_thin_structure (scale);
    }
    // walls on the right
    translate ([4*PART_WIDTH(scale),-4*PART_WIDTH(scale),0]) {
	rotate (a=[0,0,270]) wall_thin_structure (scale);
    }
    translate ([4*PART_WIDTH(scale),4*PART_WIDTH(scale),0]) {
	rotate (a=[0,0,270]) wall_thin_structure (scale);
    }

}

module corner_thin_16 (scale=SCALE)
{
    corner_thin_16_structure (scale) ;
    // nibbles on the plate
    nibbles  (-8,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-8,  6,   BASE_HEIGHT,  14,   2, scale=scale);
    //    nibbles  (6,  -6,   BASE_HEIGHT,  2,   14, scale=scale);
    nibbles  (-4,  -4,   BASE_HEIGHT,  8,   8, scale=scale);
}

// ---------------------- pool, any castly must have one
// includes some openscad code

module pool_structure (scale=SCALE) {
    difference () {
	hull () {
	    cyl_block   (-3, -2,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=scale) ;   
	    cyl_block   (-0.5,   -3,  BASE_HEIGHT,    2,    2,   2*FULL,   false, scale=scale) ;   
	    cyl_block   (1,  -2,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=scale) ;   
	    cyl_block   (-2,    1,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=scale) ;   
	    cyl_block   (1.5,   0,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=scale) ;   
	}
	translate ([0,0,2 ]) {
	     # hull () {
		  cyl_block   (-2, -1.5,  BASE_HEIGHT,  1,    2,   2*FULL,   false, scale=scale) ;   
		  cyl_block  (-0.5,  -2,  BASE_HEIGHT,    1,    2,   2*FULL,   false, scale=scale) ;   
		  cyl_block   (-1.5,    0.5,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=scale) ;   
		  cyl_block   (1,   -0.5,  BASE_HEIGHT,  2,    2,   2*FULL,   false, scale=scale) ;   
		  cyl_block   (0.5,  -1.5,  BASE_HEIGHT,  1,    2,   2*FULL,   false, scale=scale) ;   
	     }
	}
    }
}

module pool (scale=SCALE)
{
    //          (col, row, up, width,length,height,nibbles_on_off) 
    base_plate  (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles  (-4,  -4,   BASE_HEIGHT,  2,   2, scale=scale);
    nibbles  (2,  -4,   BASE_HEIGHT,  2,   2, scale=scale);
    nibbles  (2,  2,   BASE_HEIGHT,  2,   2, scale=scale);
    nibbles  (-4,  2,   BASE_HEIGHT,  2,   2, scale=scale);
    pool_structure(scale=scale);
}

// ---------------------- pool, stackable any castly must have one
// includes some openscad code

module pool_legobase (scale=SCALE)
{
    //       (col, row, up, width,length,height,nibbles_on_off) 
    pool_structure(scale);

    doblo    (-4,  -4,   0,  8,   8,    BASE_HEIGHT,     false, scale=scale);
    nibbles  (-4,  -4,   BASE_HEIGHT,  2,   2, scale=scale);
    nibbles  (2,  -4,   BASE_HEIGHT,  2,   2, scale=scale);
    nibbles  (2,  2,   BASE_HEIGHT,  2,   2, scale=scale);
    nibbles  (-4,  2,   BASE_HEIGHT,  2,   2, scale=scale);
}

module pool_big_structure (scale=SCALE) {

     nibbles  (-3,  -3, BASE_HEIGHT+3*FULL-BASE_HEIGHT,  1,   1, scale=scale);
     nibbles  (2,  -3, BASE_HEIGHT+3*FULL-BASE_HEIGHT,  1,   1, scale=scale);
     nibbles  (2,  2, BASE_HEIGHT+3*FULL-BASE_HEIGHT,  1,   1, scale=scale);
     nibbles  (-3,  2, BASE_HEIGHT+3*FULL-BASE_HEIGHT,  1,   1, scale=scale);
     difference () {
	  hull () {
	       cyl_block   (-3, -3,  BASE_HEIGHT,  2,    2,   3*FULL-BASE_HEIGHT,   false, scale=scale) ;   
	       cyl_block   (1,   -3,  BASE_HEIGHT,    2,    2,   3*FULL-BASE_HEIGHT,   false, scale=scale) ;   
	       cyl_block   (1,    1,  BASE_HEIGHT,  2,    2,   3*FULL-BASE_HEIGHT,   false, scale=scale) ;   
	       cyl_block   (-3,   1,  BASE_HEIGHT,  2,    2,   3*FULL-BASE_HEIGHT,   false, scale=scale) ;   
	  }
	  translate ([0,0,0.2]) {
	       # hull () {
		    cyl_block   (-2.5, -2.5,  BASE_HEIGHT,  2,    2,   3*FULL-BASE_HEIGHT,   false, scale=scale) ;   
		    cyl_block   (0.5,   -2.5,  BASE_HEIGHT,    2,    2,   3*FULL-BASE_HEIGHT,   false, scale=scale) ;   
		    cyl_block   (0.5,    0.5,  BASE_HEIGHT,  2,    2,   3*FULL-BASE_HEIGHT,   false, scale=scale) ;   
		    cyl_block   (-2.5,   0.5,  BASE_HEIGHT,  2,    2,   3*FULL-BASE_HEIGHT,   false, scale=scale) ;   
	       }
	  }
     }
}


module pool_stackable (scale=SCALE) {
    doblo    (-3,  -3,   0,  6,   6,    BASE_HEIGHT,     false, scale=scale);
    pool_big_structure(scale);
}

// ---- some legos/duplos

module bricks (scale=SCALE) {
    //    (col, row, up, width,length,height,nibbles_on_off, diamonds) 
    doblo (0,   0,   0,   4,   2,    FULL,  true, false , scale=scale);
    doblo (5,   0,   0,   1,   2,    FULL,  true, false , scale=scale);
    doblo (7,   0,   0,   1,   2,    FULL,  true, false , scale=scale);
    doblo (0,   3,   0,   2,   2,    FULL,  true, false , scale=scale);
    doblo (-3,   3,   0,   2,   2,    FULL,  true, false , scale=scale);
    doblo (3,   3,   0,   2,   2,    BASE_HEIGHT,  false, false , scale=scale);
    block (3,   3,   BASE_HEIGHT,   2,   2,  2*FULL+THIRD,  true, false , scale=scale);
    doblo (6,   3,   0,   2,   2,    BASE_HEIGHT,  false, false , scale=scale);
    block (6,   3,   BASE_HEIGHT,   2,   2,    2*FULL+THIRD,  true, false , scale=scale);
    doblo (0,   -3,   0,  8,  2,    FULL,  true, false , scale=scale);
    doblo (-5,   -3,   0,  4,  4,    2,  true, false , scale=scale);
 }

// for connecting base plates
module bricks_flat (scale=SCALE) {
    //    (col, row, up, width,length,height,nibbles_on_off, diamonds) 
    doblo (0,   3,   0,   2,   4,    THIRD,  false, false , scale=scale);
    doblo (3,   3,   0,   2,   4,    THIRD,  true, false , scale=scale);
    doblo (0,   0,  0,    8,   2,    THIRD,  true, false , scale=scale);
    doblo (0,  -3,  0,    8,   2,    THIRD,  false, false , scale=scale);
    doblo (6,  3,  0,     2,   4,    THIRD,  true, false , scale=scale);
}


