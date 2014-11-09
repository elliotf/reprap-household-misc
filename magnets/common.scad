left   = -1;
right  = 1;
top    = 1;
bottom = -1;
front  = -1;
rear   = 1;

// 1/8" x 1/16" inch magnet -- very tiny!
magnet_diam      = 3.175;
magnet_thickness = 3.175/2;

magnet_clearance = 0.25;

magnet_hole_diam      = magnet_diam      + magnet_clearance*2;
magnet_hole_thickness = magnet_thickness + magnet_clearance*2;

magnet_dist_to_exterior = 0.8;

function accurate_diam(diam,sides) = 1 / cos(180/sides) / 2 * diam;

module hole(diam,len,sides=8) {
  cylinder(r=accurate_diam(diam,sides),h=len,center=true,$fn=sides);
}
