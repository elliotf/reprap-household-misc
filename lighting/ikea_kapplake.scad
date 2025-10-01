include <lumpyscad/lib.scad>;
include <NopSCADlib/lib.scad>;

wall_thickness = 0.4*3*2;
light_diam = 35.5;
button_diam = 28;
light_thickness = 10;
rounded_diam = light_thickness;
body_diam = light_diam+wall_thickness*2;
hold_light_by = 2;
body_central_hollow_diam = light_diam-hold_light_by;
light_holder_thickness = light_thickness+wall_thickness;

hose_ball_diam = 11.74; // actual diam, so we can squeeze it
hose_neck_diam = 9;

//reflector_height = 18;
reflector_height = hose_ball_diam+wall_thickness;
coolant_hose_clamp_length = 12;

overall_height = light_holder_thickness+reflector_height-wall_thickness/2;
short_length = light_diam+wall_thickness;
overall_length = body_diam+coolant_hose_clamp_length;
room_avail = overall_length-short_length;

shorter_length = short_length*0.2;
shorter_height = overall_height-light_holder_thickness;

module main() {
  module dummy_light(swell_diam_by=0) {
    total_diam = light_diam + swell_diam_by;
    total_rounded_diam = light_thickness;
    rotate_extrude($fn=resolution*2) {
      hull() {
        translate([1,0,0]) {
          square([2,total_rounded_diam],center=true);
        }
        translate([total_diam/2-total_rounded_diam/2,0,0]) {
          accurate_circle(total_rounded_diam,resolution);
        }
      }
    }
  }

  module position_light() {
    translate([0,0,0]) {
      children();
    }
  }

  module position_hose_head() {
    translate([0,-body_diam/2+overall_length,-light_thickness/2-reflector_height/2]) {
      rotate([-90,0,0]) {
        children();
      }
    }
  }

  module body() {
    bevel_height = 1;
    /*
    translate([0,-body_diam/2,light_holder_thickness/2-overall_height/2]) {
      translate([0,short_length/2,0]) {
        rotate([90,0,0]) {
          hull() {
            rounded_cube(body_diam,overall_height,short_length-bevel_height,light_holder_thickness,resolution);
            rounded_cube(body_diam-bevel_height,overall_height-bevel_height,short_length,light_holder_thickness-bevel_height,resolution);
          }
        }
      }
    }
    */
    module base_portion(width=body_diam) {
      translate([0,-body_diam/2,0]) {
        translate([0,shorter_length/2,-light_thickness/2-shorter_height/2]) {
          rotate([90,0,0]) {
            rounded_cube(width,shorter_height,shorter_length-bevel_height,shorter_height,resolution);
            rounded_cube(width-bevel_height,shorter_height-bevel_height,shorter_length,shorter_height-bevel_height,resolution);
          }
        }
      }
    }
    hull() {
      base_portion();
      translate([0,-body_diam/2,0]) {
        translate([0,short_length/2,0]) {
          rotate([90,0,0]) {
            rounded_cube(body_diam,light_holder_thickness,short_length-bevel_height,light_holder_thickness,resolution);
            rounded_cube(body_diam-bevel_height,light_holder_thickness-bevel_height,short_length,light_holder_thickness-bevel_height,resolution);
          }
        }
      }
    }

    // ball holder
    hull() {
      base_portion(body_diam*0.3);
      translate([0,-body_diam/2,light_holder_thickness/2-overall_height/2]) {
        translate([0,overall_length-room_avail,-overall_height/2+reflector_height/2]) {
          rotate([-90,0,0]) {
            translate([0,0,-bevel_height]) {
              //rounded_cube(body_diam,reflector_height,bevel_height*2,light_holder_thickness,resolution);
            }
            translate([0,0,room_avail/2]) {
              narrower_width = hose_ball_diam+wall_thickness*3;
              rounded_cube(narrower_width,reflector_height,room_avail-bevel_height,light_holder_thickness,resolution);
              rounded_cube(narrower_width-bevel_height,reflector_height-bevel_height,room_avail,light_holder_thickness-bevel_height,resolution);
            }
          }
        }
      }
    }
  }

  module holes() {
    // light cavity
    position_light() {
      dummy_light();
      translate([0,0,-light_thickness/2+100/2]) {
        hole(button_diam,100+2*(wall_thickness),resolution);
        translate([0,overall_length/2,0]) {
          cube([button_diam-hold_light_by,overall_length,100],center=true);
        }
      }
      translate([0,50,0]) {
        rotate([90,0,0]) {
          rounded_cube(light_diam-hold_light_by,light_thickness,100,light_thickness);
        }
      }
    }

    // reflector
    hull() {
      position_light() {
        translate([0,0,-light_thickness/2-wall_thickness-0.1]) {
          hole(button_diam,0.2,resolution);
        }
      }
      narrow_by = wall_thickness*1.5;
      reflector_opening_height = shorter_height-narrow_by;
      translate([0,-body_diam/2,-light_thickness/2-shorter_height/2]) {
        rotate([90,0,0]) {
          rounded_cube(body_diam-narrow_by,reflector_opening_height,2*(shorter_length-1),reflector_opening_height);
        }
      }
      /*
      reflector_opening_height = reflector_height-wall_thickness*1.5;
      translate([0,-body_diam/2,light_holder_thickness/2-overall_height+wall_thickness+reflector_opening_height/2]) {
        rotate([90,0,0]) {
          rounded_cube(light_diam,reflector_opening_height,1,rounded_diam-wall_thickness);
        }
      }
      */
    }

    // hose head
    position_hose_head() {
      // split to allow more flex
      hold_hose_by = 0.45*hose_ball_diam; 
      split_width = hose_ball_diam-hold_hose_by;
      cube([split_width,100,room_avail*2],center=true);
      translate([0,0,-coolant_hose_clamp_length/2]) {
        sphere(r=hose_ball_diam/2,$fn=resolution);
        translate([0,0,20/2]) {
          hole(hose_neck_diam,20,resolution);
        }
      }

    }
  }

  difference() {
    body();
    holes();
  }
}

main();
