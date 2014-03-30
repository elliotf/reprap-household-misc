top = 1;
bottom = -1;
left = -1;
right = 1;
front = -1;
rear = 1;

neck_width     = 45;
head_width     = 60;
head_thickness = 25;

notch_depth   = 0;
opening_width = 0;

plate_thickness = 3;

dist_from_wall = 75;

screw_diam = 4;
screw_hole_spacing = 30;

total_depth = dist_from_wall+head_thickness;
neck_pos = dist_from_wall+head_thickness/2;

module main() {
  // rotate the part 45deg to see what it looks like IRL

  module body() {
    // plate
    translate([0,plate_thickness/2*front,0]) {
      hull() {
        for(side=[left,right]) {
          translate([15*side,0,0])
            rotate([90,0,0]) rotate([0,0,22.5])
              cylinder(r=screw_diam*1.5,h=plate_thickness,center=true,$fn=8);
        }
        for(end=[top,bottom]) {
          translate([0,0,screw_hole_spacing/2*end])
            cube([15,plate_thickness,15],center=true);
        }

        translate([0,front*neck_pos,neck_pos+3.5]) {
          cube([head_width+10,30+15,10],center=true);
        }
      }
    }
  }

  module holes() {
    % translate([0,dist_from_wall/2*front,dist_from_wall+20]) cube([10,dist_from_wall,10],center=true);

    translate([0,neck_pos*front,neck_pos+10])
      scale([1,1,.4])
        rotate([90,0,0])
          cylinder(r=head_width/2,h=head_thickness,center=true);

    // neck opening
    translate([0,(dist_from_wall+head_thickness/2+10)*front,total_depth/2])
      cube([neck_width,head_thickness+20,total_depth],center=true);

    // screw holes
    for(side=[top,bottom]) {
      translate([0,0,screw_hole_spacing/2*side])
        rotate([90,0,0]) rotate([0,0,22.5])
          cylinder(r=screw_diam/2,h=100,center=true,$fn=8);
    }
  }

  difference() {
    body();
    holes();
  }
}

module to_print() {
  rotate([45,0,0])
    main();
}

main();
//to_print();
