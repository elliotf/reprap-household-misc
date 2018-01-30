include <../../lib/util.scad>;

center = 0;

inch       = 25.4;
resolution = 32;

rear_cargo_angle  = 91;
front_cargo_angle = 90 - 13.5;

hole_spacing_x = 150;
hole_spacing_y = 250;
hole_diam      = (3/8)*inch;

cargo_area_width     = 390;
bottom_bar_depth_y   = 30; // making this up for now
bottom_plate_depth_y = 820 - 110; // making this up for now

// all of these are guesstimates
rear_top_hole_spacing_x             = 80;
rear_mid_hole_spacing_x             = 170*2;
rear_bottom_hole_spacing_x          = 170*2;
rear_bottom_hole_dist_from_bottom_z = 70;
rear_top_mid_hole_spacing_z         = 90;
rear_mid_bottom_hole_spacing_z      = 225;

rear_bottom_hole_z = rear_bottom_hole_dist_from_bottom_z;
rear_mid_hole_z    = rear_bottom_hole_z + rear_mid_bottom_hole_spacing_z;
rear_top_hole_z    = rear_mid_hole_z + rear_top_mid_hole_spacing_z;

// both of these are guesses
front_dist_from_bottom_to_holes = 180;
front_height                    = 310;

// L-track rails
rail_width  = 25;
rail_height = 11;

rail_hole_width  = rail_width + 5;
rail_hole_height = rail_height + 5;
rail_hole_rounded = (1/4)*inch;

sheet_thickness = 0.04*inch;
sheet_length    = bottom_plate_depth_y + front_height + rear_top_hole_z + 3*inch;

echo("SHEET LENGTH: ", sheet_length/inch);

module bottom_plate() {
  module body() {
    hull() {
      translate([0,bottom_bar_depth_y/2]) {
        square([cargo_area_width,bottom_bar_depth_y],center=true);
      }

      translate([0,bottom_bar_depth_y/2-bottom_plate_depth_y]) {
        square([cargo_area_width,bottom_bar_depth_y],center=true);
      }
    }
  }

  module holes() {
    for(x=[left,center,right]) {
      for(y=[0,-1,-2]) {
        translate([x*hole_spacing_x,y*hole_spacing_y,0]) {
          accurate_circle(hole_diam,resolution);
        }
      }
    }

    for(x=[left,right]) {
      translate([x*hole_spacing_x,-bottom_plate_depth_y,0]) {
        rounded_square(rail_hole_width,rail_hole_height*1.5,rail_hole_rounded);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module front_plate() {
  module body() {
    rounded_diam = 3*inch;
    hull() {
      square([cargo_area_width,bottom_bar_depth_y],center=true);

      translate([0,front_height-rounded_diam/2,0]) {
        accurate_circle(rounded_diam,resolution);
      }
      for(x=[left,right]) {
        translate([x*(cargo_area_width/2-10),front_dist_from_bottom_to_holes,0]) {
          accurate_circle(20,resolution);
        }
      }
    }
  }

  module holes() {
    for(x=[left,center,right]) {
      translate([x*hole_spacing_x,front_dist_from_bottom_to_holes-bottom_bar_depth_y/2,0]) {
        accurate_circle(hole_diam,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module rear_plate() {
  module position_holes() {
    holes = [
      [rear_bottom_hole_spacing_x/2,rear_bottom_hole_z],
      [rear_bottom_hole_spacing_x/2,rear_mid_hole_z],
      [rear_top_hole_spacing_x/2,rear_top_hole_z],
    ];
    for(x=[left,right]) {
      for(hole_pos=holes) {
        translate([x*hole_pos[0],hole_pos[y],0]) {
          children();
        }
      }
    }
  }

  module body() {
    rounded_diam = cargo_area_width-rear_bottom_hole_spacing_x;

    hull() {
      translate([0,rear_bottom_hole_dist_from_bottom_z/2,0]) {
        square([cargo_area_width,rear_bottom_hole_dist_from_bottom_z],center=true);
      }
      position_holes() {
        accurate_circle(rounded_diam,resolution);
      }
    }
  }

  module holes() {
    position_holes() {
      accurate_circle(hole_diam,resolution);
    }
    for(x=[left,right]) {
      translate([x*hole_spacing_x,0,0]) {
        rounded_square(rail_hole_width,rail_hole_height*3,rail_hole_rounded);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
  linear_extrude(height=sheet_thickness,center=true) {
    bottom_plate();
  }

  translate([0,bottom_bar_depth_y + 1,0]) {
    rotate([front_cargo_angle,0,0]) {
      translate([0,bottom_bar_depth_y/2,0]) {
        linear_extrude(height=sheet_thickness,center=true) {
          front_plate();
        }
      }
    }
  }

  translate([0,-bottom_plate_depth_y,0]) {
    rotate([rear_cargo_angle,0,0]) {
      translate([0,0,0]) {
        linear_extrude(height=sheet_thickness,center=true) {
          rear_plate();
        }
      }
    }
  }
}

module cut_sheet() {
  bottom_plate();

  translate([0,bottom_bar_depth_y*1.5+1,0]) {
    front_plate();
  }

  translate([0,-bottom_plate_depth_y-1,0]) {
    mirror([0,1,0]) {
      rear_plate();
    }
  }
}

assembly();

translate([-cargo_area_width*1.1,0,0]) {
  cut_sheet();
}


