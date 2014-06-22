left = -1;
right = 1;
top = 1;
bottom = -1;
front = -1;
rear = 1;

// for M4
screw_diam = 4.25;
nut_diam = 7.3;
nut_thickness = 3.5;

// for 6-32
screw_diam = 3.75;
nut_diam = 8.1;
nut_thickness = 5;

screw_spacing = 160;
screw_mount_thickness = 10;
handle_depth  = 25;
handle_height = 25;
handle_diam   = handle_depth;

trim_bottom   = 2;

resolution = 16;

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
}

module handle() {
  module body() {
    hull() {
      for(side=[left,right]) {
        translate([(screw_spacing/2)*side,0,0])
          rotate_extrude($fn=32)
            translate([handle_diam/2,0,0]) rotate([0,0,11.25])
              circle(r=accurate_diam(handle_diam,resolution),$fn=resolution);
      }
    }
  }

  module holes() {
    // flat bottom to print
    translate([0,handle_depth/2,-handle_diam/2]) {
      cube([screw_spacing*2,handle_depth,trim_bottom*2],center=true);
    }

    // mount against drawer
    translate([0,-handle_depth/2,0]) {
      cube([screw_spacing*2,handle_depth+1,handle_height+1],center=true);
    }

    // area for fingers to pull
    hull() {
      for(side=[left,right]) {
        translate([screw_spacing/2*side,0,handle_diam/2]) {
          scale([1,1,.4]) {
            sphere(r=handle_depth*.6,$fn=16);
          }
        }
      }
    }

    // screw holes with captive nuts
    for(side=[left,right]) {
      translate([screw_spacing/2*side,0,0]) {
        rotate([90,0,0])
          hole(screw_diam,handle_depth*2+1,6);

        translate([0,handle_depth,0])
          rotate([90,0,0])
            hole(nut_diam,(handle_depth-screw_mount_thickness)*2,6);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

for(side=[left,right]) {
  translate([-5*side,0,0])
    rotate([0,0,90*side])
      handle();
}

/*
for(side=[left,right])
  rotate([0,0,90-90*side])
    translate([0,5,0])
      handle(side);

*/
