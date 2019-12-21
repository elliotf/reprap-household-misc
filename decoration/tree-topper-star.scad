include <../../lib/util.scad>;

resolution = 64;
extrusion_width = 0.55;
wall_thickness = extrusion_width*2;

module star(points) {
  body_diam = 2.5*inch;
  arm_length = 3*inch;
  arm_point_diam = 4;
  arm_base_bottom_pct_width = 0.6;
  height = 1/2*inch;
  peak_height = height*2.5;
  peak_diam = body_diam * 0.001;

  light_diam = 5;

  arm_deg = 360/points;
  arm_base_width = 2*(tan(arm_deg/2)*body_diam/2);

  tree_top_diam = 3/4*inch;
  tree_mount_outer_diam = tree_top_diam + wall_thickness*4;
  tree_mount_length = body_diam/2+arm_length/2;

  // Even-legged stars just look weird, and the star of david should probably
  // have a point up, but I am allowed to ignore YAGNI when I'm not working.
  // Okay, fine. This is YAGNI and it also does weird things.
  body_rotate = 0; // (points % 2 || points == 6) ? 0 : arm_deg/2;

  module body() {
    rotate([0,0,body_rotate]) {
      translate([0,0,height/2]) {
        rotate([0,0,90+arm_deg/2]) {
          hole(body_diam,height,points);
        }
      }

      for(i=[0:points-1]) {
        rotate([0,0,i*arm_deg]) {
          hull() {
            translate([0,0,peak_height/2]) {
              cube([peak_diam,peak_diam,peak_height],center=true);
              //hole(peak_diam,peak_height,resolution);
            }

            translate([0,body_diam/2,height/2]) {
              translate([0,arm_length,0]) {
                hole(arm_point_diam,height,resolution/2);
              }
              translate([0,-1,0]) {
                translate([0,0,height/2-1]) {
                  cube([arm_base_width,2,2],center=true);
                }
                translate([0,0,-height/2+1]) {
                  cube([arm_base_width*arm_base_bottom_pct_width,2,2],center=true);
                }
              }
            }
          }
        }
      }
    }

    // tree mount
    hull() {
      translate([0,-tree_mount_length/2,0]) {
        translate([0,0,tree_mount_outer_diam/2]) {
          cube([tree_mount_outer_diam*0.5,tree_mount_length,tree_mount_outer_diam],center=true);
          rotate([90,0,0]) {
            hole(tree_mount_outer_diam,tree_mount_length,resolution);
          }
        }
      }
    }
  }

  module holes() {
    for(i=[0:points-1]) {
      rotate([0,0,i*arm_deg]) {
        translate([0,body_diam/2,0]) {
          hole(light_diam,height*2,8);

          translate([0,arm_length/2,0]) {
            hole(light_diam,height*2,8);
          }
        }
      }
    }

    translate([0,-tree_mount_length,tree_mount_outer_diam/2]) {
      intersection() {
        cube([tree_top_diam*2,tree_mount_length*2.5,tree_top_diam*0.9],center=true);
        rotate([90,0,0]) {
          hole(tree_top_diam,tree_mount_length*2,resolution);
        }
      }
    }

    // hollow out the center
    top_bottom_thickness = 0.28*4;
    rotate([0,0,90+body_rotate]) {
      hull() {
        translate([0,0,height/2]) {
          hole(body_diam*0.5,height-top_bottom_thickness*2,points);
        }
        translate([0,0,peak_height-top_bottom_thickness-1]) {
          cube([peak_diam,peak_diam,2],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

star(7);
