include <lumpyscad/lib.scad>;

module bridged_hole(od,id,length=50,is_final=1,num_sides=resolution) {
  render() {
    hole(id,length,resolution);
    translate([0,0,length/4]) {
      hole(od,length/2,num_sides);
    }
    if (is_final) {
      intersection() {
        union() {
          cube([od,id,0.2*1*2],center=true);
          cube([id,id,0.2*2*2],center=true);
          hole(id,0.2*3*2,8);
        }
        hole(od,0.2*3*3,num_sides);
      }
    }
  }
}


module mount(width, depth, thickness, dock_rounded) {
  edge_pos_x = width/2;
  space_below_desk = 1*inch; // allow space for cooling and getting fingers around cables
  wall_thickness = 2;
  ledge_width = 20;
  rounded_diam = wall_thickness;

  screw_hole_diam = 6;
  screw_head_diam = 10;
  screw_retainer_thickness = 1/4*inch;
  screw_body_diam = screw_head_diam+wall_thickness*2;

  dock_pos_z = bottom*(space_below_desk+thickness/2);

  cavity_depth = depth+2;

  overall_height = abs(dock_pos_z)+thickness/2+wall_thickness;
  body_rounded = dock_rounded+wall_thickness*2;
  body_depth = cavity_depth+wall_thickness*2;

  screw_pos_y = screw_body_diam/2;
  screw_pos_x = width/2+screw_body_diam/2;

  slide_in_room = thickness+3;
  lip_overall_height = overall_height-slide_in_room;

  translate([0,0,dock_pos_z]) {
    % rounded_cube(width, depth, thickness, dock_rounded);
  }

  module body() {
    difference() {
      union() {
        translate([width/2+wall_thickness,0,-overall_height/2]) {
          hull() {
            translate([-body_rounded/2,0,0]) {
              intersection() {
                rounded_cube(body_rounded, body_depth, overall_height, body_rounded);
                translate([body_rounded/2,0,0]) {
                  cube([body_rounded,body_depth*3,overall_height*3],center=true);
                }
              }
            }
            translate([left*ledge_width+wall_thickness,0,0]) {
              rounded_cube(rounded_diam, body_depth, overall_height, rounded_diam);
            }
          }
        }
      }

      translate([0,front*depth/2,0]) {
        cube([width+10,depth+wall_thickness*2,slide_in_room*2],center=true);
      }
    }

    translate([screw_pos_x,screw_pos_y,-overall_height/2]) {
      hull() {
        hole(screw_body_diam,overall_height,resolution);
        translate([-screw_body_diam/2+wall_thickness/2,screw_body_diam/2,0]) {
          rounded_cube(wall_thickness, screw_body_diam*2, overall_height, wall_thickness);
        }
      }
    }
  }

  module holes() {
    translate([0,0,-overall_height/2+wall_thickness]) {
      rounded_cube(width, cavity_depth, overall_height, dock_rounded);
    }
    translate([screw_pos_x,screw_pos_y,-screw_retainer_thickness]) {
      rotate([180,0,0]) {
        bridged_hole(screw_head_diam,screw_hole_diam,overall_height,1,resolution);
      }
      //hole(screw_hole_diam,overall_height*3,resolution);

      translate([0,0,-overall_height/2]) {
        hole(screw_head_diam,overall_height,resolution);
      }
    }

    translate([width/2+wall_thickness,0,-overall_height-1]) {
      hull() {
        translate([screw_body_diam/2,0,0]) {
          cube([screw_body_diam,depth*2,2],center=true);
        }
        translate([screw_body_diam+wall_thickness,0,overall_height*0.66]) {
          cube([screw_body_diam/2,depth*2,2],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

width = 230;
depth = 88;
thickness = 30;
dock_rounded = 30;

mount(width,depth,thickness,dock_rounded);
