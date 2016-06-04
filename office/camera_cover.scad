include <../lib/util.scad>;

resolution = 32;

module camera_cover() {
  extrusion_width   = 0.4;
  extrusion_height  = 0.3;
  wall_thickness    = extrusion_width*2;
  floor_thickness   = extrusion_height*4;
  camera_width      = 68.5;
  camera_depth      = 17;
  camera_height     = 35;
  cable_from_bottom = 20;
  cable_hole_width  = 10;
  rounded_diam      = 2;

  allowance    = 0.3;
  cavity_depth = camera_depth+allowance*2;
  cavity_width = camera_width+allowance*2;
  overall_height = camera_height+floor_thickness;

  body_diam = cavity_depth+wall_thickness*2;

  module shaped(added=0) {
    cube([cavity_width+added*2,cavity_depth+added*2,overall_height],center=true);
  }

  module body() {
    shaped(wall_thickness);
  }

  module holes() {
    translate([0,0,floor_thickness]) {
      shaped();
    }

    translate([0,-body_diam/2,-overall_height/2]) {
      hull() {
        translate([0,0,overall_height]) {
          cube([cable_hole_width,wall_thickness*4,2],center=true);
        }
        for(x=[left,right]) {
          translate([x*(cable_hole_width-rounded_diam)/2,0,cable_from_bottom+rounded_diam/2]) {
            rotate([90,0,0]) {
              hole(rounded_diam,wall_thickness*4,resolution);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

camera_cover();
