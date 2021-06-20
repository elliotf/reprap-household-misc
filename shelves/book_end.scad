include <lumpyscad/lib.scad>;

resolution = 64;

extrude_height = 0.2;
extrude_width = 0.5;
wall_thickness = extrude_width*2;

len_under_book = 1.5*inch;
thickness_under_book = extrude_width*2;
len_opposite_book = 2*inch;
height = 4.5*inch;
width = 3*inch;

outer_rounded_diam = 1/4*inch;
inner_rounded_diam = outer_rounded_diam-extrude_width*4;

module bookend_printed_on_side_with_hole() {
  module position_corners() {
    translate([-outer_rounded_diam/2,0,0]) {
      translate([0,outer_rounded_diam/2,0]) {
        children();
      }
      translate([0,height-outer_rounded_diam/2,0]) {
        children();
      }
    }
    translate([-len_opposite_book+outer_rounded_diam/2,outer_rounded_diam/2]) {
      children();
    }
  }

  module body_profile() {
    module body() {
      translate([len_under_book/2-10,thickness_under_book/2]) {
        rounded_square(len_under_book+20,thickness_under_book,thickness_under_book,resolution);
      }
      translate([0,thickness_under_book]) {
        round_corner_filler_profile(4,resolution);
      }
      hull() {
        position_corners() {
          accurate_circle(outer_rounded_diam,resolution);
        }
      }
      translate([-10,10,0]) {
        square([20,20],center=true);
      }
    }

    module holes() {
    }

    difference() {
      body();
      holes();
    }
  }

  module cavity_profile() {
  }

  module body() {
    rotate([90,0,0]) {
      linear_extrude(height=width,center=true,convexity=3) {
        body_profile();
      }
    }
  }

  module holes() {
    module position_center_hole() {
      translate([-len_opposite_book*0.4,height*0.33]) {
        children();
      }
    }
    flat_depth = 10;
    for(y=[front,rear]) {
      mirror([0,y-1,0]) {
        hull() {
          translate([0,-width/2,0]) {
            rotate([90,0,0]) {
              position_corners() {
                hole(inner_rounded_diam,extrude_height,resolution);
              }
              position_center_hole() {
                hole(outer_rounded_diam*3,width-flat_depth*2,resolution);
              }
            }
          }
        }
      }
    }
    rotate([90,0,0]) {
      position_center_hole() {
        hole(outer_rounded_diam*3,width,resolution);
      }
    }
    /*
    rotate([90,0,0]) {
      linear_extrude(height=width,center=true,convexity=3) {
        cavity_profile();
      }
    }
    */

  }

  difference() {
    body();
    holes();
  }
}

module bookend_printed_in_position_minimal_infill() {
  thickness_under_book = 0.6;
  overall_depth = len_under_book + len_opposite_book;

  num_parts = 7;
  outer_diam = (width+wall_thickness*(num_parts-1))/num_parts;
  inner_diam = outer_diam - wall_thickness*2;
  spacing_y = outer_diam - wall_thickness;
  pos_x=[-len_opposite_book+outer_diam/2,-outer_diam/2];
  dist_x = abs(pos_x[0])-abs(pos_x[1]);

  module body_profile() {
    module body() {
      for(y=[0:2:num_parts-1]) {
        translate([pos_x[1],-width/2+outer_diam/2+y*spacing_y,0]) {
          accurate_circle(outer_diam,resolution);
        }
      }
      for(y=[1:2:num_parts-1]) {
        translate([pos_x[0],-width/2+outer_diam/2+y*spacing_y,0]) {
          accurate_circle(outer_diam,resolution);

          for(y=[front,rear]) {
            translate([dist_x/2,y*(outer_diam/2-wall_thickness/2),0]) {
              square([dist_x,wall_thickness],center=true);
            }
          }
        }
      }
      for(y=[front,rear]) {
        translate([pos_x[1]-dist_x/4,y*(width/2-wall_thickness/2),0]) {
          rounded_square(dist_x/2,wall_thickness,wall_thickness,resolution/2);
        }
      }
    }

    module holes() {
      for(y=[0:num_parts-1]) {
        inner_cut = dist_x+inner_diam;
        translate([pos_x[0]+dist_x/2,-width/2+outer_diam/2+y*spacing_y,0]) {
          rounded_square(inner_cut,inner_diam,inner_diam,resolution);
        }
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    translate([0,0,-thickness_under_book/2]) {
      linear_extrude(height=thickness_under_book,center=true,convexity=3) {
        hull() {
          body_profile();

          translate([len_under_book/2,0,0]) {
            rounded_square(len_under_book,width,outer_diam,resolution);
          }

          for(y=[front,rear]) {
            translate([pos_x[0]+dist_x/2,y*(width/2-outer_diam/2),0]) {
              accurate_circle(outer_diam,resolution);
            }
          }
        }
      }
    }

    attach_height = 1*inch;
    dist = attach_height;
    diam = outer_diam-wall_thickness;
    module attach_ramp() {
      translate([dist_x/2+diam/2-dist/2,0,0]) {
        difference() {
          translate([0,0,attach_height/2]) {
            rounded_cube(dist,diam,attach_height,diam,resolution);
          }
          hull() {
            translate([0,0,attach_height+1]) {
              rounded_cube(dist,diam,attach_height,diam,resolution);
            }
            translate([-dist/2+diam/2-0.1,0,1-0.5]) {
              hole(diam,2,resolution);
            }
          }
        }
      }
    }

    color("pink")
    translate([pos_x[0]+dist_x/2,0,0]) {
      for(y=[0:num_parts-1]) {
        translate([0,-width/2+outer_diam/2+y*spacing_y,0]) {
          if (0==(y%2)) {
            attach_ramp();
          } else {
            mirror([1,0,0]) {
              attach_ramp();
            }
          }
        }
      }
    }

    color("lightblue") translate([0,0,height/2]) {
      linear_extrude(height=height,center=true,convexity=3) {
        body_profile();
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

module bookend_printed_in_position_very_simple() {
  len_under_book = 1.5*inch;
  len_opposite_book = 3*inch;
  height = 5*inch;
  width = 3*inch;

  thickness_under_book = 0.8;
  overall_depth = len_under_book + len_opposite_book;

  num_parts = 7;
  outer_diam = (width+wall_thickness*(num_parts-1))/num_parts;
  inner_diam = outer_diam - wall_thickness*2;
  spacing_y = outer_diam - wall_thickness;
  pos_x=[-len_opposite_book+outer_diam/2,-outer_diam/2];
  dist_x = abs(pos_x[0])-abs(pos_x[1]);

  module body_profile() {
    module body() {
      hull() {
        for(y=[front,rear]) {
          translate([-outer_diam/2,y*(width/2-outer_diam/2),0]) {
            accurate_circle(outer_diam,resolution);
          }
        }
        translate([-len_opposite_book+outer_diam/2,0,0]) {
          accurate_circle(outer_diam,resolution);
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

  module body() {
    translate([0,0,-thickness_under_book/2]) {
      linear_extrude(height=thickness_under_book,center=true,convexity=3) {
        hull() {
          body_profile();

          translate([len_under_book/2,0,0]) {
            rounded_square(len_under_book,width,outer_diam,resolution);
          }
        }
      }
    }

    color("lightblue") hull() {
      linear_extrude(height=thickness_under_book,center=true,convexity=3) {
        body_profile();
      }
      for(y=[front,rear]) {
        translate([-outer_diam/2,y*(width*0.2),height-outer_diam/2]) {
          res = resolution;
          sphere(r=accurate_diam(outer_diam,res),$fn=res);
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



//bookend_printed_on_side_with_hole();
//bookend_printed_in_position_minimal_infill();
bookend_printed_in_position_very_simple();
