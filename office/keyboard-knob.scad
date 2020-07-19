// heavily inspired by https://www.thingiverse.com/thing:3977746
// for use with the T18 shaft that came with the keebio sinc :
// https://keeb.io/products/sinc-split-staggered-75-keyboard
//
// Note that the fit is a little too loose.  :(
//
// The knob linked above fit perfectly, but when I reimplemented it in my own way, I changed the size somehow.

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  rotate([0,0,180/sides]) {
    cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
  }
}

module accurate_circle(diam,sides=8) {
  rotate([0,0,180/sides]) {
    circle(r=accurate_diam(diam,sides),$fn=sides);
  }
}

module ef_knob() {
  resolution = 128;
  shaft_height = 19;
  toothed_height = 9;

  height = shaft_height + 0.8;

  shaft_diam = 5.8; // 5.8 was optimal before adding a lip
  base_inner_diam = 8;
  base_height = shaft_height - toothed_height;
  upper_outer_diam = 20;
  base_outer_diam = 22;
  rounded_diam = upper_outer_diam/2;

  tooth_diam = 1;
  tooth_angle = 360/18;
  tooth_off = 3.2;

  num_divots = 7;
  divot_depth = 1;
  divot_diam = 25;
  divot_angle = -9.5;
  divot_interval_deg = 360/num_divots;

  % translate([0,0,shaft_height*2]) {
    translate([upper_outer_diam/2,0,0]) {
      knob_profile();
    }
    translate([-upper_outer_diam/2,0,0]) {
      toothed_profile();
    }
  }

  module toothed_profile() {
    for(a=[0:tooth_angle:360]) {
      rotate([0,0,a]) {
        translate([shaft_diam/2,0,0]) {
          circle(d=tooth_diam, $fn=3);
        }
      }
    }
  }

  module grip_divots() {
    for(a=[0:num_divots-1]) {
      translate([0,0,height-rounded_diam/2]) {
        rotate([0,0,a*divot_interval_deg]) {
          translate([upper_outer_diam/2+divot_diam/2-divot_depth,0,0]) {
            rotate([0,divot_angle,0]) {
              hole(divot_diam, height*2, resolution);
            }
          }
        }
      }
    }
  }

  module knob_profile() {
    module body() {
      hull() {
        translate([upper_outer_diam/2-rounded_diam/2,height-rounded_diam/2,0]) {
          accurate_circle(rounded_diam,resolution);
        }
        translate([1,height/2,0]) {
          square([2,height],center=true);
        }

        translate([base_outer_diam/2-1,1,0]) {
          accurate_circle(2,8);
        }
      }
    }

    module holes() {
      translate([shaft_diam/4,0,0]) {
        square([shaft_diam/2,shaft_height*2],center=true);
      }
      hull() {
        bevel = base_inner_diam - shaft_diam;
        wide_height = base_height - bevel/2;
        translate([base_inner_diam/4,0,0]) {
          square([base_inner_diam/2,wide_height*2],center=true);
        }
        translate([shaft_diam/4,0,0]) {
          square([shaft_diam/2,base_height*2],center=true);
        }
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    rotate_extrude($fn=resolution,convexity=3) {
      knob_profile();
    }
  }

  module holes() {
    linear_extrude(height=shaft_height*2,center=true,convexity=3) {
      toothed_profile();
    }

    grip_divots();
  }

  difference() {
    body();
    holes();
  }
}

ef_knob();
