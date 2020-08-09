include <../lib/util.scad>;

resolution=64;
pi = 3.14159;

tolerance = 0.2;
extrude_width = 0.45;

m2_thread_into_plastic_diam = 1.8;
m2_fsc_head_diam = 4;
m2_loose_diam = 2 + tolerance*1.5;

alignment_pin_diam = m2_thread_into_plastic_diam+extrude_width*4;
alignment_pin_length = 2;

wall_thickness = extrude_width*3;

xiao_width = 18;
xiao_length = 21.20;
xiao_height = 5;
xiao_connector_overhang = 1.5;
xiao_connector_width = 9;
xiao_connector_length = 7.5;
xiao_connector_height = 3.25;
xiao_board_thickness = 1.4;
xiao_rounded_diam = 1.75*2;
xiao_shield_width = 12;
xiao_shield_length = 12.4;
xiao_shield_height = 2.3;
xiao_shield_from_end = 1.3;

keycap_side = 20;
keyswitch_hole_side = 14+tolerance;
keyswitch_ledge_thickness = 1.3;
keyswitch_height_below_plate = 10;
keyswitch_side_below_ledge = keyswitch_hole_side+2*(1.5);

num_leds = 12;
led_side = 5;
led_height = 1.7;
led_spacing = 1000 / 144;
led_ribbon_thickness = 1;
led_ribbon_width = 12;

led_ring_id = 30;

//led_diffusion_thickness = 0.2*4; // N layers thick
led_diffusion_thickness = 0.4*4;
led_diffusion_distance = 8;


xiao_pos_z = 0.2*4;
//keyswitch_pos_z = xiao_pos_z + xiao_height + keyswitch_height_below_plate + 1;
keyswitch_pos_z = xiao_pos_z + xiao_height + led_ribbon_width + 2;

bottom_height = xiao_pos_z + xiao_board_thickness + xiao_connector_height/2;
top_height = keyswitch_pos_z - bottom_height - 0.1;

led_ring_pos_z = bottom_height + 2 + led_ribbon_width/2;

total_height = keyswitch_pos_z;

//top_inner_diam = 38;
//body_diam = top_inner_diam + wall_thickness*4;
bottom_larger_than_top = 0;
body_diam = led_ring_id + 2*(led_ribbon_thickness + led_height + led_diffusion_distance);
base_diam = body_diam + bottom_larger_than_top*2;

xiao_cavity_length = xiao_length + tolerance*2;
xiao_cavity_width = xiao_width + tolerance*2;

echo("body_diam: ", body_diam);
echo("base_diam: ", base_diam);

module countersink_screw(actual_shaft_diam,head_diam,head_depth,length) {
  loose_tolerance = 0.4;
  shaft_hole_diam = actual_shaft_diam + loose_tolerance;

  hole(shaft_hole_diam,length*2,resolution);
  diff = head_diam-shaft_hole_diam;
  hull() {
    hole(shaft_hole_diam,diff+head_depth*2,resolution);
    hole(head_diam,head_depth*2,resolution);
  }
}

module m2_countersink_screw(length) {
  countersink_screw(2,m2_fsc_head_diam,0.5,length);
}

module m3_countersink_screw(length) {
  countersink_screw(3,m3_fsc_head_diam,0.5,length);
}

module xiao() {
  module body() {
    translate([0,0,xiao_board_thickness/2]) {
      color("#444") {
        rounded_cube(xiao_width,xiao_length,xiao_board_thickness,xiao_rounded_diam);
      }
    }

    // EMI shield
    translate([0,-xiao_length/2+xiao_shield_from_end+xiao_shield_length/2,xiao_board_thickness+xiao_shield_height/2]) {
      color("#aaa") {
        cube([xiao_shield_width,xiao_shield_length,xiao_shield_height],center=true);
      }
    }

    // USB C connector
    translate([0,xiao_length/2-xiao_connector_length/2+xiao_connector_overhang,xiao_board_thickness+xiao_connector_height/2]) {
      rotate([90,0,0]) {
        color("#aaa") {
          rounded_cube(xiao_connector_width,xiao_connector_height,xiao_connector_length,xiao_connector_height);
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

module position_led_segments() {
  post_circumference = pi*led_ring_id;
  led_strip_length = num_leds*led_spacing;

  echo("post_circumference:    ", post_circumference);
  echo("led_strip_length:      ", led_strip_length);

  pct_of_circle_covered = led_strip_length/post_circumference;
  angle_coverage = pct_of_circle_covered*360;

  angle = angle_coverage/num_leds;

  echo("angle:                 ", angle);
  echo("pct_of_circle_covered: ", pct_of_circle_covered);
  echo("angle_coverage:        ", angle_coverage);

  remainder = (num_leds % 2) ? 2 : 1;

  echo("remainder: ", remainder);

  module led_segment() {
    translate([0,front*led_ring_id/2,0]) {
      children();
    }
  }
  if (num_leds % 2) {
    led_segment() {
      children();
    }
  }
  for(x=[left,right]) {
    for(i=[0:floor(num_leds/2)-1]) {
      rotate([0,0,x*(remainder/2+i)*angle]) {
        led_segment() {
          children();
        }
      }
    }
  }
}

module led_ring() {
  module body() {
    position_led_segments() {
      // ribbon
      translate([0,front*led_ribbon_thickness/2,0]) {
        rotate([-90,0,0]) {
          color("#777") cube([led_spacing+0.5,led_ribbon_width,led_ribbon_thickness],center=true);
        }
      }
      // led
      translate([0,front*(led_ribbon_thickness+led_height/2),0]) {
        rotate([-90,0,0]) {
          color("#fff") cube([led_side,led_side,led_height],center=true);
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

module position_led_ring() {
  translate([0,0,led_ring_pos_z]) {
    rotate([0,0,0]) {
      children();
    }
  }
}

module position_keyswitch() {
  translate([0,0,keyswitch_pos_z]) {
    children();
  }
}

module position_xiao() {
  translate([0,base_diam/2-xiao_cavity_length/2-2-wall_thickness*2,xiao_pos_z]) {
    children();
  }
}

module position_usb_connection_trim() {
  position_xiao() {
    translate([0,xiao_cavity_length/2+extrude_width*4,xiao_board_thickness+xiao_connector_height/2]) {
      children();
    }

    translate([0,xiao_length/2+xiao_connector_overhang,xiao_board_thickness+xiao_connector_height/2]) {
      rotate([90,0,0]) {
        rounded_cube(xiao_connector_width+tolerance*2,xiao_connector_height+tolerance*2,2*(xiao_connector_length+tolerance*4),xiao_connector_height+tolerance*2);
      }
    }
  }
}

module position_screw_holes() {
  middle_of_space = (led_ring_id/2-keyswitch_side_below_ledge/2)/2;
  translate([0,front*(keyswitch_side_below_ledge/2+alignment_pin_diam/2),0]) {
    children();
  }
  for(x=[left,right]) {
    translate([x*(keyswitch_side_below_ledge/2+middle_of_space),0,0]) {
      children();
    }
  }
}

module top() {
  module body_profile() {
    translate([0,keyswitch_pos_z]) {
      translate([body_diam/4,-keyswitch_ledge_thickness/2]) {
        square([body_diam/2,keyswitch_ledge_thickness],center=true);
      }
      translate([led_ring_id/4,-top_height/2]) {
        square([led_ring_id/2,top_height],center=true);
      }
      translate([body_diam/2-led_diffusion_thickness/2,-top_height/2]) {
        square([led_diffusion_thickness,top_height],center=true);
      }
    }
  }

  module body() {
    rotate_extrude($fn=128,convexity=3) {
      body_profile();
    }

    // add meat by USB connector
    intersection() {
      translate([0,0,keyswitch_pos_z-top_height/2-0.5]) {
        hole(body_diam-0.1,top_height-1,resolution);
      }
      position_usb_connection_trim() {
        cube([body_diam,led_diffusion_thickness*2,top_height*4],center=true);
      }
    }

    position_screw_holes() {
      translate([0,0,keyswitch_pos_z-top_height]) {
        hole(alignment_pin_diam,alignment_pin_length*2,16);
      }
    }
  }

  module holes() {
    // make inside hollow
    /*
    # difference() {
      hull() {
        top_diam = body_diam-led_diffusion_thickness*2;
        bottom_diam = base_diam-led_diffusion_thickness*2;

        translate([0,0,keyswitch_pos_z-0.1]) {
          hole(top_diam,0.2,128);
        }

        translate([0,0,keyswitch_pos_z-top_height]) {
          hole(bottom_diam,0.4,128);
        }
      }
      translate([0,0,keyswitch_pos_z]) {
        cube([base_diam,base_diam,keyswitch_ledge_thickness*2],center=true);
      }

      position_usb_connection_trim() {
        cube([base_diam,led_diffusion_thickness*2,100],center=true);
      }

      translate([0,0,keyswitch_pos_z-top_height/2-0.3]) {
        linear_extrude(height=top_height,center=true,convexity=2) {
          accurate_circle(led_ring_id,128);
          //hull() {
          //  position_led_segments() {
          //    translate([0,0.2,0]) {
          //      square([led_side,0.2],center=true);
          //    }
          //  }
          //}
        }
      }
    }
    */

    position_keyswitch() {
      cube([keyswitch_hole_side,keyswitch_hole_side,keyswitch_hole_side],center=true);

      hull() {
        translate([0,0,-keyswitch_ledge_thickness-25]) {
          rounded_cube(keyswitch_side_below_ledge,keyswitch_side_below_ledge,50,3);
        }
      }
    }

    // clearance for led strip wiring
    translate([0,led_ring_id/2-6+1,keyswitch_pos_z-top_height]) {
      cube([3,12,2*(led_ribbon_width+1)],center=true);
    }

    position_xiao() {
      // keep xiao from popping up
      height_of_xiao_at_shield = xiao_board_thickness+xiao_shield_height;
      translate([0,-xiao_length/2+xiao_shield_from_end+xiao_shield_length/2,0]) {
        rounded_cube(xiao_shield_width+tolerance,xiao_shield_length+4,height_of_xiao_at_shield*2,0.2);
      }

      // clearance for wiring into xiao headers
      xiao_pin_dist = 15;
      wire_clearance_width = 3;
      for(x=[left,right]) {
        translate([x*(keyswitch_side_below_ledge/2-wire_clearance_width/2),0,0]) {
          hull() {
            rounded_cube(wire_clearance_width,xiao_length,2*height_of_xiao_at_shield,wire_clearance_width);

            translate([0,-xiao_cavity_length/2+wire_clearance_width/2,0]) {
              hole(wire_clearance_width,3.5*(height_of_xiao_at_shield),resolution);
            }
          }
        }
      }
    }

    position_usb_connection_trim() {
      translate([0,10,0]) {
        rounded_cube(xiao_width*4,20,top_height*3,xiao_connector_height+tolerance*2);
      }
    }

    translate([0,0,keyswitch_pos_z-top_height]) {
      thread_depth = 4;
      position_screw_holes() {
        hole(m2_thread_into_plastic_diam,thread_depth*2,16);
      }
    }

    position_vent_holes() {
      hole_width = 5;
      hole_depth = 1;
      translate([0,front*(led_ring_id/2+led_ribbon_thickness+led_height/2+hole_depth/2),0]) {
        rounded_cube(hole_width,hole_depth,top_height*3,hole_depth);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module position_vent_holes() {
  num_vent_holes = 6;

  pct_of_circle = 0.75;
  angle = (pct_of_circle*360)/num_vent_holes;

  echo("angle: ", angle);

  remainder = (num_vent_holes % 2) ? 2 : 1;

  if (num_vent_holes % 2) {
    children();
  }
  echo("floor(num_vent_holes/2): ", floor(num_vent_holes/2));
  for(x=[left,right]) {
    for(i=[0:floor(num_vent_holes/2)-1]) {
      rotate([0,0,x*(remainder/2+i)*angle]) {
        children();
      }
    }
  }
}

module bottom() {
  internal_height = 10;
  internal_diam = body_diam - wall_thickness*4 - tolerance*2;

  support_ring_id = 24;
  support_ring_od = support_ring_id+extrude_width*8;

  module body() {
    difference() {
      translate([0,0,bottom_height/2]) {
        hole(base_diam,bottom_height,128);
      }
      position_xiao() {
        translate([0,0,50]) {
          rounded_cube(xiao_cavity_width,xiao_cavity_length,100,xiao_rounded_diam+tolerance*2);
        }

        // reset pad access
        reset_pad_from_edge = 4.5;
        reset_hole_width = 8;
        reset_hole_height = 4;
        translate([0,xiao_length/2-reset_pad_from_edge,0]) {
          rounded_cube(reset_hole_width,reset_hole_height,50,1.5);
        }
      }
    }

    if (0) {
      // disable for now so it's easier to assemble
      // will re-add if the microcontroller wiggles too much
      position_xiao() {
        rounded_diam = 4;
        depth = 6;
        overhang_depth = 1.1;

        translate([0,-xiao_cavity_length/2-depth/2,xiao_board_thickness+tolerance*1]) {
          hull() {
            rounded_cube(10,depth,0.2,rounded_diam);
            translate([0,overhang_depth/2,overhang_depth*1.2]) {
              rounded_cube(10,depth+overhang_depth,0.2,rounded_diam);
            }
          }
        }
      }
    }

    if (1) {
      translate([0,0,bottom_height]) {
        rim_height = 0.6;
        rim_od = body_diam-2*(led_diffusion_thickness+tolerance);
        rim_id = rim_od - 2*(extrude_width*2);
        linear_extrude(height=rim_height*2,center=true,convexity=2) {
          difference() {
            accurate_circle(rim_od,128);
            accurate_circle(rim_id,128);
            position_usb_connection_trim() {
              square([body_diam,2*(led_diffusion_thickness+tolerance)],center=true);
            }
          }
          //hull() {
          //  position_led_segments() {
          //    translate([0,0.2,0]) {
          //      square([led_side,0.2],center=true);
          //    }
          //  }
          //}
        }
      }
    }
  }

  module holes() {
    position_usb_connection_trim() {
      translate([0,10,-bottom_height+0.1]) {
        rounded_cube(xiao_width*4,20,bottom_height*2,xiao_connector_height+tolerance*2);
      }
    }

    position_screw_holes() {
      m2_countersink_screw(20);

      translate([0,0,bottom_height]) {
        hole(alignment_pin_diam+tolerance*2,2*(alignment_pin_length+tolerance),16);
      }
    }

    position_vent_holes() {
      vent_width  = 6;
      vent_length = 8;
      vent_depth  = 1.5;
      translate([0,-base_diam/2,bottom_height]) {
        rounded_cube(vent_width,vent_length*2,vent_depth*2,vent_width);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

% translate([0,0,tolerance/2]) {
  //color("grey", 0.5) top();
}
bottom();
position_led_ring() {
  led_ring();
}

position_keyswitch() {
  translate([0,0,-keyswitch_ledge_thickness-keyswitch_height_below_plate/2]) {
    // % cube([keyswitch_hole_side,keyswitch_hole_side,keyswitch_height_below_plate],center=true);
  }
}

position_xiao() {
  xiao();
}
