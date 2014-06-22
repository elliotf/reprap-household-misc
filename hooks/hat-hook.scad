left = -1;
right = 1;
top = -1;
bottom = 1;

print_layer_height = 0.2;
resolution = 128;

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
}

module backback_hook() {
  hat_diam   = 150;
  elongation = 1.3;
  //elongation = 1;
  depth      = 60;
  height     = 40;
  width      = 60;

  screw_diam            = 5;
  screw_head_diam       = 10;
  screw_mount_thickness = 10;

  screw_hole_y = hat_diam*.325*elongation;
  rim_depth    = 10;

  module body() {
    scale([1,elongation,1]) {
      intersection() {
        translate([0,-hat_diam/2,0]) {
          rotate([0,90,0]) {
            hull() {
              translate([0,0,depth/2-rim_depth/2])
                hole(hat_diam,rim_depth,resolution);
              translate([0,0,-depth/2+1])
                hole(hat_diam*.85,2,resolution);
            }
          }
        }

        translate([0,-height/2,0]) {
          cube([depth+1,height+.05,width],center=true);
        }
      }
    }
  }

  module holes() {
    translate([0,-hat_diam/2,0]) {
      rotate([0,90,0]) {
        hull() {
          translate([0,0,depth/2-rim_depth/2+0.05])// rotate([0,0,22.5])
            hole(hat_diam*.8,rim_depth,12);

          translate([0,0,-depth/2+screw_mount_thickness+1])// rotate([0,0,22.5])
            hole(hat_diam*.65,2,12);
        }
      }
    }
    /*
    # translate([depth/2,-hat_diam/2,0]) {
      rotate([0,90,0])
        scale([1,elongation,1]) {
          rotate([0,0,11.25])
            sphere(r=hat_diam/3-5,$fn=16);
        }
    }
    */

    // mounting hole
    translate([depth/2,-height/2-screw_head_diam/2,0]) {
      rotate([0,90,0]) {
        rotate([0,0,22.5]) {
          hole(screw_diam,depth*2+1,8);
          hole(screw_head_diam,(depth-screw_mount_thickness)*2,8);
        }
      }
    }

    //cube([hat_diam+1,(screw_hole_y-screw_head_diam*1.5)*2,depth+1],center=true);
  }

  difference() {
    body();
    holes();
  }
}

backback_hook();
