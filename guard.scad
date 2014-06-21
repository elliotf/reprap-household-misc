board_thickness = 23;
board_offset    = 3;
guard_diam      = 36;
inner_wall      = 10;
side_thickness  = 23;
side_length     = 50;
side_height     = 50;

module board() {
  translate([0,25,-25])
    cube([side_thickness,side_length,side_height],center=true);
}

module guard() {
  module body() {
    hull() {
      translate([-board_thickness/4,-board_thickness/4,0])
        rotate([0,0,45])
          rotate([0,-45,0])
            sphere(r=26,$fn=18);

      translate([side_thickness-board_thickness/2-inner_wall/2,0,-side_thickness])
        cube([side_thickness*2+inner_wall,board_thickness+inner_wall*2,side_thickness*2],center=true);

      translate([0,side_thickness-board_thickness/2-inner_wall/2,-side_thickness])
        cube([board_thickness+inner_wall*2,side_thickness*2+inner_wall,side_thickness*2],center=true);

      translate([board_thickness/2+inner_wall/2,board_thickness/2+inner_wall/2,0])
        rotate([0,0,45])
          rotate([0,45,0])
            cube([side_thickness,side_thickness,20],center=true);
    }
  }

  module holes() {
    // side board
    translate([0,board_thickness/2-0.5,0])
      board();

    // foot board
    translate([-board_thickness/2-3,0,0])
      rotate([0,0,-90])
        board();

    // room for mattress
  }

  difference() {
    body();
    holes();
  }
}
rotate([0,0,45])
guard();

module printable_corner_down() {
  rotate([180-45,0,0])
    rotate([0,0,45])
      guard();
}
//printable_corner_down();

module printable_opening_down() {
  difference() {
    translate([0,0,31])
      rotate([-45,0,0])
        rotate([0,0,45])
          guard();
    translate([0,0,-50])
      cube([100,100,100],center=true);
  }
}
//printable_opening_down();
