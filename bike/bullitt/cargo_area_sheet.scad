include <../../lib/util.scad>;

/*

Other people's guesses:
https://i.pinimg.com/originals/9f/8c/3a/9f8c3a35754f25b9a5583e28cbdb8af5.jpg

Aluminum sheet source, 5052 because it forms well (theoretically)
https://www.discountsteel.com/items/5052_Aluminum_Sheet.cfm?item_id=126&size_no=2&pieceLength=cut&wid_ft=1&wid_in=9&wid_fraction=0&len_ft=5&len_in=0&len_fraction=0&pieceCutType=46%7C1&itemComments=&qty=1#skus

*/

center = 0;

inch       = 25.4;
resolution = 32;

rear_cargo_angle  = 91;
front_cargo_angle = 90 - 13.5;

hole_spacing_x = 150;
hole_spacing_y = 250;
hole_diam      = (3/8)*inch;

cargo_area_width     = 400; // actual width is 400, but welds round the corner and narrow the flat area
bottom_plate_width   = cargo_area_width - 10; // accomodate for welds
bottom_bar_thickness = 20.5;
bottom_bar_depth_y   = 35.5;
bottom_plate_depth_y = 820 - 110; // making this up for now
bottom_plate_depth_y = 710;
echo("BOTTOM PLATE DEPTH: ", bottom_plate_depth_y);

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

eye_mount_od          = 26.5;
front_eye_mount_pos_y = -hole_spacing_y*1 - bottom_bar_depth_y/2 + 79    - eye_mount_od/2;
rear_eye_mount_pos_y  = -hole_spacing_y*2 - bottom_bar_depth_y/2 - 131.5 - eye_mount_od/2;

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
echo("SHEET WIDTH:  ", bottom_plate_width/inch);

module bottom_plate() {
  module body() {
    hull() {
      translate([0,bottom_bar_depth_y/2]) {
        square([bottom_plate_width,bottom_bar_depth_y],center=true);
      }

      translate([0,bottom_bar_depth_y/2-bottom_plate_depth_y]) {
        square([bottom_plate_width,0.05],center=true);
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
      translate([x*hole_spacing_x,bottom_bar_depth_y/2-bottom_plate_depth_y,0]) {
        rounded_square(rail_hole_width,rail_hole_height*0.5,rail_hole_rounded);
      }

      for (y=[front_eye_mount_pos_y,rear_eye_mount_pos_y]) {
        translate([x*cargo_area_width/2,y,0]) {
          hull() {
            square([1,eye_mount_od+5],center=true);
            translate([-x*eye_mount_od/2,0,0]) {
              accurate_circle(eye_mount_od+5,resolution);
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

module front_plate() {
  module body() {
    rounded_diam = 3*inch;
    hull() {
      square([bottom_plate_width,bottom_bar_depth_y],center=true);

      translate([0,front_height-rounded_diam/2,0]) {
        accurate_circle(rounded_diam,resolution);
      }
      for(x=[left,right]) {
        translate([x*(bottom_plate_width/2-10),front_dist_from_bottom_to_holes,0]) {
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
    rounded_diam = bottom_plate_width-rear_bottom_hole_spacing_x;

    hull() {
      translate([0,rear_bottom_hole_dist_from_bottom_z/2,0]) {
        square([bottom_plate_width,rear_bottom_hole_dist_from_bottom_z],center=true);
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
  for(y=[0,-1,-2]) {
    translate([x*hole_spacing_x,y*hole_spacing_y,-sheet_thickness*2-bottom_bar_thickness/2]) {
      % cube([cargo_area_width,bottom_bar_depth_y,bottom_bar_thickness],center=true);
    }
  }

  translate([0,bottom_bar_depth_y/2-bottom_plate_depth_y/2,5]) {
    % cube([bottom_bar_depth_y,bottom_plate_depth_y,10],center=true);
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

  translate([0,bottom_bar_depth_y/2-bottom_plate_depth_y,0]) {
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
  difference() {
    union() {
      bottom_plate();

      translate([0,bottom_bar_depth_y*1.5,0]) {
        front_plate();
      }

      translate([0,bottom_bar_depth_y/2-bottom_plate_depth_y,0]) {
        mirror([0,1,0]) {
          rear_plate();
        }
      }
    }

    translate([0,bottom_bar_depth_y,0]) {
      square([bottom_plate_width-10,1],center=true);
    }

    translate([0,bottom_bar_depth_y/2-bottom_plate_depth_y,0]) {
      square([bottom_plate_width-10,1],center=true);
    }
  }
}


