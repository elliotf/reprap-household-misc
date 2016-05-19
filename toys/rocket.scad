rocket_diam   = 20;
rocket_height = 45;

resolution = 120;

module pointed_tube(diam,height,ratio=0.5) {
  hull() {
    translate([0,0,height]) {
      scale([1,1,2]) {
        sphere(r=diam/2,$fn=resolution,center=true);
      }
    }

    translate([0,0,height/2]) {
      cylinder(r=diam/3,h=height,center=true,$fn=resolution);
    }
  }
}

module pointed_tube_holes(diam,height,ratio=0.5) {
  hull() {
    cylinder(r=diam/3-1,h=3,center=true,$fn=resolution);
    cylinder(r=0.1,h=diam+3,center=true,$fn=resolution);
  }
}

module rocket() {
  num_fins  = 3;
  r_per_fin = 360/num_fins;
  fin_width = rocket_diam*.25;
  dist_x    = rocket_diam*1.5;

  module body() {
    pointed_tube(rocket_diam,rocket_height);

    for(fin=[1:num_fins]) {
      rotate([0,0,fin*r_per_fin]) {
        translate([dist_x,0,0]) {
          pointed_tube(rocket_diam/2,rocket_height/3);
        }

        hull() {
          translate([dist_x/2,0,1]) {
            cube([dist_x,1,2],center=true);
          }
          translate([dist_x,0,rocket_height/4]) {
            rotate([0,90,0]) {
              cylinder(r=fin_width/2,h=1,center=true,$fn=resolution);
            }
          }
          translate([0,0,rocket_height*.75]) {
            rotate([0,90,0]) {
              cylinder(r=fin_width,h=1,center=true,$fn=resolution);
            }
          }
        }
      }
    }
  }

  module holes() {
    pointed_tube_holes(rocket_diam,rocket_height);

    for(fin=[1:num_fins]) {
      rotate([0,0,fin*r_per_fin]) {
        translate([dist_x,0,0]) {
          pointed_tube_holes(rocket_diam/2,rocket_height/3);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

rocket();
