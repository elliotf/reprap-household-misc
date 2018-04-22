include <../../lib/util.scad>;

// adapter inner diam
// adapter outer diam
// adapter height above thermos
// thermos neck angle
// num legs
// leg thickness

resolution = 48;
approx_pi  = 3.14159;

module rounded_square(width,depth,diam,fn=resolution) {
  pos_x = width/2-diam/2;
  pos_y = depth/2-diam/2;

  hull() {
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([x*pos_x,y*pos_y,0]) {
          accurate_circle(diam,fn);
        }
      }
    }
  }
}

module rounded_cube(width,depth,height,diam,fn=resolution) {
  linear_extrude(height=height,center=true,convexity=3) {
    rounded_square(width,depth,diam,fn);
  }
}

module pour_over_filter_on_thermos() {
  filter_diam          = 106; // 105 + fudge
  filter_shoulder_height = 6.5;

  thermos_neck_diam    = 72;
  thermos_wide_diam    = 126;
  thermos_shoulder_diam = 17;
  thermos_shoulder_to_top_dist = 77;

  thermos_filter_gap_width = 3;
  filter_cavity_depth = 3;

  platform_inner_diam  = filter_diam - 5*2;
  leg_thickness        = 3/4*inch;
  num_legs             = 6;
  angle_between_legs   = 360/num_legs;

  mount_diam = filter_diam+10*2;
  mount_diam = thermos_wide_diam+10*2;
  overall_height = thermos_shoulder_to_top_dist + filter_shoulder_height + thermos_filter_gap_width + filter_cavity_depth;

  rounded_diam         = 6;

  module cavity_profile() {
    cavity_angle = 50;

    difference() {
      union() {
        translate([platform_inner_diam/4,overall_height/2,0]) {
          square([platform_inner_diam/2,overall_height+1],center=true);
        }
        translate([platform_inner_diam/4+1,overall_height/2,0]) {
          square([platform_inner_diam/2+1,overall_height+1],center=true);
        }
        hull() {
          translate([10,0,0]) {
            square([20,thermos_shoulder_diam],center=true);
          }
          translate([thermos_wide_diam/2-thermos_shoulder_diam/2,0,0]) {
            rotate([0,0,-cavity_angle]) {
              accurate_circle(thermos_shoulder_diam,resolution);

              translate([-thermos_wide_diam/2+thermos_shoulder_diam,0,0]) {
                accurate_circle(thermos_shoulder_diam,resolution);
              }
            }
          }
        }
      }

      // round ledge so it looks nice and sits well on the thermos
      hull() {
        translate([thermos_wide_diam/2-thermos_shoulder_diam/2,0,0]) {
          rotate([0,0,-cavity_angle]) {
            translate([0,thermos_shoulder_diam,0]) {
              accurate_circle(thermos_shoulder_diam,resolution);

              //translate([-21.5,0,0]) {
              translate([-17.5,0,0]) {
                accurate_circle(thermos_shoulder_diam,resolution);

                rotate([0,0,cavity_angle]) {
                  translate([0,overall_height/2+thermos_shoulder_diam,0]) {
                    accurate_circle(thermos_shoulder_diam,resolution);
                  }
                }
              }
            }
          }
        }
      }
    }

    // hold filter somewhat securely
    translate([filter_diam/4+1,overall_height,0]) {
      square([filter_diam/2+2,filter_cavity_depth*2],center=true);
    }
  }

  module body() {
    translate([0,0,overall_height/2]) {
      linear_extrude(height=overall_height,center=true,convexity=3) {
        hull() {
          for(i=[0:num_legs-1]) {
            rotate([0,0,i*angle_between_legs]) {
              translate([0,mount_diam/4,0]) {
                rounded_square(leg_thickness,mount_diam/2,rounded_diam);
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    wall_thickness = mount_diam/2-platform_inner_diam/2;
    overall_circ   = approx_pi*mount_diam;
    hole_width     = (overall_circ/num_legs) - leg_thickness;
    // room for steam/heat to escape
    for(i=[0:num_legs-1]) {
      rotate([0,0,-(i+0.5)*angle_between_legs]) {
        hull() {
          for(side=[left,right]) {
            translate([side*(hole_width/2-rounded_diam),mount_diam/2-wall_thickness/2,10+rounded_diam/2]) {
              rotate([0,0,side*(-angle_between_legs*.5)]) {
                rotate([90,0,0]) {
                  # hole(rounded_diam,wall_thickness*2,resolution/2);
                }
              }
            }
            translate([side*(hole_width/2-rounded_diam),mount_diam/2-wall_thickness/2,overall_height*0.6]) {
              rotate([0,0,side*(-angle_between_legs*.25)]) {
                rotate([90,0,0]) {
                  # hole(rounded_diam,wall_thickness*1.5,resolution/2);
                }
              }
            }
          }
          translate([0,mount_diam/2-wall_thickness/2,overall_height-rounded_diam/2-filter_cavity_depth-5]) {
            rotate([100,0,0]) {
              # hole(rounded_diam,wall_thickness+5,8);
            }
          }
        }
      }
    }

    // make room for thermos
    rotate_extrude(convexity=10,$fn=resolution*2) {
      cavity_profile();
    }
  }

  difference() {
    body();
    holes();
  }

  translate([0,0,overall_height+8]) {
    translate([0,0,20]) {
      // color("lightblue") cavity_profile();
    }
  }
}


color("pink") pour_over_filter_on_thermos();
