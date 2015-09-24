include <config.scad>;
include <position.scad>;
include <util.scad>;

/*
  TODO
    * bolts

  ideas
    * rubber grommets for frame -- need to measure, get from grainger's
      * http://www.grainger.com/category/rubber-grommets/rubber/raw-materials/ecatalog/N-c1x
    * diesel fuel line or some other rubber for vibration damping?
      * if a lot of travel, washers around front/rear with room to move?
    * angle/channel aluminum for edge protection and stiffness?
      * or just sheet aluminum that is bent?
      * pop rivets w/ washers to attach?
    * angled area behind seat for "hidden" storage and/or lock storage?
    * foam/cloth pads for seats
    * material?
      * OSB for now
        * ugly, flakey, blegh
        * cheap!
      * birch
        * heavy-ish
      * FRP panel:
        * http://www.homedepot.com/p/FiberCorr-0-350-in-x-48-in-x-96-in-Corrugated-FRP-Wall-Panel-F3C320/206084818
          * should be plenty for the project, a 4'x8' panel weighs 24lbs
          * 10mm panel might be stiff/sturdy enough
          * would probably want to seal the ends
      * honeycomb aluminum
        * pretty darn pricey
      * aluminum clad plastic
        * heavy, pricey
    * front panel mount is below the surface of the main frame brace
      * standoffs to raise it

  Dimensions:
    * Bottom and front hole spacing x
      * 150mm (three holes)
    * rear plate
      * Top rear hole spacing x
        * 80mm
      * Mid rear hole spacing x
        * 330mm
      * Bottom rear hole spacing x
        * 350mm
      * Mid to top hole spacing z
        * 88mm
      * Top hole from edge Z
        * 50mm
      * Top hole from bottom hole Z
        * 310mm
      * Mid hole from bottom hole Z
        * 222mm
      * Mid hole from edge Z
        * 360mm
      * Bottom hole from edge Z
        * 50mm
    * floor struts
      * 20mm thick
      * longitudinal spacing
        * 3 to 2 250mm
        * 2 to 1 250mm
        * 1 to 0 210mm
    * cargo holes
      * 0 to 1: 50mm
      * 373mm apart across
      * 463mm apart longitudinally


*/

front_plate_holes_to_bottom = 6.5 * 25.4;
front_plate_holes_to_top    = 7   * 25.4;
front_plate_frame_clearance = 4   * 25.4;


module rear_plate() {
  module body() {
    hull() {
      for(side=[left,right]) {
        translate([(top_hole_spacing_x/2-frame_side_diam/2)*side,headset_z-10-frame_side_diam/2]) {
          accurate_circle(frame_side_diam,resolution);
        }
        translate([(plate_width/2-frame_side_diam/2)*side,top_hole_z+frame_side_diam/2]) {
          accurate_circle(frame_side_diam,resolution);
        }
      }

      translate([0,10]) {
        square([plate_width,20],center=true);
      }
    }
  }

  module holes() {
    for(side=[left,right]) {
      // top hole
      translate([top_hole_spacing_x/2*side,top_hole_z]) {
        accurate_circle(frame_hole_diam,resolution);
      }

      // mid hole
      translate([mid_hole_spacing_x/2*side,mid_hole_z]) {
        accurate_circle(frame_hole_diam,resolution);
      }

      // low hole
      translate([low_hole_spacing_x/2*side,low_hole_z]) {
        accurate_circle(frame_hole_diam,resolution);
      }

      // frame clearance
      translate([(frame_side_center_x+frame_side_diam/2)*side,frame_side_center_z]) {
        accurate_circle(frame_side_diam+clearance,resolution);

        translate([40*side,0,0]) {
          square([80,frame_side_diam+clearance],center=true);
        }
      }
    }

    // foot clearance
    hull() {
      for(side=[left,right]) {
        translate([(foot_clearance_width/2-40)*side,foot_clearance_height-40]) {
          accurate_circle(80,resolution);
        }
      }

      square([foot_clearance_width,1],center=true);
    }

    // bottom plate clearance
    translate([0,frame_side_center_z-20]) {
      square([frame_side_center_x*3,40],center=true);
    }
  }

  difference() {
    body();
    holes();
  }
}

module front_plate_spacer() {
  module body() {
    intersection() {
      front_plate();
      square([frame_side_center_x*2-frame_side_diam,3*25.4],center=true);
    }
  }

  module holes() {
  }

  difference() {
    body();
    holes();
  }
}

module front_plate() {
  module body() {
    hull() {
      for(side=[left,right]) {
        translate([(plate_width/2-frame_side_diam/2)*side,front_plate_holes_to_top-frame_side_diam/2]) {
          //accurate_circle(frame_side_diam,resolution);
        }
      }

      translate([0,front_plate_holes_to_top-10]) {
        square([plate_width,20],center=true);
      }
      translate([0,-front_plate_holes_to_bottom+10]) {
        square([plate_width,20],center=true);
      }
    }
  }

  module holes() {
    for(x=[left,0,right]) {
      translate([150*x,0,0]) {
        accurate_circle(8,resolution);
      }
    }

    for(side=[left,right]) {
      // frame clearance
      hull() {
        translate([(frame_side_center_x+frame_side_diam/2)*side,-front_plate_holes_to_bottom+front_plate_frame_clearance-frame_side_diam/2]) {
          accurate_circle(frame_side_diam+clearance,resolution);

          translate([40*side,0,0]) {
            square([80,frame_side_diam+clearance],center=true);
          }

          translate([0,-front_plate_frame_clearance,0]) {
            square([frame_side_diam+clearance,frame_side_diam+clearance],center=true);
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
  translate([0,-frame_side_center_x+7,0]) {
    scale([10,10,10]) {
      rotate([0,0,0]) {
        //% import("david_thomasson/cargo_box-front-oriented.stl");
      }
    }
  }
}

module bottom_plate() {
  //import("david_thomasson/cargo-bottom-simplified.dxf");
  translate([0,0,0]) {
    //accurate_circle(44,resolution);
  }
  translate([-770,-386,-10]) {
    scale([10,10,10]) {
      projection() {
        import("david_thomasson/bottom_plate.stl");
      }
    }
  }
}

module side_plate() {
  
}

module assembly() {
  translate([0,0,0]) {
    rotate([0,89,0]) {
      rotate([0,0,90]) {
        linear_extrude(height=sheet_thickness,center=true) {
          rear_plate();
        }
      }
    }
  }

  linear_extrude(height=sheet_thickness,center=true) {
    bottom_plate();
  }

  translate([800,0,20+front_plate_holes_to_bottom]) {
    rotate([0,-90+14,0]) {
      rotate([0,0,-90]) {
        linear_extrude(height=sheet_thickness,center=true) {
          front_plate();
        }

        translate([0,0,-sheet_thickness*2]) {
          linear_extrude(height=sheet_thickness,center=true) {
            front_plate_spacer();
          }
        }
      }
    }
  }

  translate([0,0,12]) {
    rotate([0,89,0]) {
      scale([1,1,4]) {
        rotate([0,0,90]) {
          translate([-735,-390,-80]) {
            scale([10,10,10]) {
              //% import("david_thomasson/cargo_box-rear.stl");
            }
          }
        }
      }
    }
  }
}

module cut_sheet() {
  translate([-plate_width/2-10,plate_width/2+10,0]) {
    rotate([0,0,-90]) {
      rear_plate();
    }
  }

  translate([0,-plate_width/2-10]) {
    rotate([0,0,90]) {
      translate([0,front_plate_holes_to_top + 60,0]) {
        front_plate_spacer();
      }

      front_plate();
    }
  }

  translate([500,-40,0]) {
    rotate([0,0,90]) {
      translate([-300,,0]) {
        bottom_plate();
      }
    }
  }

  translate([320,100,0]) {
    % cube([48*25.4,48*25.4,3/8*25.4],center=true);
  }
}
