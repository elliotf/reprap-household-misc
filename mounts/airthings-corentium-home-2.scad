include <lumpyscad/lib.scad>;

// rough dimensions
object_width = 60.5;
object_depth = 26.5;
object_height = 113;
object_rounded_diam = 30;
face_height = 70;
face_depth = 3;

// rough measurements because it doesn't matter
button_from_bottom = 30;
button_diam = 14;

wall_thickness = 2.2;
air_gap = 6; // let air circulate around the device, under the assumption it will give more accurate readings

object_tolerance = 1;
cavity_width = object_width + object_tolerance;
cavity_depth = object_depth + object_tolerance;
cavity_height = object_height-face_height-2;
cavity_rounded_diam = air_gap * 2;

air_cavity_width = cavity_width + 2 * air_gap;
air_cavity_depth = cavity_depth + air_gap;

overall_width = air_cavity_width + 2 * wall_thickness;
overall_depth = air_cavity_depth + 2 * wall_thickness; // no air gap in front
overall_height = cavity_height + wall_thickness;
overall_rounded_diam = cavity_rounded_diam + 2 * (wall_thickness);

// an airthings corentium home 2
module object() {
  module body() {
    union() {
      // main
      translate([0, 0, object_depth / 2]) {
        rounded_cube(object_width, object_height, object_depth, object_rounded_diam, resolution);
      }
      // face
      translate([0, object_height / 2 - face_height / 2, object_depth + face_depth / 2]) {
        rounded_cube(object_width, face_height, face_depth, object_rounded_diam, resolution);
      }
    }
  }

  module holes() {
    // button
    button_depth_diam = 30;
    button_depth = 2;
    translate([0, -object_height / 2 + button_from_bottom, object_depth + button_depth_diam / 2 - button_depth]) {
      sphere(r=button_depth_diam / 2, $fn=resolution * 3);
    }
  }

  difference() {
    body();
    holes();
  }
}

module main() {
  center_retainer = 40;
  retaining_rib_height = air_gap * 1.5;
  hook_hole_pos = object_height*0.7; // make high enough to be self leveling (plumbing)
  screw_head_diam = 12;
  screw_area_height = screw_head_diam + 5;

  module position_object() {
    translate([0, air_cavity_depth / 2 - object_tolerance / 2, object_height / 2]) {
      rotate([90, 0, 0]) {
        children();
      }
    }
  }

  module retaining_rib() {
    rib_len = air_gap + wall_thickness;
    hull() {
      translate([rib_len / 2, 0, retaining_rib_height / 2 - 1]) {
        rounded_cube(rib_len, wall_thickness, 2, wall_thickness);
      }
      translate([rib_len - wall_thickness / 2, 0, 0]) {
        hole(wall_thickness, retaining_rib_height);
      }
    }
  }

  module body() {
    // air gap ribs, to allow air to go by, but still hold the sensor
    translate([0, 0, overall_height / 2 - wall_thickness]) {
      translate([0, air_cavity_depth / 2 - cavity_depth + object_tolerance / 2, 0]) {
        for (x = [left, right]) {
          for (z = [-overall_height / 2 + retaining_rib_height / 2 + object_rounded_diam / 2, overall_height / 2 - retaining_rib_height / 2 - 1]) {
            for (y = [wall_thickness / 2, object_depth * 0.7]) {
              mirror([x-1, 0, 0]) {
                translate([cavity_width / 2, y, z]) {
                  retaining_rib();
                }
              }
            }
          }
        }
      }

      difference() {
        rounded_cube(overall_width, overall_depth, overall_height, overall_rounded_diam);

        translate([0, air_cavity_depth / 2 - cavity_depth / 2, wall_thickness]) {
          //rounded_cube(overall_width - wall_thickness * 2, overall_depth - wall_thickness * 2, overall_height, cavity_rounded_diam);
          cube([cavity_width, cavity_depth, overall_height], center=true);
        }

        translate([0, air_cavity_depth / 2 - cavity_depth, 0]) {
          translate([0, -cavity_depth / 2 + object_tolerance / 2, 0]) {
            rounded_cube(center_retainer - wall_thickness * 2, cavity_depth + object_tolerance / 2, overall_height + 2, wall_thickness);
          }
        }
        for (x = [left, right]) {
          mirror([x - 1, 0, 0]) {
            translate([center_retainer / 2 - wall_thickness, -overall_depth / 2, 0]) {
              //
              round_corner_filler(overall_rounded_diam, overall_height + 2);
            }

            translate([center_retainer / 2 - wall_thickness / 2, air_cavity_depth / 2 - cavity_depth, wall_thickness]) {
              for (x = [left, right]) {
                mirror([x - 1, 0, 0]) {
                  translate([wall_thickness / 2, 0, 0]) {
                    rotate([0, 0, 180]) {
                      round_corner_filler(wall_thickness, overall_height);
                    }
                  }
                }
              }
            }
          }
        }

        for (x = [left, right]) {
          bottom_hole_width = (air_cavity_width - center_retainer) / 2;
          translate([x * (air_cavity_width / 2 - bottom_hole_width / 2), 0, 0]) {
            rounded_cube(bottom_hole_width, air_cavity_depth, overall_height + 2, cavity_rounded_diam);
          }
        }
      }
      // hook/screw hanger
      translate([0, overall_depth / 2 - wall_thickness / 2, -overall_height / 2]) {
        hull() {
          translate([0, 0, overall_height-1]) {
            rounded_cube(object_width-3, wall_thickness, 2, wall_thickness);
          }
          translate([0,0,wall_thickness+hook_hole_pos]) {
            rounded_cube(screw_area_height, wall_thickness, screw_area_height, wall_thickness);
          }
        }
      }
    }
  }

  module holes() {
    //
    translate([0,overall_depth/2-wall_thickness,hook_hole_pos]) {
      rotate([-90,0,0]) {
        hull() {
          translate([0,0,-1]) {
            hole(screw_head_diam, 2, resolution);
          }
          hole(0.1, screw_head_diam, resolution);
        }
      }
    }
  }

  position_object() {
    // %color("#777") object();
  }

  difference() {
    body();
    holes();
  }
}

main();
