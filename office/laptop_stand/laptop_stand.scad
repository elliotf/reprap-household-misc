include <lumpyscad/lib.scad>;
include <NopSCADlib/lib.scad>;

sizes = [
  [
    // 16" Macbook. I hate apple laptops and would like to use linux
    // dimensions taken from https://support.apple.com/en-us/111838
    355.7, // 16" macbook width
    248.1, // 16" macbook depth
    16.8, // 16" macbook thickness
    340, // extrusion front length
    180, // extrusion spine length
    80, // extrusion brace length
    25, // dist to move brace back
  ],
  [
    // 14" Macbook. I hate apple laptops and would like to use linux
    // dimensions taken from https://support.apple.com/en-us/126318
    312.6, // 14" macbook width
    221.2, // 14" macbook depth
    //15.5, // 14" macbook thickness
    16.8,
    260, // extrusion front length
    150, // extrusion spine length
    80, // extrusion brace length
    40, // dist to move brace back
  ],
];

laptop_size = 0; // 16" macbook
//laptop_size = 1; // 14" macbook
laptop_width = sizes[laptop_size][0];
laptop_depth = sizes[laptop_size][1];
laptop_thickness = sizes[laptop_size][2];
extrusion_front_length = sizes[laptop_size][3];
extrusion_spine_length = sizes[laptop_size][4];
extrusion_brace_length = sizes[laptop_size][5];
move_brace_back = sizes[laptop_size][6];

laptop_large_rounded_diam = 11;
laptop_cavity_room = 1.3;
laptop_cavity_width = laptop_width + 1.3;
height_above_desk = 20;
stand_depth = 8*inch;
stand_angle = 35;

extrusion_type = E2020t;

extrusion_front_setback = 6;
material_front_laptop = 4;
material_beside_laptop = 4;
//front_corner_height = extrusion_width(extrusion_type)+laptop_base_thickness+2;
front_corner_height = extrusion_width(extrusion_type)+laptop_thickness-0.5;
front_corner_width = 100+laptop_cavity_room+material_beside_laptop;
front_corner_depth = extrusion_front_setback+laptop_cavity_room+material_front_laptop;

echo("front_corner_depth: ", front_corner_depth);

// M3
//fcs_head_diam = 5.7;
//fcs_shaft_diam = 3.2;
// M5
fcs_head_diam = 9.4;
fcs_shaft_diam = 5.4;

module fcs_screw_hole(sink_by=0.8) {
  translate([0,0,-sink_by]) {
    translate([0,0,sink_by]) {
      hole(fcs_head_diam,sink_by*2,resolution);
    }
    delta = fcs_head_diam-fcs_shaft_diam;
    bevel_hole(fcs_shaft_diam,delta/2);
    translate([0,0,-20/2]) {
      hole(fcs_shaft_diam,20,resolution);
    }
  }
}

module dummy_laptop(swell_by=0) {
  color("darkgrey") {
    hull() {
      translate([0,0,laptop_thickness-0.1]) {
        rounded_cube(laptop_width+swell_by,laptop_depth+swell_by,0.2,laptop_large_rounded_diam);
      }
      for(x=[left,right],y=[front,rear]) {
        translate([x*(laptop_width/2-laptop_large_rounded_diam/2),y*(laptop_depth/2-laptop_large_rounded_diam/2),laptop_large_rounded_diam/2+swell_by/2]) {
          sphere(r=laptop_large_rounded_diam/2+swell_by/2,$fn=32);
        }
      }
    }
  }
}

module position_laptop() {
  translate([0,0,0]) {
    rotate([stand_angle,0,0]) {
      translate([0,material_front_laptop+laptop_cavity_room+laptop_depth/2,extrusion_width(extrusion_type)]) {
        children();
      }
    }
  }
}

module position_front_extrusion() {
  position_laptop() {
    translate([0,front*(laptop_depth/2-extrusion_width(extrusion_type)*0.5-extrusion_front_setback),-extrusion_width(extrusion_type)/2]) {
      rotate([0,90,0]) {
        children();
      }
    }
  }
}

module position_spine_extrusion() {
  position_front_extrusion() {
    translate([0,extrusion_width(extrusion_type)/2+extrusion_spine_length/2,0]) {
      rotate([-90,0,0]) {
        children();
      }
    }
  }
}

module position_brace_extrusion() {
  position_spine_extrusion() {
    translate([0,0,move_brace_back]) {
      rotate([0,-90,0]) {
        translate([0,0,-extrusion_width(extrusion_type)/2-extrusion_brace_length/2]) {
          children();
        }
      }
    }
  }
}

module extrusion_brace() {
  brace_len = 70;
  brace_height = 15;
  webbing_thickness = 2;
  wall_thickness = 3.6;

  module profile() {
    difference() {
      union() {
        translate([wall_thickness/2,brace_len/2,0]) {
          rounded_square(wall_thickness,brace_len,wall_thickness);
        }
        translate([brace_len/2,wall_thickness/2,0]) {
          rounded_square(brace_len,wall_thickness,wall_thickness);
        }
        translate([wall_thickness,wall_thickness,0]) {
          round_corner_filler_profile(wall_thickness);
        }
      }
      union() {
        round_corner_filler_profile(wall_thickness*3);
      }
    }
  }

  module body() {
    linear_extrude(height=brace_height,center=true,convexity=3) {
      profile();
    }
    translate([0,0,-brace_height/2+webbing_thickness/2]) {
      hull() {
        linear_extrude(height=webbing_thickness,center=true,convexity=3) {
          profile();
        }
      }
    }
  }

  module holes() {
    for(r=[left,right],x=[left,right]) {
      rotate([0,0,45+45*r]) {
        translate([brace_len*0.52+x*brace_len*0.67/2,0,0]) {
          rotate([90,0,0]) {
            hole(3.5,100,8);
          }
        }
      }
    }
    hull() {
      diam = wall_thickness;
      spacing = wall_thickness+diam/2+1;
      translate([spacing,spacing,0]) {
        hole(diam,100,resolution);

        for(r=[left,right]) {
          rotate([0,0,45+45*r]) {
            translate([brace_len*0.5,0,0]) {
              hole(diam,100,resolution);
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

module front_corner() {
  module position_corner() {
    position_laptop() {
      translate([laptop_width/2+laptop_cavity_room+material_beside_laptop,front*laptop_depth/2,0]) {
        children();
      }
    }
  }

  module body() {
    position_corner() {
      translate([-front_corner_width/2,extrusion_front_setback-front_corner_depth/2,-extrusion_width(extrusion_type)+front_corner_height/2]) {
        cube([front_corner_width,front_corner_depth,front_corner_height],center=true);
      }
    }
  }

  module holes() {
    position_laptop() {
      dummy_laptop(1.3);
    }

    position_corner() {
      translate([0,front*(laptop_cavity_room+material_front_laptop),0]) {
        rotate([0,0,90]) {
          round_corner_filler(laptop_large_rounded_diam+laptop_cavity_room+material_beside_laptop,100);
        }

        translate([-front_corner_width+extrusion_width(extrusion_type)/2,0,-extrusion_width(extrusion_type)/2]) {
          num_screws = 2;
          //num_screws = 3;
          //space_avail = front_corner_width-(laptop_width/2-extrusion_front_length/2);
          //space_avail = front_corner_width-extrusion_width(extrusion_type)-material_beside_laptop-laptop_cavity_room;
          space_avail = 50;
          for(x=[0:num_screws-1]) {
            translate([x*(space_avail/(num_screws-1)),0,0]) {
              rotate([90,0,0]) {
                fcs_screw_hole();
              }
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

module foot() {
  foot_height = 15;

  module body() {
    hull() {
      translate([0,0,-2]) {
        rounded_cube(20,20,4,2);
      }
      translate([0,0,-foot_height+1]) {
        hole(20,2,resolution);
      }
    }
  }

  module holes() {
    hole(6.5,foot_height*3,resolution);

    translate([0,0,-foot_height]) {
      hole(12,foot_height,resolution);
    }
  }

  difference() {
    body();
    holes();
  }
}

module printed_brace_foot() {
  extrusion_side = 20;
  rounded_foot_diam = 20;
  thickness = 20;
  slot_width = 5;
  slot_depth = 4;
  wall_thickness = 5;
  rounded_diam = 2;

  screw_diam = 5.4;
  screw_head_diam = 9;

  overall_width = 60;

  hole_spacing = overall_width-wall_thickness*2-screw_head_diam;

  module body() {
    translate([0,-extrusion_brace_length/2+wall_thickness/2,-thickness/4]) {
      rounded_cube(overall_width,wall_thickness,extrusion_side+thickness/2,wall_thickness/2);
    }

    // leg
    hull() {
      translate([0,0,-thickness/2]) {
        translate([0,extrusion_brace_length/2+rounded_foot_diam/2,0]) {
          hole(rounded_foot_diam,thickness,resolution);
        }
        translate([0,-extrusion_brace_length/2+wall_thickness/2,0]) {
          rounded_cube(rounded_foot_diam,wall_thickness,thickness,wall_thickness);
        }
      }
    }

    // plate
    hull() {
      translate([0,0,-thickness*3/4]) {
        translate([0,extrusion_brace_length/2+rounded_foot_diam/2,0]) {
          hole(rounded_foot_diam,thickness/2,resolution);
        }

        translate([0,-extrusion_brace_length/2-extrusion_side/2,0]) {
          rounded_cube(overall_width,wall_thickness,thickness/2,rounded_diam);
        }
        translate([0,-extrusion_brace_length/2+wall_thickness/2,0]) {
          rounded_cube(overall_width,wall_thickness,thickness/2,rounded_diam);
        }
      }
    }

    // slot filler
    translate([0,-extrusion_brace_length/2-extrusion_side/2,-extrusion_side/2]) {
      rounded_cube(overall_width,slot_width,slot_depth*2,rounded_diam);
    }
  }

  module holes() {
    for(x=[left,right]) {
      translate([x*(hole_spacing/2),-extrusion_brace_length/2+wall_thickness,0]) {
        rotate([90,0,0]) {
          hole(screw_diam,wall_thickness*3,8);
          
        }
      }
    }
  }

  rotate([-90,0,0]) {
    difference() {
      body();
      holes();
    }
  }
}

module laptop_stabilizer() {
  width = 130; // small enough to print diagonally on a v0
  depth = 20;
  clamp_length = 10;
  thickness = 15;
  small_thickness = 5;
  small_diam = 8;
  tiny_diam = 4;
  tolerance = 0.4; // pretty loose

  meat_under_extrusion = tiny_diam;

  slot_width = 5;
  slot_depth = 4;

  module body() {
    translate([0,depth/2,-clamp_length/2+1]) {
      rounded_cube(slot_width,slot_depth*2,clamp_length+2,tiny_diam/2);
    }
    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        translate([depth/2,0,-clamp_length/2+1]) {
          rounded_cube(slot_depth*2,slot_width,clamp_length+2,tiny_diam/2);
        }
        hull() {
          translate([depth/2+tolerance+tiny_diam/2,-depth/2+(tolerance/2+depth/2+meat_under_extrusion/2),thickness/2-clamp_length/2]) {
            rounded_cube(tiny_diam,tolerance+depth+meat_under_extrusion,thickness+clamp_length,tiny_diam);
          }
          translate([width/2-small_diam/2,-depth/2+small_diam/2,thickness-small_thickness/2]) {
            hole(small_diam,small_thickness,resolution);
          }
        }
      }
    }
    translate([0,tolerance+depth/2+meat_under_extrusion/2,thickness/2-clamp_length/2]) {
      rounded_cube(depth+tiny_diam*2,meat_under_extrusion,thickness+clamp_length,tiny_diam);
    }
    translate([0,meat_under_extrusion/2,thickness/2]) {
      rounded_cube(depth+tiny_diam*2,depth+meat_under_extrusion,thickness,tiny_diam);
    }
  }

  module holes() {
    translate([0,0,thickness-10]) {
      mid_air_hole(6.5,12);
    }
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
  position_laptop() {
    % dummy_laptop();
  }

  position_front_extrusion() {
    % extrusion(extrusion_type,extrusion_front_length);

    for(z=[left,right]) {
      mirror([0,0,z-1]) {
        translate([0,0,-extrusion_front_length/2]) {
          foot();
        }
      }
    }
  }

  position_spine_extrusion() {
    % extrusion(extrusion_type,extrusion_spine_length);

    for(y=[front,rear]) {
      mirror([0,y-1,0]) {
        translate([0,extrusion_width(extrusion_type)/2,-extrusion_spine_length/2]) {
          rotate([0,-90,0]) {
            extrusion_brace();
          }
        }
      }
    }

    translate([0,0,extrusion_spine_length/2]) {
      rotate([0,0,0]) {
        rotate([0,0,-90]) {
          laptop_stabilizer();
        }
      }
    }
  }

  position_brace_extrusion() {
    printed_brace_foot();
  }

  // extrusion-based foot
  /*
  position_brace_extrusion() {
    % extrusion(extrusion_type,extrusion_brace_length);
    translate([0,0,-extrusion_brace_length/2]) {
      foot();
    }
    translate([-extrusion_width(extrusion_type)/2,0,extrusion_brace_length/2]) {
      rotate([0,90,0]) {
        rotate([-90,0,0]) {
          extrusion_brace();
        }
      }
    }
  }
  */

  module body() {
    for(x=[left,right]) {
      mirror([x-1,0,0]) {
        front_corner();
      }
    }
  }

  module holes() {
    translate([0,0,-100]) {
      //cube([laptop_width*2,laptop_depth*3,200],center=true);
    }
  }

  difference() {
    body();
    holes();
  }
}
