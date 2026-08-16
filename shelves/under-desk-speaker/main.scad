include <lumpyscad/lib.scad>;

speaker_width = 140;
speaker_depth = 160; // maybe? calipers don't open that wide
speaker_height = 206;
speaker_rounded_diam = 30;

wall_thickness = 0.4 * 3 * 2;

shelf_inner_width = 5 * inch;
shelf_inner_depth = 5 * inch;
shelf_inner_height = 5 * inch;

tweeter_diam = 35;
woofer_diam = 85;

// some sort of foam to decouple the speakers
air_gap_front_rear = 4;
air_gap_sides = air_gap_front_rear;

face_rim_coverage = 8; // where most of the strength comes from
side_rim_coverage = 12; // what holds the speaker in

/*
 TODO:
* some way to hold the speakers in
 * elastic retainer hooks?

*/
thickness = 2;

outer_width = speaker_width + 2 * (air_gap_sides + thickness);
outer_height = speaker_height + 2 * (air_gap_sides + thickness);
inner_width = speaker_width - 2 * (face_rim_coverage);
inner_height = speaker_height - 2 * (face_rim_coverage);

base_rounded = speaker_rounded_diam * 0.7;
outer_rounded = base_rounded + 2 * (air_gap_sides);
inner_rounded = base_rounded - 2 * (face_rim_coverage);

rim_thickness = thickness + air_gap_front_rear + side_rim_coverage;

screw_hole_spacing = outer_width * 0.32;
screw_hole_diam = 4.5;
screw_head_height = 3.5;
screw_head_diam = 8.5;
screw_area_width = rim_thickness;
screw_area_thickness = thickness * 3 + screw_head_height;

retention_hook_spacing = outer_width * 0.35;
retention_cord_diam = 6;
retention_hook_thickness = 5;

module main_plate() {
  m3_thread_into_plastic_hole_diam = 2.8;

  module face_profile() {
    difference() {
      rounded_square(outer_width, outer_height, outer_rounded, resolution * 2);
      rounded_square(inner_width, inner_height, inner_rounded, resolution * 2);
    }
  }

  module rim_profile() {
    difference() {
      rounded_square(outer_width, outer_height, outer_rounded, resolution * 2);
      rounded_square(outer_width - 2 * (thickness), outer_height - 2 * (thickness), outer_rounded - 2 * (thickness), resolution * 2);
    }
  }

  module position_mounting_screw_holes() {
    for (x = [left, right, 0]) {
      translate([x * (screw_hole_spacing), outer_height / 2 - thickness, -rim_thickness / 2]) {
        children();
      }
    }
  }

  module position_retainer_screw_holes() {
    for (x = [left, right, 0]) {
      translate([x * (screw_hole_spacing), -outer_height / 2 + thickness / 2, -rim_thickness / 2]) {
        rotate([90, 0, 0]) {
          children();
        }
      }
    }
  }

  module retention_hooks() {
    /*
    // multiple hooks to allow for different cord length / tension
    for (x = [left, 0.5, -0.5, right, 0]) {
      translate([x * (retention_hook_spacing), -outer_height / 2, -rim_thickness / 2]) {
        difference() {
          hook_height = retention_cord_diam + retention_hook_thickness;
          hull() {
            cube([retention_hook_thickness, thickness, rim_thickness], center=true);

            translate([0, -hook_height + retention_hook_thickness / 2, 0]) {
              hole(retention_hook_thickness, rim_thickness, resolution / 2);
            }
          }
          translate([0, -retention_cord_diam / 2, rim_thickness / 2]) {
            difference() {
              hull() {
                rotate([0, 90, 0]) {
                  rounded_cube(retention_cord_diam * 2, retention_cord_diam, retention_hook_thickness * 2, retention_cord_diam);
                }
              }
              // leave a 0.2mm first layer for adhesion. It can be cut before usage
              translate([0, 0, 0]) {
                cube([retention_hook_thickness, hook_height * 3, 0.4], center=true);
              }
            }
          }
        }
      }
    }
    */
  }

  module body() {
    translate([0, 0, -thickness / 2]) {
      linear_extrude(height=thickness, center=true, convexity=4) {
        face_profile();
      }
    }

    position_mounting_screw_holes() {
      hull() {
        translate([0, screw_area_thickness / 2, 0]) {
          rounded_cube(screw_area_width, screw_area_thickness, rim_thickness, thickness);
        }
        thin_thickness = 0.2;
        translate([0, thin_thickness / 2, 0]) {
          rounded_cube(1.75 * screw_area_width, thin_thickness, rim_thickness, thin_thickness);
        }
      }
    }

    position_retainer_screw_holes() {
      height = 4;
      id = m3_thread_into_plastic_hole_diam + 2 * 2;
      od = id + height * 2;
      hull() {
        hole(od, thickness / 2, resolution);
        translate([0, 0, height / 2]) {
          hole(id, height, resolution);
        }
      }
    }

    retention_hooks();

    translate([0, 0, -rim_thickness / 2]) {
      linear_extrude(height=rim_thickness, center=true, convexity=4) {
        rim_profile();
      }
    }
  }

  module holes() {
    position_mounting_screw_holes() {
      rotate([90, 0, 0]) {
        hole(screw_hole_diam, screw_area_thickness * 5, 8);
        hole(screw_head_diam, screw_head_height * 2, 8);
      }
    }
    position_retainer_screw_holes() {
      hole(m3_thread_into_plastic_hole_diam, thickness * 10, resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module mock_speaker(control_side = true) {
  small_rounded_diam = 20;
  module oriented() {
    rotate([90, 0, 0]) {
      children();
    }
  }

  module speaker_cavity(diam, rounded_diam) {
    translate([0, 0, 0.05]) {
      rotate_extrude($fn=resolution * 2) {
        translate([diam / 4, 0, 0]) {
          square([diam / 2, rounded_diam], center=true);
        }
        translate([diam / 2, 0, 0]) {
          rotate([0, 0, -90]) {
            round_corner_filler_profile(rounded_diam);
          }
        }

        translate([diam / 2 + rounded_diam / 2, 0, 0]) {
          square([0.2, 2], center=true);
        }
      }
    }
  }

  module knob() {
    knob_base_diam = 16;
    knob_tip_diam = 12;
    knob_height = 13;

    position_knob() {
      rotate_extrude($fn=resolution * 2) {
        hull() {
          translate([knob_base_diam / 4, 0, 0]) {
            square([knob_base_diam / 2, 0.2], center=true);
          }
          translate([knob_tip_diam / 4, knob_height / 2, 0]) {
            square([knob_tip_diam / 2, knob_height], center=true);
          }
        }
      }
    }
  }

  module position_tweeter() {
    translate([0, speaker_height / 2 - 45, speaker_depth / 2]) {
      children();
    }
  }

  module position_woofer() {
    translate([0, -speaker_height / 2 + speaker_width / 2, speaker_depth / 2]) {
      children();
    }
  }

  module position_knob() {
    translate([speaker_width / 2 - 22, speaker_height / 2 - 60, speaker_depth / 2]) {
      children();
    }
  }

  module tweeter() {
    position_tweeter() {
      translate([0, 0, -small_rounded_diam / 2]) {
        color("#444") hole(tweeter_diam, 1, resolution * 2);
      }
    }
  }

  module woofer() {
    position_woofer() {
      translate([0, 0, -small_rounded_diam / 2]) {
        color("#444") hole(woofer_diam, 1, resolution * 2);
      }
    }
  }

  module tweeter_cavity() {
    position_tweeter() {
      speaker_cavity(tweeter_diam, small_rounded_diam);
    }
  }

  module woofer_cavity() {
    position_woofer() {
      speaker_cavity(woofer_diam, small_rounded_diam);
    }
  }

  module body() {
    color("white") {
      rounded_cube(speaker_width, speaker_height, speaker_depth, speaker_rounded_diam);
      knob();
    }
  }

  module holes() {
    color("white") {
      tweeter_cavity();
      woofer_cavity();
    }

    color("#444") {
      translate([0, 0, -speaker_depth / 2]) {
        rounded_cube(speaker_width - 12 * 2, speaker_height - 12 * 2, 0.2, speaker_rounded_diam - 12 * 2);
      }
    }
  }

  oriented() {
    tweeter();
    woofer();
    color("#444") {
      cord_length = 80;
      translate([-speaker_width / 2 + 52, -speaker_height / 2 + 30, -speaker_depth / 2 - cord_length / 2]) {
        rounded_cube(7, 4, cord_length + 3, 4, fn=resolution / 2);
      }
    }
    difference() {
      body();
      holes();
    }
  }
}

module drill_template_and_bottom_brace() {
  outer_depth = speaker_depth + 2 * air_gap_front_rear;
  bottom_thickness = 0.6;
  wall_height = 3;
  wall_thickness = 0.8;
  rounded_diam = 5;

  echo("outer_depth: ", outer_depth / inch);

  module position_screw_holes() {
    for (x = [left, 0, right], y = [front, rear]) {
      //translate([x * (screw_hole_spacing), y * (speaker_depth / 2 + air_gap_front_rear - rim_thickness / 2), 0]) {
      translate([x * (screw_hole_spacing), y * (outer_depth / 2 - rim_thickness / 2), 0]) {
        children();
      }
    }
  }

  module body() {
    for (y = [front, rear]) {
      translate([0, y * (outer_depth / 2 - rim_thickness / 2), bottom_thickness / 2]) {
        //rounded_cube(screw_hole_spacing*2+rim_thickness,rim_thickness,0.6,rim_thickness);
        //rounded_cube(outer_width, rim_thickness, bottom_thickness, rounded_diam);
      }
    }
    translate([0, 0, wall_height / 2]) {
      difference() {
        rounded_cube(outer_width, outer_depth, wall_height, rounded_diam);
        translate([0, 0, bottom_thickness]) {
          rounded_cube(outer_width - 2 * wall_thickness, outer_depth - 2 * wall_thickness, wall_height, rounded_diam - 2 * wall_thickness);
        }
      }
    }
  }

  module holes() {
    position_screw_holes() {
      hole(3.2, 10, resolution);
    }

    for (x = [left, right]) {
      translate([x * (outer_width / 4), 0, 0]) {
        rounded_cube(outer_width / 2 - 2 * 6 * wall_thickness, outer_depth - 2 * rim_thickness, wall_height * 3, rounded_diam);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

//rotate([0, 180, 0]) {
rotate([0, 0, 0]) {
  // flipped to have cords at the top and controls closer to the bottom
  //rotate([0,0,0]) {
  %mock_speaker();
}

for (z = [top, bottom]) {
  //for (z = [top]) {
  rotate([90, 0, 0]) {
    mirror([0, 0, z - 1]) {
      translate([0, 0, speaker_depth / 2 + air_gap_front_rear]) {
        main_plate();
      }
    }
  }
}

translate([0, 0, outer_height / 2 + 10]) {
  drill_template_and_bottom_brace();
}
translate([0, 0, -outer_height / 2 - 4]) {
  drill_template_and_bottom_brace();
}
