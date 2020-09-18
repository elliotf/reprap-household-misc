use <./emily-adams-parallel-guides.scad>;

rotate([180,0,0]) {
  block_height = 3/4*25.4;
  intersection() {
    track_side();
    translate([20,0,0]) {
      // # cube([10,50,(block_height-8)*2],center=true);
    }
  }
}
