include <../../lib/util.scad>;

// actual measurements of tracks
//
// ~8.5mm slot opening
// ~8.5mm slot depth (top surface to bottom surface)
// 12mm internal slot width
// ~2mm slot top lip extrusion thickness
// ~2mm slot back extrusion thickness
// ~16mm slot outer (front to back, outer)

track_width = 185; // includes rubber strip

extrude_width = 0.4;
extrude_height = 0.2;
wall_thickness = extrude_width*3;

resolution = 64;
tolerance = 0.2;

m5_nut_diam = 8.1;
m5_nut_height = 5.5;

track_side_length = 2.5*inch;
track_side_width = 2*inch;
track_side_height = 3/4*inch;
track_side_above_surface = 0;
track_vertical_width = 5/8*inch;

tape_side_mounting_hole_diam = m4_thread_into_plastic_diam;
tape_side_mounting_hole_spacing = 74;

rounded_diam = tape_side_mounting_hole_diam + wall_thickness*4;

tape_side_width = tape_side_mounting_hole_spacing+rounded_diam;
tape_side_height_below = 1/2*inch;
tape_side_height_above = 1.6; // ~1/16" but less futzy, and more compatible with 0.2 layer height
tape_side_ledge_length = 1/2*inch;

tape_bottom_above_surface = 2.4+tape_side_height_above;
// tape_width = 15/16*inch; // emily adams
tape_width = 24 + tolerance*2; // actual + tolerance
tape_height = 2.5;
tape_thickness = 0.25;
tape_diam = 32*2; // from http://www.ambrsoft.com/trigocalc/circle3d.htm using -12x0y, +12x0y, 0x2.3y points

adjust_screw_diam = 1/4*inch;
adjust_screw_head_diam = 12;
adjust_screw_nut_diam = 11 + tolerance;
adjust_screw_nut_height = 8; // actually ~7.5 or so

module tape_side() {
  length_below_tape = adjust_screw_nut_height + wall_thickness*4 + 1/2*inch;

  echo("length_below_tape: ", length_below_tape);

  module below_tape_profile() {
    hull() {
      translate([rounded_diam/2,0,0]) {
        rounded_square(rounded_diam,tape_side_width,rounded_diam,resolution);
      }

      translate([length_below_tape-rounded_diam/2,0,0]) {
        rounded_square(rounded_diam,tape_side_width/2,rounded_diam,resolution);
      }
    }
  }

  module body() {
    translate([0,0,-tape_side_height_below/2]) {
      linear_extrude(height=tape_side_height_below,center=true,convexity=3) {
        below_tape_profile();
      }
    }
    translate([0,0,tape_side_height_above/2]) {
      linear_extrude(height=tape_side_height_above,center=true,convexity=3) {
        hull() {
          below_tape_profile();

          translate([-tape_side_ledge_length+rounded_diam/2,0,0]) {
            rounded_square(rounded_diam,tape_side_width,rounded_diam,resolution);
          }
        }
      }
    }
  }

  module holes() {
    for(y=[front,rear]) {
      translate([rounded_diam/2,y*tape_side_mounting_hole_spacing/2,0]) {
        hole(tape_side_mounting_hole_diam,50,16);
      }
    }

    translate([0,0,-adjust_screw_head_diam/2]) {
      rotate([0,90,0]) {
        hull() {
          height = (adjust_screw_head_diam-adjust_screw_diam)/2;

          hole(adjust_screw_diam,2*(height+1),resolution);
          hole(adjust_screw_head_diam,2,resolution);
        }
        hole(adjust_screw_diam,length_below_tape*3,resolution);
      }
      translate([length_below_tape/2,0,0]) {
        rotate([0,90,0]) {
          rotate([0,0,90]) {
            hole(adjust_screw_nut_diam,adjust_screw_nut_height,6);
          }
        }
        translate([0,0,-20]) {
          cube([adjust_screw_nut_height,adjust_screw_nut_diam,40],center=true);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module tape(length) {
  intersection() {
    translate([0,0,tape_height/2]) {
      cube([length,tape_width,tape_height],center=true);
    }
    translate([0,0,-tape_diam/2+tape_height]) {
      rotate([0,90,0]) {
        difference() {
          hole(tape_diam,length,resolution*3);
          hole(tape_diam-tape_thickness*2,length+1,resolution*3);
        }
      }
    }
  }
}

module track_side() {
  track_vertical_height = 7/16*inch;
  track_tab_width = 5/16*inch;
  track_tab_height = 1/4*inch;

  echo("track_tab_width: ", track_tab_width);

  // tape_height = 3/16*inch;
  tape_length = track_side_length - track_vertical_width + 1;
  tape_screw_diam = 5+tolerance;
  tape_screw_spacing = 20;
  tape_screw_from_end = 12;

  toilet_bolt_diam = 1/4*inch+tolerance*2;
  toilet_bolt_head_diam = 13; // total guess, head shape is weird
  toilet_bolt_head_width = 11.2; // actual is ~10.8 but I'm not sure how consistent that is
  toilet_bolt_head_length = 18.1; // actual is ~16.8 but I'm not sure how consistent that is

  module body() {
    intersection() {
      translate([0,0,track_side_height/2]) {
        rounded_cube(track_side_length, track_side_width, track_side_height, rounded_diam, resolution);
      }
    }
  }

  module holes() {
    // tape cavity
    translate([track_side_length/2,0,tape_bottom_above_surface+tape_thickness]) {
      intersection() {
        translate([0,0,tape_height-30]) {
          cube([tape_length*2, tape_width, 60], center=true);
        }
        translate([0,0,-tape_diam/2+tape_height]) {
          rotate([0,90,0]) {
            hole(tape_diam,tape_length*2,resolution*3);
          }
        }
      }

      % tape(tape_length);
    }

    // tape screws
    translate([track_side_length/2-tape_screw_from_end-tape_screw_spacing/2,0,track_side_height]) {
      for(x=[left,right]) {
        translate([x*tape_screw_spacing/2,0,0]) {
          nut_diam = m5_nut_diam+tolerance;
          translate([0,0,-m5_nut_height]) {
            // hole(tape_screw_diam,track_side_height,resolution);
            intersection() {
              hole(nut_diam,100,6);
              rotate([0,0,30]) {
                bridged_hole(nut_diam,5+tolerance);
              }
            }
          }

          hole(nut_diam,m5_nut_height*2,6);
        }
      }
    }

    // slot room
    translate([-track_side_length/2+track_vertical_width/2,0,0]) {
      amount_to_clear = (track_vertical_width-track_tab_width)/2;
      translate([-track_vertical_width/2,0,0]) {
        cube([amount_to_clear*2,track_side_width+1,track_vertical_height*2],center=true);
      }

      translate([track_vertical_width/2-amount_to_clear/2,0,0]) {
        cube([amount_to_clear,track_side_width+1,track_vertical_height*2],center=true);
      }

      // toilet flange bolt
      hole(toilet_bolt_diam,track_side_height*2+1,resolution);
      rounded_cube(toilet_bolt_head_width,toilet_bolt_head_length,track_vertical_height*2,toilet_bolt_head_width,resolution);

      // clearance for track
      cube([track_vertical_width,track_side_width+1,(track_vertical_height-track_tab_height)*2],center=true);

      // more plastic into the slots
      for(y=[front,rear]) {
        translate([0,y*(track_side_width*0.325),0]) {
          hole(0.1,40,6);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module sub_track_width_cut_jig(desired_cut_width) {
  track_extra_clearance = 2;

  rounded_diam = 2;

  adjustment_allowance = 2; // under-size the brace, in case it prints too large

  length_under_track = track_width - desired_cut_width - adjustment_allowance; 

  track_vertical_height = 7/16*inch;
  track_tab_width = 5/16*inch;
  track_tab_height = 1/4*inch;

  echo("track_tab_width: ", track_tab_width);

  toilet_bolt_diam = 1/4*inch+tolerance*2;
  toilet_bolt_head_diam = 13; // total guess, head shape is weird
  toilet_bolt_head_width = 11.2; // actual is ~10.8 but I'm not sure how consistent that is
  toilet_bolt_head_length = 18.1; // actual is ~16.8 but I'm not sure how consistent that is

  height_above_track = track_side_height - track_vertical_height;
  brace_width = height_above_track;
  top_main_width = track_vertical_width+brace_width;

  adjust_screw_pos_x = track_vertical_width-length_under_track;
  adjust_screw_pos_z = -track_extra_clearance-brace_width+rounded_diam/2;

  translate([0,0,35]) {
    rotate([90,0,0]) {
      // profile();
    }
  }

  module position_adjustment_screw() {
    translate([adjust_screw_pos_x,0,adjust_screw_pos_z]) {
      children();
    }
  }

  translate([track_vertical_width-track_width,0,0]) {
    translate([track_width/2,0,1]) {
      % color("lightgrey", 0.2) cube([track_width,100,2],center=true);
    }

    for(i=[0:2]) {
      length = desired_cut_width - 10*i;
      translate([length/2,0,-3*(i+1)]) {
        % color("lightgreen", 0.2) cube([length,100,2],center=true);
      }
    }
  }

  module profile() {
    module corner_clearance(diam) {
      dist = sqrt(pow(diam,2)-pow(diam/2,2));

      module body() {
        hull() {
          accurate_circle(diam,resolution);
          rotate([0,0,-45]) {
            translate([0,-diam,0]) {
              square([diam*1.75,0.1],center=true);
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
      translate([top_main_width/2,track_vertical_height+height_above_track/2]) {
        rounded_square(top_main_width,height_above_track,rounded_diam,resolution);
      }
      translate([track_vertical_width/2,track_vertical_height,0]) {
        rounded_square(track_tab_width,track_tab_height*2,rounded_diam,resolution);
      }
      translate([track_vertical_width,0,0]) {
        hull() {
          translate([brace_width/2,0]) {
            translate([0,track_vertical_height+height_above_track/2]) {
              rounded_square(brace_width,height_above_track,rounded_diam,resolution);
            }
            translate([0,-track_extra_clearance-brace_width/2]) {
              rounded_square(brace_width,brace_width,rounded_diam,resolution);
            }
          }
        }
        hull() {
          translate([0,-track_extra_clearance-brace_width/2]) {
            translate([brace_width/2,0]) {
              rounded_square(brace_width,brace_width,rounded_diam,resolution);
            }
            translate([-length_under_track+brace_width/2,0]) {
              rounded_square(brace_width,brace_width,rounded_diam,resolution);
            }
          }
        }
      }
    }

    module holes() {
      translate([track_vertical_width/2,track_vertical_height,0]) {
        for(x=[left,right]) {
          mirror([x-1,0,0]) {
            translate([-track_tab_width/2,0,0]) {
              corner_clearance(rounded_diam/2);
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

  module body() {
    rotate([90,0,0]) {
      linear_extrude(height=track_side_width,center=true,convexity=3) {
        profile();
      }
    }

    position_adjustment_screw() {
      body_length = length_under_track+brace_width;
      translate([body_length/2,0,0]) {
        rotate([90,0,0]) {
          hull() {
            rounded_cube(body_length,rounded_diam,m5_nut_diam*3+wall_thickness*4,rounded_diam,resolution);
            rounded_cube(body_length,2*(abs(adjust_screw_pos_z)-track_extra_clearance),m5_nut_diam+wall_thickness*4,rounded_diam,resolution);
          }
        }
      }
    }
  }

  module holes() {
    // slot room
    translate([track_vertical_width/2,0,track_vertical_height]) {
      // toilet flange bolt
      hole(toilet_bolt_diam,track_side_height+1,resolution);
      translate([0,0,-track_tab_height]) {
        hull() {
          rounded_cube(toilet_bolt_head_width,toilet_bolt_head_length,track_tab_height*2,toilet_bolt_head_width,resolution);
          translate([0,-track_tab_height/2,-0.1]) {
            rounded_cube(toilet_bolt_head_width,toilet_bolt_head_length+track_tab_height,0.1,toilet_bolt_head_width,resolution);
          }
        }
        translate([0,0,-20]) {
          // be able to put bolt into jig
          rounded_cube(toilet_bolt_head_width,toilet_bolt_head_length,30,toilet_bolt_head_width,8);
        }
      }

      // more plastic into the slots
      for(y=[front,rear]) {
        translate([0,y*(track_side_width*0.325),0]) {
          # hole(0.1,track_vertical_height+10,6);
        }
      }
    }

    position_adjustment_screw() {
      m5_fsc_head = 10;
      screw_diam = 5+tolerance*1.5;
      length = m5_nut_height;
      side = m5_nut_diam+tolerance;

      translate([wall_thickness*3+5+length/2,0,0]) {
        rotate([0,90,0]) {
          hole(screw_diam,length_under_track*3,resolution);

          rotate([0,0,-120]) {
            hull() {
              hole(side,length,6);
              translate([0,30,0]) {
                cube([side,60,length],center=true);
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

module knob() {
  nut_height = 5.6;
  knob_height = nut_height + extrude_height*6;
  nut_cavity_diam = adjust_screw_nut_diam+tolerance;

  module body() {
    translate([0,0,knob_height/2]) {
      body_side = nut_cavity_diam+wall_thickness*4;
      rounded_cube(body_side,body_side*2.5,knob_height,body_side,resolution);
    }
  }

  module holes() {
    hole(adjust_screw_diam+tolerance,50,resolution);

    translate([0,0,knob_height]) {
      hole(nut_cavity_diam,nut_height*2,6);
    }
  }

  difference() {
    body();
    holes();
  }
}

module track_profile() {
  module body() {
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
  /*
  translate([-track_side_length/2-40,0,0]) {
    track_side();

    translate([-track_side_length/2+track_vertical_width/2,0,track_side_height+10]) {
      knob();
    }
  }
  translate([0,0,0]) {
    tape_side();
  }
  */

  translate([0,100,0]) {
    sub_track_width_cut_jig(130);
  }
}

assembly();


translate([0,0,40]) {
  // bridged_hole(20,5+tolerance);
}
