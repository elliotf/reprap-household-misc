include <../lib/util.scad>;

resolution = 32;

extrusion_width = 0.6;
extrusion_height = 0.28;

wall_thickness = extrusion_width*2;

shelf_thickness = wall_thickness*2;

support_thickness = extrusion_height*4;

depth = 80;
width_front = 345;
width_rear = 340;

gap_thickness = 8;

ledge_width = 4;

module medicine_shelf() {
  module body() {
    // side tabs
    for(x=[left,right]) {
      hull() {
        translate([x*(width_front/2-shelf_thickness/2),gap_thickness/2,top*(depth/2-0.1)]) {
          rounded_cube(shelf_thickness,gap_thickness,0.2,shelf_thickness,resolution);
        }
        translate([x*(width_rear/2-shelf_thickness/2),gap_thickness/2,bottom*(depth/2-0.1)]) {
          rounded_cube(shelf_thickness,gap_thickness,0.2,shelf_thickness,resolution);
        }
      }
    }

    // main shelf
    hull() {
      translate([0,shelf_thickness/2,top*(depth/2-0.1)]) {
        rounded_cube(width_front,shelf_thickness,0.2,shelf_thickness,resolution);
      }
      translate([0,shelf_thickness/2,bottom*(depth/2-0.1)]) {
        rounded_cube(width_rear,shelf_thickness,0.2,shelf_thickness,resolution);
      }
    }

    // rear
    translate([0,(gap_thickness/2),bottom*(depth/2-support_thickness/2)]) {
      translate([0,0,0]) {
        rounded_cube(width_rear,gap_thickness,support_thickness,shelf_thickness,resolution);
      }
    }

    // front lip
    hull() {
      translate([0,(gap_thickness/2),top*(depth/2-support_thickness/4)]) {
        rounded_cube(width_front,gap_thickness,support_thickness/2,shelf_thickness,resolution);
      }

      translate([0,shelf_thickness/2,top*(depth/2-gap_thickness)]) {
        rounded_cube(width_front-shelf_thickness,shelf_thickness,support_thickness/2,shelf_thickness,resolution);
      }
    }

    // front support
    hull() {
      translate([0,shelf_thickness/2,top*(depth/2-gap_thickness)]) {
        rounded_cube(width_front-ledge_width*2,shelf_thickness,support_thickness/2,shelf_thickness,resolution);
      }
      translate([0,shelf_thickness/2,top*(depth/2-support_thickness/4)]) {
        rounded_cube(width_front-ledge_width*2,gap_thickness*1.5,support_thickness/2,shelf_thickness,resolution);
      }
    }

    // rear support
    hull() {
      translate([0,shelf_thickness/2,bottom*(depth/2-gap_thickness)]) {
        rounded_cube(width_rear-ledge_width*2,shelf_thickness,support_thickness/2,shelf_thickness,resolution);
      }
      translate([0,shelf_thickness/2-gap_thickness/2,bottom*(depth/2-support_thickness/4)]) {
        rounded_cube(width_rear-ledge_width*2,gap_thickness,support_thickness/2,shelf_thickness,resolution);
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

medicine_shelf();
