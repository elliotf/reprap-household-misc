top = 1;
bottom = -1;
left = -1;
right = 1;
front = -1;
rear = 1;

clamp_thickness  = 7;
clamp_inner_diam = 32;
clamp_outer_diam = clamp_inner_diam + clamp_thickness;
screw_hole_diam = 3.2;
screw_hole_spacing = 20;
nut_hole_diam = 5.6;
nut_hole_depth = 1;
height_beyond_screws = 10;
clamp_height = screw_hole_spacing + height_beyond_screws*2;
gap_width = 11;
screw_area_depth = nut_hole_diam + 5;
screw_area_thickness = clamp_thickness*2+gap_width;

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
}

module main() {
  module body() {
    hull() {
      hole(clamp_outer_diam, clamp_height, 72*2);

      translate([0,(clamp_outer_diam/2 + screw_area_depth/2 - 1.6) * front,0]) {
        cube([screw_area_thickness,screw_area_depth,clamp_height],center=true);
      }
    }
  }

  module holes() {
    hole(clamp_inner_diam, clamp_height + 0.1, 72*2);

    translate([0,(clamp_inner_diam/2-gap_width*.3)*front,0]) {
      rotate([0,0,0]) {
        hole(gap_width*1.25,clamp_height+1,6);
      }
    }

    translate([0,(clamp_outer_diam/2 + screw_area_depth/2) * front,0]) {
      cube([gap_width,screw_area_depth*2,clamp_height+0.1],center=true);

      for (side=[top,bottom]) {
        translate([0,screw_hole_diam/2,screw_hole_spacing/2*side]) { 
          rotate([0,90,0]) rotate([0,0,90]) {
            hole(screw_hole_diam,100,6);

            for (side=[left,right]) {
              translate([0,0,(1+screw_area_thickness/2)*side]) {
                hole(nut_hole_diam,nut_hole_depth*3,6);
              }
            }
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

main();
