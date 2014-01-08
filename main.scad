include <util.scad>;

extrusion_height = 0.3;
extrusion_width = 0.5;
perimeters = 3;

resolution = 72;
rotation = 180 / resolution;

collar_height = 3;
collar_inner_diam = 36;
collar_outer_diam = 96;

shade_height = 125;
shade_base_diam = collar_outer_diam;
shade_base_thickness = extrusion_height*6;
shade_wall_thickness = extrusion_width*perimeters;
shade_top_diam = 190;

top_rim_height = extrusion_height;

// make sure shade angle is greater than 45deg (shade_top_diam - shade_base_diam)/2 > shade_height;

module shade() {
  module body() {
    translate([0,0,collar_height/2])
      hole(collar_outer_diam,collar_height,resolution);

    translate([0,0,collar_height/2]) {
      hull() {
        translate([0,0,shade_height-collar_height-top_rim_height/2]) rotate([0,0,rotation])
          hole(shade_top_diam,top_rim_height,resolution);
        translate([0,0,collar_height])
          hole(shade_base_diam,collar_height,resolution);
      }
    }
  }

  module holes() {
    translate([0,0,collar_height/2+shade_base_thickness])
      hole(collar_outer_diam-shade_wall_thickness*2,collar_height,resolution);

    translate([0,0,collar_height/2])
      hole(collar_inner_diam,collar_height*2,resolution);

    translate([0,0,collar_height/2+shade_base_thickness]) {
      hull() {
        translate([0,0,shade_height-collar_height-top_rim_height/2+0.05]) rotate([0,0,rotation])
          hole(shade_top_diam-shade_wall_thickness*2,top_rim_height,resolution);
        translate([0,0,collar_height])
          hole(shade_base_diam-shade_wall_thickness*2,collar_height+0.05,resolution);
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

translate([0,0,-shade_height/2])
  shade();
