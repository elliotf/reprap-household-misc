use <util.scad>;

sheet_thickness = 4.9;

front  = -1;
rear   = 1;
top    = 1;
bottom = -1;
left   = -1;
right  = 1;

overall_width = 250;
num_bottles   = 6;

shoulder_thickness = 15;
bottle_diam    = 80;
bottle_opening = bottle_diam+10;
bottle_space   = bottle_opening + shoulder_thickness*2;

total_height  = num_bottles*bottle_space;
back_height   = total_height - bottle_space - shoulder_thickness*3;

num_verticals = 6;
space_between_verticals = (overall_width+sheet_thickness)/(num_verticals-1);

resolution = 64;

echo("TOTAL HEIGHT:", total_height);

include <boxcutter.scad>;

actual_width = overall_width + sheet_thickness*2 + bc_shoulder_width*4;
bc_space_between_tab_slot_pairs = bottle_space/2;
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

module back() {
  module body() {
    rounded_diam = 25;
    hull() {
      for(x=[left,right]) {
        for(y=[top,bottom]) {
          translate([x*(actual_width/2-rounded_diam/2),y*(back_height/2-rounded_diam/2),0]) {
            circle(r=rounded_diam/2,center=true,$fn=resolution);
          }
        }
      }
    }
  }

  module holes() {
    for(i=[0:num_verticals-1]) {
      translate([(-overall_width/2-sheet_thickness/2)+i*(space_between_verticals),0]) {
        rotate([0,0,90]) {
          box_holes_for_side(back_height,slot);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module vertical() {
  module body() {
    for(side=[top,bottom]) {
      translate([0,side*(total_height/2-bottle_space/2)]) {
        circle(r=bottle_space/2,center=true,$fn=resolution);

        translate([0,-side*(bottle_opening/4+1)]) {
          square([bottle_space,bottle_opening/2+2],center=true);
        }
      }
    }
    box_side([bottle_space,back_height],[0,0,0,tab]);
  }

  module holes() {
    for(i=[0:num_bottles-1]) {
      translate([0,-total_height/2+bottle_space*(i+0.5)]) {
        circle(r=bottle_opening/2,center=true,$fn=resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
  for(i=[0:num_verticals-1]) {
    translate([(-overall_width/2-sheet_thickness/2)+i*(space_between_verticals),0,0]) {
      rotate([0,90,0]) {
        rotate([0,0,90]) {
          color("lightblue") {
            linear_extrude(sheet_thickness,center=true) {
              vertical();
            }
          }
        }
      }
    }
  }

  translate([0,bottle_space/2+sheet_thickness/2,0]) {
    rotate([90,0,0]) {
      color("lightgreen") {
        linear_extrude(sheet_thickness,center=true) {
          back();
        }
      }
    }
  }
}

module cut_sheet() {
  spacing = bottle_space + 1 + sheet_thickness*2;
  translate([bottle_space/2+sheet_thickness,total_height/2,0]) {
    for(i=[0:num_verticals-1]) {
      if ((i % 2) == 0) {
        translate([i*spacing,0]) {
          rotate([0,180,0]) {
            vertical();
          }
        }
      } else {
        translate([i*spacing-sheet_thickness,0]) {
          vertical();
        }
      }
    }
  }

  translate([actual_width/2,total_height+back_height/2+sheet_thickness]) {
    back();
  }

  % square([24*25.4,36*25.4]);
}

//vertical();
assembly();
//cut_sheet();
