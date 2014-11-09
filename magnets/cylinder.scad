include <common.scad>;

diam = 33;
height = diam+10;
opacity = 0.5;

module circular_prism() {
  sphere_z = height - diam/2;

  module body() {
    color("lightblue", opacity) hull() {
      translate([0,0,sphere_z/2]) {
        cylinder(r=diam/2,h=sphere_z,center=true,$fn=36);
      }

      translate([0,0,sphere_z]) {
        sphere(r=diam/2,$fn=36);
      }
    }
  }

  module holes() {
    magnet_z = magnet_hole_thickness/2+magnet_dist_to_exterior;
    //magnet_z = 0;

    echo("PAUSE AT ", magnet_z + magnet_thickness/2);

    for (i=[0:3]) {
      rotate([0,0,90*i]) {
        translate([diam/4,0,0]) {
          translate([0,0,magnet_z]) {
            hole(magnet_hole_diam,magnet_hole_thickness,16);
          }
          # hole(.1,magnet_z*2,8);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

circular_prism();
