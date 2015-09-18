include <main.scad>;
include <util.scad>;

sheet_width  = 48*multiplier;
sheet_length = 96*multiplier;

cut_margin = 1*multiplier;

// sized in imperial inches

module sheet() {
  translate([0,0,-sheet_thickness]) {
    cube([sheet_length,sheet_width,sheet_thickness],center=true);
  }
}

module side_rail_sheet() {
  module side_rails() {
    for(side=[left,right,3]) {
      // side rails
      translate([0,(side_rail_height/2+tool_diam)*side]) {
        side_rail();
      }

      translate([0,-side_rail_height-tool_diam*4-platform_support_width,0]) {
        platform_supports();
      }
    }
  }

  module platform_supports() {
    for(side=[left,right]) {
      translate([0,side*(tool_diam+platform_support_width/2),0]) {
        side_rail_platform_support();
      }
    }
  }

  module leg_braces() {
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([x*(leg_brace_height/2+tool_diam/2),y*(leg_brace_width/2+tool_diam/2)]) {
          rotate([0,0,90*y]) {
            //leg_brace();
          }
        }
      }
    }
  }

  translate([0,-5*multiplier,0]) {
    translate([-sheet_length/2+cut_margin+sheet_thickness*3+side_rail_length/2,0,0]) {
      side_rails();
    }

    translate([0,side_rail_height+tool_diam*2+leg_brace_width,sheet_thickness*2]) {
      leg_braces();
    }
  }

  % sheet();
}

module head_sheet() {
  translate([-sheet_length/2+cut_margin+end_board_height/2,0,0]) {
    rotate([0,0,90]) {
      headboard();
    }
    translate([end_board_height/2+platform_sheet_length/2+tool_diam*2.1,0,0]) {
      platform_sheet();
    }
  }
  % sheet();
}

module foot_sheet() {
  translate([-sheet_length/2+cut_margin+end_board_height/2,0,0]) {
    rotate([0,0,90]) {
      footboard();
    }
    translate([end_board_height/2+platform_sheet_length/2+tool_diam*2.1,0,0]) {
      platform_sheet();
    }
  }
  % sheet();
}

translate([0,1*(sheet_width + 2*multiplier),0]) {
  side_rail_sheet();
}
translate([0,0*(sheet_width + 2*multiplier),0]) {
  head_sheet();
}
translate([0,-1*(sheet_width + 2*multiplier),0]) {
  foot_sheet();
}
