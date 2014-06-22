top = 1;
bottom = -1;
left = -1;
right = 1;
front = -1;
rear = 1;

neck_width     = 45;
head_width     = 60;
head_thickness = 25;

plate_thickness = 6;

dist_from_wall = 80;

screw_diam = 4.7;
screw_head_diam = 9.25;

hook_material_thickness = 10;
total_depth = dist_from_wall + head_thickness + hook_material_thickness;
total_width = head_width + hook_material_thickness*2;

module main() {
  module body() {
    translate([0,total_depth/2*front,0])
      cube([total_width,total_depth,total_depth],center=true);
  }

  //% rotate([-45,0,0])
  //  translate([0,total_depth*.4*front,total_depth*.45*bottom])
  //    cube([200,200,2],center=true);

  module holes() {
    // main angle
    translate([0,total_depth/2*front,0])
      rotate([-45,0,0])
        translate([0,0,total_depth/2*bottom-hook_material_thickness])
          cube([total_width+1,total_depth*2,total_depth],center=true);

    // neck space
    translate([0,(dist_from_wall+head_thickness)*front,0])
      cube([neck_width,head_thickness*2,total_depth+1],center=true);

    // retainer
    translate([0,0,total_depth/2])
      scale([1,1,.6])
        rotate([90,0,0]) rotate([0,0,0])
          cylinder(r=head_width/2,h=(dist_from_wall+head_thickness)*2,center=true,$fn=8);

    // screw holes
    for(end=[total_depth*.2,total_depth*.35*bottom]) {
      translate([0,0,end])
        rotate([90,0,0])
          translate([0,0,total_depth/2]) {
            rotate([0,0,22.5])
              cylinder(r=screw_diam/2,h=total_depth+1,center=true,$fn=8);

            translate([0,0,plate_thickness]) rotate([0,0,22.5])
              cylinder(r=screw_head_diam/2,h=total_depth,center=true,$fn=8);
          }
    }

    // cubby hole
    /*
    translate([0,0,-5])
      scale([1,1,.5])
        rotate([90,0,0]) rotate([0,0,22.5])
            cylinder(r=neck_width/2,h=total_depth*2,center=true,$fn=8);
    */

    // bottom angle
    for (side=[left,right]) {
      translate([total_depth/2*side,0,total_depth/2*bottom])
        rotate([0,22.5*side,0])
          cube([total_width,total_depth*2,total_depth*2],center=true);
    }

    // top angle
    for (side=[left,right]) {
      translate([total_depth*.4*side,0,total_depth/2])
        rotate([0,-35*side,25*side])
          cube([total_width,total_depth*2,total_depth*2],center=true);
    }
  }

  difference() {
    body();
    holes();
  }
}

module to_print() {
  dist = sqrt(pow(total_depth/2+hook_material_thickness*1.5,2)*2)/2;
  rotate([0,0,-45])
    translate([0,0,dist])
      rotate([45,0,0])
        main();

  % translate([40*left,40*front,0])
    cube([200,200,1],center=true);
}

main();
//to_print();
