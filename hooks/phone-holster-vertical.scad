include <../lib/util.scad>;

// to mount a phone on something vertical

resolution = 64;

phone_width = 82;
phone_thickness = 12;
phone_height = 163;

tolerance = 3;

module phone() {
  rounded_diam = 20;
  rotate([90,0,0]) {
    intersection() {
      cube([phone_width*2,phone_height*2,phone_thickness],center=true);
      hull() {
        for(x=[left,right],y=[front,rear]) {
          translate([x*(phone_width/2-rounded_diam/2),y*(phone_height/2-rounded_diam/2),0]) {
            sphere(r=rounded_diam/2,$fn=32);
          }
        }
      }
    }
  }
}

module phone_holster(width,thickness,height) {
  extrude_width = 0.4;
  wall_thickness = extrude_width*3*2;
  inner_rounded_diam = 10;

  bottom_thickness = 2;

  bottom_cutout_rear_width = 20;
  bottom_cutout_front_width = bottom_cutout_rear_width+thickness*2;

  module body() {
    translate([0,0,height/2-bottom_thickness/2]) {
      rounded_cube(width+wall_thickness*2,thickness+wall_thickness*2,height+bottom_thickness,inner_rounded_diam+wall_thickness*2,resolution);
    }
  }

  module holes() {
    translate([0,0,height]) {
      rounded_cube(width,thickness,height*2,inner_rounded_diam,resolution);
    }

    translate([0,front*(thickness/2+wall_thickness),0]) {
      linear_extrude(height=height*2+1,center=true,convexity=3) {
        hull() {
          rounded_square(bottom_cutout_rear_width,(thickness+wall_thickness)*2,inner_rounded_diam,resolution);
          translate([0,-wall_thickness,0]) {
            square([bottom_cutout_front_width,wall_thickness*2],center=true);
          }
        }
        for(x=[left,right]) {
          translate([x*0,0,0]) {
            
          }
        }
      }

      rotate([90,0,0]) {
        linear_extrude(height=wall_thickness*3,center=true,convexity=3) {
          translate([0,height,0]) {
            square([bottom_cutout_front_width,height*2],center=true);

            for(x=[left,right]) {
              mirror([x-1,0,0]) {
                translate([bottom_cutout_front_width/2,0,0]) {
                  rotate([0,0,-90]) {
                    round_corner_filler_profile(inner_rounded_diam,resolution);
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  translate([0,0,phone_height/2]) {
    % phone();
  }

  difference() {
    body();
    holes();
  }
}

phone_holster(phone_width+tolerance,phone_thickness+tolerance,phone_height*0.4);
