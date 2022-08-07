include <lumpyscad/lib.scad>;

debug=1;

pi = 3.141592;
resolution = 128;

extrude_width = 0.6;
extrude_height = 0.3;

wall_thickness = extrude_width*3;

echo("wall_thickness*2: ", wall_thickness*2);

module bottom_watering_pot(cavity_top_id=8*inch) {
  cavity_height = cavity_top_id;
  cavity_bottom_id = cavity_top_id*0.75;

  cavity_top_od = cavity_top_id + wall_thickness*4;
  cavity_bottom_od = cavity_bottom_id + wall_thickness*4;

  reservoir_height = cavity_top_id*0.2;
  reservoir_rim_width = (cavity_top_id-cavity_bottom_id)/2-wall_thickness*2;
  //reservoir_rim_width = 3/4*inch;

  bottom_thickness = 6;
  bottom_od = cavity_bottom_od+reservoir_rim_width*2+wall_thickness*2;

  angle_ratio = cavity_height/(cavity_top_od/2-cavity_bottom_id/2);

  bottom_circumference = pi*cavity_bottom_id;
  space_between_holes = 1.5*inch;
  num_reservoir_holes = floor(bottom_circumference/space_between_holes);
  angle_between_holes = 360/num_reservoir_holes;

  echo("num_reservoir_holes: ", num_reservoir_holes);

  if (debug) {
    translate([0,0,cavity_height*1.5]) {
      color("lightblue") rim_profile();
      color("lightblue") reservoir_profile();
    }
  }

  echo("angle_ratio: ", angle_ratio);
  module reservoir_profile() {
    module body() {
      min_thickness = extrude_height*8;
      hull() {
        translate([bottom_od/2-1,bottom_thickness/2,0]) {
          square([1,bottom_thickness],center=true);
        }
        translate([5,min_thickness/2,0]) {
          square([0.1,min_thickness],center=true);
        }
      }
      translate([0,min_thickness/2,0]) {
        square([cavity_bottom_id,min_thickness],center=true);
      }

      hull() {
        translate([bottom_od/2-wall_thickness,0,0]) {
          translate([0,0.001,0]) {
            square([wall_thickness*2,0.002],center=true);
          }

          translate([(reservoir_height/angle_ratio)*2,reservoir_height+bottom_thickness-wall_thickness,0]) {
            accurate_circle(wall_thickness*2,resolution);
          }
        }
      }
    }

    module holes() {
      // don't worry about being -x for the 2d->3d projection
      translate([-cavity_top_od,0,0]) {
        square([cavity_top_od*2,cavity_height*2],center=true);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module rim_profile() {
    module body() {
      hull() {
        translate([cavity_bottom_id/2+wall_thickness,0.2,0]) {
          square([wall_thickness*2,0.2],center=true);
        }
        translate([cavity_top_id/2+wall_thickness,bottom_thickness+cavity_height-wall_thickness,0]) {
          accurate_circle(wall_thickness*2,resolution/2);
        }
      }
    }

    module holes() {
      // don't worry about being -x for the 2d->3d projection
      translate([-cavity_top_od,0,0]) {
        square([cavity_top_od*2,cavity_height*2],center=true);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module reservoir_hole() {
    hole_width = 3/8*inch;
    hole_height = reservoir_height*0.2;
    hole_length = wall_thickness*6;

    hull() {
      translate([0,0,extrude_height/2]) {
        cube([hole_width,hole_length,extrude_height],center=true);
      }
      translate([0,0,bottom_thickness+hole_height-hole_width/2]) {
        rotate([90,0,0]) {
          intersection() {
            hole(hole_width,hole_length,8);
            translate([0,hole_width,0]) {
              cube([hole_width*2,hole_width*2,hole_length*2],center=true);
            }
          }
        }
      }
    }
  }

  module body() {
    difference() {
      rotate_extrude($fn=resolution*3,convexity=5) {
        rim_profile();
      }

      for(i=[0:num_reservoir_holes-1]) {
        rotate([0,0,angle_between_holes*i]) {
          translate([0,cavity_bottom_id/2+wall_thickness*2,0]) {
            reservoir_hole();
          }
        }
      }
    }

    rotate_extrude($fn=resolution*3,convexity=5) {
      reservoir_profile();
    }
  }

  module holes() {
    if (debug) {
      translate([0,front*cavity_top_od,0]) {
        cube([cavity_top_od*2,cavity_top_od*2,cavity_height*3],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

bottom_watering_pot(6*inch);
