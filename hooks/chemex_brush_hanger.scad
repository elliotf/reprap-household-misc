left = -1;
right = 1;
top = -1;
bottom = 1;

resolution = 64;

// something that I designed in ~2016 to hang a chemex brush over the sink
// as a place to keep it and let it drip dry. I can no longer find the brush
// for sale, and the hook is dependent upon some of the brush handle's geometry

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
}

// end boilerplate

module chemex_brush_hook() {
  bristle_diam   = 85;
  handle_max     = 28;
  handle_min     = 16.5;
  handle_med     = 20;
  height         = 60;

  narrow_diam    = handle_min;
  wall_thickness = 4;
  hole_diam      = narrow_diam + 1;
  body_diam      = hole_diam + wall_thickness*2;
  dist_from_wall = bristle_diam/2 + 10;
  anchor_depth   = dist_from_wall - body_diam/2 + wall_thickness/2;

  cut_width      = narrow_diam + wall_thickness;
  echo("cut_width: ", cut_width);
  echo("hypoten: ", (hole_diam/2+wall_thickness/2));
  opening_angle  = floor(asin((cut_width/2)/(hole_diam/2+wall_thickness/2)));
  echo("opening_angle: ", opening_angle);

  module ring_profile(wall_thickness) {
    hull() {
      for(side=[top,bottom]) {
        translate([0,side*(height/2-wall_thickness)]) {
          scale([1,2.1]) {
            circle(r=accurate_diam(wall_thickness,resolution),$fn=resolution,center=true);
          }
        }
      }
    }
  }

  module body() {
    // main clip
    difference() {
      rotate_extrude(convexity=10,$fn=resolution*2) {
        translate([hole_diam/2+wall_thickness/2,0]) {
          ring_profile(wall_thickness);
        }
      }
      hull() {
        for(side=[left,right]) {
          rotate([0,0,side*opening_angle]) {
            translate([side*-1,-hole_diam/2,0]) {
              cube([2,hole_diam,height+1],center=true);
            }
          }
        }
        translate([0,-body_diam/2,0]) {
          cube([body_diam/2,1,height+1],center=true);
        }
      }
    }

    // round the clip opening
    for(side=[left,right]) {
      rotate([0,0,opening_angle*side]) {
        translate([0,-hole_diam/2-wall_thickness/2,0]) {
          rotate_extrude(convexity=10,$fn=resolution) {
            difference() {
              ring_profile(wall_thickness);

              translate([-wall_thickness/2,0]) {
                square([wall_thickness,height*2],center=true);
              }
            }
          }
        }
      }
    }

    // connection to wall
    translate([0,hole_diam/2+wall_thickness/2+anchor_depth/2,0]) {
      rotate([90,0,0]) {
        linear_extrude(anchor_depth,center=true) {
          ring_profile(wall_thickness);
        }
      }
    }

    // wall plate
    translate([0,dist_from_wall-wall_thickness/2,0]) {
      linear_extrude(height,center=true) {
        hull() {
          square([0.1,wall_thickness],center=true);
          translate([hole_diam,0,0]) {
            circle(r=accurate_diam(wall_thickness,resolution),$fn=resolution,center=true);
          }
        }
      }
    }
  }

  module holes() {
    translate([0,-hole_diam/2,0]) {
      % cube([narrow_diam,hole_diam,height+1],center=true);
    }
    for(side=[top,bottom]) {
      translate([0,0,side*(height/2+1)]) {
        cube([100,dist_from_wall*4,2],center=true);
      }

      translate([hole_diam*0.6,dist_from_wall,side*height*.3]) {
        rotate([90,0,0]) {
          # hole(4,wall_thickness*3,resolution);
        }
      }
    }
  }

  module bridges() {
  }

  difference() {
    body();
    holes();
  }
  bridges();
}

chemex_brush_hook();
