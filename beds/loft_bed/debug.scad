include <main.scad>;

//rotate([0,0,90]) {
  captive_retention_wedge(1);

  translate([25,0,0]) {
    rotate([0,0,180]) {
      retention_wedge(-1);
    }
  }
//}
