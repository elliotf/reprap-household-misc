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
  height     = 50;

  screw_diam            = 5;
  screw_head_diam       = 10;
  screw_mount_thickness = 10;
  screw_hole_spacing    = post_height - screw_head_diam*2;

  screw_hole_y = hat_diam*.325*elongation;
  rim_depth    = 10;

  module body() {
    scale([1,elongation,1]) {
      intersection() {
        hull() {
          translate([0,0,depth/2-rim_depth/2])
            hole(hat_diam,rim_depth,resolution);
          translate([0,0,-depth/2+1])
            hole(hat_diam*.85,2,resolution);
        }

        translate([0,hat_diam*.66,0])
          scale([.5,1,1])
            rotate([0,0,45])
              cube([hat_diam+5,hat_diam+5,depth+5],center=true);
      }
    }
  }

  module holes() {
    scale([1,elongation,1]) {
      translate([0,0,depth/2])
        scale([1,1,.95])
          rotate([0,0,11.25])
            sphere(r=hat_diam/2-5,$fn=16);
    }

    // mounting hole
    translate([0,screw_hole_y+screw_head_diam*.75,0]) {
      hole(screw_diam,depth+1,16);
      hole(screw_head_diam,depth-screw_mount_thickness*2,16);
    }

    cube([hat_diam+1,(screw_hole_y-screw_head_diam*1.5)*2,depth+1],center=true);
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
  //bridges();
}

backback_hook();
