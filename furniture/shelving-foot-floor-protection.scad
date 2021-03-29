resolution = 32;

include <../lib/util.scad>;

extrude_width = 0.5;
extrude_height = 0.3;

wall_thickness = extrude_width*3;

module main() {
  cavity_thickness = 3;
  cavity_length = 32;
  corner_diameter = 5;
  height = 10;

  bottom_thickness = extrude_height*6;

  module profile(additional_thickness=0) {
    module body() {
      for(angle=[0,-90]) {
        rotate([0,0,angle]) {
          translate([0,cavity_length/2,0]) {
            //square([cavity_thickness+additional_thickness*2,cavity_length+cavity_thickness+additional_thickness*2],center=true);
            rounded_square(cavity_thickness+additional_thickness*2,cavity_length+cavity_thickness+additional_thickness*2,2+additional_thickness*2,resolution);
          }
        }
      }
      translate([cavity_thickness/2+additional_thickness,cavity_thickness/2+additional_thickness,0]) {
        //round_corner_filler_profile(wall_thickness*2-additional_thickness,resolution);
      }
    }

    module holes() {
      translate([-cavity_thickness/2-additional_thickness,-cavity_thickness/2-additional_thickness,0]) {
        round_corner_filler_profile(corner_diameter+cavity_thickness+additional_thickness*2,resolution);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    linear_extrude(height=height,convexity=2,center=true) {
      profile(extrude_width*3);
    }
  }

  module holes() {
    translate([0,0,bottom_thickness]) {
      linear_extrude(height=height,convexity=2,center=true) {
        profile(0);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

main();
