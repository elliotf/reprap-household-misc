include <../lib/util.scad>;

resolution = 32;

m3_nut_diam = 5.5+0.2;

extrude_width = 0.4;
extrude_height = 0.2;

wall_thickness = extrude_width*3;

screw_diam = 3;
screw_from_edge = 4;
hole_diam = 3.5;

lever_width = 11.5;
lever_length_from_edge = 11.5;
lever_depth = 1.6;

handle_width = lever_length_from_edge + wall_thickness*2;
handle_depth = 11;
handle_length = 40;

module screendoor_handle() {
  module profile() {
    module body() {
      rounded_diam = wall_thickness*2;
      translate([rounded_diam/2,0,0]) {
        rounded_square(wall_thickness*2,handle_length,wall_thickness*2);
      }

      lever_containment_width = lever_width+rounded_diam*2;
      translate([handle_width/2,0,0]) {
        rounded_square(handle_width,lever_containment_width,wall_thickness*2);
      }

      for(y=[front,rear]) {
        mirror([0,y-1,0]) {
          translate([rounded_diam,lever_containment_width/2,0]) {
            round_corner_filler_profile(lever_containment_width,resolution*2);
          }
        }
      }
    }

    module holes() {
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    // cube([10,10,10],center=true);
    linear_extrude(height=handle_depth,center=true,convexity=5) {
      profile();
    }
  }

  module holes() {
    translate([0,0,handle_depth/2]) {
      cube([lever_length_from_edge*2,lever_width,lever_depth*2],center=true);
    }

    nut_cavity_height = m3_nut_diam;
    translate([screw_from_edge,0,bottom*(handle_depth/2)]) {
      hole(m3_nut_diam,nut_cavity_height*2,6);

      translate([0,0,nut_cavity_height+20+extrude_height]) {
        hole(hole_diam,40,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

screendoor_handle();
