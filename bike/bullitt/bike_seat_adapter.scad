include <../../lib/util.scad>;

inch                   = 25.4;
bullitt_hole_spacing_x = 150;
bullitt_hole_spacing_y = 200;
bullitt_hole_diam      = (3/8)*inch;
topeak_bolt_diam       = (1/2)*inch;
topeak_bolt_spacing_x  = (7+(15/16))*inch;
topeak_seat_depth      = 11*inch;

sheet_thickness        = 0.1*inch;

front_mount_bolt_dist_y = 10*inch;
mounting_hole_offset    = 0*inch;
rear_mount_bolt_dist_y  = 4*inch+mounting_hole_offset;

tubing_height = (1)*inch;
tubing_width  = (1.5)*inch;
tubing_wall_thickness = (1/8)*inch;

module tube(length) {
  difference() {
    cube([tubing_width,length,tubing_height],center=true);
    cube([tubing_width-tubing_wall_thickness*2,length+1,tubing_height-tubing_wall_thickness*2],center=true);
  }
}

overall_width = bullitt_hole_spacing_x*2+tubing_width;
echo("Overall width: ", bullitt_hole_spacing_x*2+tubing_width/inch);
echo("Overall depth: ", (rear_mount_bolt_dist_y+front_mount_bolt_dist_y+tubing_width)/inch);

module adapter_plate() {
  module body() {
    hull() {
      translate([0,-rear_mount_bolt_dist_y+mounting_hole_offset,0]) {
        accurate_circle(tubing_width,16);
      }

      for(x=[left,right]) {
        translate([topeak_bolt_spacing_x/2*x,0,0]) {
          accurate_circle(topeak_bolt_diam+tubing_width,16);
        }

        for(y=[0,front_mount_bolt_dist_y]) {
          translate([bullitt_hole_spacing_x*x,y+mounting_hole_offset,0]) {
            accurate_circle(tubing_width,16);
          }
        }
      }
    }
  }

  module holes() {
    for(x=[left,0,right]) {
      translate([topeak_bolt_spacing_x/2*x,0,0]) {
        accurate_circle(topeak_bolt_diam,16);
      }

      for(x=[left,0,right]) {
        for(y=[-rear_mount_bolt_dist_y,0,4*inch,8*inch,12*inch]) {
          translate([bullitt_hole_spacing_x*x,y+mounting_hole_offset,0]) {
            accurate_circle(bullitt_hole_diam,16);
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

translate([0,0,sheet_thickness]) {
  linear_extrude(height=sheet_thickness,center=true) {
    adapter_plate();
  }
}

tube_opacity = 0.75;

tubing_length = front_mount_bolt_dist_y+tubing_width;
for(x=[left,right]) {
  translate([bullitt_hole_spacing_x*x,-tubing_width/2+tubing_length/2,-tubing_height/2]) {
    color("lightblue", tube_opacity) tube(tubing_length);
  }
}

center_tubing_length = tubing_length+rear_mount_bolt_dist_y;
translate([0,-tubing_width/2-rear_mount_bolt_dist_y+center_tubing_length/2,-tubing_height/2]) {
  color("lightblue", tube_opacity) tube(center_tubing_length);
}

translate([0,0,sheet_thickness*2+tubing_height/2]) {
  rotate([0,0,90]) {
    color("lightblue", tube_opacity) tube(overall_width);
  }
}
