include <../../lib/util.scad>;

larger_diam   = 11.2; // LR44
larger_height = 5;    // LR44
smaller_diam   = 9.5; // LR932
smaller_height = 3.2; // LR932

offset_x = (smaller_diam - larger_diam)/2;

resolution = 32;

module battery_adapter() {
  difference() {
    intersection() {
      translate([0,0,larger_height/2]) {
        hole(larger_diam,larger_height,resolution);
      }

      hull() {
        translate([offset_x,0,larger_height/2]) {
          hole(smaller_diam-1,larger_height*2,resolution);
        }
        translate([larger_diam/2,0,larger_height]) {
          cube([larger_diam-1,larger_diam,larger_height*2],center=true);
        }
      }
    }
    translate([offset_x,0,larger_height]) {
      # hole(smaller_diam,smaller_height*2,resolution/2);
    }
    translate([-larger_diam/2,0,larger_height]) {
      cube([larger_diam+1,larger_diam*2,smaller_height*2],center=true);
    }
  }
}

battery_adapter();
