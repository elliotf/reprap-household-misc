left   = -1;
right  = 1;
front  = -1;
rear   = 1;
top    = 1;
bottom = -1;

x = 0;
y = 1;
z = 2;

width  = x;
depth  = y;
height = z;

inch = 25.4;

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  rotate([0,0,180/sides]) {
    cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
  }
}

module accurate_circle(diam,sides=8) {
  rotate([0,0,180/sides]) {
    circle(r=accurate_diam(diam,sides),$fn=sides);
  }
}

module debug_axes() {
  color("red") {
    translate([50,0,0]) cube([100,.2,.2],center=true);
    translate([0,50,0]) cube([.2,100,.2],center=true);
    translate([0,0,50]) cube([.2,.2,100],center=true);
  }
}

module rounded_square(width,height,diam,resolution=16) {
  hull() {
    for(x=[left,right]) {
      for(y=[front,rear]) {
        translate([x*(width/2-diam/2),y*(height/2-diam/2),0]) {
          accurate_circle(diam,resolution);
        }
      }
    }
  }
}
