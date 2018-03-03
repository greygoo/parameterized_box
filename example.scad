$fn = 16;


// Wall thickness
WALL    = 1.4;

// Object dimensions
OBJECT  = [40,60,10];

// Distance between Object and Wall
PADDING = [0.4,0.4,0.4]; 

// Ratio between cover and case
COVER_RATIO = 0.4;

// Height of the rim
RIM_HEIGHT = 4;

// Gap for the Rim
RIM_GAP = 0.2;

// Radius of mountholes
MNT_RADIUS = 1.5;

// X/Y distance from wall for mountholes
MNT_LOC_X = 3;
MNT_LOC_Y = 3;

// Mount hole height
MNT_HEIGHT = 3;

/*
Define openings as matrix. Each line is on opening defined as

[DIMENSION,LOCATION,WALL]

DIMENSION:  defined as [X,Y,Z] values for the opening on the front of the object,
            before being rotated to fit on a wall other than the front.
LOCATION:   the distance of the lower left point of the opening from the lower
            left front of the object.
WALL:       the wall the opening is moved to:
            0: Front
            1: Back
            2: Left
            3: Right
            4: Top
            5: Bottom

*/

/*OPENINGS = [[[10,WALL,4],[0,0,0],0],
            [[10,WALL,4],[0,0,0],1],
            [[10,WALL,4],[0,0,0],2],
            [[10,WALL,4],[0,0,0],3],
            [[10,WALL,4],[0,0,0],4],
            [[10,WALL,4],[0,0,0],5]
           ];
*/           


OPENINGS = [[[10,WALL,4],[0,0,0],0],
            [[10,WALL,4],[0,0,0],1]
           ];

include <parameterized_box.scad>

*case_top();
case_bottom();
