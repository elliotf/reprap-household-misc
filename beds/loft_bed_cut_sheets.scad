include <loft_bed.scad>;
include <util.scad>;

sheet_width  = 48;
sheet_length = 96;

cut_margin = 1;

// sized in imperial inches

module sheet() {
  translate([0,0,-sheet_thickness]) {
    cube([sheet_length,sheet_width,sheet_thickness],center=true);
  }
}

module sheet_one() {
  module side_rails() {
    for(side=[left,right]) {
      // side rails
      translate([0,(side_rail_height/2+tool_diam/2)*side]) {
        side_rail();
      }
    }
  }

  module platform_supports() {
    for(side=[left,right]) {
      translate([side*(tool_diam/2+platform_width/2-sheet_thickness*1.5),0,0]) {
        rotate([0,0,90]) {
          end_board_platform_support();
        }
      }
      translate([0,side*(tool_diam+platform_support_width),0]) {
        rotate([0,0,0]) {
          side_rail_platform_support();
        }
      }
    }
  }

  module leg_braces() {
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([x*(leg_brace_height/2+tool_diam/2),y*(leg_brace_width/2+tool_diam/2)]) {
          rotate([0,0,90*y]) {
            leg_brace();
          }
        }
      }
    }
  }

  translate([0,-3,0]) {
    side_rails();

    translate([0,-side_rail_height-tool_diam*2.5-platform_support_width*1.5,0]) {
      platform_supports();
    }

    translate([0,side_rail_height+tool_diam*2+leg_brace_width,sheet_thickness*2]) {
      leg_braces();
    }
  }

  % sheet();
}

module sheet_two() {
  for(x=[left,right]) {
    translate([(platform_sheet_length/2+tool_diam/2)*x,0,0]) {
      platform_sheet();
    }
  }

  % sheet();
}

module sheet_three() {
  translate([(end_board_height/2+tool_diam/2)*left,0,0]) {
    rotate([0,0,-90]) {
      headboard();
    }
  }
  translate([(end_board_height/2+tool_diam/2)*right,0,0]) {
    rotate([0,0,-90]) {
      footboard();
    }
  }
  % sheet();
}

translate([0,2*(sheet_width + 2),0]) {
  sheet_one();
}
translate([0,1*(sheet_width + 2),0]) {
  sheet_two();
}
translate([0,0*(sheet_width + 2),0]) {
  sheet_three();
}
