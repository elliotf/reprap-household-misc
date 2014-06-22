include <util.scad>;

extrusion_height = 0.3;
extrusion_width = 0.5;
perimeters = 12;

resolution = 72;
sphere_resolution = resolution*1;
sphere_internal_resolution = sphere_resolution*.4;
sphere_internal_resolution = 16;
rotation = 180 / resolution;
rotation = 0;

collar_height = 3;
collar_hole_diam = 36;
collar_outer_diam = 99.5;

shade_height = 160;
shade_base_outer_diam = collar_outer_diam;
shade_base_thickness = extrusion_height*6;
shade_wall_thickness = extrusion_width*perimeters;
shade_base_inner_diam = shade_base_outer_diam-shade_wall_thickness*2;
shade_base_inner_diam = 70;
shade_top_diam = 140;

sphere_scale = 1.75;

top_rim_height = extrusion_height;

// make sure shade angle is greater than 45deg (shade_top_diam - shade_base_outer_diam)/2 > shade_height;

module shade() {
  module body() {
    translate([0,0,collar_height/2])
      hole(collar_outer_diam,collar_height,resolution);

    translate([0,0,collar_height/2]) {
      hull() {
        translate([0,0,shade_height-(shade_top_diam/2*sphere_scale)]) rotate([0,0,rotation]) {
          intersection(){
            translate([0,0,shade_top_diam*sphere_scale/2])
              cube([shade_top_diam,shade_top_diam,shade_top_diam*sphere_scale],center=true);
            scale([1,1,sphere_scale])
              sphere(shade_top_diam/2,$fn=sphere_resolution);
          }
        }
        translate([0,0,collar_height])
          hole(shade_base_outer_diam,collar_height,resolution);
      }
    }
  }

  module holes() {
    translate([0,0,collar_height/2])
      hole(collar_hole_diam,collar_height*2,resolution);

    translate([0,0,collar_height/2+shade_base_thickness]) {
      hull() {
        translate([0,0,shade_height-(shade_top_diam/2*sphere_scale)-shade_wall_thickness]) rotate([0,0,rotation])
          intersection() {
            translate([0,0,shade_top_diam*sphere_scale/2])
              cube([shade_top_diam,shade_top_diam,shade_top_diam*sphere_scale],center=true);
            scale([.9,.9,sphere_scale])
              sphere(shade_top_diam/2-shade_wall_thickness,$fn=sphere_internal_resolution);
          }
        translate([0,0,0])
          hole(shade_base_inner_diam,collar_height,resolution);
      }
    }

    translate([shade_top_diam*.25,0,shade_height])
      rotate([0,-33,0])
        hole(shade_top_diam*.75,shade_height*2,sphere_internal_resolution*2);
  }

  difference() {
    render() body();
    holes();
  }
}

translate([0,0,-shade_height/2])
  shade();
