$fn = 16;

/*
// Wall thickness
WALL    = 2;

// Object dimensions
OBJECT  = [40,60,10];

// Distance between Object and Wall
PADDING = [0.4,0.4,0.4]; 

// Ratio between cover and case
COVER_RATIO = 0.3;

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

OPENINGS = [[[10,WALL,4],[0,0,0],0],
            [[10,WALL,4],[0,0,0],1],
            [[10,WALL,4],[0,0,0],2],
            [[10,WALL,4],[0,0,0],3],
            [[10,WALL,4],[0,0,0],4],
            [[10,WALL,4],[0,0,0],5]
           ];
           


OPENINGS = [[[10,WALL,4],[0,0,0],0],
            [[10,WALL,4],[0,0,0],1]
           ];

*/

// calculate outside dimensions
OBJECT_BOX = OBJECT + 2 * PADDING + 2 * [WALL, WALL, WALL]; 

// calculate rim thickness
RIM_THICKNESS = (WALL - RIM_GAP)/2;


module outside_rim(){
    translate([0,0,(OBJECT_BOX[2]/2 - RIM_HEIGHT/2) - COVER_RATIO * OBJECT_BOX[2] + RIM_HEIGHT]){
        difference(){
            cube([OBJECT_BOX[0], OBJECT_BOX[1], RIM_HEIGHT], center = true);
            cube([OBJECT_BOX[0] - (WALL - RIM_GAP), 
                  OBJECT_BOX[1] - (WALL - RIM_GAP),
                  RIM_HEIGHT], center = true);
        }
    }
}


module inside_rim(){
    translate([0,0,(OBJECT_BOX[2]/2 - RIM_HEIGHT/2) - (COVER_RATIO * OBJECT_BOX[2]) + RIM_HEIGHT - RIM_GAP]){
        difference(){
            cube([OBJECT_BOX[0], OBJECT_BOX[1], RIM_HEIGHT], center = true);
            cube([OBJECT_BOX[0] - (WALL + RIM_GAP), 
                  OBJECT_BOX[1] - (WALL + RIM_GAP),
                  RIM_HEIGHT], center = true);
        }
    }
}


module case_bottom(){
    // cut openings into upper part
    difference(){
        // lower part with rim
        union(){
            outside_rim();
            // cut off the upper part by COVER_RATIO
            difference(){
                case();
                translate([0,0,OBJECT_BOX[2]/2 - COVER_RATIO * OBJECT_BOX[2]/2])
                    scale([1,1,COVER_RATIO])
                        cube(OBJECT_BOX, center = true);
            }
        }
        create_openings(OPENINGS);
    }
    mount_holes();
}


module case_top(){
    // cut off the lower part by COVER_RATIO, create openings and a rim
    difference(){
        case();
        translate([0,0,- OBJECT_BOX[2]/2 + (1 - COVER_RATIO) * OBJECT_BOX[2]/2])
            scale([1,1,1 - COVER_RATIO])
                cube(OBJECT_BOX, center = true);
        inside_rim();
        create_openings(OPENINGS);
    }
}


module case(){
    difference(){
        cube(OBJECT_BOX, center = true);
        cube(OBJECT_BOX - 2 * [WALL,WALL,WALL], center = true);
    }
}




module create_openings(OPENINGS){
    module draw_opening(X_ZERO_LOC, Y_ZERO_LOC, Z_ZERO_LOC, DIMENSION, LOCATION, ROTATION){
        translate([X_ZERO_LOC, Y_ZERO_LOC, Z_ZERO_LOC])
                translate(LOCATION)
                    rotate(ROTATION){
                        hull(){
                        cube(DIMENSION, center = true);
                        translate([0,- DIMENSION[1] + WALL/2, 0])
                            cube([DIMENSION[0] + 2, WALL - 0.1 * WALL, DIMENSION[2] + 2],center = true);
                        }
                    }
    }

    for (OPENING = [0:len(OPENINGS)-1]) {
        DIMENSION   = OPENINGS[OPENING][0];
        LOCATION    = OPENINGS[OPENING][1];
        POSITION    = OPENINGS[OPENING][2];
        
        
        echo(POSITION);
        
        // front
        if (POSITION == 0) {
            X_ZERO_LOC  = - (OBJECT[0]/2 - DIMENSION[0]/2);
            Y_ZERO_LOC  = - (OBJECT_BOX[1]/2 - DIMENSION[1]/2);
            Z_ZERO_LOC  = - (OBJECT[2]/2 - DIMENSION[2]/2);
            ROTATION    = [0,0,0];
            
            draw_opening(X_ZERO_LOC, Y_ZERO_LOC, Z_ZERO_LOC, DIMENSION, LOCATION, ROTATION);
        }
        
        //back
        if (POSITION == 1) {
            X_ZERO_LOC  = - (OBJECT[0]/2 - DIMENSION[0]/2);
            Y_ZERO_LOC  = (OBJECT_BOX[1]/2 - DIMENSION[1]/2);
            Z_ZERO_LOC  = - (OBJECT[2]/2 - DIMENSION[2]/2);
            ROTATION    = [0,0,180];
            
            draw_opening(X_ZERO_LOC, Y_ZERO_LOC, Z_ZERO_LOC, DIMENSION, LOCATION, ROTATION);
        }
        
        // left
        if (POSITION == 2) {
            X_ZERO_LOC  = - (OBJECT_BOX[0]/2 - DIMENSION[1]/2);
            Y_ZERO_LOC  = - (OBJECT[1]/2 - DIMENSION[0]/2);
            Z_ZERO_LOC  = - (OBJECT[2]/2 - DIMENSION[2]/2);
            ROTATION    = [180,0,90];
            
            draw_opening(X_ZERO_LOC, Y_ZERO_LOC, Z_ZERO_LOC, DIMENSION, LOCATION, ROTATION);
        }
        
        // right
        if (POSITION == 3) {
            X_ZERO_LOC  = (OBJECT_BOX[0]/2 - DIMENSION[1]/2);
            Y_ZERO_LOC  = - (OBJECT[1]/2 - DIMENSION[0]/2);
            Z_ZERO_LOC  = - (OBJECT[2]/2 - DIMENSION[2]/2);
            ROTATION    = [0,0,90];
            
            draw_opening(X_ZERO_LOC, Y_ZERO_LOC, Z_ZERO_LOC, DIMENSION, LOCATION, ROTATION);
        }
        
        // top
        if (POSITION == 4) {
            X_ZERO_LOC  = - (OBJECT[0]/2 - DIMENSION[0]/2);
            Y_ZERO_LOC  = - (OBJECT[1]/2 - DIMENSION[2]/2);
            Z_ZERO_LOC  = (OBJECT_BOX[2]/2 - DIMENSION[1]/2);
            ROTATION    = [90,180,0];
            
            draw_opening(X_ZERO_LOC, Y_ZERO_LOC, Z_ZERO_LOC, DIMENSION, LOCATION, ROTATION);
        }
        
        // bottom
        if (POSITION == 5) {
            X_ZERO_LOC  = - (OBJECT[0]/2 - DIMENSION[0]/2);
            Y_ZERO_LOC  = - (OBJECT[1]/2 - DIMENSION[2]/2);
            Z_ZERO_LOC  = - (OBJECT_BOX[2]/2 - DIMENSION[1]/2);
            ROTATION    = [90,0,0];
            
            draw_opening(X_ZERO_LOC, Y_ZERO_LOC, Z_ZERO_LOC, DIMENSION, LOCATION, ROTATION);
        }
    }
}

module mount_hole(X,Y,Z){
    translate([X,Y,Z])
        difference(){
            cylinder(MNT_HEIGHT, MNT_RADIUS + 1.2, MNT_RADIUS + 0.6, center = true);
            cylinder(MNT_HEIGHT, MNT_RADIUS, MNT_RADIUS, center = true);
        }
}


module mount_holes(){
    MNT_X = (OBJECT[0] - MNT_RADIUS)/2 - MNT_LOC_X;
    MNT_Y = (OBJECT[1] - MNT_RADIUS)/2 - MNT_LOC_Y;
    MNT_Z = - (OBJECT_BOX[2] - MNT_HEIGHT)/2 + WALL;
    
    // front left
    mount_hole(- MNT_X, - MNT_Y, MNT_Z);
    
    // front right
    mount_hole(MNT_X, - MNT_Y, MNT_Z);
    
    // back left
    mount_hole(- MNT_X, MNT_Y, MNT_Z);
    
    // front left
    mount_hole(MNT_X, MNT_Y, MNT_Z);
}