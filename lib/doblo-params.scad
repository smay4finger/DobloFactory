/*
 Copyright (c) 2013 Daniel M. Taub
 Copyright (c) 2010 Daniel K. Schneider

 This file is part of DobloFactory.

 DobloFactory is free source: you can redistribute it and/or modify
    modify it under the terms of the CC BY-NC-SA 3.0 License:
    CreativeCommons Attribution-NonCommerical-ShareAlike 3.0
    as published by Creative Commons.

    You should have received a copy of the CC BY-NC-SA 3.0 License
    with this source package.
    If not, see <http://creativecommons.org/licenses/by-nc-sa/3.0/>

-------------------------
PARAMETERS              -
-------------------------

These define in principle all dimensions.

Close to DUPLO dimensions by default. Depending on your printer and your layer/thickness printing parameters you do want to change nibbles and walls. The settings below are for a layer Thickness of 0.25mm

All units are mm.

Dimensions:
* A typical small 2x2 nibbles on top DUPLO compatible brick with one nibble underneath is
32mm x 32mm x 19.2mm (plus a nibble height of 4.5mm)
* LEGO-compatible bricks are half that size in all three dimensions

*/

// Normal size (DUPLO)
// SCALE = 1;
// Lego size - see also the hacks in the code for fixing wall and nibble dimensions
// SCALE = 0.5 ;
// Mini Lego size / Nano - does not really work yet, but you can try
// SCALE = 0.25

// DATA FOR QUATRO (DMT)
// nibble outter diam: 18.45
// nibble inner diam: 14.45
// nibble inner nub(for duplo) diam: 13.25

CADRO = 2; // not yet tested
DOBLO = 1;
LUGO = 0.5;
MINI = 0.25; // not tested much

HALF=3;
THIRD=2;
THIRDx2=4;
FULL=6;

// defines minimum size of a fragment of a nibble, e.g. set openscad $fs
// Smaller is better, but will take much more time for rendering and slicing
NIBBLE_FS = 0.5;
CYL_FS = 2;

// LEGO SCALE - don't change, allows to create nano legos, should be 1 if real Legos
function LEGO_SCALE(SCALE) = 2 * SCALE;

// Doblo block size
// Real DUPLO Block = 31.7 / 2 = 15.85 (with some variations)
function PART_WIDTH(SCALE)  = 16.0  * SCALE;

// Block height (a typical block is 4 * PART_HEIGHT)
// Real Duplo Block = 19.17 / 4 = 4.8, we also measured 19.09, 19.16
function PART_HEIGHT(SCALE)  = (SCALE < 0.6) ? ( 1.6 * LEGO_SCALE(SCALE) ) : ( 3.2 * SCALE );
// Diamonds - size of anti-warping holes - used optionally
DIAMOND = 4;

// Top nibble size definitions
// Must be adjusted with respect to layer resolution and other slicing considerations
function NO(SCALE)         = PART_WIDTH(SCALE) / 2.0;              //nibble offset
function NBO(SCALE)        = PART_WIDTH(SCALE);                   // nibble bottom offset
function NH(SCALE)         = (SCALE < 0.6) ? 1.75 * LEGO_SCALE(SCALE) : 4.55 * SCALE;  // LEGO vs. DUPLO
function NB_RADIUS(SCALE)  = (SCALE < 0.6) ? (4.9 / 2 * LEGO_SCALE(SCALE)) : (9.2 / 2.0 * SCALE);  // Lego vs. DUPLO

// Real DUPLO Block = 9.38
function NB_RADIUS_INSIDE(SCALE) = 6.8/2  * SCALE;
// 6.44 = Real DUPLO block

function NB_THICKNESS(SCALE)=NB_RADIUS(SCALE)-NB_RADIUS_INSIDE(SCALE);

// For square nibble supports in 1xM or Nx1 blocks
function ALONG_LEN(SCALE)  = (PART_WIDTH(SCALE)-NB_RADIUS(SCALE))/1.7; //tighter fit than 1.8
function CROSS_LEN(SCALE)  = (PART_WIDTH(SCALE)-NB_RADIUS(SCALE)/2);

// Bottom nibbles size definitions
// Must be adjusted with respect to layer resolution and other slicing considerations
function NB_BOTTOM_RADIUS(SCALE)        = (SCALE < 0.6) ? 6.5/2*LEGO_SCALE(SCALE) : 13.4/2*SCALE;
function NB_BOTTOM_RADIUS_THIN(SCALE)   = (SCALE < 0.6) ? 3.5/2*LEGO_SCALE(SCALE) : 7.2/2*SCALE;
// Real DUPLO = 13.48
function NB_BOTTOM_RADIUS_INSIDE(SCALE) = (SCALE < 0.6) ? 4.8/2*LEGO_SCALE(SCALE) : 10.8/2*SCALE;
// Real DUPLO = 10.73
// rapman 10.6
// Real Lego = 4.9

// walls - IMPORTANT: must be adjusted with respect to layer resolution and other slicing considerations
function DOBLOWALL(SCALE) = (SCALE < 0.6) ? 1.2 * LEGO_SCALE(SCALE): 1.55 *SCALE;
// Lego vs. Duplo, Lego is not 2x smaller
// Real Lego = 1.2

function USE_INSET(SCALE) = (SCALE < 0.6) ? true : true;
function INSET_WIDTH(SCALE)    = (SCALE < 0.6) ? 0.4 *LEGO_SCALE(SCALE) : 1.50 * SCALE; //little inset walls to make it stick
function INSET_LENGTH(SCALE)  = (SCALE < 0.6) ? 3*DOBLOWALL(SCALE) : 4*DOBLOWALL(SCALE); // Legos have proportionally smaller insets

//lattice width and height (optional, see LATTICE_TYPE)
// A grid underneath the flat bridge, crossing through the nibbles underneath
function LATTICE_WIDTH(SCALE)   = 1.50 * SCALE;

// 0 means none, 1 means more spacing (same as nibbles underneath),
// 2 means denser
LATTICE_TYPE    = 1;

// Sizes of a standard 2x2 square brick, normal height
// Not used, but are practical in your custom modules
function DOBLOWIDTH(SCALE)  = PART_WIDTH(SCALE)  * 2.0  * SCALE;
function DOBLOHEIGHT(SCALE) = PART_HEIGHT(SCALE) * 6.0  * SCALE;
function LEGOHEIGHT(SCALE)  = PART_HEIGHT(SCALE) * 6.0  * SCALE;

