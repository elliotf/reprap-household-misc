include <../lib/util.scad>;

resolution=64;
pi = 3.14159;

tolerance = 0.2;
extrude_width = 0.45;

m3_thread_into_plastic_diam = 2.8;
m3_fsc_head_diam = 6;

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

keycap_side = 20;
keyswitch_hole_side = 14+tolerance*2;
keyswitch_ledge_thickness = 1.3;
keyswitch_height_below_plate = 10;

num_leds = 12;
led_side = 5;
led_height = 1.7;
led_spacing = 1000 / 144;
led_ribbon_thickness = 1;
led_ribbon_width = 8;

led_ring_id = 32;
//led_ring_id = (num_leds*led_spacing)/pi;
led_ring_od = led_ring_id + led_ribbon_thickness*2 + led_height*2;

led_diffusion_thickness = 0.2*4; // N layers thick

xiao_pos_z = 0.2*4;
keyswitch_pos_z = xiao_pos_z + xiao_height + keyswitch_height_below_plate + 1;

bottom_height = xiao_pos_z + xiao_board_thickness + xiao_connector_height/2;
top_height = keyswitch_pos_z - bottom_height;

led_ring_pos_z = bottom_height + 2 + led_ribbon_width/2;

total_height = keyswitch_pos_z;

top_inner_diam = 40;
body_diam = top_inner_diam + wall_thickness*4;
base_diam = body_diam + 5*2;

echo("body_diam: ", body_diam);
echo("top_inner_diam: ", top_inner_diam);
echo("base_diam: ", base_diam);

echo("total_height: ", total_height);
echo("body_diam: ", body_diam);
echo("base_diam: ", base_diam);

xiao_cavity_length = xiao_length + tolerance*2;
xiao_cavity_width = xiao_width + tolerance*2;

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
                                                                         
module m3_countersink_screw(length) {                                    
  countersink_screw(3,m3_fsc_head_diam,0.5,length);                      
}                                                                        

module xiao() {
  shield_width = 12;
  shield_length = 12.4;
  shield_height = 2.3;
  shield_from_end = 1.3;

  module body() {
    translate([0,0,xiao_board_thickness/2]) {
      color("#444") {
        rounded_cube(xiao_width,xiao_length,xiao_board_thickness,xiao_rounded_diam);
      }
    }

    // EMI shield
    translate([0,-xiao_length/2+shield_from_end+shield_length/2,xiao_board_thickness+shield_height/2]) {
      color("#aaa") {
        cube([shield_width,shield_length,shield_height],center=true);
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

module led_post() {
  
}

module position_led_segments() {
}

module led_ring() {
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

  module body() {

    if (num_leds % 2) {
      led_segment();
    }
    for(x=[left,right]) {
      for(i=[0:floor(num_leds/2)]) {
        rotate([0,0,x*(remainder/2+i)*angle]) {
          led_segment();
        }
      }
    }
    /*
    translate([0,0,led_ring_board_thickness/2]) {
      color("#444") linear_extrude(height=led_ring_board_thickness,center=true,convexity=2) {
        difference() {
          accurate_circle(led_ring_od,resolution);
          accurate_circle(led_ring_id,resolution);
        }
      }
    }

    ring_width = (led_ring_od-led_ring_id)/2;
    for(i=[0:11]) {
      rotate([0,0,i*angle]) {
        translate([0,led_ring_id/2+ring_width/2,led_ring_board_thickness+led_height/2]) {
          color("#fff") cube([led_side,led_side,led_height],center=true);
        }
      }
    }
    */
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
  translate([0,base_diam/2-xiao_length/2-1.5-wall_thickness*2,xiao_pos_z]) {
    //rotate([0,180,0]) {
      children();
    //}
  }
}

module position_usb_connection_trim() {
  position_xiao() {
    translate([0,xiao_cavity_length/2+extrude_width*4,xiao_board_thickness+xiao_connector_height/2]) {
      children();
    }
  }
}

module position_screw_holes() {
  /*
  for(x=[left,right]) {
    translate([x*(top_inner_diam/2+extrude_width*4+m3_thread_into_plastic_diam/2),0,0]) {
      children();
    }
  }
  */
}

module alignment_pins(pin_tolerance=0) {
  pin_height = 2;
  pin_width = 4+pin_tolerance*2;

  linear_extrude(height=pin_height+pin_tolerance*2,center=true,convexity=2) {
    accurate_circle(top_inner_diam-tolerance*3+pin_tolerance*2,128);

    for(side=[left,right]) {
      for(r=[45,135]) {
        rotate([0,0,side*r]) {
          translate([0,top_inner_diam/2,0]) {
            accurate_circle(pin_width,16);
          }
        }
      }
    }
  }
}

module top() {
  diffusion_thickness = 0.4*4;

  module body() {
    hull() {
      translate([0,0,keyswitch_pos_z-0.1]) {
        hole(body_diam,0.2,128);
      }

      translate([0,0,keyswitch_pos_z-top_height+0.1]) {
        hole(base_diam,0.2,128);
      }
    }
  }

  module holes() {
    // make inside hollow
    difference() {
      hull() {
        top_diam = body_diam-diffusion_thickness*2;
        bottom_diam = base_diam-diffusion_thickness*2;

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
        cube([base_diam,diffusion_thickness*2,100],center=true);
      }
    }

    position_keyswitch() {
      cube([keyswitch_hole_side,keyswitch_hole_side,keyswitch_hole_side],center=true);
    }

    position_xiao() {
      translate([0,xiao_length/2,xiao_board_thickness+xiao_connector_height/2]) {
        rotate([90,0,0]) {
          rounded_cube(xiao_connector_width+tolerance*2,xiao_connector_height+tolerance*2,xiao_length,xiao_connector_height+tolerance*2);
        }
      }
    }

    position_usb_connection_trim() {
      translate([0,10,0]) {
        rounded_cube(xiao_width*4,20,bottom_height*3,xiao_connector_height+tolerance*2);
      }
    }

    translate([0,0,keyswitch_pos_z-top_height]) {
      thread_depth = 4;
      position_screw_holes() {
        hole(m3_thread_into_plastic_diam,thread_depth*2,16);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module bottom() {
  internal_height = 10;
  internal_diam = body_diam - wall_thickness*4 - tolerance*2;

  support_ring_id = 24;
  support_ring_od = support_ring_id+extrude_width*8;

  module body() {
    translate([0,0,bottom_height/2]) {
      hole(base_diam,bottom_height,128);
    }
  }

  module holes() {
    position_xiao() {
      translate([0,xiao_length/2,xiao_board_thickness+xiao_connector_height/2]) {
        rotate([90,0,0]) {
          rounded_cube(xiao_connector_width+tolerance*2,xiao_connector_height+tolerance*2,xiao_length,xiao_connector_height+tolerance*2);
        }
      }

      translate([0,0,50]) {
        rounded_cube(xiao_cavity_width,xiao_cavity_length,100,xiao_rounded_diam+tolerance*2);
      }
    }

    position_usb_connection_trim() {
      translate([0,10,0]) {
        rounded_cube(xiao_width*4,20,bottom_height*3,xiao_connector_height+tolerance*2);
      }
    }

    translate([0,0,0]) {
      m3_loose_diam = 3.3;
      position_screw_holes() {
        m3_countersink_screw(20);
      }
    }
  }

  module supports() {
    // xiao retainer to make it easier to assemble
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

  difference() {
    body();
    holes();
  }
  supports();
}

% translate([0,0,tolerance/2]) {
  color("grey", 0.5) top();
}
//bottom();

position_led_ring() {
  led_ring();
}

position_keyswitch() {
  translate([0,0,-keyswitch_ledge_thickness-keyswitch_height_below_plate/2]) {
    // % cube([keyswitch_hole_side,keyswitch_hole_side,keyswitch_height_below_plate],center=true);
  }
}

position_xiao() {
  // xiao();
}
