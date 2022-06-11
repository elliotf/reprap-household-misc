include <lumpyscad/lib.scad>;

// designed for https://www.homedepot.com/p/HDX-8-1-2-in-150-Watt-Aluminum-Incandescent-Light-Fixture-with-Clamp-277894/202847393
// which I got on sale for pretty cheap and is a decent spotlight lamp for the money, but:
//   * the aluminum shade did stay on very well
//   * the clamp made it awkward to place where I wanted it to be (sitting in my desk area)
//   * the shade/reflector, while good for its intended job, made the light highly directional, which I no longer wanted

resolution = 128;
//resolution = 32;
inch = 25.4;

extrude_width = 0.5;
extrude_height = 0.24;

wall_thickness = extrude_width*2;

lamp_neck_length = 22.5; // including threads
lamp_neck_diam = 33.5; // actually ~33.5 but let's give it some room

lamp_wide_diam = 39;
lamp_wide_length = 14;

lamp_butt_diam = 35.5;
lamp_butt_length = 25;
lamp_butt_rounded = 16;

lamp_tip_diam = 20;
lamp_tip_length = 8;

bulb_diam = 60;
bulb_length = 96;
bulb_base_diam = 35;
bulb_base_bevel_length = 5;

spacer = 0.2;

set_screw_diam = m3_diam + spacer;
set_screw_nut_diam = m3_nut_diam + spacer;
set_screw_nut_depth = 4;

shade_large_diam = 170;
shade_height_from_neck = bulb_length+lamp_neck_length+1/2*inch;
shade_hole_diam = lamp_neck_diam+0.4;
shade_base_diam = shade_hole_diam+wall_thickness*4;
shade_base_height = max(set_screw_nut_diam+extrude_height*4*5, extrude_height*ceil(11.5/extrude_height));
//shade_tip_angle = 0;
shade_tip_angle = -55;
shade_tip_ratio = 1/tan(abs(shade_tip_angle));
shade_angle_ratio = (shade_large_diam/2-shade_base_diam/2)/shade_height_from_neck;
shade_angle = atan(shade_angle_ratio);
//shade_pivot_point = -(lamp_wide_length+lamp_butt_length+lamp_tip_length);
shade_pivot_point = -(lamp_wide_length+lamp_butt_length);
//shade_pivot_point = -(lamp_wide_length);
//shade_above_floor = lamp_wide_diam/2;
//shade_above_floor = bulb_diam/2;
shade_above_floor = 0;

foot_rounded_diam = shade_base_diam*0.6;

echo("shade_angle_ratio: ", shade_angle_ratio);
echo("shade_angle: ", shade_angle);

echo("shade_base_height: ", shade_base_height);

module bulb_vitamin() {
  module bulb_profile() {
    difference() {
      union() {
        hull() {
          translate([0,bulb_length-bulb_diam/2,0]) {
            accurate_circle(bulb_diam,resolution);
          }
          translate([0,bulb_base_bevel_length+1,0]) {
            square([bulb_base_diam,2],center=true);
          }
          translate([0,bulb_base_bevel_length/2,0]) {
            square([lamp_neck_diam-5,bulb_base_bevel_length],center=true);
          }
        }
      }
      translate([-100,0,0]) {
        square([200,300],center=true);
      }
    }
  }

  module body() {
    rotate_extrude($fn=resolution) {
      bulb_profile();
    }
  }

  module holes() {
    
  }

  color("white") difference() {
    body();
    holes();
  }
}

module lamp_vitamin() {
  lamp_switch_diam = 5;
  lamp_switch_length = 50;
  lamp_switch_depressed_height = 2;

  module lamp_profile() {
    translate([lamp_neck_diam/4,lamp_neck_length/2]) {
      square([lamp_neck_diam/2,lamp_neck_length],center=true);
    }
    translate([lamp_wide_diam/4,-lamp_wide_length/2]) {
      square([lamp_wide_diam/2,lamp_wide_length],center=true);
    }
    hull() {
      translate([lamp_butt_diam/4,-lamp_wide_length-1]) {
        square([lamp_butt_diam/2,2],center=true);
      }
      translate([1,-lamp_wide_length-lamp_butt_length/2]) {
        square([2,lamp_butt_length],center=true);
      }
      translate([lamp_butt_diam/2-lamp_butt_rounded/2,-lamp_wide_length-lamp_butt_length+lamp_butt_rounded/2]) {
        accurate_circle(lamp_butt_rounded,resolution);
      }
    }
    translate([lamp_tip_diam/4,-lamp_wide_length-lamp_butt_length-lamp_tip_length/2,0]) {
      square([lamp_tip_diam/2,lamp_tip_length],center=true);
    }
  }

  module body() {
    color("#444") rotate_extrude($fn=resolution) {
      lamp_profile();
    }

    color("#555") translate([0,-lamp_wide_diam/2-lamp_switch_depressed_height+lamp_switch_length/2,-lamp_wide_length+lamp_switch_diam/2]) {
      rotate([90,0,0]) {
        hole(lamp_switch_diam,lamp_switch_length,resolution);
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

module main() {
  module position_lamp_vitamin() {
    translate([0,0,shade_above_floor]) {
      rotate([0,shade_tip_angle,0]) {
        //translate([lamp_tip_diam/2,0,-shade_pivot_point]) {
        translate([shade_hole_diam/2,0,-shade_pivot_point]) {
          children();
        }
      }
    }
  }

  module lamp_cavity() {
    hull() {
      translate([0,0,shade_height_from_neck]) {
        // main large ring
        hole(shade_large_diam-wall_thickness*2,extrude_height*2,resolution);

        translate([-shade_hole_diam/2,0,0]) {
          // two outermost feet
          top_rim_dist_to_floor = shade_tip_ratio*(shade_height_from_neck+abs(shade_pivot_point));
          perpendicular_dist_to_floor = sin(abs(shade_tip_angle))*top_rim_dist_to_floor;

          rotate([0,-90-shade_tip_angle,0]) {
            translate([-perpendicular_dist_to_floor,0,0]) {
              for(y=[front,rear]) {
                difference_in_wall_thickness_at_angle = 0;
                echo("shade_tip_ratio: ", shade_tip_ratio);
                translate([foot_rounded_diam/2-difference_in_wall_thickness_at_angle,y*(shade_large_diam/2-foot_rounded_diam/2),0]) {
                  hole(foot_rounded_diam-shade_tip_ratio*2,extrude_height,resolution);
                }
              }
            }
          }
        }
      }
      translate([0,0,shade_base_height+0.1]) {
        bottom_cavity_diam = shade_base_diam+(shade_base_height*shade_angle_ratio)*2-wall_thickness*2;
        hole(bottom_cavity_diam,0.2,resolution);

        height_from_pivot = abs(shade_pivot_point)+shade_base_height;
        dist_to_floor = shade_tip_ratio*height_from_pivot+shade_hole_diam/2;//+bottom_cavity_diam/2;
        translate([-(dist_to_floor-foot_rounded_diam/2),0,0]) {
          hole(foot_rounded_diam-wall_thickness*2,0.2,resolution);
        }
      }
    }
  }

  module body() {
    position_lamp_vitamin() {
      hull() {
        translate([0,0,shade_height_from_neck-extrude_height/2]) {
          // main large ring
          hole(shade_large_diam,extrude_height,resolution);

          translate([-shade_hole_diam/2,0,0]) {
            // two outermost feet
            top_rim_dist_to_floor = shade_tip_ratio*(shade_height_from_neck+abs(shade_pivot_point));
            perpendicular_dist_to_floor = sin(abs(shade_tip_angle))*top_rim_dist_to_floor;
            echo("perpendicular_dist_to_floor: ", perpendicular_dist_to_floor);
            echo("top_rim_dist_to_floor: ", top_rim_dist_to_floor);

            rotate([0,-90-shade_tip_angle,0]) {
              translate([-perpendicular_dist_to_floor,0,0]) {
                for(y=[front,rear]) {
                  translate([foot_rounded_diam/2,y*(shade_large_diam/2-foot_rounded_diam/2),0]) {
                    hole(foot_rounded_diam,extrude_height,resolution);
                  }
                }
              }
            }
          }
        }
        translate([0,0,shade_base_height/2]) {
          // base ring
          hole(shade_base_diam,shade_base_height,resolution);

          height_from_pivot = abs(shade_pivot_point);
          dist_to_floor = shade_tip_ratio*height_from_pivot+shade_hole_diam/2;
          // foot_rounded_diam = shade_base_diam*0.6;
          translate([-(dist_to_floor-foot_rounded_diam/2),0,0]) {
            // set screw access and foot
            hole(foot_rounded_diam,shade_base_height,resolution);
          }
        }
      }

      % lamp_vitamin();
      % translate([0,0,lamp_neck_length]) {
        bulb_vitamin();
      }
    }
  }

  module holes() {
    position_lamp_vitamin() {
      hole(shade_hole_diam,shade_height_from_neck*3,resolution);
      lamp_cavity();
      /*
      // main cavity
      hull() {
        translate([0,0,shade_height_from_neck+1]) {
          hole(shade_large_diam-wall_thickness*2,2,resolution);
        }

        translate([0,0,shade_base_height+1]) {
          bottom_cavity_diam = shade_base_diam+(shade_base_height*shade_angle_ratio)*2-wall_thickness*2;
          echo("shade_angle_ratio: ", shade_angle_ratio);
          hole(bottom_cavity_diam,2,resolution);
        }
      }
      */

      // trim far side
      translate([-shade_hole_diam/2,0,shade_height_from_neck]) {
        rotate([0,-shade_tip_angle,0]) {
          //% debug_axes(3);
          translate([-shade_large_diam,0,0]) {
            cube([shade_large_diam*2,shade_large_diam*2,shade_large_diam*2],center=true);
          }
        }
      }

      // set screw and nyloc nut
      translate([-shade_hole_diam/2,0,shade_base_height/2]) {
        rotate([0,-90,0]) {
          // % debug_axes(4);
          translate([0,0,shade_large_diam/2]) {
            hole(set_screw_diam,shade_large_diam,8);
          }

          hole(set_screw_nut_diam,set_screw_nut_depth*2,6);

          translate([0,0,set_screw_nut_depth+extrude_width*6+shade_large_diam/2]) {
            hole(set_screw_nut_diam,shade_large_diam,6);
          }
        }
      }
    }

    translate([0,0,-shade_large_diam]) {
      cube([shade_large_diam*10,shade_large_diam*10,shade_large_diam*2],center=true);
    }
    // for debug
    translate([0,-shade_large_diam+0.1,0]) {
      // color("yellow") cube([shade_large_diam*10,shade_large_diam*2,shade_large_diam*10],center=true);
    }
  }

  difference() {
    body();
    holes();
  }
}

rotate([0,-shade_tip_angle,0]) {
  main();
}

// main();
