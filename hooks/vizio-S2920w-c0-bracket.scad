include <../lib/util.scad>;

// hook to mount a Vizio S2920w-c0 soundbar underneath a shelf

extrude_width = 0.4;
wall_thickness = extrude_width*3;
rounded_diam = wall_thickness*2;

front_plastic_height = 90;
back_plastic_height = 80;
drop_height = front_plastic_height - back_plastic_height;

bottom_depth = 54;
angled_surface_len = 55;
fascia_depth = 15;

mount_screw_hole_from_bottom = 46;
mount_screw_diam = 5;
mount_screw_head_diam = 10;
mount_screw_thread_into_length = 5;
mount_screw_support_length = 4;
mount_screw_length = mount_screw_thread_into_length + mount_screw_support_length;
mount_screw_body_diam = mount_screw_head_diam + wall_thickness*4;

anchor_screw_diam = 6;
anchor_screw_head_diam = 13;
anchor_screw_support_length = wall_thickness*2;
anchor_slot_added_length = 9;
anchor_slot_length = anchor_screw_diam + anchor_slot_added_length;
anchor_head_slot_length = anchor_screw_head_diam + anchor_slot_added_length;

resolution = 64;

//top_angle = sin(drop_height/angled_surface_len)*360;
top_angle = -1*atan2(drop_height,bottom_depth);

bracket_top_space = 2;
bracket_width = mount_screw_body_diam;
bracket_top_width = bracket_width + anchor_screw_head_diam + rounded_diam*3;
bracket_depth = 2*inch;
bracket_height = back_plastic_height + bracket_top_space;

bracket_width_difference = bracket_top_width-bracket_width;

screw_spacing = (mount_screw_head_diam/2+wall_thickness*2+anchor_screw_head_diam/2);

module bracket() {

  module position_top_face() {
    translate([bracket_depth/2,0,back_plastic_height+bracket_top_space]) {
      rotate([0,top_angle,0]) {
        translate([-bracket_depth/2,0,0]) {
          children();
        }
      }
    }
  }

  module bottom_tip() {
    translate([bracket_depth/2-mount_screw_support_length/2,-mount_screw_head_diam/2-rounded_diam/2,mount_screw_hole_from_bottom*0.25]) {
      rotate([0,90,0]) {
        hole(rounded_diam,mount_screw_support_length,resolution);
      }
    }
  }

  module body() {
    intersection() {
      union() {
        position_top_face() {
          hull() {
            translate([0,0,-anchor_screw_support_length/2]) {
              rotate([0,90,0]) {
                translate([0,-bracket_width_difference/2,bracket_depth/2-mount_screw_support_length/2]) {
                  rounded_cube(anchor_screw_support_length,bracket_top_width,mount_screw_support_length+1,anchor_screw_support_length);
                }
                narrow_width = anchor_screw_head_diam + rounded_diam*2;
                translate([0,-screw_spacing,-bracket_depth/2]) {
                  # rounded_cube(anchor_screw_support_length,narrow_width,4,anchor_screw_support_length);
                }
              }
            }
          }
        }
        // main plate
        intersection() {
          hull() {
            position_top_face() {
              translate([bracket_depth/2-mount_screw_support_length/2,-bracket_width_difference/2,-anchor_screw_support_length/2]) {
                rotate([0,90,0]) {
                  rounded_cube(anchor_screw_support_length,bracket_top_width,mount_screw_support_length+2,anchor_screw_support_length);
                }
              }
            }
            translate([bracket_depth/2-mount_screw_support_length/2,0,mount_screw_hole_from_bottom]) {
              rotate([0,90,0]) {
                hole(mount_screw_body_diam,mount_screw_support_length,resolution);
              }
            }
            for(y=[0,-anchor_screw_head_diam-rounded_diam]) {
              translate([0,y,0]) {
                bottom_tip();
              }
            }
          }
          translate([bracket_depth/2-mount_screw_support_length/2,0,0]) {
            cube([mount_screw_support_length,bracket_width*20,bracket_height*3],center=true);
          }
        }
        for(y=[0,-anchor_screw_head_diam-rounded_diam]) {
          translate([0,y,0]) {
            hull() {
              position_top_face() {
                translate([0,-mount_screw_head_diam/2-wall_thickness,-anchor_screw_support_length+rounded_diam/2]) {
                  rotate([0,90,0]) {
                    hole(rounded_diam,bracket_depth+2,resolution);
                  }
                }
              }
              bottom_tip();
            }
          }
        }
      }
      cube([bracket_depth,bracket_width*20,bracket_height*3],center=true);
    }
  }

  module holes() {
    translate([0,0,mount_screw_hole_from_bottom]) {
      rotate([0,-90,0]) {
        translate([0,0,mount_screw_support_length]) {
          hole(mount_screw_diam+1,bracket_depth*3,resolution);
          hole(mount_screw_head_diam,bracket_depth,resolution);
        }
      }
    }

    translate([0,0,back_plastic_height+bracket_top_space]) {
      rotate([0,top_angle,0]) {
        translate([0,0,200]) {
          color("red") cube([400,400,400],center=true);
        }
      }
    }

    position_top_face() {
      translate([3,-screw_spacing,0]) {
        rounded_cube(anchor_slot_length,anchor_screw_diam,100,anchor_screw_diam,8);
        translate([0,0,-anchor_screw_support_length-50]) {
          rounded_cube(anchor_head_slot_length,anchor_screw_head_diam,100,anchor_screw_head_diam,8);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module soundbar_placeholder(sample_width=30) {
  module body() {
    color("#777",0.1) hull() {
      translate([0.01,0,back_plastic_height/2]) {
        cube([0.02,sample_width,back_plastic_height],center=true);
      }
      translate([bottom_depth-0.01,0,front_plastic_height/2]) {
        cube([0.02,sample_width,front_plastic_height],center=true);
      }
    }
    translate([bottom_depth+fascia_depth/2,0,front_plastic_height/2]) {
      color("#444",0.1) cube([fascia_depth,sample_width,front_plastic_height],center=true);
    }
  }

  module holes() {
    translate([0,0,mount_screw_hole_from_bottom]) {
      rotate([0,90,0]) {
        color("red") hole(mount_screw_diam,bottom_depth,resolution);
      }
    }
    
  }

  difference() {
    body();
    holes();
  }
}

translate([-bracket_depth/2-1,0,0]) {
  bracket();
}

% soundbar_placeholder(150);
