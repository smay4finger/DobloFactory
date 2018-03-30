/* Castle kit, Lego and Duplo compatible-- examples
Daniel.schneider@unige.ch (DKS)
VERSION 2.x modified for usability and compatibility by DKS feb 2017
VERSION 1.2 modified as an extension to doblo-factory v2.0 by dmtaub@cemi.org
VERFSION 1 sept./dec 2012

The doblo factory is documented here:
http://edutechwiki.unige.ch/en/Doblo_factory

Download
http://tecfa.unige.ch/guides/3dprinting/doblo-factory/

*/

// *** SCALE MUST BE SET ! *** (but you can override later)

// SCALE=1;   // DUPLO Size, partially print tested
SCALE =0.5;   // Lego size, print tested
// SCALE=0.25; // Half lego size (1/8 volume, not print tested)

// LOAD doblo factory
include <../doblo-factory.scad>;
// LOAD castle kit extension. It sits in the "ext" directory
include <../ext/castle-kit-2-0.scad>;

// One can override global scale for a single model, thus combining scales.
// uncomment 2 of the following lines for an example: 
// large_example (); 
// large_example (scale=0.25);
// large_example (scale=0.5);
// tower_legobase(scale=0.25); 
// tower_legobase(scale=0.5);  

echo (str ("LATTICE-WIDTH = ", LATTICE_WIDTH(SCALE)));	
echo (str ("SCALE = ", SCALE));

// ----------------  Execute models. Uncomment only one

// --- vertical scales - get an idea how heights are working
// vert_scale ();
// vert_scale_full ();
// man_scale ();

// --- simple brick for calibrating doblo-factory params
// color ("orange") calibration();

// --- reference model for height
// translate([100,0,0]) { tower (); }

// --- simple plates
// base ();                    // --- simple 8x8 base with partly empty floor
// base_16 ();                 // --- simple 16x16 base with partly empty floor, must have
// base_24 ();                 // --- For the ambitious, full 24x24 plate, THIRD height
// base_legobase ();            // --- simple 8x8 stackable base with partly empty floor

// --- square tower
// tower();                     // --- 8x8 Tower
// tower_16();                  // --- 8x8 Tower sitting on a 16x16 base plate, must have
// tower_legobase();            // --- tower
// tower_stackable();            // --- tower, must have

// --- fairly ugly corner tower 
// corner_tower ();             // --- Corner with tower inside
// corner_tower_legobase ();      // --- Corner with tower inside
// corner_tower_stackable ();      // --- Corner with tower inside

// --- round tower
// tower_round();               // --- 8x8 round Tower
// tower_round_16();            // --- 8x8 round Tower  on 16x16 plate
// tower_round_legobase();      // --- round tower
// tower_round_stackable();      // --- round tower, must have

// --- round tower square
// tower_round_square();        // --- 8x8 round Tower
// tower_round_square_16();        // --- 8x8 round Tower on 16x16 plate
// tower_round_square_legobase();  // --- 8x8 round Tower
// tower_round_square_stackable();  // --- 8x8 round Tower, must have
// tower_round_square_element();    // --- like above, but stacking on itself looks better

// --- dungeon
// dungeon ();
// dungeon_stackable ();

// --- wizard tower
// wizard_tower ();             // --- 6x6 small round tower with texture
// wizard_tower_legobase ();    // --- tower, must have
// wizard_tower_stackable ();    // --- tower, must have

// --- stackable tower/house elements

// tower_floor_stackable ();    // --- stackable floor with pillars underneath
// pillars_legobase ();         // --- stackable floor with pillars on top
// pillars_stackable ();        // --- two pillars connected at bottom
// pillars_round_stackable ();  // --- round ones
// tower_roof_legobase ();      // --- anti-rain measures, lots of overhangs

// --- gatehouse tower

gatehouse_tower ();
// gatehouse_tower_stackable ();

// --- walls 
// wall_8x8 ();                 // --- Very simple wall on plate, sturdy
// wall_legobase ();            // --- Very simple wall on lego feet , sturdy
// wall_stackable ();            // --- Very simple wall (a big lego brick)
// wall_thin_8x8 ();            // --- Simple wall on plate
// wall_thin_legobase ();       // --- Simple wall on lego feet
// wall_thin_16x16 ();             // --- Simple wall on a 16x16 plate
// wall_thin_16_8 ();           // --- Simple wall on a 16x8 plate
// wall_stairs_16_8 ();         // --- Wall and stairs on a 16x8 plate
// wall_stairs_stackable ();     // --- Wall and stairs 16 long
// wall_stairs_16_16 ();        // --- Wall and stairs on a 16x8 plate
// portal_8x8 ();               // --- Portal on a 8x8 plate, a wall with a "door"
// portal_8x8_legobase ();         // --- Portal on a 8x8 plate, a wall with a "door"
// portal_stackable ();         // --- Portal on lego feet, a wall with a "door"

// ---- corners
// corner_8x8 ();                   // --- Corner, two simple walls, ugly
// corner_stackable ();          // --- Corner, two simple walls, ugly
// corner_thin_8x8 ();              // --- Corner, two walls, thinner and nicer
// corner_thin_stackable ();     // --- Corner, two walls, thinner
// corner_thin_16 ();           // --- Corner on 16x16 basis

// --- other objects

// pool ();                     // --- pool, jacuzzi-style on base plate
// pool_legobase ();            // --- stackable pool, jacuzzi-style, must have
// pool_stackable ();            // --- stackable pool, jacuzzi-style, must have 
// large_example ();            // --- a large glued layout

// --- some ordinary Lego bricks
// bricks ();                   // --- collection of bricks 1
// bricks_flat ();              // --- collection of bricks 2    
// wall_connector () ;          // --- connect towers on top or for stacking

// --------------- simple bricks and tests -------------

//         (col, row, up, width, length, height, scale) 
// house_lr   (-5, -1,  0,  10,    3,     3*FULL, SCALE) ;
// house_fb   (-5, -1,  0,  3,    10,     3*FULL, SCALE) ;
// doblo   (0,   -5,   0,   4,   2,    3*FULL,  false, false, SCALE );	
// color("red") doblo   (0,   6,   0,   4,   2,    FULL,  true, false, SCALE );
// color("red") doblo   (0,   0,   0,   2,   2,    FULL,  true, false, DOBLO );
// color("green") doblo   (0,   5,   0,   2,   2,    FULL,  true, false, LUGO );
// color("pink") doblo   (0,   5,   0,   2,   2,    THIRD,  true, false, 0.5 );
// color("yellow") doblo   (0,   3,   0,   4,   4,   2*THIRD,  true, false, SCALE );
// doblo   (0,   0,   0,   2,   2,    2*THIRD,  false, false, SCALE );	
// color("blue")  doblo (-8,  4,   0,   4,   4,    THIRD,  false, false , scale=SCALE);
// flat leg<obase plate
// doblo  (-4,  -4,   0,  8,   8,   THIRD,   false, scale=SCALE);
// base_plate (width=16, length=16, nibbles_on_off=true);
