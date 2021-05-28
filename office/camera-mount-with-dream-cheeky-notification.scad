include <lumpyscad/lib.scad>;

extrude_height = 0.2;
extrude_width = 0.4;
wall_thickness = extrude_width*2;

camera_bottom_width = 60;
camera_bottom_thickness = 7;

hole_spacing_x = 42;
hole_spacing_y = 22;

board_width = 48; // ~47 actual
board_height = 28; // ~27 actual
board_thickness = 1.25;

room_behind_board = 6;

// treat top as a 30/60/90 triangle
top_back_slope = 26;
top_height = top_back_slope/2;
top_rear_depth = sqrt(3)*top_back_slope/2;
top_front_depth = top_height * 1/sqrt(3);

top_rear_thickness = wall_thickness*2;
top_front_thickness = 13.5;
top_angle = 30;

overall_width = camera_bottom_width+wall_thickness*4;
base_height = camera_bottom_thickness + board_height + wall_thickness*4 + 0.1;
base_top_depth = top_front_depth+top_rear_depth;
base_bottom_depth = top_front_depth+top_rear_depth+base_height*0.2;

module position_board_holes() {
  for(x=[left,right],y=[front,rear]) {
    if (x == y) {
      translate([x*hole_spacing_x/2,y*hole_spacing_y/2,0]) {
        children();
      }
    }
  }
}

module cheeky_board() {
  screw_diam = 2.25; // actual size, printing will probably be a good self-tapping diam
  module body() {
    color("green") {
      translate([0,0,-board_thickness/2]) {
        cube([board_width,board_height,board_thickness],center=true);
      }
    }

    led_width = 3.5;
    led_depth = 3;
    led_height = 2;
    translate([0,0,led_height/2]) {
      difference() {
        color("white") {
          cube([led_width,led_depth,led_height],center=true);
        }
        translate([0,0,led_height/2]) {
          color("grey") {
            hole(led_depth-0.3,1,resolution);
          }
        }
      }
    }
  }

  module holes() {
    position_board_holes() {
      hole(screw_diam,board_thickness*4,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

board_pos_x = 0;
board_pos_y = top_rear_depth/2;
board_pos_z = board_height/2+wall_thickness*2;
module position_board() {
  translate([board_pos_x,board_pos_y,board_pos_z]) {
    rotate([90,0,0]) {
      children();
    }
  }
}

module mount() {
  anchor_diam = m2_threaded_insert_diam+wall_thickness*4;
  screw_area_thickness = 6;

  bottom_front_depth = (base_height/top_height)*top_front_depth;

  module body_side_profile() {
    hull() {
      translate([0,base_height]) {
        translate([0,top_height/2,0]) {
          square([0.05,top_height],center=true);
        }
        translate([top_rear_depth/2,0,0]) {
          square([top_rear_depth,0.05],center=true);
        }
        translate([-top_front_depth/2,0,0]) {
          square([top_front_depth,0.05],center=true);
        }
      }
      translate([top_rear_depth/2,0.025]) {
        square([top_rear_depth,0.05],center=true);
      }
      translate([-top_front_depth-bottom_front_depth/2,0.025]) {
        square([bottom_front_depth,0.05],center=true);
      }
    }
  }

  module cavity_side_profile() {
    divider_width = wall_thickness*2-0.2;
    translate([0,base_height-camera_bottom_thickness/2,0]) {
      square([200,camera_bottom_thickness],center=true);
    }
    hull() {
      translate([0,base_height-camera_bottom_thickness-divider_width-0.1,0]) {
        square([200,0.2],center=true);
      }
      translate([0,wall_thickness*2-0.1,0]) {
        square([200,0.05],center=true);
      }
    }
  }

  module body() {
    rotate([90,0,0]) {
      rotate([0,90,0]) {
        difference() {
          linear_extrude(height=overall_width,center=true,convexity=3) {
            body_side_profile();
          }
          linear_extrude(height=overall_width-wall_thickness*4,center=true,convexity=3) {
            cavity_side_profile();
          }
        }
      }
    }
  }

  module holes() {
  }

  module bridges() {
    hull() {
      front_thickness = extrude_height*6+0.1;
      translate([0,front*(top_front_depth+bottom_front_depth-front_thickness/2),0.025]) {
        cube([overall_width,front_thickness,0.05],center=true);
      }
      translate([0,front*(top_front_depth-front_thickness/2),base_height+0.02]) {
        cube([overall_width,front_thickness,0.05],center=true);
      }
    }

    module board_anchor() {
      hull() {
        rotate([90,0,0]) {
          hole(anchor_diam,screw_area_thickness,resolution);
        }
        offset_by = 12;
        translate([offset_by,-offset_by,0]) {
          rotate([90,0,0]) {
            hole(wall_thickness,screw_area_thickness,resolution);
          }
        }
        translate([offset_by,0,0]) {
          cube([wall_thickness,screw_area_thickness,1],center=true);
        }
      }
    }

    union() {
      intersection() {
        union() {
          for(x=[left,right]) {
            translate([0,0,board_pos_z]) {
              mirror([x-1,0,0]) {
                translate([0,board_pos_y-screw_area_thickness/2,0]) {
                  translate([hole_spacing_x/2,0,hole_spacing_y/2]) {
                    board_anchor();
                  }
                  translate([hole_spacing_x/2,0,-hole_spacing_y/2]) {
                    rotate([0,0,0]) {
                      board_anchor();
                    }
                  }
                }
              }
            }
          }
        }
        translate([0,0,base_height]) {
          cube([overall_width-wall_thickness*2,200,base_height*2],center=true);
        }
      }
    }
  }

  module bridge_holes() {
    position_board() {
      position_board_holes() {
        hole(m2_threaded_insert_diam,screw_area_thickness*2-1,resolution);
      }
    }
  }

  position_board() {
    % cheeky_board();
  }

  difference() {
    body();
    holes();
  }
  difference() {
    bridges();
    bridge_holes();
  }
}

module back_cover() {
  screw_hole_diam = 2.2;
  post_diam = screw_hole_diam + wall_thickness*4;
  post_height = room_behind_board;
  plate_thickness = 1;
  plate_width = overall_width - wall_thickness*4 - 1;
  plate_height = board_height;
  cable_hole_width = 3.1; // cable is ~3mm when squeezed in the calipers

  module body() {
    position_board() {
      translate([0,0,-board_thickness]) {
        translate([0,0,-post_height-plate_thickness/2]) {
          cube([plate_width,plate_height,plate_thickness],center=true);
        }
        translate([0,0,-post_height/2]) {
          position_board_holes() {
            hole(post_diam,post_height,resolution);
          }

          for(r=[0,180]) {
            post_side = wall_thickness*6;
            rotate([0,0,r]) {
              translate([board_width/2,-board_height/2]) {
                support_len = 5;
                translate([-wall_thickness,support_len/2,0]) {
                  cube([wall_thickness*2,support_len,post_height],center=true);
                }
                translate([-support_len/2,wall_thickness,0]) {
                  cube([support_len,wall_thickness*2,post_height],center=true);
                }
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    position_board() {
      position_board_holes() {
        hole(screw_hole_diam,post_height*4,resolution);
      }

      translate([plate_width/2,0,0]) {
        rounded_cube(cable_hole_width*2.5,cable_hole_width,20,cable_hole_width);

        translate([-8,0,0]) {
          for(y=[front,rear]) {
            translate([0,y*3,0]) {
              rounded_cube(3.5,1.5,20,1.5);
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

% mount();

back_cover();
