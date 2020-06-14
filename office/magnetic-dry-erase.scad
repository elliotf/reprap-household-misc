include <../../lib/util.scad>;

extrude_width = 0.4;
resolution = 128;

marker_diam = 16.9; // marker appears to have a taper from ~16.9 to ~19mm, so err on the tighter side
marker_len = 90;

magnet_diam = 10.5; // actual is 10
magnet_thickness = 5.5; // actual is 5

wall_thickness = extrude_width*2;

outer_diam = marker_diam+wall_thickness*4;
mount_width = magnet_diam + 2*2;

module main() {
  module profile() {
    module body() {
      hull() {
        accurate_circle(outer_diam,resolution);

        translate([marker_diam/2+magnet_thickness/2,0,0]) {
          rounded_square(magnet_thickness+wall_thickness*2,mount_width,2,resolution);
        }
      }
    }

    module holes() {
      accurate_circle(marker_diam,resolution);

      hull() {
        for(x=[left,right]) {
          rotate([0,0,90+x*15]) {
            translate([x*0.1,marker_diam,0]) {
              square([0.2,marker_diam],center=true);
            }
          }
        }
      }
    }
    
    difference() {
      body();
      holes();
    }
  }

  module body() {
    linear_extrude(convexity=10,height=mount_width,center=true) {
      profile();
    }
  }

  module holes() {
    translate([marker_diam/2,0,0]) {
      rotate([0,90,0]) {
        hole(magnet_diam,magnet_thickness*2,8);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

% translate([0,0,marker_len/2-10]) {
  hole(marker_diam,marker_len,resolution);
}

main();
