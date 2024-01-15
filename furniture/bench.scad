include <lumpyscad/lib.scad>;

foot = 12*inch;

thin_ply = 0.5*inch;
//thick_ply = 18; // 3/4" ply
thick_ply = 3/4*inch; // 3/4" ply, actually ~18mm

slide_thickness = 0.5*inch;
num_drawers = 2;
first_drawer = 0;
last_drawer = num_drawers-1;

side_reveal = 1/2*inch;
front_reveal = side_reveal;

drawer_spacing = 31*inch+thick_ply;
//drawer_spacing = 29*inch+thick_ply;
drawer_depth = 22*inch;

width = drawer_spacing*num_drawers+thick_ply;

//top_width = ((98-1)*inch)/2;
top_width = width+side_reveal*2;
top_depth = (25+3/4)*inch;
top_thickness = (1+1/8)*inch;

echo("top_width: ", top_width/inch);

//carpet_clearance = 2*inch; // sort of a toe kick, but not really
//shear_prevention_height = 2.5*inch;

carpet_clearance = 3*inch; // sort of a toe kick, but not really
shear_prevention_height = carpet_clearance;

echo("width: ", width/inch);
depth = drawer_depth+1*inch;
echo("depth: ", depth/inch);
height = 20*inch;
echo("height: ", height/inch);

drawer_gap = 1/8*inch;
drawer_height = height-carpet_clearance-drawer_gap*2;

echo("drawer_spacing/inch: ", drawer_spacing/inch);
//drawer_width = width-(num_drawers+1)*thick_ply-(num_drawers*slide_thickness*2);
drawer_width = drawer_spacing-thick_ply-slide_thickness*2;
drawer_face_width = drawer_spacing-thick_ply-1/4*inch;

//echo("drawer_width (in): ", drawer_width/inch);

drawer_side_depth = drawer_depth;
drawer_internal_width = drawer_width-thick_ply*2;
drawer_internal_depth = drawer_depth-thick_ply;
drawer_internal_height = drawer_height-thick_ply;

echo("drawer_internal_width:  ", drawer_internal_width/inch);
echo("drawer_internal_depth:  ", drawer_internal_depth/inch);
echo("drawer_internal_height: ", drawer_internal_height/inch);

echo("-----------3x");
echo("divider height: ", height/inch);
echo("divider depth: ", depth/inch);

echo("-----------4x");
echo("drawer side height: ", drawer_height/inch);
echo("drawer side depth: ", drawer_depth/inch);

echo("-----------2x");
echo("drawer bottom width: ", drawer_internal_width/inch);
echo("drawer bottom depth: ", drawer_depth/inch);

echo("-----------2x");
echo("drawer back width: ", drawer_internal_width/inch);
echo("drawer back height: ", drawer_internal_height/inch);

echo("-----------2x");
echo("drawer face width: ", drawer_face_width/inch);
echo("drawer face height: ", drawer_height/inch);

echo("-----------1x or 3x");
echo("carpet clearance width: ", width/inch);
echo("carpet clearance height: ", carpet_clearance/inch);

echo("");
echo("");

module vertical_divider(i) {
  module body() {
    translate([0,thick_ply+depth/2,0]) {
      cube([thick_ply,depth,height],center=true);
    }
  }

  module holes() {
    /*
    if (i != 0 && i < num_drawers) {
      for(z=[top,bottom]) {
        translate([0,depth/2,z*height/2]) {
          cube([thick_ply*2,thick_ply*2,shear_prevention_height*2],center=true);
        }
      }
      
      translate([0,-depth/2,-height/2]) {
        cube([thick_ply*2,thick_ply*2,carpet_clearance*2],center=true);
      }
    }
    */
  }

  difference() {
    body();
    holes();
  }
}

module drawer(i) {

  drawer_face_width = drawer_spacing-drawer_gap;


  module drawer_face(i) {
    wider_face = drawer_spacing+thick_ply/2-drawer_gap/2;
    skew = thick_ply/2-drawer_gap*1.25;
    if (i == first_drawer) {
      translate([-skew,0,0]) {
        color("#555") cube([wider_face,thick_ply,drawer_height],center=true);
      }
    }

    if (i == last_drawer) {
      translate([skew,0,0]) {
        color("#555") cube([wider_face,thick_ply,drawer_height],center=true);
      }
    }

    if (i > first_drawer && i < last_drawer) {
      drawer_face_width = drawer_spacing-drawer_gap;
      color("#555") cube([drawer_face_width,thick_ply,drawer_height],center=true);
    }
  }

  module body() {
    translate([0,0,drawer_height/2]) {
      // front
      translate([0,thick_ply/2,0]) {
        // color("#555") cube([drawer_face_width,thick_ply,drawer_height],center=true);
        drawer_face(i);
      }

      translate([0,thick_ply,0]) {
        // sides
        for(x=[left,right]) {
          translate([x*(drawer_width/2-thick_ply/2),drawer_side_depth/2,0]) {
            color("#faa") cube([thick_ply,drawer_side_depth,drawer_height],center=true);
          }
        }

      }
    }

    // back
    translate([0,thick_ply+drawer_side_depth-thick_ply/2,thick_ply+drawer_internal_height/2]) {
      color("#bfb") cube([drawer_internal_width,thick_ply,drawer_internal_height],center=true);
    }

    // bottom
    translate([0,thick_ply+drawer_side_depth/2,thick_ply/2]) {
      color("#aaf") cube([drawer_internal_width,drawer_side_depth,thick_ply],center=true);
    }
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module assembly() {
  module body() {
    translate([0,top_depth/2-front_reveal,height+top_thickness/2]) {
      cube([top_width,top_depth,top_thickness],center=true);
    }

    for(i=[0:num_drawers-1]) {
      translate([-width/2+thick_ply/2+(i+0.5)*drawer_spacing,0,carpet_clearance+drawer_gap]) {
        //pct = i/(num_drawers-1);
        pct = 0;
        translate([0,-drawer_depth*pct,0]) {
          drawer(i);
        }
      }
    }

    translate([0,0,0]) {
      translate([-width/2,0,0]) {
        for(i=[0:num_drawers]) {
          translate([thick_ply/2+i*drawer_spacing,0,height/2]) {
            vertical_divider(i);
          }
        }
      }

      // carpet clearance
      translate([0,0,height/2]) {
        translate([0,thick_ply/2,-height/2+carpet_clearance/2]) {
          color("red") cube([width,thick_ply,carpet_clearance],center=true);
        }
      }

      // rear shear brace
      translate([0,0,height/2]) {
        for(z=[top,bottom]) {
          translate([0,depth+thick_ply*1.5,z*(height/2-shear_prevention_height/2)]) {
            color("red") cube([width,thick_ply,shear_prevention_height],center=true);
          }
        }
      }
    }

    translate([0,0,0]) {
    }
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

assembly();
