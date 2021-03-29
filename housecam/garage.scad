include <../lib/util.scad>;
include <../../plotter/lib/vitamins.scad>;

use <threadlib/threadlib.scad>

// https://www.thingiverse.com/thing:2668816

// AV1200 gigabit powerline homeav adapter dimensions
powerline_length = 131;
powerline_width = 72;
powerline_height = 42;
powerline_plug_diam = 43;
powerline_plug_from_end = 30;
powerline_outlet_from_end = 30;

power_adapter_length = 86;
power_adapter_width = 48;
power_adapter_height = 38;
power_adapter_outlet_from_end = 20;

resolution = 32;
extrude_width = 0.4;
extrude_height = 0.2;
wall_thickness = extrude_width*3;

// board dimensions are lengthwise along x
// akin to drawings:
//   raspi A+ : https://www.raspberrypi-spy.co.uk/wp-content/uploads/2012/03/raspberry_pi_a_plus_mechanical-1024x780.png
//   raspi B+ : https://www.raspberrypi-spy.co.uk/wp-content/uploads/2012/03/raspberry_pi_3_b_plus_mechanical.png

mount_thickness = wall_thickness*2;
bevel_height = 2;

rounded_diam = 8;

rasp_a_plus_max_x = 65;
rasp_a_plus_max_y = 56;
rasp_b_plus_max_x = rasp_a_plus_max_x + 20;
rasp_hole_spacing_x = 58;
rasp_hole_spacing_y = 49;
rasp_hole_coords = [
  [3.5,3.5], // bottom left
  [3.5,3.5+rasp_hole_spacing_y], // top left
  [3.5+rasp_hole_spacing_x,3.5+rasp_hole_spacing_y], // top right
  [3.5+rasp_hole_spacing_x,3.5], // bottom right
];

rasp_a_plus_usb_socket_offset_y = 31.45;

wireless_relay_board_width = 67.25;
wireless_relay_board_depth = 48;
wireless_relay_board_hole_diam = 3;
wireless_relay_hole_spacing_width = 58.9 + wireless_relay_board_hole_diam;
wireless_relay_hole_spacing_depth = 38.4 + wireless_relay_board_hole_diam;

two_relay_board_width = 38.3;
two_relay_board_depth = 50.5;
two_relay_board_hole_diam = 3.3;
two_relay_hole_spacing_width = 30 + two_relay_board_hole_diam;
two_relay_hole_spacing_depth = 41 + two_relay_board_hole_diam;

four_relay_board_width = 75.1;
four_relay_board_depth = 55.4;
four_relay_board_hole_diam = 3.3;
four_relay_hole_spacing_width = 65.6 + two_relay_board_hole_diam;
four_relay_hole_spacing_depth = 45.7 + two_relay_board_hole_diam;

// ikea 176oz container
// https://www.ikea.com/us/en/p/ikea-365-food-container-with-lid-rectangular-plastic-s69276807/
container_length = 12.5*inch;
container_width = 8.25*inch;
container_height = 4.75*inch;
container_wall_thickness = 2;

module position_pi_holes() {
  for(coord=rasp_hole_coords) {
    translate(coord) {
      children();
    }
  }
}

module raspi() {
  board_thickness = 1.5;

  usb_connector_height = 7.1;
  usb_connector_width = 13.1;
  usb_connector_length = 14;
  usb_connector_overhang = 2;
  usb_connector_offset_y = 31.45;

  microusb_connector_width = 8;
  microusb_connector_height = 3;
  microusb_connector_length = 6;
  microusb_connector_overhang = 1.5;

  gpio_width = 5;
  gpio_length = 50;
  gpio_pos_x = 7+gpio_length/2;
  gpio_pos_y = rasp_a_plus_max_y-1-gpio_width/2;

  microsd_width = 11;
  microsd_length = 15;
  microsd_thickness = 1.5;
  microsd_overhang = 2;

  rasp_connector_area_x = 22;
  rasp_connector_area_y = 53;
  rasp_connector_area_z = 16;
  rasp_connector_overhang = 2;

  module body() {
    translate([0,rasp_a_plus_max_y/2,board_thickness/2]) {
      translate([rasp_a_plus_max_x/2,0,0]) {
        color("green") rounded_cube(rasp_a_plus_max_x,rasp_a_plus_max_y,board_thickness,3);
      }

      translate([rasp_b_plus_max_x/2,0,0]) {
        color("green", 0.4) rounded_cube(rasp_b_plus_max_x,rasp_a_plus_max_y,board_thickness,3);
      }
    }

    translate([rasp_a_plus_max_x-usb_connector_length/2+usb_connector_overhang,usb_connector_offset_y,board_thickness+usb_connector_height/2]) {
      color("silver") cube([usb_connector_length,usb_connector_width,usb_connector_height],center=true);
    }

    translate([rasp_b_plus_max_x-rasp_connector_area_x/2+rasp_connector_overhang,rasp_a_plus_max_y/2,board_thickness+rasp_connector_area_z/2]) {
      color("silver", 0.4) cube([rasp_connector_area_x,rasp_connector_area_y,rasp_connector_area_z],center=true);
    }

    translate([microsd_length/2-microsd_overhang,rasp_a_plus_max_y/2,-microsd_thickness/2]) {
      color("#333") cube([microsd_length,microsd_width,microsd_thickness],center=true);
    }

    translate([10.6,microusb_connector_length/2-microusb_connector_overhang,board_thickness+microusb_connector_height/2]) {
      color("silver") cube([microusb_connector_width,microusb_connector_length,microusb_connector_height],center=true);
    }

    translate([gpio_pos_x,gpio_pos_y,board_thickness+3]) {
      color("#333") cube([gpio_length,gpio_width,6],center=true);
    }
  }

  module holes() {
    position_pi_holes() {
      color("tan") hole(2.5,board_thickness*3,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module position_two_relay_holes() {
  for(x=[left,right],y=[front,rear]) {
    translate([x*(two_relay_hole_spacing_width/2),y*(two_relay_hole_spacing_depth/2),0]) {
      children();
    }
  }
}

module position_four_relay_holes() {
  for(x=[left,right],y=[front,rear]) {
    translate([x*(four_relay_hole_spacing_width/2),y*(four_relay_hole_spacing_depth/2),0]) {
      children();
    }
  }
}

module position_wireless_relay_holes() {
  for(x=[left,right],y=[front,rear]) {
    translate([x*(wireless_relay_hole_spacing_width/2),y*(wireless_relay_hole_spacing_depth/2),0]) {
      children();
    }
  }
}

module wireless_relay() {
  board_thickness = 1;

  rounded_diam = 0;

  terminal_block_spacing = 0;
  terminal_block_width = 60.5;
  terminal_block_height = 10.7;
  terminal_block_depth = 7.6;
  terminal_block_top_depth = 5;
  terminal_block_from_edge = 5.7;

  relay_block_width = 12;
  relay_block_depth = 15.5;
  relay_block_height = 14;
  relay_block_spacing = 1;
  relay_block_from_right = 3.7;
  relay_block_from_edge = terminal_block_from_edge+terminal_block_depth+0.8;

  dark_green = "#151";
  light_green = "#484";
  black = "#333";

  module terminal_block(width) {
    color(light_green) {
      hull() {
        translate([0,0,terminal_block_height/2]) {
          cube([width,terminal_block_top_depth,terminal_block_height],center=true);
        }
        lower_height = 6.7;
        translate([0,0,lower_height/2]) {
          cube([width,terminal_block_depth,lower_height],center=true);
        }
      }
    }
  }

  module body() {
    translate([0,0,board_thickness/2]) {
      translate([0,0,0]) {
        color(dark_green) {
          cube([wireless_relay_board_width,wireless_relay_board_depth,board_thickness],center=true);
        }
      }
    }

    translate([x*(terminal_block_width+terminal_block_spacing)/2,0,0]) {
      translate([0,wireless_relay_board_depth/2-terminal_block_from_edge-terminal_block_depth/2,board_thickness/2]) {
        terminal_block(terminal_block_width);
      }
    }

    translate([-wireless_relay_board_width/2+relay_block_from_right+terminal_block_depth/2,wireless_relay_board_depth/2-20,board_thickness/2]) {
      rotate([0,0,90]) {
        terminal_block(10);
      }
    }

    for(x=[-0.5,-1.5,-2.5,-3.5]) {
      translate([wireless_relay_board_width/2-relay_block_from_right+x*(relay_block_width+relay_block_spacing),0,0]) {
        color(black) {
          translate([0,wireless_relay_board_depth/2-relay_block_from_edge-relay_block_depth/2,board_thickness/2+relay_block_height/2]) {
            cube([relay_block_width,relay_block_depth,relay_block_height],center=true);
          }
        }
      }
    }

    antenna_diam = 6.5;
    antenna_length = 40;
    translate([-wireless_relay_board_width/2+12,-wireless_relay_board_depth/2+2,antenna_diam]) {
      rotate([0,80,0]) {
        translate([0,0,antenna_length/2]) {
          color(black) hole(antenna_diam,antenna_length,24);
        }
      }
    }
  }

  module holes() {
    position_wireless_relay_holes() {
      color("tan") hole(3.2,board_thickness*3,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module pin_header(x=1,y=1) {
  spacing = 2.54;
  base_height = 2.6;
  pin_side = 0.6;
  pin_height = 8;

  black = "#333";
  silver = "lightgrey";

  module pin() {
    translate([0,0,base_height/2]) {
      color(black) cube([spacing,spacing,base_height],center=true);
    }
    translate([0,0,pin_height/2]) {
      color(silver) cube([pin_side,pin_side,pin_height],center=true);
    }
  }

  translate([-(x-1)/2*2.54,-(y-1)/2*2.54,0]) {
    for(x=[1:x],y=[y:1]) {
      translate([(x-1)*spacing,(y-1)*spacing,0]) {
        pin();
      }
    }
  }
}

module four_relay() {
  board_thickness = 1.6;

  rounded_diam = 6;

  terminal_block_spacing = 2.8;
  terminal_block_width = 30.3;
  terminal_block_height = 10.1;
  terminal_block_depth = 7.6;
  terminal_block_top_depth = 5;
  terminal_block_from_edge = 3.5;

  relay_block_width = 14.9;
  relay_block_depth = 19;
  relay_block_height = 16;
  relay_block_spacing = 1.6;
  relay_block_from_edge = 12.5;

  blue = "#46c";

  module body() {
    translate([0,0,board_thickness/2]) {
      translate([0,0,0]) {
        color("#347") {
          rounded_cube(four_relay_board_width,four_relay_board_depth,board_thickness,rounded_diam);
        }
      }
    }

    for(x=[left,right]) {
      translate([x*(terminal_block_width+terminal_block_spacing)/2,0,0]) {
        color(blue) translate([0,four_relay_board_depth/2-terminal_block_from_edge-terminal_block_depth/2,board_thickness/2]) {
          hull() {
            translate([0,0,terminal_block_height/2]) {
              cube([terminal_block_width,terminal_block_top_depth,terminal_block_height],center=true);
            }
            lower_height = 6.7;
            translate([0,0,lower_height/2]) {
              cube([terminal_block_width,terminal_block_depth,lower_height],center=true);
            }
          }
        }
      };
    }

    for(x=[-1.5,-0.5,0.5,1.5]) {
      translate([x*(relay_block_width+relay_block_spacing),0,0]) {
        color(blue) {
          translate([0,four_relay_board_depth/2-relay_block_from_edge-relay_block_depth/2,board_thickness/2+relay_block_height/2]) {
            cube([relay_block_width,relay_block_depth,relay_block_height],center=true);
          }
        }
      }
    }

    translate([four_relay_board_width/2-8-(6*2.54)/2,-four_relay_board_depth/2+3.4+2.54/2,0]) {
      pin_header(6,1);
    }
  }

  module holes() {
    position_four_relay_holes() {
      color("tan") hole(3.2,board_thickness*3,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module two_relay() {
  board_thickness = 1.6;

  rounded_diam = 6;

  terminal_block_width = 30.3;
  terminal_block_height = 10.1;
  terminal_block_depth = 7.6;
  terminal_block_top_depth = 5;
  terminal_block_from_edge = 3.5;

  relay_block_width = 14.9;
  relay_block_depth = 19;
  relay_block_height = 16;
  relay_block_spacing = 1.6;
  relay_block_from_edge = 12.5;

  blue = "#46c";

  module body() {
    translate([0,0,board_thickness/2]) {
      translate([0,0,0]) {
        color("#555") rounded_cube(two_relay_board_width,two_relay_board_depth,board_thickness,rounded_diam);
      }
    }

    color(blue) translate([0,two_relay_board_depth/2-terminal_block_from_edge-terminal_block_depth/2,board_thickness/2]) {
      hull() {
        translate([0,0,terminal_block_height/2]) {
          cube([terminal_block_width,terminal_block_top_depth,terminal_block_height],center=true);
        }
        lower_height = 6.7;
        translate([0,0,lower_height/2]) {
          cube([terminal_block_width,terminal_block_depth,lower_height],center=true);
        }
      }
    }

    color(blue) translate([0,two_relay_board_depth/2-relay_block_from_edge-relay_block_depth/2,board_thickness/2+relay_block_height/2]) {
      for(x=[left,right]) {
        translate([x*(relay_block_spacing/2+relay_block_width/2),0,0]) {
          cube([relay_block_width,relay_block_depth,relay_block_height],center=true);
        }
      }
    }
  }

  module holes() {
    position_two_relay_holes() {
      color("tan") hole(3.2,board_thickness*3,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

csi_extension_board_width = 25;
csi_extension_board_length = 27.63;
csi_extension_hole_spacing_width = 21;

module position_csi_extension_board_holes() {
  hole_spacing_width = 21;
  hole_spacing_depth = 12;
  holes_from_end = 1.5;

  for(x=[left,right],y=[front,rear]) {
    translate([x*(hole_spacing_width/2),y*(hole_spacing_depth/2)+csi_extension_board_length/4-holes_from_end,0]) {
      children();
    }
  }
}

module csi_extension_board() {
  board_thickness = 1.5;

  module body() {
    translate([0,0,board_thickness/2]) {
      translate([0,0,0]) {
        color("green") cube([csi_extension_board_width,csi_extension_board_length,board_thickness],center=true);
      }
    }

    hdmi_connector_width = 15;
    hdmi_connector_depth = 12;
    hdmi_connector_height = 6.2;
    hdmi_connector_overhang = 1;
    translate([0,-csi_extension_board_length/2-hdmi_connector_overhang+hdmi_connector_depth/2,board_thickness+hdmi_connector_height/2]) {
      color("silver") cube([hdmi_connector_width,hdmi_connector_depth,hdmi_connector_height],center=true);
    }

    csi_connector_width = 21;
    csi_connector_depth = 5;
    csi_connector_height = 2;
    csi_connector_from_edge = 5;
    translate([0,csi_extension_board_length/2-csi_connector_from_edge-csi_connector_depth/2,board_thickness+csi_connector_height/2]) {
      color("#fff") cube([csi_connector_width,csi_connector_depth,csi_connector_height],center=true);
    }
  }

  module holes() {
    position_csi_extension_board_holes() {
      color("tan") hole(2,board_thickness*3,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

room_for_buck_converter = 14;

module position_csi_extension() {
  translate([left*(bevel_height+mount_thickness/2),-rasp_b_plus_max_x/2+csi_extension_board_width/2,csi_extension_board_length/2]) {
    rotate([0,-90,0]) {
      rotate([0,0,-90]) {
        children();
      }
    }
  }
}

module position_keystone_retainer() {
  translate([0,0,keystone_depth/2]) {
    children();
  }
}

module container() {
  base_narrower_by = 1*inch;

  module shape(inset_by=0) {
    hull() {
      translate([0,0,container_height-5]) {
        cube([container_width-inset_by*2,container_length-inset_by*2,10+inset_by],center=true);
      }
      translate([0,0,5]) {
        cube([container_width-base_narrower_by-inset_by*2,container_length-base_narrower_by-inset_by*2,10-inset_by*2],center=true);
      }
    }
  }

  module body() {
    shape();
  }

  module holes() {
    shape(container_wall_thickness);

    translate([-container_width/2,0,0]) {
      // cube([container_width,container_length*2,container_height*3],center=true);
    }
  }

  color("#fff", 0.3) difference() {
    body();
    holes();
  }
}

keystone_width = 14.6;
keystone_length = 16.1;
keystone_depth = 10;

module keystone() {
}

module keystone_retainer() {
  arm_clearance = 3.9;
  hook_catch_length = 2;

  opening_width = keystone_width + 0.25*2;
  opening_length = keystone_length + 0.2*2;
  retainment_opening_length = opening_length+arm_clearance;

  cavity_opening_length = retainment_opening_length + hook_catch_length*2;
  overall_width = opening_width + wall_thickness*2*2;
  overall_length = cavity_opening_length + wall_thickness*2*2;
  overall_height = keystone_depth;

  face_thickness = 2;
  hook_ledge_thickness = 1.4;
  hook_ledge_fine_adjustment = 0.9;

  module body() {
    cube([overall_width,overall_length,overall_height],center=true);
  }

  module holes() {
    translate([0,-overall_length/2+opening_length/2+wall_thickness*2+hook_catch_length,0]) {
      cube([opening_width,opening_length,overall_height*2],center=true);
    }

    // insertion opening
    translate([0,0,overall_height/2]) {
      cube([opening_width,retainment_opening_length,overall_height],center=true);
    }
    // cavity that creates ledges
    hull() {
      translate([0,0,overall_height/2-hook_ledge_thickness*2-hook_ledge_fine_adjustment]) {
        cube([opening_width,retainment_opening_length,hook_ledge_thickness*4],center=true);
        translate([0,0,0]) {
          cube([opening_width,cavity_opening_length,hook_ledge_thickness*2],center=true);
        }
      }

      // let keystone tilt in
      translate([0,-overall_length/2+opening_length*0.75+wall_thickness*2+hook_catch_length,-overall_height/2+1]) {
        cube([opening_width,opening_length/2,2],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}


module raspi_mount() {
  extra_room_below_pi = mount_thickness+bevel_height/2;
  height = rasp_a_plus_max_y + extra_room_below_pi + bevel_height/4;;
  length = rasp_a_plus_max_x + bevel_height/2 + mount_thickness;
  bottom_width = 1*inch;
  hole_diam = 2.4;
  hole_depth = bevel_height+mount_thickness-extrude_width*2;

  module position_buck_converter() {
    translate([right*(bevel_height+mount_thickness/2),rear*(length/2-buck_conv_width/2-mount_thickness/2-bevel_height),rasp_a_plus_max_y/2+mount_thickness+bevel_height]) {
      rotate([0,90,0]) {
        rotate([0,0,90]) {
          children();
        }
      }
    }
  }

  module position_pi() {
    translate([left*(bevel_height+mount_thickness/2),-rasp_a_plus_max_x/2,rasp_a_plus_max_y+extra_room_below_pi]) {
      rotate([0,0,90]) {
        rotate([-90,0,0]) {
          children();
        }
      }
    }
  }

  module position_mounting_holes() {
    for(y=[front,rear]) {
      translate([bottom_width/2,y*20,0]) {
        children();
      }
    }
  }

  position_csi_extension() {
    // csi_extension_board();
  }

  position_keystone_retainer() {
    //keystone_retainer();
  }

  module body() {
    translate([0,0,height/2]) {
      rounded_cube(mount_thickness,length,height,mount_thickness,resolution);
    }

    hull() {
      translate([-mount_thickness/2+bottom_width/2,0,mount_thickness/2]) {
        rounded_cube(bottom_width,length,mount_thickness,mount_thickness,resolution);
      }
      translate([left*(18-rounded_diam/2),0,mount_thickness/2]) {
        hole(rounded_diam,mount_thickness,resolution);
      }
    }

    hull() {
      translate([0,rear*(length/2-mount_thickness-buck_conv_width-bevel_height*2),0]) {
        translate([0,0,height-1]) {
          hole(mount_thickness,2,resolution);
        }
        translate([-mount_thickness/2+bottom_width/2,0,mount_thickness/2]) {
          rounded_cube(bottom_width,mount_thickness,mount_thickness,mount_thickness,resolution);
        }
      }
    }

    position_buck_converter() {
      % buck_converter();
      position_buck_converter_holes() {
        bevel(rounded_diam,m3_thread_into_plastic_hole_diam+wall_thickness*2,bevel_height);
      }
    }

    position_pi() {
      % raspi();
      position_pi_holes() {
        bevel(rounded_diam,m3_thread_into_plastic_hole_diam+wall_thickness*2,bevel_height);
      }
    }

    position_mounting_holes() {
      translate([0,0,mount_thickness+bevel_height]) {
        inner_diam = m5_thread_into_plastic_hole_diam+extrude_width*4;
        bevel(inner_diam+bevel_height*2,inner_diam,bevel_height);
      }
    }
  }

  module holes() {
    position_pi() {
      position_pi_holes() {
        hole(hole_diam,2*(hole_depth),8);
      }
    }

    position_buck_converter() {
      position_buck_converter_holes() {
        hole(hole_diam,2*(hole_depth),8);
      }
    }

    position_mounting_holes() {
      hole(m5_thread_into_plastic_hole_diam,4*hole_depth,16);
    }
  }

  difference() {
    body();
    holes();
  }
}

// for 433mhz and rpi relays
module relay_mount() {
  height = max(wireless_relay_hole_spacing_depth,four_relay_hole_spacing_depth) + rounded_diam + mount_thickness + bevel_height/2;
  length = max(wireless_relay_hole_spacing_width,four_relay_hole_spacing_width) + rounded_diam + mount_thickness*2;
  bottom_width = 34;
  hole_diam = 2.4;
  hole_depth = bevel_height+mount_thickness-extrude_width*2;

  // make room for excess leads below board
  high_bevel_height = 3.2;

  module position_four_relay() {
    translate([left*(bevel_height+mount_thickness/2),-mount_thickness/2-bevel_height/4,height-four_relay_board_depth/2-bevel_height/2-0.2]) {
      rotate([0,0,-90]) {
        rotate([90,0,0]) {
          children();
        }
      }
    }
  }

  module position_wireless_relay() {
    translate([right*(high_bevel_height+mount_thickness/2),-mount_thickness/2-bevel_height/2,height-wireless_relay_board_depth/2-high_bevel_height/2-0.2]) {
      rotate([0,0,90]) {
        rotate([90,0,0]) {
          children();
        }
      }
    }
  }

  module position_transmitter_holes() {
    transmitter_hole_spacing=16;
    for(x=[left,right]) {
      translate([bottom_width/2+x*transmitter_hole_spacing/2,length/2+bevel_height,12]) {
        rotate([-90,0,0]) {
          children();
        }
      }
    }
  }

  module position_mounting_holes() {
    for(y=[front,rear]) {
      translate([bottom_width/2,y*20,0]) {
        children();
      }
    }
  }

  module body() {
    translate([0,0,height/2]) {
      rounded_cube(mount_thickness,length,height,mount_thickness,resolution);
    }

    hull() {
      translate([-mount_thickness/2+bottom_width/2,0,mount_thickness/2]) {
        rounded_cube(bottom_width,length,mount_thickness,mount_thickness,resolution);
      }
      translate([left*(18-rounded_diam/2),0,mount_thickness/2]) {
        hole(rounded_diam,mount_thickness,resolution);
      }
    }

    hull() {
      translate([0,length/2-mount_thickness/2,0]) {
        translate([0,0,height-1]) {
          hole(mount_thickness,2,resolution);
        }
        transmitter_side_height = 16;
        translate([-mount_thickness/2+bottom_width/2,0,transmitter_side_height/2]) {
          rounded_cube(bottom_width,mount_thickness,transmitter_side_height,mount_thickness,resolution);
        }
      }
      translate([-mount_thickness/2+bottom_width/2,length/2-mount_thickness/2,height/2]) {
        // rounded_cube(bottom_width,mount_thickness,height,mount_thickness,resolution);
      }
    }

    position_four_relay() {
      position_four_relay_holes() {
        bevel(rounded_diam,m3_thread_into_plastic_hole_diam+wall_thickness*2,bevel_height);
      }
      % four_relay();
    }

    position_wireless_relay() {
      position_wireless_relay_holes() {
        bevel(m3_thread_into_plastic_hole_diam+high_bevel_height*2,m3_thread_into_plastic_hole_diam+wall_thickness*2,high_bevel_height);
      }
      % wireless_relay();
    }

    position_transmitter_holes() {
      bevel(rounded_diam,m3_thread_into_plastic_hole_diam+wall_thickness*2,bevel_height);
    }

    position_mounting_holes() {
      translate([0,0,mount_thickness+bevel_height]) {
        inner_diam = m5_thread_into_plastic_hole_diam+extrude_width*4;
        bevel(inner_diam+bevel_height*2,inner_diam,bevel_height);
      }
    }
  }

  module holes() {
    position_four_relay() {
      position_four_relay_holes() {
        hole(hole_diam,2*(hole_depth),8);
      }
    }

    position_wireless_relay() {
      position_wireless_relay_holes() {
        hole(hole_diam,2*(hole_depth),8);
      }
    }

    position_transmitter_holes() {
      hole(hole_diam,2*hole_depth,8);
    }

    position_mounting_holes() {
      //hole(m3_thread_into_plastic_hole_diam,4*hole_depth,16);
      hole(m5_thread_into_plastic_hole_diam,4*hole_depth,16);
    }
  }

  difference() {
    body();
    holes();
  }
}

module connector_mount() {
  module position_keystone_retainer() {
    translate([0,0,keystone_depth/2]) {
      children();
    }
  }

  module position_csi_extension() {
    translate([left*(bevel_height+mount_thickness/2),-rasp_b_plus_max_x/2+csi_extension_board_width/2,csi_extension_board_length/2]) {
      rotate([0,-90,0]) {
        rotate([0,0,-90]) {
          children();
        }
      }
    }
  }

  position_csi_extension() {
    // csi_extension_board();
  }

  position_keystone_retainer() {
    keystone_retainer();
  }
}

camera_bundle_width = 26;
//camera_bundle_length = 33;
camera_bundle_length = 69;
camera_front_depth = 7;

camera_hole_width = 10;
camera_hole_length = 10;
camera_hole_from_bottom = 11+camera_hole_length/2;

camera_case_width = camera_bundle_width+wall_thickness*2;
camera_case_length = camera_bundle_length+wall_thickness*2;

camera_case_screw_head_diam = 4.5;
camera_case_screw_diam = 2.4;

module position_phono_jack() {
  position_hdmi_adapter() {
    translate([0,-hdmi_pcb_length/2+8.25,0]) {
      children();
    }
  }
}

// hdmi connector
hdmi_pcb_length = 28;
hdmi_pcb_recess_depth = 3;
hdmi_socket_width = 15.5;
hdmi_socket_length = 12.5;
csi_connector_length = 11;
module position_hdmi_adapter() {
  translate([0,camera_bundle_length/2-hdmi_pcb_length/2,0]) {
    children();
  }
}

module position_camera_case_screw_holes() {
  for(x=[left,right],y=[front,rear]) {
    mirror([x-1,0,0]) {
      translate([camera_case_width/2+camera_case_screw_diam/2,y*camera_case_length*0.25,0]) {
        children();
      }
    }
  }
}

module rpi_hdmi_camera_bundle_base_case(height,screw_hole_diam) {
  module rpi_hdmi_camera_bundle_case_screw_side() {
    diam = screw_hole_diam+wall_thickness*2;
    hull() {
      translate([0,0,0]) {
        accurate_circle(diam,resolution);

        translate([left*diam/4,0,0]) {
          square([diam/2,diam],center=true);
        }
      }
    }

    for(y=[front,rear]) {
      mirror([0,y-1,0]) {
        translate([left*(camera_case_screw_diam/2),diam/2,0]) {
          round_corner_filler_profile(diam/2,resolution);
        }
      }
    }
  }

  linear_extrude(height=height,convexity=2,center=true) {
    rounded_square(camera_case_width,camera_case_length,wall_thickness*2);

    position_camera_case_screw_holes() {
      rpi_hdmi_camera_bundle_case_screw_side();
    }
  }
}

module rpi_hdmi_camera_bundle_case_front() {
  face_thickness = extrude_height*4;
  depth = camera_front_depth+face_thickness;
  extra_rim = 3;

  module body() {
    translate([0,0,(depth+extra_rim)/2]) {
      rpi_hdmi_camera_bundle_base_case(depth+extra_rim,camera_case_screw_diam);
    }
  }

  module holes() {
    // rounded_cube(camera_bundle_width,camera_bundle_length,camera_front_depth*2,0.4);

    translate([0,-camera_bundle_length/2+camera_hole_from_bottom,0]) {
      // cube([camera_hole_width,camera_hole_length,camera_front_depth*4],center=true);
    }

    camera_round_diam = 8;
    camera_square_side = 9;
    camera_square_height_above_pcb = 4;
    pcb_thickness = 2;
    ribbon_width = camera_bundle_width-4;
    ribbon_cut_depth = 4.5;
    ribbon_cavity_length = camera_bundle_length*0.75;

    translate([0,-camera_bundle_length/2+ribbon_cavity_length/2,depth]) {
      rounded_cube(ribbon_width,ribbon_cavity_length,ribbon_cut_depth*2,3);
    }

    // camera part
    translate([0,-camera_case_length/2+33/2,0]) {
      hole(camera_round_diam,depth*3,resolution);
      translate([0,0,depth+face_thickness]) {
        // cube([camera_square_side,camera_square_side,depth],center=true);

        translate([0,-24.5/2+14,0]) {
          rounded_cube(camera_bundle_width,24.5,depth,3);
          pcb_rim_rest = 2;
          pcb_rim_depth = 2;
          rounded_cube(camera_bundle_width-pcb_rim_rest,24.5-pcb_rim_rest,depth*2,3);
        }
      }
    }

    translate([0,0,depth]) {
      position_hdmi_adapter() {
        cube([camera_bundle_width,hdmi_pcb_length,hdmi_pcb_recess_depth*2],center=true);

        translate([0,hdmi_pcb_length/2,0]) {
          cube([hdmi_socket_width,hdmi_socket_length*2,depth*3],center=true);
        }

        translate([0,-hdmi_pcb_length/2+3+csi_connector_length/2,0]) {
          rounded_cube(camera_bundle_width,csi_connector_length,camera_front_depth*2,3);
        }
      }
    }

    position_camera_case_screw_holes() {
      translate([0,0,depth]) {
        hole(camera_case_screw_diam,2*(depth-0.8),16);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module rpi_hdmi_camera_bundle_case_back() {
  depth = 2;

  ball_past_centerline = 2.8;
  ball_res = 72;
  ball_inner_diam = 11.8;
  ball_outer_diam = ball_inner_diam+wall_thickness*2;
  ball_split_width = 2;
  module position_ball() {
    translate([0,camera_case_length*0.21,depth+ball_inner_diam/2]) {
      children();
    }
  }

  module body() {
    translate([0,0,depth/2]) {
      rpi_hdmi_camera_bundle_base_case(depth,camera_case_screw_diam+0.5);
    }

    hull() {
      position_ball() {
        sphere($fn=ball_res, r=accurate_diam(ball_outer_diam,ball_res));

        translate([0,0,-ball_inner_diam/2-0.2]) {
          hole(ball_outer_diam*1.2,0.1,ball_res);
        }
      }
    }
  }

  module holes() {
    position_camera_case_screw_holes() {
      hole(camera_case_screw_diam+0.5,depth*3,16);
    }
    position_ball() {
      sphere($fn=ball_res, r=accurate_diam(ball_inner_diam,ball_res));
      // trim top
      translate([0,0,ball_outer_diam/2+ball_past_centerline]) {
        cube([ball_outer_diam,ball_outer_diam,ball_outer_diam],center=true);
      }

      // split for easier insertion
      cube([ball_split_width,ball_outer_diam*2,ball_inner_diam],center=true);
    }

    position_phono_jack() {
      phono_jack_allowance = 1;
      cube([camera_bundle_width-extrude_width*2,10,2*(depth-phono_jack_allowance)],center=true);
    }
  }

  difference() {
    body();
    holes();
  }
}

module rpi_hdmi_csi_adapter_mount_retainer() {
  hole_diam = 2.5;
  diam = hole_diam+extrude_width*8;
  echo("diam: ", diam);
  // diam = 6; // ~roughly the HDMI port height

  thickness = 2;

  module body() {
    hull() {
     for(x=[left,right]) {
       translate([x*csi_extension_hole_spacing_width/2,0,0]) {
         hole(diam,thickness,resolution);
       }
     }
    }
  }

  module holes() {
   for(x=[left,right]) {
     translate([x*csi_extension_hole_spacing_width/2,0,0]) {
       hole(hole_diam,thickness*2,resolution);
     }
   }
  }

  difference() {
    body();
    holes();
  }
}

base_thickness = 5;
base_lip_thickness = 2.6;
base_lip_width = 6;
base_lip_diam = 33 + base_lip_width*2;

module rpi_hdmi_csi_adapter_mount_ring_profile() {
  resolution = 128;

  module body() {
    accurate_circle(base_lip_diam,resolution);
  }

  module holes() {
    cuts = 10;
    cut_diam = base_lip_width/2;
    deg = 360/cuts;
    for(r=[0:cuts]) {
      rotate([0,0,r*deg]) {
        translate([base_lip_diam/2,0,0]) {
          scale([1,3,1]) {
            accurate_circle(cut_diam,resolution);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module rpi_hdmi_csi_adapter_mount_ring() {
  //thread_profile = "M33x2"; // 3 turns
  thread_profile = "8-UN-1 3/8"; // 2 turns

  resolution = 128;
  height = 9;

  module body() {
    nut(thread_profile, turns=2, Douter=base_lip_diam);
    /*
    translate([0,0,height/2-1.3]) {
      // hole(base_lip_diam,height,resolution);
      linear_extrude(height=height,convexity=2,center=true) {
        rpi_hdmi_csi_adapter_mount_ring_profile();
      }
    }
    */
  }

  module holes() {
    // # tap(thread_profile, turns=2);
    cuts = 10;
    cut_diam = base_lip_width/2;
    deg = 360/cuts;
    for(r=[0:cuts]) {
      rotate([0,0,r*deg]) {
        translate([base_lip_diam/2,0,0]) {
          scale([1,3,1]) {
            hole(cut_diam,height*2,resolution);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module rpi_hdmi_csi_adapter_mount() {
  board_length = 28;
  board_width = 25.8;
  board_thickness = 2.6;

  //mount_diam = 34; // use a 1-3/8 forstner bit
  //thread_profile = "M33x2-ext";
  //thread_profile = "UNC-1 3/8-ext";
  thread_profile = "8-UN-1 3/8-ext";
  //thread_profile = "UNEF-1 3/8-ext";
  specs = thread_specs(thread_profile);
  mount_diam = specs[2];
  // mount_diam = 30; // use a 1-1/4 forstner bit

  hdmi_connector_width = 15.4;
  hdmi_connector_length = 12.4;
  hdmi_connector_height = 6.5;
  hdmi_connector_overhang = 1.2;

  phono_width = 8;
  photo_from_end = 5.1;

  board_cavity_depth = hdmi_connector_length-hdmi_connector_overhang;
  board_retainer_lip = extrude_height*5;
  overall_height = board_cavity_depth+board_retainer_lip;

  thread_pitch = specs[0];
  thread_turns = floor((overall_height-base_lip_thickness) / thread_pitch) - 1;

  echo("thread_turns: ", thread_turns);

  resolution = 128;

  module position_csi_extension() {
    translate([0,0,board_length/2+extrude_height*5]) {
      rotate([90,0,0]) {
        translate([0,0,-board_thickness/2]) {
          children();
        }
      }
    }
  }

  module position_screw_holes() {
  }

  module body() {
    translate([0,0,thread_pitch/2+base_lip_thickness]) {
      thread(thread_profile, turns=thread_turns);
      //bolt("M33x2", turns=thread_turns, higbee_arc=30);
      //bolt("UNC-1 3/8", turns=thread_turns, higbee_arc=30);
    }
    translate([0,0,overall_height/2]) {
      hole(mount_diam,overall_height,resolution);
    }
    translate([0,0,base_lip_thickness/2]) {
      // hole(base_lip_diam,base_lip_thickness,resolution);
      linear_extrude(height=base_lip_thickness,convexity=2,center=true) {
        rpi_hdmi_csi_adapter_mount_ring_profile();
      }
    }

    translate([0,0,overall_height/2-thread_pitch/2+0.25]) {
    //translate([base_lip_diam*1.1,0,0]) {
      % rpi_hdmi_csi_adapter_mount_ring();
    }

    translate([0,-hdmi_connector_height/2-board_thickness/2,overall_height+2]) {
      % rpi_hdmi_csi_adapter_mount_retainer();
    }
  }

  module holes() {
    position_csi_extension() {
      translate([0,0,0.2]) {
        % csi_extension_board();
      }

      translate([0,0,board_thickness/2]) {
        cube([board_width,board_length,board_thickness],center=true);
      }

      translate([0,-board_length/2+hdmi_connector_length-hdmi_connector_overhang,board_thickness+hdmi_connector_height/2]) {
        cube([hdmi_connector_width,hdmi_connector_length*2,hdmi_connector_height],center=true);

        for(x=[left,right]) {
          translate([x*csi_extension_hole_spacing_width/2,0,0]) {
            rotate([90,0,0]) {
              hole(1.9,20,8);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module rpi_hdmi_camera_bundle_case() {
  translate([0,0,0]) {
    rpi_hdmi_camera_bundle_case_front();
  }
  translate([0,0,-1]) {
    //rpi_hdmi_camera_bundle_case_back();
  }
}

translate([1.5*inch,0,0]) {
  raspi_mount();
}

translate([-1.5*inch,0,0]) {
  relay_mount();
}
