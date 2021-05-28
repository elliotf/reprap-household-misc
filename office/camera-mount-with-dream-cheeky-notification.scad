include <lumpyscad/lib.scad>;

extrude_height = 0.2;
extrude_width = 0.4;
wall_thickness = extrude_width*2;

face_plate_thickness = 0.8;

camera_bottom_width = 60;
camera_bottom_thickness = 7;

hole_spacing_x = 42;
hole_spacing_y = 22;

board_width = 48; // ~47 actual
board_height = 28; // ~27 actual
board_thickness = 1.25;

room_behind_board = 7;

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

board_pos_x = 0;
board_pos_y = top_rear_depth*0.2;
board_pos_z = board_height/2+wall_thickness*2;

board_mount_hole_diam = 1.8;
anchor_diam = board_mount_hole_diam+wall_thickness*4;
plate_hole_spacing_x = overall_width-wall_thickness*4-anchor_diam;

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

module position_board() {
  translate([board_pos_x,board_pos_y,board_pos_z]) {
    rotate([90,0,0]) {
      children();
    }
  }
}

module mount() {
  screw_area_thickness = 6;
  body_rounded_diam = 6;
  body_rounded_height = 12;

  bottom_front_depth = (base_height/top_height)*top_front_depth;
  divider_width = wall_thickness*2-0.2;

  module face_plate(thickness) {
    hull() {
      translate([0,-top_front_depth-bottom_front_depth,0]) {
        rotate([60,0,0]) {
          translate([0,body_rounded_diam/2+body_rounded_height/sqrt(3),-thickness/2]) {
            rounded_cube(overall_width,body_rounded_diam,thickness,body_rounded_diam,resolution);
          }
        }
      }
      translate([0,0,base_height+top_height]) {
        rotate([60,0,0]) {
          translate([0,-body_rounded_diam/2,-thickness/2]) {
            rounded_cube(overall_width,body_rounded_diam,thickness,body_rounded_diam,resolution);
          }
        }
      }
    }
  }

  module body() {
    hull() {
      face_plate(body_rounded_height);
      translate([0,0,base_height+top_height]) {
        rotate([60,0,0]) {
          translate([0,-body_rounded_diam/2,-top_back_slope/2]) {
            rounded_cube(overall_width,body_rounded_diam,top_back_slope,body_rounded_diam,resolution);
          }
        }
      }
      translate([0,top_rear_depth,body_rounded_diam/2*sqrt(3)]) {
        rotate([60,0,0]) {
          translate([0,-body_rounded_diam/2,body_rounded_height/2]) {
            rounded_cube(overall_width,body_rounded_diam,body_rounded_height,body_rounded_diam,resolution);
          }
        }
      }
    }
  }

  module holes() {
    thickness = 6;
    depth = top_front_depth+bottom_front_depth;
    depth_offset = body_rounded_height*2/sqrt(3) + wall_thickness;

    // main cavity
    hull() {
      rounded_diam = body_rounded_diam-wall_thickness*4;
      for(y=[front,rear]) {
        translate([0,depth*y,0]) {
          translate([0,depth_offset,base_height-camera_bottom_thickness-divider_width]) {
            rotate([60,0,0]) {
              translate([0,-rounded_diam/2,-body_rounded_height/2]) {
                rounded_cube(overall_width-wall_thickness*4,rounded_diam,body_rounded_height,rounded_diam,resolution);
              }
            }
          }
          translate([0,depth_offset,wall_thickness*sqrt(3)]) {
            rotate([60,0,0]) {
              translate([0,rounded_diam/2,body_rounded_height/2-face_plate_thickness/2]) {
                rounded_cube(overall_width-wall_thickness*4,rounded_diam,body_rounded_height-face_plate_thickness,rounded_diam,resolution);
              }
            }
          }
        }
      }
    }

    // camera bottom cavity
    hull() {
      rounded_diam = body_rounded_diam-wall_thickness*4;
      for(y=[front,rear]) {
        translate([0,30*y,base_height]) {
          rotate([60,0,0]) {
            translate([0,-rounded_diam/2,-thickness/2]) {
              rounded_cube(overall_width-wall_thickness*4,rounded_diam,thickness,rounded_diam,resolution);
            }
          }
        }
        translate([0,30*y,base_height-camera_bottom_thickness]) {
          rotate([60,0,0]) {
            translate([0,rounded_diam/2,thickness/2]) {
              rounded_cube(overall_width-wall_thickness*4,rounded_diam,thickness,rounded_diam,resolution);
            }
          }
        }
      }
    }
  }

  module bridges() {
    face_plate(face_plate_thickness);

    module board_anchor() {
      hull() {
        rotate([90,0,0]) {
          hole(anchor_diam,screw_area_thickness,resolution);
        }
        offset_by = 12;
        translate([offset_by,-offset_by,0]) {
          rotate([90,0,0]) {
            hole(anchor_diam/2,screw_area_thickness,resolution);
          }
        }
        translate([offset_by,0,0]) {
          cube([1,screw_area_thickness,anchor_diam],center=true);
        }
        translate([0,board_thickness+room_behind_board-1,0]) {
          rotate([90,0,0]) {
            hole(anchor_diam,2,resolution);
          }
          translate([offset_by,0,0]) {
            cube([1,2,anchor_diam],center=true);
          }
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
        hole(board_mount_hole_diam,screw_area_thickness*2-1,resolution);
      }

      for(x=[left,right],y=[front,rear]) {
        translate([x*(plate_hole_spacing_x/2),y*(hole_spacing_y/2),-room_behind_board]) {
          hole(board_mount_hole_diam,screw_area_thickness*2-1,resolution);
        }
      }

      translate([0,0,-20]) {
        cube([board_width+0.4,board_height+0.4,40],center=true);
      }
    }
  }

  position_board() {
    // % cheeky_board();
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
  screw_hole_diam = board_mount_hole_diam + 0.5;
  plate_thickness = 1;
  plate_width = overall_width - wall_thickness*4 - 0.6;
  plate_height = board_height - 0.2;
  cable_hole_width = 3.1; // cable is ~3mm when squeezed in the calipers

  module body() {
    position_board() {
      translate([0,0,0]) {
        translate([0,0,-room_behind_board+plate_thickness/2]) {
          rounded_cube(plate_width,plate_height,plate_thickness,wall_thickness*4,resolution);
        }
      }
    }
  }

  module holes() {
    position_board() {
      for(x=[left,right],y=[front,rear]) {
        translate([x*plate_hole_spacing_x/2,y*hole_spacing_y/2,0]) {
          hole(screw_hole_diam,room_behind_board*4,resolution);
        }
      }

      translate([plate_width/2,0,0]) {
        rounded_cube(cable_hole_width*2.5,cable_hole_width,20,cable_hole_width);
        for(y=[front,rear]) {
          mirror([0,y-1,0]) {
            translate([0,cable_hole_width/2,0]) {
              rotate([0,0,90]) {
                round_corner_filler(cable_hole_width,resolution);
              }
            }
          }
        }

        for(x=[-10,-20]) {
          for(y=[front,rear]) {
            translate([x,y*3,0]) {
              rounded_cube(3.5,2,20,2);
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

difference() {
  mount();
  translate([overall_width/2,0,0]) {
    //cube([overall_width,200,200],center=true);
  }
}

// color("white", 0.3) back_cover();
