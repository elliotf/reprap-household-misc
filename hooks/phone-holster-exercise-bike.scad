include <../lib/util.scad>;

resolution = 64;

phone_width = 82;
phone_thickness = 12;
phone_height = 163;
phone_rounded_diam = 20;

phone_screen_width = 70;
phone_screen_height = 152;

tolerance = 2;

bike_mount_diam = 189;
bike_mount_depth = 52;
bike_mount_outer_depth = 32;
bike_mount_smaller_diam = 170;

extrude_width = 0.6;
wall_thickness = extrude_width*2;

rest_height = 15;
rest_width = 169;
rest_below_center = -sqrt(pow(bike_mount_diam/2,2)-pow(rest_width/2,2));

mount_depth = phone_width*0.75;

smallest_printable_gap = 0.1;

echo("rest_below_center: ", rest_below_center);

phone_pos_x = 0;
phone_pos_y = rest_below_center+phone_width/2+tolerance/2+wall_thickness;

usb_connector_width = 20;

module phone(swell=0) {
  rounded_diam = phone_rounded_diam+swell*2;

  rotate([90,0,0]) {
    intersection() {
      cube([phone_width+swell*2,phone_height+swell*2,phone_thickness+swell*2],center=true);
      hull() {
        for(x=[left,right],y=[front,rear]) {
          translate([x*((phone_width+swell*2)/2-rounded_diam/2),y*((phone_height+swell*2)/2-rounded_diam/2),0]) {
            sphere(r=rounded_diam/2,$fn=32);
          }
        }
      }
    }
  }
}

module phone_cavity(swell) {
  intersection() {
    scale([2,1,1]) {
      phone(swell);
    }
    cube([phone_width+swell*2,phone_height*2,phone_height*2],center=true);
  }
}

module bike_part(swell=0) {
  translate([0,0,-bike_mount_depth/2]) {
    hull() {
      hole(bike_mount_diam+swell*2,bike_mount_outer_depth+swell,resolution*8);
      hole(bike_mount_smaller_diam+swell,bike_mount_depth+swell*2,resolution*8);
    }
  }
}

translate([0,rest_below_center,0]) {
  % debug_axes();
}

module phone_holster(width,height) {
  module body() {
    module main_cube() {
      translate([0,rest_below_center+mount_depth/2,0]) {
        cube([bike_mount_diam*2,mount_depth,bike_mount_depth*3],center=true);
      }
    }

    intersection() {
      union() {
        intersection() {
          bike_part(wall_thickness);
          main_cube();
        }
        position_phone() {
          // # phone(tolerance/2+wall_thickness);
          phone_cavity(tolerance/2+wall_thickness);
        }
      }

      main_cube();
    }
  }

  module holes() {
    lip_amount = 10;
    translate([0,phone_pos_y,phone_thickness]) {
      rounded_cube(phone_screen_height,phone_screen_width,phone_thickness,phone_rounded_diam-lip_amount,resolution);
    }

    position_phone() {
      phone_cavity(tolerance/2);

      translate([0,-(phone_thickness/2+tolerance/2),-phone_height/2]) {
        hull() {
          thickness = phone_thickness*2+tolerance*2;
          rounded_cube(usb_connector_width,thickness,phone_height,phone_rounded_diam,resolution);
          translate([phone_width,0,0]) {
            cube([1,thickness,phone_height],center=true);
          }
        }
      }
    }

    bike_part();
    translate([0,0,-bike_mount_depth]) {
      // hole(bike_mount_smaller_diam-8,wall_thickness*4,resolution*8);
      cube([bike_mount_smaller_diam-8,bike_mount_smaller_diam-8,bike_mount_depth],center=true);
    }

    translate([0,phone_pos_y,wall_thickness+40]) {
      // put a slice in the front to make it printable in vase mode
       cube([smallest_printable_gap,phone_width+tolerance,80],center=true);
    }
  }

  module position_phone() {
    translate([0,phone_pos_y,phone_thickness/2+tolerance/2+wall_thickness]) {
      rotate([-90,0,0]) {
        rotate([0,-90,0]) {
          children();
        }
      }
    }
  }

  position_phone() {
    % phone();
  }

  % bike_part();

  difference() {
    body();
    holes();
  }
}

phone_holster(phone_width+tolerance,phone_height*0.4);
