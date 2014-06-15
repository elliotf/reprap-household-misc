side_length=180;
thickness = 4;
diagonal_length = sqrt(2*pow(side_length, 2));

echo("DIAGONAL LENGTH: ", diagonal_length);

x=0;
y=1;
z=2;

module straight_edge() {
  module body() {
    cube([side_length,side_length,thickness],center=true);
  }

  module holes() {
    // diagonal
    translate([side_length/2,side_length/2,0])
      rotate([0,0,45])
        cube([diagonal_length,diagonal_length+10,thickness+1],center=true);

    // large hole
    translate([-side_length/4.5,-side_length/4.5,0])
      cylinder(r=side_length/6,h=thickness+1,center=true,$fn=72);

    // medium hole
    med_hole=[side_length/3,side_length/8,0];
    translate([-med_hole[x],med_hole[y],0])
      cylinder(r=side_length/12,h=thickness+1,center=true,$fn=72);
    translate([med_hole[y],-med_hole[x],0]) rotate([0,0,22.5])
      cylinder(r=side_length/12,h=thickness+1,center=true,$fn=8);

    // less pointy corners
    for (side=[1,-1]) {
      translate([-side_length/2*side,side_length/2*side,0])
        rotate([0,0,25*side])
          cube([8,8,thickness+1],center=true);
    }

    translate([-side_length/2,-side_length/2,0])
      rotate([0,0,45])
        cube([5,5,thickness+1],center=true);
  }

  difference() {
    body();
    holes();
  }
}

straight_edge();
