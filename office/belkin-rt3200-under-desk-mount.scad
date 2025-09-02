include <lumpyscad/lib.scad>;

module bridged_hole(od,id,length=50,is_final=1,num_sides=resolution) {
  render() {
    hole(id,length,resolution);
    translate([0,0,length/4]) {
      hole(od,length/2,num_sides);
    }
    if (is_final) {
      intersection() {
        union() {
          cube([od,id,0.2*1*2],center=true);
          cube([id,id,0.2*2*2],center=true);
          hole(id,0.2*3*2,8);
        }
        hole(od,0.2*3*3,num_sides);
      }
    }
  }
}

foot_contact_width = 78;
foot_contact_height = 5;
retention_height = 8;
wall_thickness = 4;
tolerance = 1;

overall_width = foot_contact_width+2*wall_thickness+tolerance;
overall_height = 2*wall_thickness+foot_contact_height+retention_height;

mount_depth = inch;
foot_angle = 35;
elbow_pos_y = -overall_height+wall_thickness/2;

router_depth = 156;

screw_hole_diam = 6;

translate([0,0,-wall_thickness-retention_height-3]) {
  rotate([0,180,0]) {
    % color("white") dummy_belkin_sketch();
  }
}

module dummy_belkin_sketch() {
  narrow_body_width = 28;
  wide_body_width = 45;
  wide_body_height = 110;
  total_body_height = 210;
  height_under = 12;

  overall_height = height_under + total_body_height;

  rounded_diam = 5;

  feet_stance_width = 78;
  feet_root_thickness = 10;
  feet_end_thickness = 6;
  feet_skewed_by = 4;

  foot_depth = 145;

  translate([0,0,total_body_height/2+height_under]) {
    rotate([90,0,0]) {
      hull() {
        rounded_cube(wide_body_width, wide_body_height, router_depth, rounded_diam);
        rounded_cube(narrow_body_width, total_body_height, router_depth, rounded_diam);
      }
    }
  }

  for(x=[left,right]) {
    mirror([x-1,0,0]) {
      hull() {
        translate([narrow_body_width/2-2,0,height_under+feet_root_thickness/2]) {
          rotate([0,-70,0]) {
            rounded_cube(feet_root_thickness, foot_depth, 2, 2);
          }
        }
        translate([feet_stance_width/2-feet_end_thickness/2,feet_skewed_by,1]) {
          rotate([0,0,0]) {
            rounded_cube(feet_end_thickness, foot_depth, 2, 2);
          }
        }
      }
    }
  }
}

module profile() {
  module body() {
    translate([0,-wall_thickness/2,0]) {
      rounded_square(overall_width, wall_thickness, wall_thickness);
    }

    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        translate([overall_width/2-wall_thickness/2,-overall_height/2,0]) {
          rounded_square(wall_thickness, overall_height, wall_thickness);
        }
        translate([overall_width/2-wall_thickness/2,elbow_pos_y,0]) {
          rotate([0,0,foot_angle]) {
            translate([-overall_height/2+wall_thickness/2,0,0]) {
              rounded_square(overall_height, wall_thickness, wall_thickness);
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

module corner_trim() {
  for(x=[left,right]) {
    mirror([x-1,0,0,]) {
      translate([overall_width/2,0,0]) {
        rotate([90,0,0]) {
          rotate([0,0,180]) {
            round_corner_filler(wall_thickness*2, mount_depth*3);
          }
        }
      }
    }
  }
}

module mount_rear() {
  % translate([150,0,0]) {
    profile();
  }

  module body() {
    translate([0,front*mount_depth/2,0]) {
      rotate([90,0,0]) {
        linear_extrude(mount_depth+wall_thickness, center = true, convexity = 3) {
          profile();
        }
      }
    }
    translate([0,wall_thickness/2,0]) {
      rotate([90,0,0]) {
        linear_extrude(wall_thickness, center = true, convexity = 3) {
          hull() {
            profile();
          }
        }
      }
    }
  }

  module holes() {
    translate([0,0,-wall_thickness-overall_height/2]) {
      rotate([90,0,0]) {
        rounded_cube(30, overall_height, 30, wall_thickness);
      }
    }
    translate([0,-mount_depth/2+wall_thickness/2,0]) {
      hole(screw_hole_diam, wall_thickness*4, resolution);
    }

    corner_trim();
  }

  difference() {
    body();
    holes();
  }
}

module mount_front() {
  module retention_clip_profile() {
    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        hull() {
          translate([overall_width/2-wall_thickness/2,elbow_pos_y+retention_height/2,0]) {
            rounded_square(wall_thickness, retention_height+wall_thickness, wall_thickness);
          }
          translate([overall_width/2-wall_thickness/2,elbow_pos_y,0]) {
            rotate([0,0,foot_angle]) {
              translate([-overall_height/2+wall_thickness/2,0,0]) {
                rounded_square(overall_height, wall_thickness, wall_thickness);

                translate([-overall_height/2+wall_thickness/2,0,0]) {
                  rotate([0,0,- foot_angle]) {
                    translate([0,retention_height/2,0]) {
                      rounded_square(wall_thickness, retention_height+wall_thickness, wall_thickness);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  module body() {
    translate([0,rear*mount_depth/2+wall_thickness/2,0]) {
      rotate([90,0,0]) {
        linear_extrude(mount_depth+wall_thickness, center = true, convexity = 3) {
          profile();
        }
      }
    }
    translate([0,rear*wall_thickness/2,0]) {
      rotate([90,0,0]) {
        linear_extrude(wall_thickness, center = true, convexity = 3) {
          retention_clip_profile();
        }
      }
    }

  }

  module holes() {
    translate([0,mount_depth/2+wall_thickness/2,0]) {
      hole(screw_hole_diam, wall_thickness*4, resolution);
    }
    corner_trim();
  }

  difference() {
    body();
    holes();
  }
}

translate([0,router_depth/2+1,0]) {
  mount_rear();
}

translate([0,-router_depth/2-1,0]) {
  mount_front();
}
