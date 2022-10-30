include <lumpyscad/lib.scad>;

// designed to wrap around something like https://www.gobilda.com/1309-series-sonic-hub-8mm-rex-bore/
//
// TODO:
//
//   line retainment
//   verify dimensions

tolerance = 0.5;

extrude_width = 0.5;
extrude_height = 0.24;

resolution = 128;
id = 32+tolerance*2;
pulley_wall_thickness = extrude_width*3*2;
od = id + 2*pulley_wall_thickness;
rim_height = 2.5;

plate_thickness = 3;
height = 8+plate_thickness;

mounting_hole_spacing = 16;
mounting_hole_diam = 4+tolerance;
center_shaft_diam = 14+tolerance;

module pulley() {
  module profile() {
    module body() {
      translate([od/4,plate_thickness/2,0]) {
        square([od/2,plate_thickness],center=true);
      }
      translate([od/2-pulley_wall_thickness/2,height/2,0]) {
        square([pulley_wall_thickness,height-2*rim_height],center=true);
      }

      translate([od/2-pulley_wall_thickness/2,height/2]) {
        for(y=[top,bottom]) {
          mirror([0,y-1,0]) {
            hull() {
              translate([0,height/2-rim_height]) {
                square([pulley_wall_thickness,extrude_height],center=true);
              }
              translate([rim_height,height/2-extrude_height/2]) {
                square([pulley_wall_thickness,extrude_height],center=true);
              }
            }
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
    translate([0,0,height*2]) {
      // profile();
    }

    rotate_extrude($fn=resolution) {
      profile();
    }
  }

  module holes() {
    for(x=[left,right],y=[front,rear]) {
      translate([x*mounting_hole_spacing/2,y*mounting_hole_spacing/2,0]) {
        hole(mounting_hole_diam,height*3,16);
      }
    }
    hole(center_shaft_diam,height*3,resolution/2);
  }

  difference() {
    body();
    holes();
  }
}

pulley();
