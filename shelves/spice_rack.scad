use <util.scad>;
include <spice_rack_positions.scad>;
include <boxcutter.scad>;

echo("SHELF WIDTH: ", shelf_width);

translate([0,0,total_height/2]) {
  % cube([total_width,spice_width*2,total_height],center=true);
}

for(i=[0:num_shelves-1]) {
  translate([0,0,bc_shoulder_width+sheet_thickness/2+shelf_spacing*i]) {
    color("green") {
      linear_extrude(sheet_thickness,center=true) {
        shelf();
      }
    }
  }
}

translate([0,shelf_depth/2+sheet_thickness/2,bc_shoulder_width+sheet_thickness+ backing_sheet_height/2]) {
  rotate([90,0,0]) {
    linear_extrude(sheet_thickness,center=true) {
      back();
    }
  }
}

for(side=[left,right]) {
  translate([side*(shelf_width/2+sheet_thickness/2),0,bc_shoulder_width+sheet_thickness+backing_sheet_height/2]) {
    rotate([0,90,0]) {
      rotate([0,0,90]) {
        color("lightblue") {
          linear_extrude(sheet_thickness,center=true) {
            sides();
          }
        }
      }
    }
  }
}

module shelf() {
  box_side([shelf_width,shelf_depth],[3,3,0,3]);
}

module back() {
  module body() {
    box_side([shelf_width,backing_sheet_height],[0,3,4,3]);
  }

  module holes() {
    for(i=[1:num_shelves-1]) {
      translate([0,-backing_sheet_height/2-sheet_thickness/2+shelf_spacing*i]) {
        box_holes_for_side(shelf_width,4);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

translate([0,0,400]) {
  //sides();
}

module sides() {
  module body() {
    box_side([shelf_depth,backing_sheet_height],[0,0,4,4]);
  }

  module holes() {
    for(i=[1:num_shelves-1]) {
      translate([0,-backing_sheet_height/2-sheet_thickness/2+shelf_spacing*i]) {
        box_holes_for_side(shelf_depth,4);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}
