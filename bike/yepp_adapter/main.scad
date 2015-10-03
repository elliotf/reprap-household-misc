include <config.scad>;
include <position.scad>;
include <util.scad>;

yepp_window_len   = 90;
yepp_window_width = 65;

yepp_tongue_len    = 20;
yepp_tongue_height = 35;

min_material_width = 20;
resolution         = 32;

rack_tube_diam    = 10;
rack_tube_spacing = 100 - rack_tube_diam;
rack_tube_spacing = 65 - rack_tube_diam;

outer_rack_tube_spacing = 100 - rack_tube_diam;
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

module screw_holes(height) {
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
    for(x=[inner_rack_tube_spacing]) {
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
        screw_holes(main_plate_thickness+1);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module clamp_cap() {
  module body() {
    translate([0,0,clamp_cap_height/2]) {
      cube([main_plate_width,rack_clamp_thickness,clamp_cap_height],center=true);
    }
  }

  module holes() {
    translate([0,0,clamp_cap_height+space_between/2]) {
      tube_holes(rack_tube_diam+1);
    }

    screw_holes(clamp_height);
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

    screw_holes(clamp_height*3);
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
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
          clamp_cap();
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
