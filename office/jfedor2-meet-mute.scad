include <lumpyscad/lib.scad>;
include <NopSCADlib/lib.scad>;

debug=1;
resolution=32;
pi = 3.14159;

tolerance = 0.2;
extrude_width = 0.5;
extrude_height = 0.2;
room_for_wires = 0;

m2_thread_into_plastic_diam = 1.8;
m2_fsc_head_diam = 4;
m2_loose_diam = 2 + tolerance*1.5;

wall_thickness = extrude_width*2;

keycap_hole_side = 20;
keycap_hole_rounded = 3;
keyswitch_hole_side = 13.9+tolerance;
keyswitch_ledge_thickness = 1.2;
keyswitch_height_below_plate = 10;

num_leds = 16;
led_side = 5;
led_height = 1.7;
led_ring_id = 54;
led_ring_od = 67.8;
led_ring_thickness = 1.6;
led_ring_led_angle = 360/num_leds;

led_ring_screw_hole_diam = 1.95;
led_ring_screw_hole_spacing_x = 37.6-led_ring_screw_hole_diam;
led_ring_screw_hole_spacing_y = 55.16-led_ring_screw_hole_diam;

uc_type = RPI_Pico;
uc_length = pcb_length(uc_type);
uc_width = pcb_width(uc_type);
uc_pcb_thickness = pcb_thickness(uc_type);
uc_height = 4;
uc_screw_hole_diam = 1.75;

case_screw_diam = 3+tolerance;
case_screw_hole_diam = 2.9; // screw into plastic
case_screw_head_diam = 6+tolerance;
case_screw_length = 10;

top_height = 20;
top_thickness = extrude_height*4;
bottom_height = 6.5; // uc_cavity_deep_height+extrude_height*6;
bottom_thickness = extrude_height*8;

top_bevel = 5;
bottom_bevel = bottom_thickness;

top_bottom_screw_gap = 0.5; // make screw post area a little short so that the outside rim closes first
keyswitch_below_surface = top_height-keyswitch_height_below_plate-keyswitch_ledge_thickness;

overall_height = bottom_height+top_height;

uc_cavity_width = uc_width+tolerance*2;
uc_cavity_length = uc_length+tolerance*2;
uc_cavity_shallow_height = uc_pcb_thickness+tolerance;
uc_cavity_deep_height = bottom_height-bottom_thickness;
uc_cavity_deep_width = uc_width-4;

uc_pos_z = bottom_height-tolerance/2;
led_ring_pos_z = uc_pos_z+room_for_wires;

body_od = led_ring_od + 2*(5+wall_thickness*2);
body_od_fn = 256;
body_outer_flat_depth = 3;

module uc() {
  pcb(RPI_Pico);
}

module main_shape(od,height,bevel_height=3) {
  a_od = od-bevel_height*2;
  a_height = height-bevel_height;
  hull() {
    // narrower but full height
    difference() {
      hole(a_od,height,body_od_fn);
      translate([-a_od+body_outer_flat_depth,0,0]) {
        cube([a_od,100,100],center=true);
      }
    }
    // shorter but full diam
    translate([0,0,-bevel_height/2]) {
      difference() {
        hole(od,a_height,body_od_fn);
        translate([-od+body_outer_flat_depth,0,0]) {
          cube([od,100,100],center=true);
        }
      }
    }
  }
}

module position_led_ring_holes() {
  for(x=[left,right],y=[front,rear]) {
    translate([x*led_ring_screw_hole_spacing_x/2,y*led_ring_screw_hole_spacing_y/2,0]) {
      children();
    }
  }
}

module led_ring() {
  module led() {
    translate([0,0,led_height/2]) {
      color("white") cube([led_side,led_side,led_height],center=true);
    }
  }

  module body() {
    translate([0,0,led_ring_thickness/2]) {
      color("#444") hole(led_ring_od,led_ring_thickness,128);
    }

    led_pos_y = led_ring_id/2+(led_ring_od/2-led_ring_id/2)/2;
    for(r=[0:num_leds]) {
      rotate([0,0,r*led_ring_led_angle]) {
        translate([0,led_pos_y,led_ring_thickness/2]) {
          led();
        }
      }
    }
  }

  module holes() {
    translate([0,0,led_ring_thickness/2]) {
      color("#888") hole(led_ring_id,led_ring_thickness*2,128);
    }

    position_led_ring_holes() {
      hole(led_ring_screw_hole_diam,led_ring_thickness*3,resolution/2);
    }
  }

  difference() {
    body();
    holes();
  }
}

module position_led_ring() {
  translate([0,0,led_ring_pos_z]) {
    rotate([0,0,0]) {
      children();
    }
  }
}

module position_keyswitch() {
  translate([0,0,0]) {
    children();
  }
}

module position_uc() {
  translate([-body_od/2+body_outer_flat_depth+wall_thickness*2+uc_cavity_length/2,0,uc_pos_z]) {
    rotate([180,0,0]) {
      children();
    }
  }
}

module top() {
  module body_profile() {
  }

  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module position_case_screw_holes() {
  screw_post_dist = uc_cavity_width+case_screw_diam+wall_thickness*4;
  for(y=[front,rear]) {
    translate([0,y*(screw_post_dist/2),0]) {
      children();
    }
  }
}

module bottom() {
  module body() {
    translate([0,0,bottom_height/2]) {
      rotate([180,0,0]) {
        main_shape(body_od,bottom_height,bottom_bevel);
      }
    }
  }

  module holes() {
    position_uc() {
      cube([uc_cavity_length,uc_cavity_width,uc_cavity_shallow_height*2],center=true);
      area_for_screw_in = 8;
      translate([-area_for_screw_in/2,0,0]) {
        cube([uc_cavity_length-area_for_screw_in,uc_cavity_deep_width,uc_cavity_deep_height*2],center=true);
      }
      length_for_wires = 14;
      translate([-uc_length/2-tolerance+length_for_wires/2,0,0]) {
        cube([length_for_wires,uc_width+wall_thickness*6,uc_cavity_deep_height*2],center=true);
      }
      translate([-uc_length/2,0,0]) {
        cube([uc_cavity_length,10,uc_cavity_deep_height*2],center=true);
      }

      // make it so that the boot select button can be pressed without disassembly
      // nophead has 12.75x and 7.5y, but measuring my uc looks different
      //translate([-uc_length/2+12.75,-uc_width/2+7.5,0]) {
      translate([-uc_length/2+12,-uc_width/2+7,0]) {
        button_tab_size = 4;
        button_tab_length = 20;

        intersection() {
          difference() {
            hole(button_tab_size+tolerance*4,bottom_height*3,resolution);
            hole(button_tab_size,bottom_height*3,resolution);
          }
          translate([-button_tab_size/2,0,0]) {
            cube([button_tab_size,button_tab_size*2,bottom_height*3],center=true);
          }
        }

        for(y=[front,rear]) {
          translate([button_tab_length/2,y*(button_tab_size/2+tolerance),0]) {
            cube([button_tab_length+0.05,tolerance*2,bottom_height*3],center=true);
          }
        }
      }

      for(y=[front,rear]) {
        translate([uc_length/2-2,y*(uc_width/2-4.8),0]) {
          hole(uc_screw_hole_diam,uc_cavity_deep_height*2,resolution/2);
        }
      }
    }

    translate([-body_od/2+body_outer_flat_depth-20,0,0]) {
      cube([40,100,100],center=true);
    }

    // save some amount of plastic, maybe let more light out
    translate([0,0,bottom_height]) {
      difference() {
        translate([0,0,-bottom_height/2+bottom_thickness]) {
          rotate([180,0,0]) {
            main_shape(body_od-wall_thickness*4,bottom_height,bottom_bevel-bottom_thickness);
          }
        }
        position_uc() {
          rounded_cube(uc_cavity_length+wall_thickness*4,uc_cavity_width+wall_thickness*4,bottom_height*4,wall_thickness*4);
        }
        for(r=[left,right]) {
          rotate([0,0,r*(led_ring_led_angle*1.5)]) {
            cube([extrude_width*4,led_ring_od,bottom_height*4],center=true);
          }
        }
        position_led_ring_holes() {
          hole(led_ring_screw_hole_diam+extrude_width*8,bottom_height*4,resolution);
        }

        position_case_screw_holes() {
          hole(case_screw_head_diam+extrude_width*8,bottom_height*4,resolution);
        }
      }
    }

    position_case_screw_holes() {
      hole(case_screw_diam,bottom_height*3,resolution);
      translate([0,0,0]) {
        hull() {
          delta = case_screw_head_diam-case_screw_diam;
          hole(case_screw_diam,bottom_height+delta,resolution);
          hole(case_screw_head_diam,bottom_height,resolution);
        }
      }
    }

    position_led_ring_holes() {
      translate([0,0,bottom_height/2+1]) {
        hole(led_ring_screw_hole_diam,bottom_height,resolution);
      }
    }
  }

  module bridges() {
    position_uc() {
      support_tab_length = 10;
      support_tab_height = uc_cavity_deep_height-uc_pcb_thickness+tolerance;
      translate([-uc_length/2+6+support_tab_length/2,0,uc_pcb_thickness+support_tab_height/2]) {
        rounded_cube(support_tab_length,2,support_tab_height,2);
      }
    }
    
  }

  difference() {
    body();
    holes();
  }
  bridges();
}

module top() {
  keyswitch_body_side = keycap_hole_side+2*(wall_thickness*2);

  module body() {
    translate([0,0,-top_height/2]) {
      main_shape(body_od,top_height,top_bevel);
    }
  }

  module holes() {
    translate([-body_od/2+body_outer_flat_depth-10,0,0]) {
      cube([20,body_od,overall_height*2],center=true);
    }

    // make it hollow
    translate([0,0,-top_height]) {
      recess_height = top_height-top_thickness; // bottom_height-extrude_height*6;
      difference() {

        translate([0,0,-top_thickness+top_height/2]) {
          main_shape(body_od-wall_thickness*4,top_height,top_bevel-top_thickness);
        }

        // posts for keyswitch and screws
        translate([0,0,top_height/2+top_bottom_screw_gap]) {
          hull() {
            position_case_screw_holes() {
              hole(case_screw_hole_diam+extrude_width*6*2,top_height,resolution);
            }
          }

          rounded_cube(keyswitch_body_side,keyswitch_body_side,top_height,keycap_hole_rounded+wall_thickness*4);
        }
      }

      position_case_screw_holes() {
        hole(case_screw_hole_diam,2*(top_height-1),resolution);
      }
    }

    cube([keyswitch_hole_side,keyswitch_hole_side,overall_height*2],center=true);
    rounded_cube(keycap_hole_side,keycap_hole_side,keyswitch_below_surface*2,keycap_hole_rounded);

    translate([0,0,-keyswitch_below_surface]) {
      cube([keycap_hole_side,keyswitch_hole_side,extrude_height*2],center=true);

      translate([0,0,-keyswitch_ledge_thickness-overall_height]) {
        rounded_cube(keycap_hole_side,keycap_hole_side,overall_height*2,keycap_hole_rounded);

        translate([-keycap_hole_side/2,0,0]) {
          cube([10,keycap_hole_side-keycap_hole_rounded,overall_height*2],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

if (debug) {
  difference() {
    union() {
      position_led_ring() {
        led_ring();
      }

      position_uc() {
        uc();
      }

      translate([0,0,bottom_height+top_height]) {
        // color("#9a9", 0.1) top();
      }

      color("#a99", 0.1) bottom();
    }
    if (0) {
      translate([0,front*50,0]) {
        cube([100,100,100],center=true);
      }
    }
  }

  if (0) {
    translate([0,0,overall_height*3]) {
      difference() {
        translate([0,0,0]) {
          main_shape(body_od,top_height);
        }
        translate([0,0,-top_thickness]) {
          main_shape(body_od-wall_thickness*4,top_height);
        }
        translate([0,-50,0]) {
          cube([100,100,100],center=true);
        }
      }
    }
  }
}
