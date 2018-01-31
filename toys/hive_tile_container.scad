include <../../lib/util.scad>;

tile_diam = 2*inch; // guess for now
tile_height = 0.5*inch; // guess for now
num_tiles   = 11; // base set + room
tolerance_xy = 1.5;

wall_thickness = 0.8;

inner_diam = tile_diam + tolerance_xy*2;
outer_diam = inner_diam + wall_thickness*2;
cavity_height = (num_tiles + 0.5) * tile_height;
floor_thickness = 2;

module container(outer,inner,height,floor_thickness) {
  overall_height = height + floor_thickness;
  module body() {
    translate([0,0,overall_height/2]) {
      hole(outer,overall_height,6);
    }
  }

  module holes() {
    translate([0,0,floor_thickness+height]) {
      hole(inner,height*2,6);
    }
  }

  difference() {
    body();
    holes();
  }
}

container(outer_diam,inner_diam,cavity_height,floor_thickness);
