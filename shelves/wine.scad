use <util.scad>;

sheet_thickness = 4.9;

front  = -1;
rear   = 1;
top    = 1;
bottom = -1;
left   = -1;
right  = 1;

overall_width = 250;
num_bottles   = 2;

bottle_diam   = 90;
bottle_space  = bottle_diam + 15;
shelf_spacing = bottle_space + sheet_thickness;
shelf_depth   = bottle_space;
shelf_width   = overall_width;

total_height  = num_bottles*(sheet_thickness+bottle_space);

resolution = 64;

echo("TOTAL HEIGHT:", total_height);

include <boxcutter.scad>;

bc_space_between_tab_slot_pairs = bc_tab_slot_pair_len*3;
bc_tab_from_end_dist = 15;

// screws
tab  = 3;
slot = 4;
// zip ties
tab  = 1;
slot = 2;

/*
general idea is that there will be a rectangle with holes in it
the bottles sit in those holes
*/

module window_hole(diam) {
  hull() {
    for(side=[left,right]) {
      translate([side*(shelf_width/2-diam),0,0]) {
        circle(r=diam/2,center=true,$fn=resolution);
      }
    }
  }
}

module shelf() {
  module body() {
    box_side([shelf_width,shelf_depth],[tab,tab,tab,tab]);
  }

  module holes() {
    window_hole(bottle_diam*0.66);
  }

  difference() {
    body();
    holes();
  }
}

module front() {
  module body() {
    box_side([shelf_width,total_height],[slot,tab,slot,tab]);
  }

  module holes() {
    for(i=[1:num_bottles-1]) {
      translate([0,-total_height/2+shelf_spacing*i]) {
        box_holes_for_side(shelf_width,slot);
      }
    }

    for(i=[0:num_bottles-1]) {
      translate([0,-total_height/2+shelf_spacing*(i+0.5)]) {
        window_hole(bottle_diam*0.66);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module back() {
  module body() {
    box_side([shelf_width,total_height],[slot,tab,slot,tab]);
  }

  module holes() {
    for(i=[1:num_bottles-1]) {
      translate([0,-total_height/2+shelf_spacing*i]) {
        box_holes_for_side(shelf_width,slot);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module sides() {
  module body() {
    box_side([shelf_depth,total_height],[slot,slot,slot,slot]);
  }

  module holes() {
    for(i=[1:num_bottles-1]) {
      translate([0,-total_height/2+shelf_spacing*i]) {
        box_holes_for_side(shelf_depth,slot);
      }
    }
    for(i=[0:num_bottles-1]) {
      translate([0,-total_height/2+shelf_spacing*(i+0.5)]) {
        circle(r=bottle_diam/2,center=true,$fn=resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
  for(side=[left,right]) {
    translate([side*(shelf_width/2+sheet_thickness/2),0,0]) {
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

  for(i=[1:num_bottles-1]) {
    translate([0,0,-total_height/2+shelf_spacing*i]) {
      color("pink") {
        linear_extrude(sheet_thickness,center=true) {
          shelf();
        }
      }
    }
  }

  for(side=[top,bottom]) {
    translate([0,0,side*(total_height/2+sheet_thickness/2)]) {
      color("orange") {
        linear_extrude(sheet_thickness,center=true) {
          shelf();
        }
      }
    }
  }

  translate([0,shelf_depth/2+sheet_thickness/2,0]) {
    rotate([90,0,0]) {
      color("lightgreen") {
        linear_extrude(sheet_thickness,center=true) {
          back();
        }
      }
    }
  }

  translate([0,-shelf_depth/2-sheet_thickness/2,0]) {
    rotate([90,0,0]) {
      color("khaki") {
        linear_extrude(sheet_thickness,center=true) {
          front();
        }
      }
    }
  }
}

assembly();
