left = -1;
right = 1;
top = -1;
bottom = 1;

print_layer_height = 0.2;

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
}

module backback_hook() {
  arm_width          = 200;
  arm_thickness      = 20;
  arm_dist_from_wall = 15;

  post_width         = 35;
  post_height        = 50;
  post_depth         = arm_dist_from_wall + arm_thickness;

  screw_diam            = 5;
  screw_head_diam       = 10;
  screw_mount_thickness = 10;
  screw_hole_spacing    = post_height - screw_head_diam*2;

  module body() {
    // mount post
    cube([post_width,post_height,post_depth*2],center=true);

    // arms
    rounded_radius = arm_thickness;
    for (side=[left,right]) {
      hull() {
        translate([(arm_width/2-rounded_radius)*side,post_height/2+5,0]) {
          sphere(r=rounded_radius,$fn=8);
        }

        // arm closer to wall
        translate([(post_width/2)*side,post_height/2-.5,post_depth/2-arm_dist_from_wall/2])
          cube([0.05,1,post_depth],center=true);

        // full distance from wall
        translate([(post_width/2)*side,-post_height/2+.5,arm_dist_from_wall/2])
          cube([0.05,1,arm_dist_from_wall],center=true);
      }
    }
  }

  module holes() {
    // ensure a flat bottom for printing
    translate([0,0,-50])
      cube([arm_width+20,post_height*3,100],center=true);

    // mounting holes
    for (side=[top,bottom]) {
      translate([0,screw_hole_spacing/2*side,0]) {
        hole(screw_diam,post_depth*2+1,16);
        hole(screw_head_diam,(post_depth-screw_mount_thickness)*2,16);
      }
    }
  }

  module bridges() {
    for (side=[top,bottom]) {
      translate([0,screw_hole_spacing/2*side,post_depth-screw_mount_thickness]) {
        cube([screw_head_diam+1,screw_head_diam+1,print_layer_height],center=true);
      }
    }
  }

  difference() {
    body();
    holes();
  }
  bridges();
}

backback_hook();
