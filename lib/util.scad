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

m2_thread_into_plastic_diam = 1.8;
m3_thread_into_plastic_diam = 2.8;
m4_thread_into_plastic_diam = 3.7;
m5_thread_into_plastic_diam = 4.65;

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
    translate([50,0,0]) cube([100,.05,.05],center=true);
    translate([0,50,0]) cube([.05,100,.05],center=true);
    translate([0,0,50]) cube([.05,.05,100],center=true);
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

module rounded_cube(width,depth,height,diam,resolution=16) {
  linear_extrude(convexity=2,height=height,center=true) {
    rounded_square(width,depth,diam,resolution);
  }
}

module round_corner_filler(diam,length) {
  linear_extrude(height=length,center=true,convexity=3) {
    round_corner_filler_profile(diam);
  }
}

module round_corner_filler_profile(diam,res=resolution) {
  extra = 0.1;
  main = diam/2+extra;
  difference() {
    translate([diam/4-extra,diam/4-extra,0]) {
      square([main,main],center=true);
    }
    translate([diam/2,diam/2,0]) {
      accurate_circle(diam,res);
    }
  }
}

module bridged_hole(outer_diam,inner_diam,sides=16,layer_height=0.2) {
  cube([inner_diam,outer_diam,layer_height*2],center=true);
  cube([inner_diam,inner_diam,layer_height*4],center=true);
  hole(inner_diam,layer_height*6,8);
  hole(inner_diam,50,sides);
}
