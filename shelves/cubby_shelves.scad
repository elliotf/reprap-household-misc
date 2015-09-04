include <util.scad>;

cubby_inner_width  = 20; // inches
cubby_inner_depth  = 20; // inches
cubby_inner_height = 20; // inches

cubby_inner_width  = 12; // inches
cubby_inner_depth  = 12; // inches
cubby_inner_height = 12; // inches

sheet_thickness    = 0.5;

num_cubby_high = 4;
num_cubby_wide = 2;

num_cubby_high = 2;
num_cubby_wide = 1;

total_width  = (num_cubby_wide * cubby_inner_width) + sheet_thickness * (num_cubby_wide + 1);
total_depth  = cubby_inner_depth;
total_height = (num_cubby_high * cubby_inner_height) + sheet_thickness * (num_cubby_high + 1);

tool_diam = 0.25;

resolution = 72;

side_material_remaining = total_depth*.6;
shelf_tenon_depth       = (total_depth - side_material_remaining) / 2;

shelf([total_width-sheet_thickness,total_depth,sheet_thickness]);

// in inches
for(side=[left, right]) {
  translate([(total_width/2-sheet_thickness/2)*side,0,0]) {
    rotate([0,-90*side,0]) {
      color("lightgreen", 0.5) {
        side_sheet();
      }
    }
  }
}

module side_sheet() {
  module body() {
    linear_extrude(height=sheet_thickness,center=true) {
      square([total_height,cubby_inner_depth],center=true);
    }
  }

  module holes() {
    translate([0,0,sheet_thickness/2]) {
      tenon_hole_3d([sheet_thickness,shelf_tenon_depth]);

      for(end=[front,rear]) {
        translate([0,total_depth/2*end,0]) {
          tenon_hole_3d([sheet_thickness,shelf_tenon_depth]);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module tenon_hole(dim) {
  square([dim[x],dim[y]],center=true);

  for(side=[left,right]) {
    for(end=[front,rear]) {
      translate([dim[x]/2*side,end*(dim[y]/2-tool_diam/2)]) {
        circle(r=accurate_diam(tool_diam,resolution),$fn=resolution);
      }
    }
  }
}

module tenon_hole_3d(dim) {
  linear_extrude(height=sheet_thickness,center=true) {
    tenon_hole([dim[x],dim[y]],center=true);
  }
}

module shelf(dim) {
  remove_material_per_side = side_material_remaining/2;
  linear_extrude(height=dim[z],center=true) {
    difference() {
      square([dim[x],dim[y]],center=true);

      for(side=[left,right]) {
        mirror([1-side,0,0]) {
          for(end=[front,rear]) {
            translate([dim[x]/2,dim[y]/4*end]) {
              tenon_hole([sheet_thickness,remove_material_per_side]);
              //square([sheet_thickness,remove_material_per_side],center=true);

              //for(cut_side=[front,rear]) {
              //  translate([-sheet_thickness/2,cut_side*(remove_material_per_side/2-tool_diam/2)]) {
              //    circle(r=accurate_diam(tool_diam,resolution),$fn=resolution);
              //  }
              //}
            }
          }
        }
      }
    }
  }
}



color("pink", 0.6) {
  translate([0,0,total_height*.6]) {
    //side_sheet();
    linear_extrude(height=sheet_thickness,center=true) {
      //tenon_hole([sheet_thickness,4]);
    }
  }
}
