include <lumpyscad/lib.scad>;

resolution = 128;

module tablet_mount(width,height,thickness,power_button_rotate_side,power_button_side,power_button_from_end) {
  od = 7;
  tolerance = 0.5;

  bevel_height = 0.6;
  frame_width = 13;

  charger_cable_hole_width = 14;

  power_button_hole_width = 18;
  power_button_hole_height = frame_width-bevel_height-0.4*4;

  mounting_screw_head_diam = 8; // FIXME
  mounting_screw_hole_diam = 5; // FIXME
  mount_thickness = 3;

  retaining_detent_height = 1.8+tolerance;
  retaining_detent_depth = tolerance+bevel_height;
  retaining_detent_length = height*0.5;

  screen_lip_depth = 4;

  screen_hole_width = width-screen_lip_depth*2;
  screen_hole_height = height-screen_lip_depth*2;

  cavity_width = width + tolerance*2;
  cavity_height = height + tolerance*2;
  cavity_thickness = thickness;
  cavity_od = od+tolerance*2;

  overall_width = cavity_width + frame_width*2;
  overall_height = cavity_height + frame_width*2;
  overall_thickness = cavity_thickness + mount_thickness + retaining_detent_height;

  frame_od = od + frame_width*2;

  module tablet() {
    rounded_cube(width,height,thickness,od);
  }

  module body() {
    translate([0,0,cavity_thickness/2]) {
      % tablet();
    }

    translate([0,0,overall_thickness/2-mount_thickness]) {
      difference() {
        hull() {
          rounded_cube(overall_width,overall_height,overall_thickness-bevel_height*2,frame_od);
          rounded_cube(overall_width-bevel_height*2,overall_height-bevel_height*2,overall_thickness,frame_od-bevel_height*2);
        }
        translate([0,0,-overall_thickness/2+mount_thickness+cavity_thickness]) {
          rounded_cube(cavity_width,cavity_height,cavity_thickness*2,cavity_od);
        }
      }
    }

    for(x=[left,right]) {
      translate([x*(cavity_width/2+1),0,-mount_thickness+overall_thickness-retaining_detent_height/2]) {
        rotate([90,0,0]) {
          rounded_cube(1+retaining_detent_depth*2,retaining_detent_height,retaining_detent_length,retaining_detent_height,8);
        }
      }
    }
  }

  module zip_tie_anchor() {
    zip_tie_hole_id = 6;
    zip_tie_width = 5;
    zip_tie_thickness = 3;

    linear_extrude(height=zip_tie_width,center=true,convexity=3) {
      od = zip_tie_hole_id+zip_tie_thickness*2;
      id = zip_tie_hole_id;
      difference() {
        rounded_square(od,od+5,od);
        rounded_square(id,id+5,id);
      }
    }
  }

  module holes() {
    rounded_cube(screen_hole_width,screen_hole_height,overall_height*3,5);

    // power button
    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        rotate([0,0,90*power_button_rotate_side]) {
          side_dim = (power_button_rotate_side % 2) ? height : width;
          other_dim = (power_button_rotate_side % 2) ? cavity_width : cavity_height;
          translate([power_button_side*(side_dim/2-power_button_from_end),other_dim/2,cavity_thickness/2+x*cavity_thickness/2]) {
            rounded_cube(power_button_hole_width,power_button_hole_height*2,cavity_thickness*2,5);
          }
        }
      }
    }

    // power cable
    translate([0,-height/2,cavity_thickness/2]) {
      cable_hole_size_z = cavity_thickness;
      cube([charger_cable_hole_width,height,cable_hole_size_z],center=true);
    }

    // zip tie anchor to secure charger cable
    for(x=[left,right]) {
      translate([x*(charger_cable_hole_width/2+10),-overall_height/2+3,cavity_thickness/2]) {
        zip_tie_anchor();
      }
    }

    // mounting screw holes
    screw_delta = mounting_screw_head_diam-mounting_screw_hole_diam;
    for(x=[left,right],y=[front,rear]) {
      screw_pos_x = 30;
      //translate([x*(width/2-mounting_screw_head_diam/2+bevel_height/2),y*(height/2+frame_width/2-bevel_height/2),-mount_thickness+overall_thickness/2]) {
      translate([x*(screw_pos_x),y*(height/2+frame_width/2),-mount_thickness+overall_thickness/2]) {
        hole(mounting_screw_hole_diam,overall_thickness*2,resolution);

        /*
        for(z=[top,bottom]) {
          translate([0,0,z*overall_thickness/2]) {
            countersink_depth = 2;
            hull() {
              hole(mounting_screw_head_diam,countersink_depth*2,resolution);
              hole(mounting_screw_hole_diam,countersink_depth*2+2*screw_delta,resolution);
            }
          }
        }
        */
      }
    }

    ipad_button_hole_diam =20;
    translate([0,-(cavity_height/2-ipad_button_hole_diam/2),0]) {
      hole(ipad_button_hole_diam, overall_thickness*4,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}
