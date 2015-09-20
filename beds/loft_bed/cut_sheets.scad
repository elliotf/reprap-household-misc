include <main.scad>;
include <util.scad>;

sheet_width  = 48*multiplier;
sheet_length = 96*multiplier;

cut_margin = 2*multiplier;

// sized in imperial inches

module sheet() {
  translate([0,0,-sheet_thickness]) {
    difference() {
      cube([sheet_length,sheet_width,sheet_thickness],center=true);
      cube([sheet_length-cut_margin*2,sheet_width-cut_margin*2,sheet_thickness+1],center=true);
    }
  }
}

module side_rail_sheet() {
  module side_rails() {
    for(i=[0,1,2]) {
      // side rails
      translate([0,sheet_width/2-cut_margin-side_rail_height/2-(side_rail_height+tool_diam*4)*i]) {
        side_rail();
      }
    }

    for(i=[0,1]) {
      translate([0,-sheet_width/2+cut_margin+(tool_diam*3+platform_support_width)*i,0]) {
        // platform_supports
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

  translate([-sheet_length/2+cut_margin+sheet_thickness*3+side_rail_length/2,0,0]) {
    side_rails();
  }

  % sheet();
}

module head_sheet() {
  translate([-sheet_length/2+cut_margin+end_board_height/2,0,0]) {
    rotate([0,0,90]) {
      headboard();
    }
    translate([end_board_height/2+platform_sheet_length/2+cut_margin+tool_diam*2.1,0,0]) {
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
    translate([end_board_height/2+platform_sheet_length/2+cut_margin+tool_diam*2.1,0,0]) {
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
