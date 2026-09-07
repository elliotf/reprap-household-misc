include <../laptop_stand.scad>;

module print_orientation_corner() {
  translate([-300/2,-front_corner_depth-1.5,0]) {
    rotate([-35,0,0]) {
      front_corner();
    }
  }
}

for(x=[left,right]) {
  mirror([0,x-1,0]) {
    print_orientation_corner();
  }
}
