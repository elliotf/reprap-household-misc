include <util.scad>;

// sizes in imperial (inches)

// FIXME: add some level of tolerance compensation (make tab slots marginally larger 1/16 to 1/64 of an inch?)
// FIXME: create sample fitting piece to test design of tab/slot

sheet_thickness = .75;
tool_diam       = 0.25;
resolution      = 96;
rounded_diam    = 1;
tolerance       = 1 / 16;

overcut_corner = sqrt(pow(tool_diam/2,2)/2)/2;

mattress_width     = 39;
extra_space_on_side_of_mattress = 3.5;
platform_width     = mattress_width + extra_space_on_side_of_mattress;
mattress_length    = 75;
mattress_thickness = 4;

platform_support_width      = 1.5;
slot_support_material_width = 1.5;
tab_tongue_length           = 1;
tab_spring_width            = 0.75;

leg_brace_width  = 5;

num_bed_supports = 3;
bed_support_width  = 8;
bed_support_spacing = (mattress_length - bed_support_width*2 - tab_tongue_length*4) / (num_bed_supports - 1);
bed_support_pos_z   = -sheet_thickness*1.5;

height_of_adult_sitting_cross_legged = 37;
height_below_kitchen_table           = 28;
clearance_under_bed                  = height_below_kitchen_table + 6;

side_rail_height_above_mattress = 6.5;
side_rail_height_below_mattress = sheet_thickness + slot_support_material_width;
side_rail_height                = mattress_thickness + side_rail_height_above_mattress + side_rail_height_below_mattress;
side_rail_length                = mattress_length;

side_rail_tab_height            = 3.5;
side_rail_num_tabs              = 2;
side_rail_pos_y                 = platform_width/2 + sheet_thickness/2;
side_rail_pos_z                 = mattress_thickness + side_rail_height_above_mattress - side_rail_height/2;

end_board_height_above_side_board = 0;
end_board_width                   = side_rail_pos_y*2 + sheet_thickness + 2;
end_board_height                  = side_rail_height + end_board_height_above_side_board + clearance_under_bed;
end_board_pos_x                   = mattress_length/2 + sheet_thickness/2;
end_board_pos_z                   = side_rail_pos_z + side_rail_height/2 + end_board_height_above_side_board - end_board_height/2;

leg_brace_height = end_board_height;
leg_brace_pos_x  = end_board_pos_x - sheet_thickness/2 - leg_brace_width/2;
leg_brace_pos_y  = side_rail_pos_y + sheet_thickness;
leg_brace_pos_z  = end_board_pos_z;

access_hole_height = side_rail_height_above_mattress + mattress_thickness*.75;
ladder_hole_width  = platform_width - leg_brace_width*4;
headboard_width    = ladder_hole_width-tool_diam*2;

echo("CLEARANCE UNDER BED: ", clearance_under_bed);
echo("SIDE RAIL HEIGHT:    ", side_rail_height);
echo("SIDE RAIL LENGTH:    ", side_rail_length);
echo("END BOARD HEIGHT:    ", end_board_height);
echo("END BOARD WIDTH:     ", end_board_width);

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

module round_corner(diam=rounded_diam) {
  difference() {
    square([diam,diam],center=true);

    translate([-diam/2,-diam/2,0]) {
      accurate_circle(diam,resolution);
    }
  }
}

module fill_corner_with_round(diam=tool_diam) {
  difference() {
    square([diam,diam],center=true);
    translate([diam/2,diam/2,0]) {
      accurate_circle(diam,resolution);
    }
  }
}

module slot(height) {
  hull() {
    for(x=[left,right]) {
      for(y=[top,bottom]) {
        translate([(sheet_thickness/2-tool_diam/2)*x,(height/2-tool_diam/2)*y,0]) {
          accurate_circle(tool_diam,resolution);
        }
      }
    }
  }
}

module spring_tab() {
  tab_length        = 0.5;
  tab_tongue_length = 0.75;
  rounded_diam      = tab_tongue_length;

  module body() {
    translate([tab_length/2,sheet_thickness+tab_tongue_length/2]) {
      square([tab_length,sheet_thickness],center=true);
    }

    translate([-tab_spring_width/2,0,0]) {
      square([tab_spring_width,sheet_thickness*4],center=true);
    }
  }

  module holes() {
    translate([tab_length,sheet_thickness*2,0]) {
      round_corner();
    }
  }

  difference() {
    body();
    holes();
  }
}

module tab(height) {
  rounded_diam = tab_tongue_length;

  module body() {
    translate([0,height/2,0]) {
      fill_corner_with_round();
    }
    hull() {
      translate([0,height/2-0.5]) {
        square([2,1],center=true);
      }
      translate([sheet_thickness+tab_tongue_length-rounded_diam/2,y*(height/2-rounded_diam/2)]) {
        accurate_circle(rounded_diam,resolution);
      }
      square([sheet_thickness*2+tab_tongue_length*2,height-rounded_diam],center=true);
    }

    hull() {
      translate([sheet_thickness+tab_tongue_length/2,0,0]) {
        square([tab_tongue_length,tab_tongue_length],center=true);
        for(x=[left,right]) {
          translate([x*(tab_tongue_length/2-rounded_diam/2),-height/2+rounded_diam/2]) {
            accurate_circle(rounded_diam,resolution);
          }
        }
      }
    }
  }

  module holes() {
    translate([sheet_thickness/2,-height/2]) {
      hull() {
        for(x=[left,right]) {
          for(y=[top,bottom]) {
            translate([(sheet_thickness/2-tool_diam/2)*x,(tab_tongue_length-tool_diam/2)*y,0]) {
              accurate_circle(tool_diam,resolution);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module side_rail() {
  module body() {
    square([side_rail_length,side_rail_height],center=true);
    for(x=[left,right]) {
      for(i=[0:side_rail_num_tabs-1]) {
        mirror([1-x,0,0]) {
          translate([side_rail_length/2,-side_rail_height/2+side_rail_tab_height*(.5+i*2),0]) {
            tab(side_rail_tab_height);
          }
        }
      }
    }
  }

  module holes() {
    for(i=[-3,-1,1,3]) {
      /*
      translate([mattress_length/8*i,-side_rail_height/2+platform_support_width+sheet_thickness/2]) {
        square([side_rail_tab_height,sheet_thickness],center=true);
        for(x=[left,right]) {
          translate([side_rail_tab_height/2*x,-sheet_thickness/2+tool_diam/2]) {
            accurate_circle(tool_diam,resolution);
          }
          translate([(side_rail_tab_height/2-tool_diam/2+overcut_corner)*x,sheet_thickness/2-tool_diam/2+overcut_corner]) {
            accurate_circle(tool_diam,resolution);
          }
        }
      }
      */
      translate([mattress_length/8*i,-side_rail_height/2+platform_support_width+sheet_thickness/2]) {
        rotate([0,0,90]) {
          slot(side_rail_tab_height);
        }
      }
    }
    translate([0,-side_rail_height/2+slot_support_material_width+sheet_thickness/2]) {
      position_for_bed_supports() {
        //square([bed_support_width,sheet_thickness],center=true);
        for(x=[left,right]) {
          for(y=[top,bottom]) {
            translate([(bed_support_width/2-tool_diam/2+overcut_corner)*x,(sheet_thickness/2-tool_diam/2+overcut_corner)*y,0]) {
              //accurate_circle(tool_diam,resolution);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module side_rail_platform_support() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module platform_sheet() {
  module body() {
    square([mattress_length/2-tolerance,platform_width],center=true);
    for(x=[left,right]) {
      for(y=[front,rear]) {
        mirror([0,1-y,0]) {
          translate([mattress_length/8*x-tab_tongue_length,-platform_width/2,0]) {
            rotate([0,0,-90]) {
              tab(side_rail_tab_height);
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

module bed_support() {
  module body() {
    square([bed_support_width,platform_width+sheet_thickness*4],center=true);
    tab_width = 1;

    for(x=[left,right]) {
      for(y=[front,rear]) {
        mirror([1-x,0,0]) {
          mirror([0,1-y,0]) {
            translate([bed_support_width/2,platform_width/2,0]) {
              spring_tab();
            }
          }
        }
      }
    }
  }

  module holes() {
    spring_length = 5;
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([x*(bed_support_width/2-tab_spring_width*1.75),y*platform_width/2,0]) {
          hull() {
            for(side=[front,rear]) {
              translate([0,spring_length*side,0]) {
                accurate_circle(tab_spring_width*1.5,resolution);
              }
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module end_board_base() {
  module body() {
    square([end_board_width,end_board_height],center=true);
  }

  module holes() {
    // to make it more likely that we can get to an outlet, try to make a step hole overlaps with 12"-18"
    rung_hole_width  = ladder_hole_width;
    rung_hole_height = 5;
    rung_hole_spacing = 10;
    rung_hole_from_bottom = 7.5;
    num_rungs = 3;
    for(rung=[0:num_rungs-1]) {
      hull() {
        translate([0,-end_board_height/2+rung_hole_from_bottom+rung_hole_height/2+rung_hole_spacing*rung]) {
          for(x=[left,right]) {
            for(y=[top,bottom]) {
              translate([x*(rung_hole_width/2 - rounded_diam/2),(rung_hole_height/2-rounded_diam/2)*y]) {
                accurate_circle(rounded_diam,resolution);
              }
            }
          }
        }
      }
    }

    translate([0,end_board_height/2-side_rail_height]) {
      for(x=[left,right]) {
        for(i=[0:side_rail_num_tabs-1]) {
          translate([side_rail_pos_y*x,side_rail_tab_height*(.5+i*2)+tab_tongue_length]) {
            slot(side_rail_tab_height);
          }
        }
      }
    }

    for(x=[left,right]) {
      for(y=[top,bottom]) {
        mirror([1-x,0,0]) {
          translate([end_board_width/2,end_board_height/2*top,0]) {
            round_corner(rounded_diam);
          }
          translate([end_board_width/2,end_board_height/2*bottom,0]) {
            rotate([0,0,-90]) {
              round_corner(rounded_diam);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module headboard() {
  module body() {
    end_board_base();
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
    end_board_base();
  }

  module holes() {
    // access cutout
    translate([0,end_board_height/2]) {
      hull() {
        square([ladder_hole_width,1],center=true);
        for(x=[left,right]) {
          translate([(ladder_hole_width/2-rounded_diam/2)*x,-access_hole_height+rounded_diam/2]) {
            accurate_circle(rounded_diam,resolution);
          }
        }
      }

      for(x=[left,right]) {
        mirror([1-x,0,0]) {
          translate([-ladder_hole_width/2,0,0]) {
            round_corner(rounded_diam);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module leg_brace() {
  module body() {
    hull() {
      translate([leg_brace_width/2-1,0,0]) {
        square([2,leg_brace_height],center=true);
      }
      for(side=[top,bottom]) {
        translate([-leg_brace_width/2+rounded_diam/2,side*(leg_brace_height/2-rounded_diam/2),0]) {
          accurate_circle(rounded_diam,resolution);
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

module position_for_bed_supports() {
  for(i=[0:num_bed_supports-1]) {
    translate([-mattress_length/2+tab_tongue_length+leg_brace_width+bed_support_width/2+bed_support_spacing*(i),0]) {
      children();
    }
  }
}

module assembly() {
  // head board
  color("lightgreen") {
    translate([end_board_pos_x*left,0,end_board_pos_z]) {
      rotate([0,0,90]) {
        rotate([90,0,0]) {
          linear_extrude(height=sheet_thickness,center=true) {
            headboard();
          }
        }
      }
    }
  }

  // foot board
  color("plum") {
    translate([end_board_pos_x*right,0,end_board_pos_z]) {
      rotate([0,0,90]) {
        rotate([90,0,0]) {
          linear_extrude(height=sheet_thickness,center=true) {
            footboard();
          }
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
  // and side supports
  color("orange") {
    for(side=[front,rear]) {
      translate([0,(side_rail_pos_y-sheet_thickness)*side,side_rail_pos_z-side_rail_height/2+platform_support_width/2]) {
        rotate([90,0,0]) {
          linear_extrude(height=sheet_thickness,center=true) {
            square([mattress_length,platform_support_width],center=true);
          }
        }
      }
    }
  }
  // and end supports
  color("slateblue") {
    for(side=[left,right]) {
      translate([side*(mattress_length/2-sheet_thickness/2),0,side_rail_pos_z-side_rail_height/2+platform_support_width/2]) {
        rotate([0,90,0]) {
          linear_extrude(height=sheet_thickness,center=true) {
            square([platform_support_width,platform_width-sheet_thickness*3],center=true);
          }
        }
      }
    }
  }

  // platform sheets
  color("teal") {
    for(side=[left,right]) {
      translate([-mattress_length/4*side,0,-sheet_thickness/2]) {
        linear_extrude(height=sheet_thickness,center=true) {
          platform_sheet();
        }
      }
    }
  }

  // bed supports
  color("orange") {
    translate([0,0,bed_support_pos_z]) {
      position_for_bed_supports() {
        linear_extrude(height=sheet_thickness,center=true) {
          //bed_support();
        }
      }
    }
  }

  translate([0,extra_space_on_side_of_mattress/2,mattress_thickness/2]) {
    % cube([mattress_length,mattress_width,mattress_thickness],center=true);
  }
}

assembly();
