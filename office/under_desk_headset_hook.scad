include <../lib/util.scad>;

resolution = 64;

module under_desk_hook() {
  extrusion_width   = 0.4;
  extrusion_height  = 0.3;
  wall_thickness    = extrusion_width*3;
  floor_thickness   = extrusion_height*4;

  hook_opening = 30;
  hook_width   = 80;
  hook_depth   = 30;

  body_thickness = 6;

  screw_head_diam  = 8;
  screw_hole_diam  = 5;
  screw_hole_pos_z = -hook_depth-hook_opening+body_thickness-screw_head_diam/2;

  offset_by    = 100;
  module hook_2d() {
    translate([offset_by,0]) {
      translate([-hook_opening/2,-hook_depth/2,0]) {
        //% square([hook_opening,hook_depth],center=true);
      }
      translate([-hook_opening+body_thickness/2,0]) {
        accurate_circle(body_thickness,resolution);

        translate([0,-(hook_depth-body_thickness)/2,0]) {
          square([body_thickness,hook_depth-body_thickness],center=true);
        }
      }

      translate([0,-hook_depth+body_thickness]) {
        intersection() {
          difference() {
            accurate_circle(hook_opening*2,resolution);
            accurate_circle((hook_opening*2)-body_thickness*2,resolution);
          }
          translate([-hook_opening,-hook_opening]) {
            square([hook_opening*2,hook_opening*2],center=true);
          }
        }

        translate([hook_opening/2,-hook_opening+body_thickness/2]) {
          square([hook_opening,body_thickness],center=true);
        }
      }
    }
  }

  module body() {
    translate([0,-hook_opening/2,-hook_depth/2]) {
      % cube([hook_width,hook_opening,hook_depth],center=true);
    }
    intersection() {
      union() {
        translate([0,-offset_by-body_thickness,0]) {
          rotate_extrude(convexity=10,$fn=resolution*4) {
            hook_2d();
          }
        }
      }
      translate([0,-offset_by/2,0]) {
        cube([hook_width,offset_by-body_thickness,200],center=true);
      }
    }

    translate([0,-body_thickness/2,-hook_depth-hook_opening+body_thickness*1.5]) {
      hull() {
        rotate([0,90,0]) {
          hole(body_thickness,hook_width,resolution);
        }

        for(side=[left,right]) {
          translate([hook_width/4*side,0,-body_thickness/2-screw_head_diam/2]) {
            rotate([90,0,0]) {
              hole(body_thickness*2,body_thickness,resolution);
            }
          }
        }
      }
    }
  }

  module holes() {
    screw_hole_depth  = 5;
    screw_head_recess = body_thickness - screw_hole_depth;
    for(side=[left,right]) {
      translate([hook_width/4*side,-body_thickness,screw_hole_pos_z]) {
        rotate([90,0,0]) {
          hole(screw_hole_diam,200,resolution);
          hole(screw_head_diam,screw_head_recess*2,resolution);
        }
      }
    }
  }

  //hook_2d();
  difference() {
    body();
    holes();
  }
}

rotate_for_print = 0;
rotate_for_print = 1;

rotate([0,rotate_for_print*90,180*rotate_for_print]) {
  under_desk_hook();
}

