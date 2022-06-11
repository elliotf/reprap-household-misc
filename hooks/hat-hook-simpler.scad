include <lumpyscad/lib.scad>;

print_layer_height = 0.2;
resolution = 128;

module hat_hook() {
  hat_diam   = 150;
  elongation = 1.3;
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

module simpler_hat_hook() {
  hat_diam   = 100;
  depth      = 1.75*inch;
  height     = 1.5*inch;
  width      = 60;

  sweep_angle = 55;
  extrude_width = 0.5;
  extrude_height = 0.2;
  wall_thickness = extrude_width*2;

  screw_diam            = 5;
  screw_head_diam       = 10;
  screw_mount_thickness = 10;
  screw_hole_y = height/2-wall_thickness*2-wall_thickness*2-screw_head_diam/2;

  module profile() {
    translate([hat_diam/2-wall_thickness,depth/2,0]) {
      square([wall_thickness*2,depth],center=true);
    }
    translate([hat_diam/2-height/2,wall_thickness,0]) {
      square([height,wall_thickness*2],center=true);
    }
    hull() {
      mount_height = screw_mount_thickness+wall_thickness*2;
      // FIXME: make this parametric rather than half-assed guessery
      translate([20.91,mount_height-1,0]) {
        square([1,2],center=true);
      }
      translate([hat_diam/2-wall_thickness*2,mount_height-1,0]) {
        square([1,2],center=true);
      }
      translate([hat_diam/2-height/2,wall_thickness,0]) {
        square([height,wall_thickness*2],center=true);
      }
    }
  }

  module position_screw_hole() {
    translate([0,screw_hole_y,screw_mount_thickness]) {
      children();
    }
  }

  module body() {
    intersection() {
      union() {
        translate([0,-hat_diam/2+height/2,0]) {
          rotate([0,0,90-sweep_angle/2]) {
            rotate_extrude(angle=sweep_angle,convexity=3,$fn=resolution) {
              profile();
            }
          }
        }
      }

      translate([0,0,depth/2]) {
        cube([width,height*2,depth],center=true);
      }
    }

    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        translate([0,-hat_diam/2+height/2,0]) {
          rotate([0,0,sweep_angle/2]) {
            translate([0,hat_diam/2-wall_thickness,depth/2]) {
              hole(wall_thickness*2,depth,resolution);
            }
            translate([0,hat_diam/2-height/2,wall_thickness]) {
              rounded_cube(wall_thickness*2,height,wall_thickness*2,wall_thickness*2,resolution);
            }
          }
          for(i=[1]) {
            rotate([0,0,i*sweep_angle/2]) {
              hull() {
                translate([0,hat_diam/2-wall_thickness,depth/2]) {
                  hole(wall_thickness*2,depth,resolution);
                }
                translate([0,hat_diam/2-height+wall_thickness,wall_thickness]) {
                  hole(wall_thickness*2,wall_thickness*2,resolution);
                }
              }
            }
          }
        }
      }
    }
  }

  module holes() {
    position_screw_hole() {
      hole(screw_diam,100,resolution);
      translate([0,0,50]) {
        hole(screw_head_diam,100,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

//hat_hook();
simpler_hat_hook();
