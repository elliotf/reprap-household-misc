left = -1;
right = 1;
top = -1;
bottom = 1;

// for M4
screw_diam = 4.25;
nut_diam = 7.3;
nut_thickness = 3.5;

// for 6-32
screw_diam = 3.75;
nut_diam = 8.1;
nut_thickness = 5;

screw_spacing = 105;

handle_opening_depth = 22;
handle_diam = 20;
handle_height = 25;
handle_scale = 1.5;

resolution = 16;

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
}

module handle(handle_side=left) {
  module body() {
    for(side=[left,right]) {
      translate([screw_spacing/2*side,handle_height/2,0]) rotate([90,0,0])
        rotate([0,0,11.25])
          hole(handle_diam,handle_height+0.05,resolution);

      translate([(screw_spacing/2-handle_diam/2)*side,handle_height])
        intersection() {
            rotate_extrude($fn=64)
              translate([handle_diam/2,0,0]) rotate([0,0,11.25])
                circle(r=accurate_diam(handle_diam,resolution),$fn=resolution);
          translate([handle_diam/2*side,handle_diam/2,0])
            cube([handle_diam,handle_diam,handle_diam],center=true);
        }
    }

    translate([0,handle_height+handle_diam/2,0])
      rotate([0,90,0]) rotate([0,0,11.25])
        hole(handle_diam,screw_spacing-handle_diam+0.05,resolution);
  }

  module holes() {
    for(side=[left,right]) {
      translate([screw_spacing/2*side,0,0]) {
        // screw holes
        rotate([90,0,0]) rotate([0,0,22.5])
          hole(screw_diam,handle_height*2+handle_diam*.7,8);

        // captive nuts
        translate([0,nut_diam*1.5,0]) {
          rotate([90,0,0])
            hole(nut_diam,nut_thickness,6);

          translate([handle_diam/2*handle_side*-1,0,0])
            cube([handle_diam,nut_thickness,nut_diam],center=true);
        }
      }
    }

    // flatten the top/bottom
    for (side=[top,bottom]) {
      translate([0,handle_height/2,(handle_diam/2*handle_scale)*side])
        cube([screw_spacing*2,handle_height*4,handle_diam*.2*handle_scale],center=true);
    }
  }

  difference() {
    scale([1,1,handle_scale]) body();
    holes();
  }
}

for(side=[left,right])
  rotate([0,0,90-90*side])
    translate([0,5,0])
      handle(side);

