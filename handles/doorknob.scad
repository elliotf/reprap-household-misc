include <../lib/util.scad>;

resolution = 180;

shaft_depth = 34; // actually ~26;
shaft_diam = 9.1;
shaft_side_x = 7.8;
shaft_side_y = 8.3;
plate_hole_inner_diam = 17;
knob_depth_into_plate_hole = 3;
// plate_hole_inner_diam = 26;

m4_head_diam = 8.2;
m4_shaft_diam = 4.4;
m4_nut_height = 3.5;
m4_nut_side = 7.2;

knob_height = 45;
knob_diam = 50;

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
  rounded_diam = knob_diam*0.6;

  num_divots = 7;
  divot_depth = 4;
  divot_diam = 25;
  divot_angle = -9;
  divot_interval_deg = 360/num_divots;
  divot_squish_scale = 1.2;

  set_screw_pos_z = m4_head_diam/2+3;

  % translate([0,0,knob_height+5]) {
    translate([knob_diam/2,0,0]) {
      knob_profile();
    }
  }

  module grip_divots() {
    for(a=[0:num_divots-1]) {
      translate([0,0,knob_height-rounded_diam/2]) {
        rotate([0,0,a*divot_interval_deg]) {
          translate([knob_diam/2+divot_diam/2-divot_depth,0,0]) {
            rotate([0,divot_angle,0]) {
              scale([1,divot_squish_scale,1]) {
                hole(divot_diam, knob_height*2, resolution);
              }
            }
          }
        }
      }
    }
  }

  module knob_profile() {
    module body() {
      hull() {
        translate([knob_diam/2-rounded_diam/2,knob_height-rounded_diam/2,0]) {
          # accurate_circle(rounded_diam,resolution);
        }


        translate([1,knob_height/2,0]) {
          square([2,knob_height],center=true);
        }

        base_diam = knob_diam*1;
        translate([base_diam*0.5-1,1,0]) {
          accurate_circle(2,8);
        }
      }

      translate([plate_hole_inner_diam/4,0,0]) {
        square([plate_hole_inner_diam/2,knob_depth_into_plate_hole*2],center=true);
      }
    }

    module holes() {
      translate([-50,0,0]) {
        square([100,200],center=true);
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
    grip_divots();

    translate([0,0,set_screw_pos_z]) {
      rotate([0,-90,0]) {
        //rotate([0,0,90]) {
          translate([0,0,shaft_side_x/2]) {
          //translate([0,0,shaft_diam/2]) {
            hole(m4_nut_side,m4_nut_height*2,6);
            translate([0,0,m4_nut_height+4+10]) {
              hole(m4_head_diam,2*10,32);
            }
          }
          translate([0,0,knob_diam/2]) {
            hole(m4_shaft_diam,knob_diam,32);
            hole(m4_head_diam,2*10,32);
          }
        //}
      }
      translate([-shaft_diam/2,0,-50]) {
        // cube([m4_nut_height,5,100],center=true);
      }
    }

    cube([shaft_side_x,shaft_side_y,shaft_depth*2],center=true);
    //hole(shaft_diam,shaft_depth*2,16);
  }

  difference() {
    body();
    holes();
  }
}

/*
intersection() {
  ef_knob();
  translate([-knob_diam/2+plate_hole_inner_diam/2,0,-50+15]) {
    rounded_cube(knob_diam,plate_hole_inner_diam,100,plate_hole_inner_diam, resolution);
  }
}
*/

ef_knob();

