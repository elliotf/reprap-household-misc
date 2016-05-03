include <common.scad>;

extrusion_width  = 0.4;
extrusion_height = 0.3;
wall_thickness   = extrusion_width * 4;
floor_thickness  = extrusion_height * 4;
resolution       = 64;

magnet_depth       = 12;
magnet_inner_diam  = 40;
magnet_outer_diam  = magnet_inner_diam + magnet_depth*2;
magnet_thickness   = 2;
magnet_arc_portion = 85;

magnet_hole_width     = 17+3;
magnet_hole_length    = 36+2;
magnet_hole_thickness = magnet_thickness+1;

module hdd_magnet() {
  module body() {
    hole(magnet_outer_diam, magnet_thickness, resolution);
  }

  module holes() {
    hole(magnet_inner_diam, magnet_thickness+1, resolution);
  }

  translate([-magnet_outer_diam/2,0,0]) {
    intersection() {
      difference() {
        body();
        holes();
      }
      hull() {
        for(side=[left,right]) {
          rotate([0,0,magnet_arc_portion/2*side]) {
            translate([magnet_outer_diam,.5*side,0]) {
              cube([magnet_outer_diam*2,1,magnet_thickness*2],center=true);
            }
          }
        }
      }
    }
  }
}

module hdd_fridge_magnet() {
  height = magnet_hole_width + floor_thickness*2;
  width  = magnet_thickness  + wall_thickness*2;

  handle_height    = height-floor_thickness-1;
  handle_thickness = width*1.5;

  module body() {
    hull() {
      for(side=[left,right]) {
        translate([0,magnet_hole_length/2*side,height/2]) {
          hole(width,height,resolution);
        }
      }
    }


    hull() {
      translate([0,0,handle_height/2]) {
        cube([1,handle_thickness,handle_height],center=true);

        translate([20,0,0]) {
          hole(handle_thickness,handle_height,resolution);
        }
      }
    }

    for(side=[left,right]) {
      translate([width/2,handle_thickness/2*side,handle_height/2]) {
        cube([handle_thickness,handle_thickness,handle_height],center=true);
      }
    }
  }

  module holes() {
    translate([0,0,floor_thickness]) {
      hull() {
        for(side=[left,right]) {
          translate([0,magnet_hole_length/2*side,magnet_hole_width/2]) {
            hole(magnet_hole_thickness,magnet_hole_width,resolution);
          }
        }
      }
      translate([-4,0,0]) {
        rotate([0,90,0]) {
          % hdd_magnet();
        }
      }
    }

    for(side=[left,right]) {
      translate([width/2+handle_thickness/2,handle_thickness*side,handle_height/2]) {
        hole(handle_thickness,handle_height+1,resolution);
      }
    }

    translate([0,0,height]) {
      cube([1,1,height],center=true);
    }
  }

  difference() {
    body();
    holes();
  }
}

hdd_fridge_magnet();
