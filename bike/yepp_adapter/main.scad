include <config.scad>;
include <position.scad>;
include <../../lib/util.scad>;

yepp_window_len   = 90;
yepp_window_width = 65;

yepp_tongue_len    = 20;
yepp_tongue_height = 35;

min_material_width = 20;
resolution         = 32;

rack_tube_diam    = 10.75;

outer_rack_tube_spacing = 99 - rack_tube_diam;
inner_rack_tube_spacing = 60 - rack_tube_diam;

rack_clamp_thickness = 30;
clamp_hole_spacing   = [inner_rack_tube_spacing/2-rack_tube_diam,outer_rack_tube_spacing/2-(outer_rack_tube_spacing/2-inner_rack_tube_spacing/2)/2];
clamp_screw_diam     = 5;
clamp_height         = yepp_tongue_height+rack_tube_diam/2 - 1;
clamp_cap_height     = rack_tube_diam * 1.5;
space_between        = 2;

main_plate_thickness = 10;
main_plate_width     = yepp_window_width + min_material_width*2;
main_plate_len       = yepp_window_len + yepp_tongue_len*1.5 + rack_clamp_thickness*2;

box_tube_width     = 127;
box_tube_height    = 50.5;
box_tube_length    = 187;
box_tube_thickness = 3.1;

box_tube_clamp_wall_thickness = 5;
box_tube_clamp_hole_diam  = 5;
box_tube_clamp_width      = rack_tube_diam + box_tube_clamp_hole_diam + box_tube_clamp_wall_thickness*2;
box_tube_clamp_height     = rack_tube_diam + box_tube_clamp_wall_thickness*2;
box_tube_clamp_length     = 30;
box_tube_clamp_screw_tube_dist = box_tube_clamp_hole_diam/2+rack_tube_diam/2; // inside
box_tube_clamp_screw_side = -1; // inside
box_tube_clamp_screw_side = 1; // outside
box_tube_clamp_hole_mount_spacing = outer_rack_tube_spacing + 2*(box_tube_clamp_screw_tube_dist*box_tube_clamp_screw_side);

module printed_part_screw_holes(height) {
  for(side=[left,right]) {
    for(x=clamp_hole_spacing) {
      translate([x*side,0,0]) {
        hole(clamp_screw_diam,height,resolution);
      }
    }
  }
}

module tube_holes(diam) {
  for(side=[left,right]) {
    //for(x=[outer_rack_tube_spacing,inner_rack_tube_spacing]) {
    for(x=[outer_rack_tube_spacing]) {
    //for(x=[inner_rack_tube_spacing]) {
      translate([x/2*side,0,0]) {
        rotate([90,0,0]) {
          hole(diam,main_plate_len+2,resolution);
        }
      }
    }
  }
}

module main_plate() {
  module body() {
    cube([main_plate_width,main_plate_len,main_plate_thickness],center=true);
  }

  module holes() {
    cube([yepp_window_width,yepp_window_len,main_plate_thickness+1],center=true);

    for(end=[front,rear]) {
      translate([0,(main_plate_len/2-rack_clamp_thickness/2)*end,0]) {
        printed_part_screw_holes(main_plate_thickness+1);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module printed_clamp_cap() {
  module body() {
    translate([0,0,clamp_cap_height/2]) {
      cube([main_plate_width,rack_clamp_thickness,clamp_cap_height],center=true);
    }
  }

  module holes() {
    translate([0,0,clamp_cap_height+space_between/2]) {
      tube_holes(rack_tube_diam+1);
    }

    printed_part_screw_holes(clamp_height);
  }

  difference() {
    body();
    holes();
  }
}

module rack_clamp() {
  module body() {
    translate([0,0,-clamp_height/2]) {
      cube([main_plate_width,rack_clamp_thickness,clamp_height],center=true);
    }
  }

  module holes() {
    translate([0,0,-clamp_height-space_between/2]) {
      tube_holes(rack_tube_diam+1);
    }

    translate([0,-rack_clamp_thickness/2,-yepp_tongue_height/2]) {
      rotate([0,90,0]) {
        hole(yepp_tongue_height/2,yepp_window_width,resolution);
      }
    }

    printed_part_screw_holes(clamp_height*3);
  }

  difference() {
    body();
    holes();
  }
}

module printed_assembly() {
  translate([0,0,main_plate_thickness/2]) {
    main_plate();
  }

  for(side=[0,1]) {
    rotate([0,0,180*side]) {
      translate([0,main_plate_len/2-rack_clamp_thickness/2,0]) {
        color("lightblue") {
          rack_clamp();
        }
      }

      translate([0,main_plate_len/2-rack_clamp_thickness/2,-clamp_height-space_between-clamp_cap_height]) {
        color("lightgreen") {
          printed_clamp_cap();
        }
      }
    }
  }

  % for(side=[left,right]) {
    translate([0,0,-clamp_height-space_between/2]) {
      tube_holes(rack_tube_diam);
    }
  }
}

module box_tube() {
  module body() {
    cube([box_tube_width,box_tube_length,box_tube_height],center=true);
  }

  module holes() {
    cube([box_tube_width-box_tube_thickness*2,box_tube_length+box_tube_thickness*2,box_tube_height-box_tube_thickness*2],center=true);

    translate([0,0,box_tube_height/2]) {
      linear_extrude(height=box_tube_thickness*2+1,center=true) {
        box_tube_top_holes();
      }
    }

    translate([0,0,-box_tube_height/2]) {
      linear_extrude(height=box_tube_thickness*2+1,center=true) {
        box_tube_bottom_holes();
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module box_tube_top_holes() {
  square([yepp_window_width,yepp_window_len],center=true);
}

module top_cuts() {
  box_tube_top_holes();
  difference() {
    square([box_tube_width,box_tube_length],center=true);
    square([box_tube_width-5,box_tube_length-5],center=true);
  }
}

module bottom_cuts() {
  box_tube_bottom_holes();
  difference() {
    square([box_tube_width,box_tube_length],center=true);
    square([box_tube_width-5,box_tube_length-5],center=true);
  }
}

module box_tube_bottom_holes() {
  hole_spacing_y = 20;
  to_cover       = box_tube_length;
  num_holes      = floor(to_cover / hole_spacing_y);
  coverage       = num_holes*hole_spacing_y;
  remainder      = to_cover - coverage;
  per_hole       = remainder / (num_holes);
  final_spacing  = hole_spacing_y+per_hole;

  for(x=[left,right]) {
    for(i=[1:num_holes-1]) {
      translate([box_tube_clamp_hole_mount_spacing/2*x,-box_tube_length/2+final_spacing*(i+0),0]) {
        accurate_circle(box_tube_clamp_hole_diam,resolution);
      }
    }
    for(i=[1:num_holes-2]) {
      translate([((box_tube_clamp_hole_mount_spacing/2)-box_tube_clamp_screw_tube_dist*2)*x,-box_tube_length/2+final_spacing*(i+0.5),0]) {
        accurate_circle(box_tube_clamp_hole_diam,resolution);
      }
    }
  }
}

module box_tube_clamp() {
  module body() {
    translate([-box_tube_clamp_hole_diam/2,0,0]) {
      cube([box_tube_clamp_width,box_tube_clamp_height,box_tube_clamp_length],center=true);
    }
  }

  module holes() {
    rack_tube_hole_diam = rack_tube_diam + 0.1;
    hole(rack_tube_hole_diam,box_tube_clamp_length+1,resolution);

    translate([-rack_tube_hole_diam/2-box_tube_clamp_hole_diam/2,0,0]) {
      rotate([90,0,0]) {
        # hole(box_tube_clamp_hole_diam,box_tube_clamp_height*2,resolution);
      }
    }

    translate([-box_tube_clamp_width/2,0,0]) {
      cube([box_tube_clamp_width,rack_tube_hole_diam-1,box_tube_clamp_length+1],center=true);
    }
  }

  color("lightblue") difference() {
    body();
    holes();
  }
}

module assembly() {
  translate([0,0,box_tube_height/2]) {
    box_tube();
  }

  translate([0,0,box_tube_height+box_tube_clamp_length]) {
    //box_tube_clamp();
  }

  translate([0,0,-box_tube_clamp_height/2]) {
    % tube_holes(rack_tube_diam);

    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([outer_rack_tube_spacing/2*x,(box_tube_length/2-box_tube_clamp_length*.75)*y,0]) {
          rotate([0,0,-90*(x+box_tube_clamp_screw_side)]) {
            rotate([90,0,0]) {
              box_tube_clamp();
            }
          }
        }
      }
    }
  }
}
