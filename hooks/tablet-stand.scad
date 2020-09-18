include <../../lib/util.scad>;

// time openscad-nightly -m make -o tablet-stand.stl tablet-stand.scad && notify-send 'openscad rendering finished'

extrude_width = 0.4;
extrude_height = 0.2;

resolution = 128;

tablet_length_with_case = 250;
tablet_width_with_case = 178;
tablet_thickness_with_case = 14;

extra_tablet_room = 4;
tablet_cavity_thickness = tablet_thickness_with_case + extra_tablet_room;

case_rounded_diam = tablet_thickness_with_case*0.5;

angle = 25;

ring_thickness = extrude_width*4*2;
rounded_diam = ring_thickness;

base_width = 160;
top_width = 80;
lip_width = 10;
base_thickness = 8;
front_lip_height = 10;
front_lip_length = 20;

module tablet() {
  hull() {
    for(x=[left,right],y=[front,rear],z=[top,bottom]) {
      translate([x*(tablet_length_with_case/2-case_rounded_diam/2),y*(tablet_width_with_case/2-case_rounded_diam/2),z*(tablet_thickness_with_case/2-case_rounded_diam/2)]) {
        sphere(r=case_rounded_diam/2,$fn=32);
      }
    }
  }
}

module position_tablet() {
  translate([0,0,tablet_cavity_thickness/2+base_thickness]) {
    rotate([90-angle,0,0]) {
      translate([0,tablet_width_with_case/2-tablet_thickness_with_case/2,0]) {
        children();
      }
    }
  }
}

position_tablet() {
  % tablet();
}

module stand() {
  module base_profile(diam,lip_length) {
    module body() {
      hull() {
        intersection() {
          accurate_circle(diam,resolution);
          translate([0,diam/2,0]) {
            square([diam*2,diam],center=true);
          }
        }
        translate([0,-lip_length+rounded_diam/2,0]) {
          rounded_square(diam,rounded_diam,rounded_diam,resolution/4);
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

  module tablet_cavity() {
    translate([160,0,0]) {
      % profile();
    }

    module profile() {
      module position_reverse_angle() {
        translate([tablet_cavity_thickness/2-case_rounded_diam/2,-tablet_width_with_case/2+case_rounded_diam/2,0]) {
          rotate([0,0,-angle]) {
            translate([case_rounded_diam/2,0,0]) {
              children();
            }
          }
        }
      }

      module body() {
        hull() {
          rounded_square(tablet_cavity_thickness,tablet_width_with_case,case_rounded_diam,resolution/4);

          position_reverse_angle() {
            translate([-case_rounded_diam/2,tablet_width_with_case/2,0]) {
              square([case_rounded_diam,tablet_width_with_case],center=true);
            }
          }
        }

        position_reverse_angle() {
          translate([0,front_lip_height,0]) {
            rotate([0,0,-90]) {
              round_corner_filler_profile(case_rounded_diam);
            }
            translate([30,tablet_width_with_case/2,0]) {
              square([60,tablet_width_with_case],center=true);
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
    rotate([00,0,0]) {
      rotate([0,-90,0]) {
        linear_extrude(height=tablet_length_with_case,center=true,convexity=3) {
          profile();
        }
      }
    }
  }

  module position_top() {
    translate([0,0,base_width/2]) {
      children();
    }
  }

  module body() {
    translate([0,0,base_thickness/2]) {
      hull() {
        linear_extrude(height=base_thickness,center=true,convexity=2) {
          base_profile(base_width,front_lip_length);
        }
        position_top() {
          translate([0,0,0]) {
            linear_extrude(height=0.05,center=true,convexity=2) {
              base_profile(top_width,front_lip_length);
            }
          }
        }
      }
    }
  }

  module holes() {
    translate([0,0,base_thickness]) {
      hull() {
        linear_extrude(height=0.05,center=true,convexity=2) {
          base_profile(base_width-ring_thickness,front_lip_length-ring_thickness/2);
        }
        linear_extrude(height=base_thickness*2+0.1+2,center=true,convexity=2) {
          base_profile(base_width-ring_thickness-base_thickness*2,front_lip_length-ring_thickness/2-base_thickness);
        }
        position_top() {
          translate([0,0,-1]) {
            linear_extrude(height=0.05,center=true,convexity=2) {
              base_profile(top_width-ring_thickness*2,front_lip_length-ring_thickness/2);
            }
          }
        }
      }
    }
    linear_extrude(height=base_thickness,center=true,convexity=2) {
      trim_inside = 2;
      base_profile(base_width-ring_thickness-base_thickness*2+trim_inside*2,front_lip_length-ring_thickness/2-base_thickness+trim_inside);
    }

    // trim front lip area
    translate([0,-front_lip_length,base_thickness]) {
      cut_out_width = base_width-front_lip_length*2;
      hull() {
        translate([0,0,front_lip_height+rounded_diam/2]) {
          rotate([90,0,0]) {
            rounded_cube(cut_out_width,10,front_lip_length*2,3);
          }
          translate([0,0,front_lip_height]) {
            cube([cut_out_width+front_lip_length,front_lip_length,1],center=true);
          }
        }
      }
    }

    translate([base_width/2,0,0]) {
      // cube([base_width,base_width*3,base_width*5],center=true);
    }

    position_tablet() {
      tablet_cavity();
    }
  }

  difference() {
    body();
    holes();
  }
}

stand();
