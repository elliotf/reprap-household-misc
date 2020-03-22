include <../lib/util.scad>;

resolution = 128;

turret_diam = 30;
turret_height = 15;
tank_body_width = turret_diam + 10*2;
tank_body_height = 25;
tank_length = 75;
turret_shank_small_diam = tank_body_height/2;
cannon_diam = 10;
cannon_length = tank_body_width/2-turret_diam/2+3;

lego_leg_height = 12;
lego_leg_depth = 12;
lego_leg_width = 16.5;

module turret_shaft(tolerance=0) {
  straight_length = 5;
  hole(turret_shank_small_diam+tolerance,straight_length+1,resolution);
  for(z=[top,bottom]) {
    hull() {
      translate([0,0,z*straight_length/2]) {
        hole(turret_shank_small_diam+tolerance,1,resolution);
      }
      translate([0,0,z*(tank_body_height/2-0.5)]) {
        hole(turret_diam+tolerance,1,resolution);
      }
    }
  }
}

module tank_main() {
  module body() {
    hull() {
      for(end=[front,rear]) {
        translate([end*(tank_length/2-tank_body_height/2),0,tank_body_height/2]) {
          rotate([90,0,0]) {
            hole(tank_body_height,tank_body_width,8);
          }
        }
      }
    }
  }

  module holes() {
    translate([0,0,tank_body_height/2]) {
      turret_shaft(2);
    }
  }

  difference() {
    body();
    holes();
  }
}

module tank_turret() {
  module body() {
    translate([0,0,tank_body_height+turret_height/2]) {
      rotate([0,0,-90]) {
        translate([turret_diam/2+cannon_length/2-2,0,0]) {
          rotate([0,90,0]) {
            hole(cannon_diam,cannon_length+4,8);
          }
        }
      }

      hole(turret_diam,turret_height,resolution);
    }

    support_height = tank_body_height+turret_height/2-cannon_diam/2+0.2;
    support_width = 5;
    translate([0,-turret_diam/2-cannon_length-support_width/2,support_height/2]) {
      cube([support_width,support_width,support_height],center=true);
    }

    translate([0,0,tank_body_height/2]) {
      turret_shaft();
    }
  }

  module holes() {
    translate([0,0,tank_body_height+turret_height]) {
      cube([lego_leg_width,lego_leg_depth,lego_leg_height*2],center=true);
    }
  }

  difference() {
    color("khaki") body();
    color("green") holes();
  }
}

module tank() {
  color("orange") tank_main();
  tank_turret();
}

tank();
