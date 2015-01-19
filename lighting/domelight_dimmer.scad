left = -1;
right = 1;
top = -1;
bottom = 1;

build_x = 180;
build_y = 180;
build_z = 180;

extrusion_height = 0.2;
extrusion_width = 0.5;
resolution = 72;

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  rotate([0,0,180/sides]) {
    cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
  }
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
shade_height      = bulb_height_above_socket + insert_threaded_height + 20;
shade_height      = 155;
echo("SHADE HEIGHT: ", shade_height + 13);
shade_bottom_diam = insert_diam + bulb_heat_clearance;
shade_bottom_diam = 55;
shade_top_diam    = 170;
shade_wall_thickness = extrusion_width*4;

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
 resolution = 36*3;

  module body() {
    hull() {
      translate([0,0,-12.5]) {
        //hole(shade_bottom_diam,1,resolution);
        hole(insert_mount_diam+4,1,resolution);
      }

      translate([0,0,shade_height]) {
        hole(shade_top_diam,1,resolution);
      }
    }
  }

  module holes() {
    hull() {
      translate([0,0,3]) {
        hole(shade_bottom_diam,1,resolution);
      }

      translate([0,0,shade_height+1]) {
        hole(shade_top_diam-shade_wall_thickness*2,1,resolution);
      }
    }

    hole(insert_diam-1, 400, resolution);

    translate([0,0,-20]) {
      hole(insert_mount_diam+1,40,resolution);

      translate([0,shade_bottom_diam/2,-2]) {
        cube([wall_brace_thickness+1,shade_bottom_diam,40],center=true);
      }
    }

    // ventilation/convection holes
    // also, provide support for top layer
    num_holes = 18;
    hole_diam = 3;
    for(i=[1:num_holes]) {
      rotate([0,0,(i-.0)*(360/num_holes)]) {
        translate([0,insert_diam/2+hole_diam/2+3.5,0]) {
          rotate([15,0,0]) {
            hole(hole_diam,100,6);
          }
        }
      }
    }

    /*
    num_holes_z = 10;
    z_spacing = shade_height/num_holes_z*2;
    for(z=[1:num_holes_z]) {
      for(i=[1:num_holes/2]) {
        rotate([0,0,(i-(z%2/2))*(360/(num_holes/4))]) {
          translate([0,insert_diam/2+hole_diam/2+3,z*z_spacing]) {
            rotate([15,0,0]) {
              rotate([0,0,22.5]) {
                hole(.5,500,4);
              }
            }
          }
        }
      }
    }
    */

    top_cut_side = shade_top_diam+5;
    translate([0,-top_cut_side/2,shade_height]) {
      rotate([-lamp_tilt_angle,0,0]) {
        translate([0,top_cut_side/2,50]) {
          cube([top_cut_side,top_cut_side,100],center=true);
        }
      }
    }
  }

  module bridges() {
    translate([0,0,0]) {
      hole(insert_mount_diam+2,extrusion_height,resolution);
    }

    translate([0,0,-6.5]) {
      hole(insert_diam-4,13,resolution);
    }
  }

  difference() {
    body();
    holes();
  }

  bridges();
}

module wall_hanging_lamp() {
  module body() {
    translate([0,0,sin(lamp_tilt_angle)*insert_mount_diam/4]) {
      rotate([lamp_tilt_angle,0,0]) {
        insert_mount();

        translate([0,0,insert_mount_height+0.5]) {
          # shade();
        }
      }
    }
  }

  module holes() {
    translate([0,-tan(lamp_tilt_angle)*100,build_z/2]) {
      //% cube([build_x,build_y,build_z],center=true);
    }
    translate([0,0,-50]) {
      cube([400,400,100],center=true);
    }
  }

  difference() { body();
    holes();
  }
}

module domelight_cover() {
  light_length = 20;
  light_width  = 20;
  pcb_thickness = 1.5;
  lip_width = 1;

  resolution = 36*2;

  extrusion_width  = .5;
  extrusion_height = .2;

  module body() {
    intersection() {
      translate([0,pcb_thickness/2,0]) {
        hole(light_width+extrusion_width*4,light_length,resolution);
      }

      translate([0,light_width,0]) {
        cube([light_width*2,light_width*2,light_length+1],center=true);
      }
    }

    // pcb body
    cube([light_width+extrusion_width*4,pcb_thickness+extrusion_width*4,light_length],center=true);
  }

  module holes() {
    // main cavity
    intersection() {
      translate([0,pcb_thickness/2,0]) {
        hole(light_width+extrusion_width*2*.8,light_length+1,resolution);
      }

      translate([0,light_width+pcb_thickness/2+extrusion_width*2,0]) {
        cube([light_width*2,light_width*2,light_length+1],center=true);
      }
    }

    // pcb hole
    cube([light_width,pcb_thickness,light_length+1],center=true);

    translate([0,pcb_thickness,0]) {
      cube([light_width-lip_width*2,pcb_thickness+0.05,light_length+1],center=true);
    }

    translate([0,-pcb_thickness,0]) {
      cube([light_width-lip_width*4,pcb_thickness+0.05,light_length+1],center=true);
    }
  }

  difference() {
    body();
    holes();
  }
}

domelight_cover();

//wall_hanging_lamp();
//shade();
