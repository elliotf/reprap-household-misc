use <spice_rack.scad>;
include <spice_rack_positions.scad>;
include <boxcutter.scad>;

cutter_width = 600;
cutter_depth = 450;
translate([0,0,-2]) {
  % cube([cutter_width,cutter_depth,1],center=false);
}

translate([shelf_width+shelf_depth,backing_sheet_height/2+sheet_thickness+bc_shoulder_width+5]) {
  sides();

  translate([shelf_depth+sheet_thickness*2+bc_shoulder_width*2+5,0,0]) {
    mirror([1,0,0]) {
      sides();
    }

    translate([shelf_depth+5,0,0]) {
      rotate([0,0,-90]) {
        shelf();
      }
    }
  }
}

translate([shelf_width/2+sheet_thickness+5,backing_sheet_height/2+sheet_thickness+bc_shoulder_width+5]) {
  back();
}
