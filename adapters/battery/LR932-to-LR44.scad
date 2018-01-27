include <../../lib/util.scad>;

LR44_diam   = 11.6;
LR44_height = 5.4;
LR932_diam   = 9.3;
LR932_height = 3.2;

z_margin  = 0.2;
xy_margin = 0.4;

rim_height = LR44_height - LR932_height - z_margin;

body_diam   = LR44_diam    - xy_margin;
body_height = rim_height   + LR932_height/2;
void_diam   = LR932_diam   + xy_margin;
void_height = LR932_height + z_margin;

offset_x = (LR932_diam - LR44_diam)/2;

resolution = 64;

module battery_adapter() {
  difference() {
    intersection() {
      translate([0,0,body_height/2]) {
        hole(body_diam,body_height,resolution);
      }

      hull() {
        translate([offset_x,0,body_height/2]) {
          hole(void_diam-1,body_height*2,resolution);
        }
        translate([body_diam/2,0,body_height]) {
          cube([body_diam-1,body_diam,body_height*2],center=true);
        }
      }
    }
    translate([0,0,rim_height+void_height/2]) {
      translate([offset_x,0,0]) {
        hole(void_diam,void_height,resolution/4);
      }
      translate([-body_diam/2,0,0]) {
        cube([body_diam+1,body_diam*2,void_height],center=true);
      }
    }
  }

  if (1) {
    translate([0,0,LR44_height/2]) {
      % difference() {
        hole(LR44_diam,LR44_height,resolution);
        hole(LR44_diam-0.1,LR44_height*2,resolution);
      }
    }
  }

  if (1) {
    translate([offset_x,0,LR44_height-LR932_height/2+0.01]) {
      % color("red", 0.2) hole(LR932_diam,LR932_height,resolution);
    }
  }
}

battery_adapter();
