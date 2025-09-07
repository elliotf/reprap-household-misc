use <./homelab-rackmount.scad>;

intersection() {
  m720_mount();
  s = 400;
  translate([s/2,0,0]) {
    cube([s,s,s],center=true);
  }
}
