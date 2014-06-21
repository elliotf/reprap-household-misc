left = -1;
right = 1;

board_thickness = 23;
board_offset    = 3;
guard_diam      = 36;
inner_wall      = 10;
side_thickness  = 23;
side_length     = 50;
side_height     = 50;

resolution = 18*1;

module board() {
  translate([0,25,-25])
    cube([side_thickness,side_length,side_height],center=true);
}

module guard() {
  module body() {
    hull() {
      translate([0,board_thickness*.1,0]) {
        rotate([45,0,0])
          sphere(r=26,$fn=resolution);

        translate([0,0,-side_thickness])
          cylinder(r=26,h=side_thickness*2,center=true,$fn=resolution);
      }

      for (side = [left, right]) {
        rotate([0,0,45*side]) {
          translate([inner_wall*.425*side,10+side_thickness-board_thickness/2-inner_wall/2,-side_thickness])
            cube([board_thickness+inner_wall*1.125,side_thickness*2+inner_wall-20,side_thickness*2],center=true);
        }
      }

      translate([0,board_thickness*.75+inner_wall*.5,0])
          rotate([45,0,0])
            cube([side_thickness,side_thickness,20],center=true);
    }
  }

  module holes() {
    // bed boards
    for (side = [left,right]) {
      rotate([0,0,-45*side])
        translate([0,25-board_thickness/2-3,-side_height/2]) {
          cube([side_thickness,side_length,side_height],center=true);
        }
    }

    hull() {
      for (side = [left,right]) {
        rotate([0,0,-45*side])
          translate([0,-9.5,-side_height])
            cube([side_thickness,10,8],center=true);
      }

      rotate([0,0,45])
        translate([-side_thickness/2+4,-side_thickness/2+4,-side_height+30])
          cube([8,8,8],center=true);
    }
  }

  difference() {
    body();
    holes();
  }
}

module printable_opening_down() {
  difference() {
    translate([0,0,31])
      rotate([-45,0,0])
          guard();
    translate([0,0,-50])
      cube([100,100,100],center=true);
  }
}

//guard();
printable_opening_down();
