include <lumpyscad/lib.scad>;

module mount(width, thickness, length) {
  retaining_lip_height = 1/2*inch;
  wide_tolerance = 2;
  wall_thickness = 2;
  rounded_diam = 2;

  cavity_width = width+wide_tolerance;
  cavity_thickness = thickness+wide_tolerance;

  body_width = cavity_width+wall_thickness+retaining_lip_height+wide_tolerance;
  body_thickness = cavity_thickness+wall_thickness*2;
  mount_width = 1*inch;

  screw_hole_diam = 6;
  screw_head_diam = 10;
  screw_hole_length = 1/4*inch;
  screw_body_thickness = screw_head_diam+wall_thickness*2;
  sheet_thickness = wall_thickness*2;
  mount_pos_x = length/2-mount_width/2+sheet_thickness;

  leave_remaining_bottom = cavity_width/2;
  leave_remaining_sides = 6;

  cavity_pos_z = -wide_tolerance-retaining_lip_height-cavity_width/2;
  overall_cavity_height = abs(cavity_pos_z)+cavity_width/2;

  module position_endcap() {
    translate([mount_pos_x,0,-body_width/2]) {
      rotate([0,-90,0]) {
        children();
      }
    }
  }

  module thick_profile() {
    module body() {
      translate([screw_hole_length/2,screw_body_thickness/2+cavity_thickness/2]) {
        rounded_square(screw_hole_length,screw_body_thickness,rounded_diam);
      }
      translate([body_width/2,cavity_thickness/2+wall_thickness/2,0]) {
        rounded_square(body_width,wall_thickness,wall_thickness);
      }
      translate([overall_cavity_height,0,0]) {
        rounded_square(wall_thickness*2,body_thickness,wall_thickness);
      }
      translate([overall_cavity_height-retaining_lip_height/2+wall_thickness/2,-body_thickness/2+wall_thickness/2,0]) {
        rounded_square(retaining_lip_height+wall_thickness,wall_thickness,wall_thickness);
      }
    }

    module holes() {
    }

    difference() {
      body();
      holes();
    }
  }

  module sheet_profile() {
    module body() {
      hull() {
        translate([0,cavity_thickness/2]) {
          translate([screw_hole_length/2,screw_body_thickness/2]) {
            rounded_square(screw_hole_length,screw_body_thickness,rounded_diam);
          }
          translate([body_width/2,wall_thickness/2,0]) {
            rounded_square(body_width,wall_thickness,wall_thickness);
          }
        }
      }
      translate([body_width/2,cavity_thickness/2+wall_thickness/2-leave_remaining_sides/2]) {
        rounded_square(body_width,wall_thickness+leave_remaining_sides,wall_thickness);
      }
      hull() {
        translate([overall_cavity_height+wall_thickness/2-retaining_lip_height/2,0]) {
          rounded_square(wall_thickness+retaining_lip_height,body_thickness,wall_thickness);
        }
        translate([overall_cavity_height-leave_remaining_bottom/2+wall_thickness/2,1+cavity_thickness/2-leave_remaining_sides]) {
          square([wall_thickness+leave_remaining_bottom,2],center=true);
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

  /*
  translate([0,cavity_width,0]) {
    sheet_profile();
  }
  translate([0,-cavity_width,0]) {
    thick_profile();
  }
  */

  translate([0,0,cavity_pos_z]) {
    % rotate([90,0,0]) {
      rounded_cube(length,width,thickness, 3);
    }
  }

  module body() {
    translate([mount_pos_x,0,0]) {
      rotate([0,90,0]) {
        linear_extrude(mount_width, center = true, convexity = 3, scale = 1.0) {
          thick_profile();
        }
      }
      translate([mount_width/2-sheet_thickness/2,0,0]) {
        rotate([0,90,0]) {
          linear_extrude(sheet_thickness, center = true, convexity = 3, scale = 1.0) {
            sheet_profile();
          }
        }
      }
    }

    position_endcap() {
      //rounded_cube(body_width,body_thickness, mount_width, rounded_diam+ wall_thickness*2);
    }
  }

  module holes() {
    # translate([mount_pos_x,cavity_thickness/2+screw_body_thickness/2,-screw_hole_length]) {
      hole(screw_hole_diam, cavity_width*2, 8);

      translate([0,0,-cavity_width/2]) {
        hole(screw_head_diam, cavity_width, 8);
      }
    }

    translate([0,0,-overall_cavity_height/2]) {
      rotate([0,-90,0]) {
        # rounded_cube(overall_cavity_height,cavity_thickness,length,2);
      }

      translate([0,0,leave_remaining_bottom/2]) {
        rotate([0,-90,0]) {
          # rounded_cube(overall_cavity_height-leave_remaining_bottom,cavity_thickness- leave_remaining_sides*2,length*2,rounded_diam);
        }
      }
    }
    position_endcap() {
      translate([0,0,wall_thickness*2]) {
        rounded_cube(body_width- wall_thickness*2, cavity_thickness, mount_width, rounded_diam);
      }
    }

    for(y=[front,rear]) {
      mirror([0,y-1,0]) {
        translate([mount_pos_x,body_thickness/2,-overall_cavity_height-wall_thickness]) {
          rotate([0,90,0]) {
            rotate([0,0,180]) {
              round_corner_filler(wall_thickness*3, mount_width*4);
            }
          }
          debug_axes();
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
  for(x=[left,right]) {
    mirror([x-1,0,0]) {
      translate([length/2,0,0]) {
      }
    }
  }
}

width = 65;
thickness = 30;
length = 145;

mount(width,thickness,length);
