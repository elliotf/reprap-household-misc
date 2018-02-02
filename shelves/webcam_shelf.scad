include <../lib/util.scad>;

resolution      = 64;
extrusion_width = 0.4;

width  = 60;
depth  = 24;
height = 50;
wall_thickness = extrusion_width*4;
shelf_thickness = wall_thickness; // account for the angle that we're printing?

module webcam_shelf() {
  module body() {
    hull() {
      translate([0,0,height+shelf_thickness/2]) {
        cube([width+wall_thickness*2,depth,shelf_thickness],center=true);
      }
      translate([0,-depth/2,-shelf_thickness/2]) {
        cube([width+wall_thickness*2,depth*2,shelf_thickness],center=true);
      }
    }
  }

  module holes() {
    translate([0,0,height*0.75]) {
      cube([width,depth*4,height*0.5],center=true);
    }
    translate([0,(depth/2+1)*front,height*0.3]) {
      cube([width,depth*2,height*0.6],center=true);
    }
  }

  difference() {
    body();
    holes();
  }
}

webcam_shelf();
