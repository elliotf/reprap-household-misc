use <../lib/util.scad>;

hole_smaller = 14;
keycap_width = 20;
keycap_length = 25;
keycap_height = 15;
hole_ledge_thickness = 1.3;
ledge_width = 1.5;
switch_side = 16.5;

body_added = 4;
body_side = keycap_width + body_added;
body_height = keycap_length + body_added;

top = 1;
bottom = -1;

module keyswitch_fidgeter() {
  module position_end_keyswitches() {
    for(z=[top,bottom]) {
      mirror([0,0,z-1]) {
        translate([0,0,body_height/2]) {
          children();
        }
      }
    }
  }

  module position_side_keyswitches() {
    for(r=[0,90,180,270]) {
      rotate([0,0,r]) {
        rotate([90,0,0]) {
          translate([0,0,body_side/2]) {
            children();
          }
        }
      }
    }
  }

  module position_keyswitches() {
    position_end_keyswitches() {
      children();
    }
    position_side_keyswitches() {
      children();
    }
  }

  module keyswitch_hole() {
    cube([hole_smaller,hole_smaller,body_side*3],center=true);
  }

  module body() {
    hull() {
      position_end_keyswitches() {
        translate([0,0,keycap_height-0.1]) {
          rounded_cube(13,13,0.2,2,8);
        }
      }
      position_side_keyswitches() {
        translate([0,0,keycap_height-0.1]) {
          rounded_cube(13,17,0.2,2,8);
        }
      }
    }
  }

  module holes() {
    position_keyswitches() {
      keyswitch_hole();
    }
    hull() {
      position_keyswitches() {
        translate([0,0,-hole_ledge_thickness-1]) {
          cube([switch_side,switch_side,2],center=true);
        }
      }
    }

    height_above_plate = 13;
    position_end_keyswitches() {
      translate([0,0,20]) {
        rounded_cube(keycap_width,keycap_width,40,2,8);
      }
      hull() {
        translate([0,0,height_above_plate]) {
          rounded_cube(keycap_width,keycap_width,keycap_height,2,8);
        }
        translate([0,0,height_above_plate]) {
          rounded_cube(keycap_width+keycap_height,keycap_width+keycap_height,0.1,2,8);
        }
      }
    }
    position_side_keyswitches() {
      translate([0,0,20]) {
        rounded_cube(keycap_width,keycap_length,40,2,8);
      }
      hull() {
        translate([0,0,height_above_plate]) {
          rounded_cube(keycap_width,keycap_length,keycap_height,2,8);
        }
        translate([0,0,height_above_plate]) {
          rounded_cube(keycap_width+keycap_height,keycap_length+keycap_height,0.1,2,8);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

keyswitch_fidgeter();
