include <../../lib/util.scad>;

extrude_width = 0.4;
dowel_diam = 34; // actual is ~34, but leave tolerance
dowel_tolerance = 0.5;
dowel_cavity_diam = dowel_diam+dowel_tolerance;
dowel_lip_height = 2;
cap_thickness = 3/8*inch;
cap_diam = dowel_diam + 1*inch;
resolution = 128;
bevel_height = 3;

overall_thickness = cap_thickness + dowel_lip_height;
dowel_side_diam = dowel_diam + dowel_tolerance + (extrude_width*4*2);

screw_hole_diam = 6;
screw_head_diam = 10;
screw_head_height = 4;

module dowel_endcap() {
  module profile() {
    module body() {
      hull() {
        translate([dowel_side_diam/4,overall_thickness/2,0]) {
          square([dowel_side_diam/2,overall_thickness],center=true);
        }
        translate([cap_diam/2-bevel_height/2,bevel_height,0]) {
          accurate_circle(bevel_height,resolution);
        }
        translate([cap_diam/4,bevel_height/2,0]) {
          square([cap_diam/2-bevel_height*1.5,bevel_height],center=true);
        }
      }
    }

    module holes() {
      translate([dowel_cavity_diam/4,overall_thickness]) {
        square([dowel_cavity_diam/2,dowel_lip_height*2],center=true);
      }
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    rotate_extrude(convexity=10,$fn=resolution*2) {
      profile();
    }
  }

  module holes() {
    hole(screw_head_diam,screw_head_height*2,resolution);

    translate([0,0,screw_head_height+0.2+50]) {
      hole(screw_hole_diam,100,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

% translate([0,0,cap_thickness+34]) {
  hole(dowel_diam,60,resolution);
}

dowel_endcap();
