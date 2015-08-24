use <spice_rack.scad>;
include <spice_rack_positions.scad>;
include <boxcutter.scad>;

cutter_width = 600;
cutter_depth = 450;
translate([0,0,-2]) {
  % cube([cutter_width,cutter_depth,1],center=false);
}

translate([shelf_width+shelf_depth,backing_sheet_height/2+sheet_thickness+bc_shoulder_width+5]) {
  //sides();

  translate([shelf_depth+sheet_thickness*2+bc_shoulder_width*2+5,0,0]) {
    mirror([1,0,0]) {
      //sides();
    }

    translate([shelf_depth+5,0,0]) {
      rotate([0,0,-90]) {
        //shelf();
      }
    }
  }
}

translate([backing_sheet_height/2,shelf_width+shelf_depth/2+sheet_thickness*4]) {
  rotate([0,0,90]) {
    sides();
  }

  translate([backing_sheet_height+sheet_thickness*4,0,0]) {
    mirror([1,0,0]) {
      rotate([0,0,90]) {
        sides();
      }
    }
  }
}

translate([shelf_depth/2+sheet_thickness+2,shelf_width/2+sheet_thickness+5]) {
  rotate([0,0,90]) {
    shelf();
  }
}

translate([shelf_depth+backing_sheet_height/2+sheet_thickness+bc_shoulder_width+5,shelf_width/2+sheet_thickness+5]) {
  rotate([0,0,90]) {
    back();
  }

  translate([backing_sheet_height/2+sheet_thickness*2+bc_shoulder_width+10+shelf_depth,0]) {
    for(side=[left,right]) {
      translate([side*(shelf_depth/2+2),0,0]) {
        rotate([0,0,-90*side]) {
          shelf();
        }
      }
    }
  }
}
