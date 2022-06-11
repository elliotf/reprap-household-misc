include <lumpyscad/lib.scad>;

od = 1*inch;
id = 3/4*inch;
thickness = 1/8*inch;

difference() {
  hole(od,thickness,resolution*2);
  hole(id,thickness+1,resolution*2);
}
