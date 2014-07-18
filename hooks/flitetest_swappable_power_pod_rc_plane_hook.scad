top = 1;
bottom = -1;
left = -1;
right = 1;
front = -1;
rear = 1;

pod_opening_width    = 62;
base_thickness       = 4;
hook_thickness       = 4;
hook_height          = 20;
hook_depth           = 25;
hole_spacing         = 70;
nail_diam            = 1.5;
nail_head_diam       = 2.5;
rounded_diam         = nail_diam+base_thickness;
hook_vertical_offset = -hook_height*0.75;

module main() {
  module body() {
    hull() {
      for(side=[top,bottom]) {
        translate([0,hole_spacing/2*side,0]) {
          cylinder(r=rounded_diam/2,h=base_thickness,center=true);
        }
      }

      translate([0,hook_vertical_offset,0]) {
        cube([pod_opening_width+hook_thickness*2,hook_height,base_thickness],center=true);
      }
    }

    for(side=[left,right]) {
      translate([(pod_opening_width/2+hook_thickness/2)*side,hook_vertical_offset,0]) {
        hull() {
          cube([hook_thickness,hook_height,base_thickness],center=true);

          translate([0,hook_depth-hook_height*0.33,hook_depth])
            rotate([0,90,0])
              rotate([0,0,90])
                cylinder(r=rounded_diam/2,h=hook_thickness,center=true,$fn=6);
        }
      }
    }
  }

  module holes() {
    translate([0,hook_vertical_offset*0.25,0])
      cylinder(r=hook_height*0.9,h=100,center=true);

    for(side=[top,bottom]) {
      translate([0,(hole_spacing/2-nail_diam)*side,base_thickness/2*side]) {
        rotate([-45,0,0]) {
          cylinder(r=nail_diam/2,h=base_thickness*10,center=true,$fn=8);

          // this is probably too clever.  :(
          translate([0,0,5+(base_thickness*1)*((1-side)/2)+(base_thickness*.15*-side)]) {
            cylinder(r=nail_head_diam/2,h=10,center=true,$fn=8);
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
