include <lumpyscad/lib.scad>;

resolution = 64;

extrude_height = 0.2;
extrude_width = 0.5;
wall_thickness = extrude_width*2;
base_thickness = extrude_height*5;

// taken from https://www.amazon.com/gp/product/B06VVPWSXM to start with
side_length = 7*inch;
height = 4*inch;
// width = 3/4*inch;
width = 1*inch;
rounded = width/2;
top_width = 1/3*width;
top_rounded = top_width;

top_length = -width+top_width+side_length-2*inch;

module block() {
  module body() {
    for(m=[0,1]) {
      mirror([m,-m,0]) {
        hull() {
          translate([0,0,extrude_height/2]) {
            translate([0,side_length/2-width/2,0]) {
              difference() {
                rounded_cube(width,side_length,extrude_height,rounded,resolution);
                translate([-width/2,-side_length/2,0]) {
                  round_corner_filler(width*2,height);
                }
              }
            }
          }

          translate([0,0,height-extrude_height/2]) {
            translate([width/2-top_width/2,width/2-top_width+top_length/2,0]) {
              difference() {
                rounded_cube(top_width,top_length,extrude_height,top_rounded,resolution);
                translate([-top_width/2,-top_length/2,0]) {
                  round_corner_filler(top_width*2,height);
                }
              }
            }
          }
        }
      }
    }

    translate([width/2,width/2,height/2]) {
      round_corner_filler(5,height);
    }
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

block();
