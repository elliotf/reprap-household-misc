left = -1;
right = 1;
top = -1;
bottom = 1;

build_x = 180;
build_y = 180;
build_z = 180;

print_layer_height = 0.2;
extrusion_width = 0.5;
resolution = 72;

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
}
lamp_tilt_angle = 20;
wall_thickness = 2;

insert_diam = 40;
insert_height = 70;
insert_bottom_diam = 20;
insert_bottom_height = 8;
insert_bottom_hole = 12;
insert_threaded_height = 23;

insert_mount_diam   = insert_diam + wall_thickness * 2;
insert_mount_height = insert_height - insert_threaded_height + 5;

switch_dist_from_top = 35;
switch_shaft_diam = 7;
switch_shaft_len = 60;

bulb_diam = 50;
bulb_height_above_socket = 85;
bulb_heat_clearance = 30;

shade_height      = bulb_height_above_socket + 20;
shade_bottom_diam = insert_mount_diam + bulb_heat_clearance/2;
shade_top_diam    = shade_bottom_diam + shade_height - 2;
shade_wall_thickness = extrusion_width*2;

wall_brace_thickness = wall_thickness*4;
wall_plate_width     = 80;
wall_plate_thickness = wall_thickness*2;

dist_from_wall = 20;

nail_diam = 1.75;
nail_head_diam = 5;
nail_angle = 60;

module insert() {
  main_height = insert_height - insert_bottom_height;

  translate([0,0,insert_height]) {
    translate([0,0,-switch_dist_from_top]) {
      rotate([0,90,0]) {
        translate([0,0,switch_shaft_len/2]) {
          rotate([0,0,22.5-lamp_tilt_angle]) {
            hole(switch_shaft_diam,switch_shaft_len,8);
          }
        }
      }
    }

    translate([0,0,-main_height/2]) {
      hole(insert_diam,main_height,resolution);

      translate([0,0,-main_height/2]) {
        hole(insert_bottom_diam,insert_bottom_height*2,resolution);
        hole(insert_bottom_hole,main_height*2-0.05,resolution);
      }
    }
  }
}

module nail_hole() {
  hole_height = 20;
  head_hole_height = hole_height/2;

  rotate([nail_angle,0,0]) {
    rotate([0,0,22.5]) {
      hole(nail_diam,hole_height,8);

      translate([0,0,head_hole_height/2]) {
        hole(nail_head_diam,head_hole_height,8);
      }
    }
  }
}

module insert_mount() {
  material_below_insert = 0;

  overall_height = insert_mount_height+material_below_insert;

  anchor_depth = (insert_mount_diam-insert_diam)/2-1;

  module translate_wall_anchor() {
    translate([0,insert_mount_diam/2-anchor_depth/2+tan(lamp_tilt_angle)*insert_mount_diam/4],0) {
      rotate([-lamp_tilt_angle,0,0]) {
        translate([0,dist_from_wall-(tan(lamp_tilt_angle)*insert_mount_diam/2),-(sin(lamp_tilt_angle)*insert_mount_diam/2)]) {
          children();
        }
      }
    }
  }

  module body() {
    hole(insert_mount_diam, overall_height*2, resolution);

    overall_depth = insert_mount_diam/2+dist_from_wall;

    translate_wall_anchor() {
      cube([wall_brace_thickness,anchor_depth,overall_height*2],center=true);

      translate([0,-overall_depth/2,0]) {
        cube([wall_brace_thickness,overall_depth,overall_height*2],center=true);
      }
    }

    translate_wall_anchor() {
      cube([wall_plate_width,wall_plate_thickness,overall_height*2],center=true);
    }
  }

  module holes() {
    translate([0,0,material_below_insert]) {
      # insert();

      translate([0,0,insert_height+bulb_height_above_socket/2 + 1]) {
        % cylinder(r=bulb_diam/2,h=bulb_height_above_socket,center=true);
      }
    }

    translate_wall_anchor() {
      for(side=[top,0,bottom]) {
        for(end=[left,right]) {
          # translate([(wall_plate_width/2-5)*end,-anchor_depth/2,overall_height/2-1+(overall_height/2-8)*side]) {
            nail_hole();
          }
        }
      }

      // route the cord through this in case the cord gets pulled
      for (i=[1,3]) {
        translate([0,-wall_plate_thickness/2-6,overall_height/4*i]) {
          rotate([0,90,0]) {
            rotate([0,0,22.5]) {
              hole(10,40,8);
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

module shade() {
  module body() {
    hull() {
      hole(shade_bottom_diam,2,resolution);

      translate([0,0,shade_height]) {
        hole(shade_top_diam,2,resolution);
      }
    }
  }

  module holes() {
    hull() {
      hole(shade_bottom_diam,2,resolution);

      translate([0,0,shade_height]) {
        hole(shade_top_diam,2,resolution);
      }
    }
  }

  difference() {
    //body();
    //holes();
  }
}

module wall_hanging_lamp() {
  module body() {
    translate([0,0,sin(lamp_tilt_angle)*insert_mount_diam/4]) {
      rotate([lamp_tilt_angle,0,0]) {
        insert_mount();

        translate([0,0,insert_height]) {
          % shade();
        }
      }
    }
  }

  module holes() {
    translate([0,-tan(lamp_tilt_angle)*100,build_z/2]) {
      % cube([build_x,build_y,build_z],center=true);
    }
    translate([0,0,-50]) {
      cube([400,400,100],center=true);
    }
  }

  difference() { body();
    holes();
  }
}

wall_hanging_lamp();
