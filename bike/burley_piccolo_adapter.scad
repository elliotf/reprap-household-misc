include <../lib/util.scad>;

// dimensions seem to be imperial.  :(

extrusion_height = 0.3;

resolution = 16;
vertical_clearance = 5;
length_clearance   = 5;

channel_depth  = 20.5 + vertical_clearance;
channel_length = 80;
overall_length = channel_length + length_clearance*2;
overall_depth  = channel_depth + vertical_clearance;

channel_inner  = 82.5;
channel_outer  = 107.5;
channel_width  = (channel_outer - channel_inner) /2; // something like 1/2 inch
channel_pos_x  = channel_inner/2 + channel_width/2;

brace_width    = 16.35;
brace_height   = 16 + vertical_clearance;

lock_hole_diam     = 5;
lock_hole_from_end = 14.2 + lock_hole_diam/2;
lock_hole_from_top = 10.3 + lock_hole_diam/2;
lock_nut_diam      = 16;
lock_nut_thickness = 10;

lock_screw_diam      = 10; // not true, need to find thread which is likely imperial
lock_screw_safe_diam = 35;

anchor_hole_diam = 4.25;

echo("overall_length/2: ", overall_length/2);
echo("channel_pos_x: ", channel_pos_x);

echo("overall depth: ", overall_depth);

module piccolo_adapter() {
  module body() {
    translate([0,0,brace_height/2]) {
      cube([channel_outer,brace_width,brace_height],center=true);

      rotate([0,0,90]) {
        hole(lock_screw_safe_diam,brace_height,6);
      }
    }

    for(x=[left,right]) {
      translate([x*channel_pos_x,0,overall_depth/2]) {
        cube([channel_width,overall_length,overall_depth],center=true);
      }
    }

    translate([0,-overall_length/2-channel_width/2+0.05,overall_depth/2]) {
      cube([channel_outer,channel_width,overall_depth],center=true);
    }
  }

  module holes() {
    hole(lock_screw_diam,brace_height*3,resolution);

    for(end=[front,rear]) {
      translate([0,end*(channel_length/2-lock_hole_from_end),overall_depth-lock_hole_from_top]) {
        rotate([0,90,0]) {
          hole(lock_hole_diam,channel_outer+1,resolution);
        }
      }
    }

    rotate([0,0,90]) {
      hole(lock_nut_diam,lock_nut_thickness*2,6);
    }

    for(side=[left,right]) {
      for(x=[0,channel_pos_x,channel_pos_x/2]) {
        for(y=[0,-overall_length/2-channel_width/2]) {
          translate([side*x,y,0]) {
            hole(anchor_hole_diam,overall_depth*2+1,resolution);
          }
        }
      }
    }
  }

  module bridges() {
    translate([0,0,lock_nut_thickness]) {
      hole(lock_nut_diam+2,extrusion_height,6);
    }

    translate([0,0,lock_nut_thickness/2]) {
      hole(lock_screw_diam-1,lock_nut_thickness,resolution);
    }
  }

  difference() {
    body();
    holes();
  }

  bridges();
}

piccolo_adapter();
