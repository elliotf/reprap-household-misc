include <lumpyscad/lib.scad>;

resolution = 128;

use <./stand-and-shade.scad>;

debug=1;

module chandelier_shade_for_vase_mode() {
  base_od = 42;
  inset_rim_height = 12;
  inset_rim_od = 42; // ~45mm is outside of steel base
  // inset_rim_od = 54; // transparent plastic base below steel base

  // bulb_cover_height = 90 + 23; // including metal base
  bulb_cover_height = 110; // only covering bulb

  bulb_diam = 60;
  room_for_fingers = 20;
  max_od = bulb_diam + room_for_fingers*2;

  overall_height = bulb_cover_height + inset_rim_height;

  module profile() {
    module body() {
      translate([0,-inset_rim_height+overall_height/2,0]) {
        square([base_od,overall_height],center=true);

      }
      hull() {
        translate([0,bulb_cover_height/2,0]) {
          square([base_od,bulb_cover_height],center=true);
        }
        translate([0,max_od/2,0]) {
          accurate_circle(max_od,resolution);
        }
        translate([0,bulb_cover_height-1,0]) {
          square([max_od,2],center=true);
        }
      }
    }

    module holes() {
      // don't worry about being -x for the 2d->3d projection
      translate([-1000,0,0]) {
        square([2000,2000],center=true);
      }
    }

    difference() {
      intersection() {
        body();
        translate([0,-1000+bulb_cover_height,0]) {
          square([2000,2000],center=true);
        }
      }
      holes();
    }
  }

  module body() {
    rotate_extrude($fn=resolution*3,convexity=5) {
      profile();
    }
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

chandelier_shade_for_vase_mode();

translate([100,0,0]) {
  % bulb_vitamin();
}
