include <lumpyscad/lib.scad>;

tolerance = 0.2;

slot_width = 5.8;
slot_depth = 5;

room_for_t_slot_nut_length = 9;

extrusion_side = 20;
attach_width = 80;
attach_depth = 50;
attach_height = 60;
rounded_diam = 2;

plate_thickness = 4;
wall_thickness = 4;
extrusion_attach_width = extrusion_side + tolerance * 2 + wall_thickness * 2;
extrusion_slot_coverage = extrusion_side / 2 + slot_width / 2;

total_depth = attach_depth + extrusion_side / 2 + slot_width / 2;

width_offset = left * (attach_width / 2 - extrusion_side / 2 - wall_thickness);

plate_screw_diam = 4.5;
plate_screw_head_diam = 9;
plate_screw_head_height = 3;

extrusion_screw_diam = 5.2;
extrusion_screw_head_diam = 9.7;

module main() {
  module position_plate_screws() {
    position_width_brace() {
      for (x = [left, right]) {
        translate([x * (attach_width - extrusion_side) / 2, extrusion_side / 2, 0]) {
          children();
        }
      }
    }
    translate([0, attach_depth - extrusion_side / 2, 0]) {
      children();
    }
  }

  module position_extrusion_screws() {
    translate([0, 0, -attach_height + extrusion_side / 2]) {
      rotate([90, 0, 0]) {
        children();
      }
    }
    translate([0, 0, -plate_thickness - plate_screw_head_height - extrusion_screw_head_diam / 2 - 3]) {
      rotate([90, 0, 0]) {
        children();
      }
    }
  }

  module position_width_brace() {
    translate([width_offset, 0, 0]) {
      children();
    }
  }

  module plate_profile() {
    module body() {
      hull() {
        translate([0, attach_depth / 2, 0]) {
          rounded_square(extrusion_attach_width, attach_depth, rounded_diam);
        }
        position_width_brace() {
          translate([0, extrusion_side / 2, 0]) {
            rounded_square(attach_width, extrusion_side, rounded_diam);
          }
        }
      }
    }

    module holes(){}

    difference() {
      body();
      holes();
    }
  }
  module body() {
    translate([0, 0, -plate_thickness / 2]) {
      linear_extrude(height=plate_thickness, convexity=3, center=true) {
        plate_profile();
      }
    }

    hull() {
      translate([0, wall_thickness / 2, 0]) {
        translate([0, 0, -attach_height / 2]) {
          rounded_cube(extrusion_attach_width, wall_thickness, attach_height, rounded_diam);
        }
        position_width_brace() {
          translate([0, 0, -plate_thickness / 2]) {
            rounded_cube(attach_width, wall_thickness, plate_thickness, rounded_diam);
          }
        }
      }
    }

    // vertical side supports
    for (x = [left, right]) {
      mirror([x - 1, 0, 0]) {
        translate([extrusion_attach_width / 2 - wall_thickness / 2, 0, 0]) {
          translate([-slot_depth / 2 - wall_thickness / 2 + rounded_diam / 2, -extrusion_side / 2, -attach_height / 2]) {
            rounded_cube(slot_depth + rounded_diam, slot_width, attach_height, rounded_diam);
          }
          hull() {
            translate([0, attach_depth - total_depth / 2, -plate_thickness / 2]) {
              rounded_cube(wall_thickness, total_depth, plate_thickness, rounded_diam);
            }
            translate([0, -extrusion_slot_coverage / 2 + wall_thickness / 2, -attach_height / 2]) {
              rounded_cube(wall_thickness, extrusion_slot_coverage + wall_thickness, attach_height, rounded_diam);
            }
          }
        }
      }
    }

    translate([0, -slot_depth / 2 + rounded_diam / 2, -attach_height / 2]) {
      rounded_cube(slot_width, slot_depth + rounded_diam, attach_height, rounded_diam);
    }
  }

  module holes() {
    position_extrusion_screws() {
      hole(5.2, 40, resolution);
      debug_axes(1);
      // clear out the slot filler
      translate([0, 0, slot_depth / 2 + tolerance / 2]) {
        hull() {
          cube([slot_width + 0.5, room_for_t_slot_nut_length, slot_depth + tolerance], center=true);

          translate([0, -slot_depth, slot_depth]) {
            cube([slot_width + 0.5, room_for_t_slot_nut_length, slot_depth + tolerance], center=true);
          }
        }
      }
    }

    position_plate_screws() {
      hole(plate_screw_diam, 40, resolution);
      translate([0, 0, -plate_thickness - 2]) {
        %hole(plate_screw_head_diam, 2, resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

main();

