include <util.scad>;

// sizes in imperial (inches)

sheet_thickness = .75;
tool_diam       = 0.25;
resolution      = 72;

mattress_width     = 39;
mattress_length    = 75;
mattress_thickness = 4;

slot_support_material_width = 2;
tab_tongue_length           = 1;

num_bed_supports = 5;
bed_support_spacing = mattress_length / (num_bed_supports - 1);
bed_support_height  = 4;
bed_support_pos_z   = -sheet_thickness-bed_support_height/2;

height_of_adult_sitting_cross_legged = 37;
height_below_kitchen_table           = 28;
clearance_under_bed                  = height_below_kitchen_table;

side_rail_height_above_mattress = 5;
side_rail_height_below_mattress = sheet_thickness + bed_support_height + slot_support_material_width;
side_rail_height                = mattress_thickness + side_rail_height_above_mattress + side_rail_height_below_mattress;
side_rail_pos_y                 = mattress_width/2 + sheet_thickness/2;
side_rail_pos_z                 = mattress_thickness + side_rail_height_above_mattress - side_rail_height/2;

end_board_height_above_side_board = tab_tongue_length + slot_support_material_width;
end_board_width                   = side_rail_pos_y*2 + sheet_thickness*3 + slot_support_material_width * 2;
end_board_height                  = side_rail_height + end_board_height_above_side_board + clearance_under_bed;
end_board_pos_x                   = mattress_length/2 + sheet_thickness/2;
end_board_pos_z                   = side_rail_pos_z + side_rail_height/2 + end_board_height_above_side_board - end_board_height/2;

leg_brace_width  = bed_support_height;
leg_brace_height = end_board_height;
leg_brace_pos_x  = end_board_pos_x - sheet_thickness/2 - leg_brace_width/2;
leg_brace_pos_y  = side_rail_pos_y + sheet_thickness;
leg_brace_pos_z  = end_board_pos_z;

echo("SIDE RAIL HEIGHT: ", side_rail_height);
echo("END BOARD HEIGHT: ", end_board_height);

module tenon_hole(dim) {
  square([dim[x],dim[y]],center=true);

  for(side=[left,right]) {
    for(end=[front,rear]) {
      translate([dim[x]/2*side,end*(dim[y]/2-tool_diam/2)]) {
        circle(r=accurate_diam(tool_diam,resolution),$fn=resolution);
      }
    }
  }
}

module tenon_hole_3d(dim) {
  linear_extrude(height=sheet_thickness,center=true) {
    tenon_hole([dim[x],dim[y]],center=true);
  }
}

module side_rail() {
  module body() {
    square([mattress_length,side_rail_height],center=true);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module bed_support() {
  module body() {
    square([bed_support_height,mattress_width],center=true);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module headboard() {
  module body() {
    square([end_board_height,end_board_width],center=true);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module footboard() {
  module body() {
    square([end_board_height,end_board_width],center=true);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module leg_brace() {
  module body() {
    square([leg_brace_width,leg_brace_height],center=true);
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
  // head board
  color("lightgreen") {
    translate([end_board_pos_x*left,0,end_board_pos_z]) {
      rotate([0,90,0]) {
        linear_extrude(height=sheet_thickness,center=true) {
          headboard();
        }
      }
    }
  }

  // foot board
  color("plum") {
    translate([end_board_pos_x*right,0,end_board_pos_z]) {
      rotate([0,90,0]) {
        linear_extrude(height=sheet_thickness,center=true) {
          footboard();
        }
      }
    }
  }

  // end board leg braces
  color("dodgerblue") {
    for(side=[front,rear]) {
      for(end=[left,right]) {
        mirror([1-end,0,0]) {
          translate([leg_brace_pos_x,leg_brace_pos_y*side,leg_brace_pos_z]) {
            rotate([90,0,0]) {
              linear_extrude(height=sheet_thickness,center=true) {
                leg_brace();
              }
            }
          }
        }
      }
    }
  }

  // side rails
  color("lightblue") {
    for(side=[front,rear]) {
      translate([0,side_rail_pos_y*side,side_rail_pos_z]) {
        rotate([90,0,0]) {
          linear_extrude(height=sheet_thickness,center=true) {
            side_rail();
          }
        }
      }
    }
  }

  // bed supports
  color("orange") {
    for(i=[0:num_bed_supports-1]) {
      translate([-mattress_length/2+bed_support_spacing*(i),0,bed_support_pos_z]) {
        rotate([0,90,0]) {
          linear_extrude(height=sheet_thickness,center=true) {
            bed_support();
          }
        }
      }
    }
  }

  translate([0,0,mattress_thickness/2]) {
    % cube([mattress_length,mattress_width,mattress_thickness],center=true);
  }
}

assembly();
