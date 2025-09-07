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

// be able to mount loose mini machines in a vertical rack

rack_opening_width = 440;

tolerance = 0.5;

nuc_width = 117;
nuc_depth = 113;
nuc_height = 47.8;
nuc_rounded = 3; // not really
nuc_foot_height = 3.6;
nuc_foot_diam = 14;
nuc_foot_spacing_x = 95;
nuc_foot_spacing_y = 90;
nuc_total_height = nuc_height + nuc_foot_height;

m720_width = 180;
m720_depth = 182;
m720_height = 35; // includes feet
m720_rounded = 4; // actually more, but who cares

m720_foot_height = 2;
m720_foot_width = 6.5;
m720_foot_depth = 16.5;

m720_total_height = m720_height + m720_foot_height;

extrude_width = 0.4;
wall_thickness = extrude_width*4;

rack_bar_width = 20;
rack_space_depth = 3 * inch;
rack_bar_thickness = 3;
extrusion_side = 20;

mount_ear_thickness = 4;
height_above_rack = mount_ear_thickness;

m720_pos_z = - m720_depth / 2 + height_above_rack;
m720_pos_y = rack_space_depth / 2 - m720_total_height - wall_thickness - tolerance;

nuc_pos_y = m720_pos_y - wall_thickness ;
nuc_pos_z = - nuc_depth / 2 + height_above_rack;

mount_bottom_thickness = wall_thickness*2;

extrusion_pos_y = m720_pos_y - wall_thickness - extrusion_side / 2 - tolerance;
extrusion_pos_z = nuc_pos_z - nuc_depth / 2 - extrusion_side / 2 - mount_bottom_thickness;

outside_room = 24;


module rj45_jack() {
  color("#444") {
    translate([0, 0, -6.9 / 2]) {
      rotate([90, 0, 0]) {
        rounded_cube(11.8, 6.9, 8, 1);
      }
    }
    translate([0, 0, -6.9]) {
      rotate([90, 0, 0]) {
        rounded_cube(7, 3 * 2, 7, 1);
      }
    }
  }
}

module m720() {
  foot_spacing_x = m720_width - m720_foot_width - 5 * 2;
  foot_spacing_y = m720_depth - m720_foot_depth - 15 * 2;

  module body() {
    translate([0, 0, m720_height / 2 + m720_foot_height]) {
      rotate([90, 0, 0]) {
        color("darkgrey") rounded_cube(m720_width, m720_height, m720_depth, m720_rounded);
      }

      button_diam = 13;
      translate([-m720_width / 2 + 8.5 + button_diam / 2, front * m720_depth / 2, -m720_height / 2 + 4.5 + button_diam / 2]) {
        rotate([90, 0, 0]) {
          color("#333") hole(button_diam, 2, resolution);
        }
      }
    }

    for (x = [left, right], y = [front, rear]) {
      translate([x * (foot_spacing_x / 2), y * (foot_spacing_y / 2), m720_foot_height]) {
        color("#333") rounded_cube(m720_foot_width, m720_foot_depth, m720_foot_height * 2, m720_foot_width);
      }
    }
  }

  module holes() {
    vent_width = 64;
    vent_height = 12;
    // 11 from side
    // 4.5 from top
    translate([m720_width / 2 - 11 - vent_width, m720_depth / 2, m720_total_height - 4.5 - vent_height / 2]) {
      num_holes = 10;
      hole_spacing = 6.4;
      hole_width = 5.4;
      for (i = [0:num_holes], z = [top, bottom]) {
        translate([(i + 0.5) * hole_spacing, 0, hole_spacing / 2 * z]) {
          color("#888") cube([hole_width, 10, hole_width], center=true);
        }
      }
    }

    plug_width = 12.5;
    plug_height = 6.2;
    translate([m720_width / 2 - 16 - plug_width / 2, m720_depth / 2, m720_foot_height + 7.8 + plug_height / 2]) {
      color("yellow") cube([plug_width, 4, plug_height], center=true);
    }

    translate([-m720_width / 2, m720_depth / 2, 0]) {
      translate([19.5, 0, m720_total_height - 6.3]) {
        jack_spacing = (15.2 - 1.6);
        num_jacks = 4;
        for (i = [0:num_jacks]) {
          translate([i * jack_spacing, 0, 0]) {
            rj45_jack();
          }
        }
      }

      translate([18.6, 0, m720_foot_height + 4.2]) {
        rotate([0, 180, 0]) {
          rj45_jack();
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module m720_mount() {
  id = m720_rounded+tolerance*2;
  od = id+wall_thickness*2;
  cavity_width = m720_width+tolerance*2;
  cavity_depth = m720_total_height+tolerance*2;
  width = cavity_width+wall_thickness*2;
  depth = cavity_depth+wall_thickness*2;

  height = m720_depth-abs(extrusion_pos_z)+extrusion_side/2 + mount_bottom_thickness - height_above_rack - 1;
  //dist_to_extrusion_z = m720_pos_z-extrusion_pos_z;
  dist_to_extrusion_z = extrusion_pos_z-m720_pos_z;
  dist_to_extrusion_y = m720_pos_y-extrusion_pos_y;
  echo("dist_to_extrusion_z: ", dist_to_extrusion_z);
  bottom_of_extrusion_offset_z = dist_to_extrusion_z-extrusion_side/2;

  max_width = 20;
  cut_width = width/2-max_width;
  echo("width/2: ", width/2);
  echo("max_width: ", max_width);
  echo("cut_width: ", cut_width);

  module position_mount() {
    translate([0,-m720_total_height/2,- m720_depth/2+height/2]) {
      children();
    }
  }

  screw_head_diam = 6.5;
  screw_hole_diam = 3.5;
  screw_mount_width = screw_head_diam+wall_thickness*4;
  mounting_hole_positions=[width/2-od/2-screw_mount_width/2,cut_width/2+screw_mount_width/2+wall_thickness];

  module body(){
    position_mount() {
      translate([0,0,- mount_bottom_thickness]) {
        rounded_cube(width,depth,height,od);
      }

    }
    for(x=[left,right]) {
      for(p=mounting_hole_positions) {
        translate([x*p,0,0]) {
          translate([0,dist_to_extrusion_y-wall_thickness/2,bottom_of_extrusion_offset_z - mount_bottom_thickness/2]) {
            rounded_cube(screw_mount_width,20+wall_thickness,mount_bottom_thickness,wall_thickness);
          }
          for(x=[left,right]) {
            hull() {
              translate([x*(screw_mount_width/2-wall_thickness),0,0]) {
                translate([0,dist_to_extrusion_y-wall_thickness/2,bottom_of_extrusion_offset_z-mount_bottom_thickness/2]) {
                  rounded_cube(wall_thickness*2,20+wall_thickness,mount_bottom_thickness,wall_thickness);
                }
                translate([0,tolerance+wall_thickness/2,-m720_depth/2]) {
                  rounded_cube(wall_thickness*2,wall_thickness,mount_bottom_thickness,wall_thickness);
                }
              }
            }
          }
        }
      }
    }
  }

  module holes(){
    position_mount() {
      cube([cut_width,depth*2,height*3],center=true);
      translate([0,0,height/2]) {
        rounded_cube(cavity_width,cavity_depth,height*2,id);

        for(x=[left,right]) {
          button_hole_width = 15;
          button_hole_depth = cavity_depth-6*2;
          button_from_side = 8+button_hole_width/2;
          hole_spacing = button_hole_width+5;
          num_holes = 3;
          for(i=[0:num_holes-1]) {
            translate([x*(cavity_width/2-button_from_side-i*(hole_spacing)),0,0]) {
              rounded_cube(button_hole_width,button_hole_depth+i*3,height*3,button_hole_width);
            }
          }
        }
      }

      for(x=[left,right],y=[front,rear]) {
        mirror([x-1,0,0]) {
          mirror([0,y-1,0]) {
            translate([cut_width/2,-depth/2,0]) {
              round_corner_filler(wall_thickness, height*2);
            }
            translate([cut_width/2,cavity_depth/2,height/2]) {
              round_corner_filler(wall_thickness, height*2);
            }
          }
        }
      }
    }

    for(x=[left,right]) {
      for(p=mounting_hole_positions) {
        translate([x*p,dist_to_extrusion_y,bottom_of_extrusion_offset_z-mount_bottom_thickness]) {
          rotate([180,0,0]) {
            bridged_hole(screw_head_diam, screw_hole_diam, length = 50, 1, resolution);
          }
          cube([screw_head_diam,screw_hole_diam,0.2*2],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module nuc() {
  module body() {
    color("darkgrey") {
      rounded_cube(nuc_width, nuc_depth, nuc_height, 16);
    }

    color("#555") {
      button_side = 9;
      translate([nuc_width / 2 - 20 - button_side / 2, -nuc_depth / 2, -nuc_height / 2 + 20.5 + button_side / 2]) {
        rotate([90, 0, 0]) {
          rounded_cube(button_side, button_side, 2, 2);
        }
      }
    }

    for (x = [left, right], y = [front, rear]) {
      translate([x * (nuc_foot_spacing_x / 2), y * (nuc_foot_spacing_y / 2), -nuc_height / 2 - nuc_foot_height / 2]) {
        color("#333") hole(nuc_foot_diam, nuc_foot_height, resolution);
      }
    }
  }

  module holes() {
    translate([0, nuc_depth / 2, 0]) {
      // vent holes
      num_holes = 14;
      hole_width = 4;
      hole_height = 9;
      hole_space = 80;
      hole_spacing = (hole_space - hole_width) / (num_holes - 1);
      echo("hole_spacing: ", hole_spacing);
      for (i = [0:num_holes - 1]) {
        translate([-hole_space / 2 + (i + 0.5) * hole_spacing, 0, nuc_height / 2 - 5.5 - hole_height / 2]) {
          rotate([90, 0, 0]) {
            color("#777") rounded_cube(hole_width, hole_height, 6 * 2, 3);
          }
        }
      }

      // RJ45
      union() translate([0, 0, nuc_height / 2 - 18]) {
          rj45_jack();
        }

      // power socket
      plug_diam = 6;
      translate([nuc_width / 2 - 17 - plug_diam / 2, 0, -nuc_height / 2 + 18 + plug_diam / 2]) {
        rotate([90, 0, 0]) {
          color("#333") hole(plug_diam, 4, resolution);
        }
      }
    }

    // show where the side vents are
    for(x=[left,right]) {
      from_top = 7;
      from_front = 13;
      depth = nuc_depth-from_front*2;
      height = nuc_height-from_top*2;

      translate([x*(nuc_width/2),0,nuc_total_height/2-from_top-height/2]) {
        color("#333") cube([1,depth,height],center=true);
      }
    }
  }

  translate([0, 0, nuc_height / 2 + nuc_foot_height]) {
    difference() {
      body();
      holes();
    }
  }
}

module nuc_mount() {
  height = nuc_depth/2;
  width = 20;

  cavity_depth = nuc_total_height+tolerance*2;
  depth = cavity_depth+wall_thickness*2;

  dist_to_extrusion_y = nuc_pos_y-extrusion_pos_y;

  module high_profile() {
    module body() {
      translate([-nuc_depth/2 - mount_bottom_thickness,- tolerance - wall_thickness,0]) {
        for(y=[front,rear]) {
          translate([height/2,depth/2+y*(depth/2-wall_thickness/2)]) {
            rounded_square(height,wall_thickness,wall_thickness);
          }
        }
        translate([mount_bottom_thickness/2,depth/2]) {
          rounded_square(mount_bottom_thickness,depth,wall_thickness);
        }
      }
      extrusion_slot_width = 6;
      extrusion_slot_depth = 5;
      translate([-nuc_depth/2-mount_bottom_thickness- extrusion_slot_depth/2+1,dist_to_extrusion_y,0]) {
        rounded_square(extrusion_slot_depth+2,extrusion_slot_width,1);
      }
      translate([-nuc_depth/2-mount_bottom_thickness/2-extrusion_side/2,dist_to_extrusion_y+extrusion_side/2+mount_bottom_thickness/2,0]) {
        rounded_square(extrusion_side+mount_bottom_thickness,mount_bottom_thickness,wall_thickness);
      }
    }

    module holes() {
    }

    difference() {
      body();
      holes();
    }
  }

  translate([0,-100,0]) {
    //% plate_profile();
  }

  module plate_profile() {
    module body() {
      // bottom front of nuc
      translate([-nuc_depth/2 - mount_bottom_thickness,- tolerance - wall_thickness,0]) {
        // the vent is larger than the hole it covers
        front_rim_width = 11;
        rear_rim_width = 16;
        bottom_rim_width = 18;
        translate([height/2,depth/2+(depth/2-front_rim_width/2)]) {
          rounded_square(height,front_rim_width,wall_thickness);
        }
        translate([height/2,depth/2-(depth/2-rear_rim_width/2)]) {
          rounded_square(height,rear_rim_width,wall_thickness);
        }
        translate([bottom_rim_width/2,depth/2]) {
          rounded_square(bottom_rim_width,depth,wall_thickness);
        }
        rounded_diam = 6;
        translate([bottom_rim_width,bottom_rim_width-wall_thickness-tolerance,0]) {
          round_corner_filler_profile(rounded_diam);
        }
        translate([bottom_rim_width,depth-front_rim_width,0]) {
          rotate([0,0,-90]) {
            round_corner_filler_profile(rounded_diam);
          }
        }
      }
      hull() {
        translate([-nuc_depth/2,0,0]) {
          translate([-mount_bottom_thickness/2-extrusion_side/2,dist_to_extrusion_y+extrusion_side/2+mount_bottom_thickness/2,0]) {
            rounded_square(extrusion_side+mount_bottom_thickness,mount_bottom_thickness,wall_thickness);
          }

          translate([-mount_bottom_thickness+wall_thickness/2,nuc_total_height+tolerance+wall_thickness/2,0]) {
            accurate_circle(wall_thickness,resolution);
          }
        }
      }
    }

    module holes() {
    }

    difference() {
      body();
      holes();
    }
  }

  module body() {
    translate([nuc_width/2+tolerance+wall_thickness-width/2,0,0]) {
      rotate([0,90,0]) {
        rotate([0,0,90]) {
          linear_extrude(width, center = true, convexity = 3) {
            high_profile();
          }
        }
      }
    }
    translate([nuc_width/2+tolerance+wall_thickness/2,0,0]) {
      rotate([0,90,0]) {
        rotate([0,0,90]) {
          linear_extrude(wall_thickness, center = true, convexity = 3) {
            plate_profile();
          }
        }
      }
    }
    translate([nuc_width/2+tolerance+wall_thickness/2,front*(nuc_depth/2+mount_bottom_thickness)+height/2,nuc_total_height+tolerance+wall_thickness-depth/2]) {
      rotate([0,90,0]) {
        //rounded_cube(depth,height,wall_thickness,wall_thickness);
      }
      
    }
  }

  module holes() {
    translate([nuc_width/2+wall_thickness-width/2,front*(nuc_depth/2+mount_bottom_thickness+extrusion_side/2),0]) {
      rotate([0,0,0]) {
        hole(3.3,100,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module rack_ear() {
  module body(){
  }

  module holes(){
  }

  difference() {
    body();
    holes();
  }
}

for (x = [left, right]) {
  translate([x * (rack_opening_width / 2 + rack_bar_width / 2), 0, -rack_bar_thickness / 2]) {
    % cube([rack_bar_width, rack_space_depth, rack_bar_thickness], center=true);
  }
  mirror([x-1,0,0]) {
    rack_ear();
  }
}

for (x = [left, right]) {
  //translate([x*(rack_opening_width/2-m720_width/2-20),rack_space_depth/2-m720_total_height-wall_thickness,- m720_depth/2 ]) {
  translate([x * (rack_opening_width / 2 - m720_width / 2 - outside_room), m720_pos_y, m720_pos_z]) {
    rotate([0, 0, 180]) {
      m720_mount();
      rotate([90, 0, 0]) {
        % m720();
      }
    }
  }
}

//translate([-rack_opening_width/2,rack_space_depth/2 - wall_thickness - m720_total_height  ,- nuc_depth/2]) {
//  for(i=[0,1]) {
//    translate([10+(i+0.5)*(nuc_width+20),0,0]) {
//translate([0, rack_space_depth / 2 - wall_thickness - m720_total_height, -nuc_depth / 2]) {
translate([0, nuc_pos_y, nuc_pos_z]) {
  //for(x=[left,0,right]) {
  for (x = [left, right]) {
    translate([x * (rack_opening_width / 2 - nuc_width / 2 - outside_room), 0, 0]) {
      rotate([0, 0, 0]) {
        rotate([90, 0, 0]) {
          for(x=[left,right]) {
            mirror([x-1,0,0]) {
              nuc_mount();
            }
          }
          //%nuc();
        }
      }
    }
  }
}

/*
// for modifying the nuc mount, to reduce the need to translate coordinates
translate([0,100,0]) {
  //translate([-nuc_depth/2-wall_thickness-extrusion_side/2,extrusion_pos_,0]) {
  translate([extrusion_pos_z,-extrusion_pos_y,0]) {
    %extrusion_2020(rack_opening_width);
  }
  translate([nuc_pos_z,-nuc_pos_y,0]) {
    rotate([0,0,-90]) {
      rotate([0,-90,0]) {
        nuc_mount();
        %nuc();
      }
    }
  }
}
*/

//translate([0,rack_space_depth/2- m720_total_height - wall_thickness - extrusion_side/2,- nuc_depth - wall_thickness - extrusion_side/2 - 10]) {
translate([0, extrusion_pos_y, extrusion_pos_z]) {
  rotate([0, 90, 0]) {
    %extrusion_2020(rack_opening_width);
  }
}
