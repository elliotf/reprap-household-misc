include <../lib/util.scad>;

module tile_holder(num_players) {
  /*
   * 1 bee
   * 3 ants
   * 3 grasshoppers
   * 2 spiders
   * 2 beetles
   * 1 mosquito
   * 1 pillbug
   * 1 ladybug
   */
  num_tiles_per_player = 14;
  num_tiles = num_tiles_per_player*num_players;

  extrusion_width = 0.55;
  wall_thickness = extrusion_width*2*num_players;
  tile_width = 41;
  tile_height = 12;
  tile_gap = 0.5;
  num_columns = 2;
  base_height = 2;

  inner_diam = tile_width+tile_gap*2;
  inner_height = (round(num_tiles/num_columns))*tile_height;

  echo("tile_height: ", tile_height);
  echo("inner_height: ", inner_height);

  outer_diam = inner_diam+wall_thickness*2;
  outer_height = inner_height+base_height;

  function getCornerToCorner(diam) = 2 * (diam/2) / sqrt(3);

  inner_corner_to_corner = getCornerToCorner(inner_diam+wall_thickness);
  outer_corner_to_corner = getCornerToCorner(outer_diam);

  x_spacing = (inner_diam + wall_thickness);
  rubber_band_clip_short_height = 4;
  rubber_band_clip_height = rubber_band_clip_short_height*2+3;
  rubber_band_clip_thickness = extrusion_width*8;
  rubber_band_clip_spacing = inner_diam-rubber_band_clip_thickness-10;

  module position_stack() {
    translate([0,inner_corner_to_corner,0]) {
      children();
    }
  }

  module body() {
    hull() {
      for(x=[left,right]) {
        translate([x*x_spacing/2,0,0]) {
          hole(outer_diam,outer_height,6);
        }
      }
    }
    for(y=[front,rear]) {
      for(x=[left,right]) {
        translate([x*(rubber_band_clip_spacing/2),y*(outer_corner_to_corner),outer_height/2]) {
          hull() {
            translate([0,-y*1,-rubber_band_clip_height/2]) {
              cube([rubber_band_clip_thickness,2,rubber_band_clip_height],center=true);
            }
            translate([0,y*(rubber_band_clip_height-rubber_band_clip_short_height)*1.3,-rubber_band_clip_short_height/2]) {
              hole(rubber_band_clip_thickness,rubber_band_clip_short_height,16);
            }
          }
        }
      }
    }
  }

  module holes() {
    for(x=[left,right]) {
      translate([x*(x_spacing/2),0,0]) {
        translate([0,0,outer_height/2]) {
          hole(inner_diam,inner_height*2,6);
        }

        translate([x*outer_diam*0.1,0,-outer_height/2]) {
          hole(inner_diam*0.75,base_height*3,8);
        }

        translate([x*outer_diam*0.6,0,0]) {
          rotate([0,0,90]) {
            hole(outer_diam,outer_height*2,6);
          }
        }
      }

      translate([0,0,outer_height/2]) {
        hull() {
          translate([x*((rubber_band_clip_spacing+rubber_band_clip_thickness)/2+50),0,50]) {
            cube([100,100,100],center=true);
          }
          translate([x*(outer_diam+50),0,-tile_height/2+50]) {
            cube([100,100,100],center=true);
          }
        }
      }
    }

    for(y=[front,rear]) {
      hull() {
        translate([0,0,outer_height/2-rubber_band_clip_height-1]) {
          translate([0,y*(outer_corner_to_corner+1),0]) {
            cube([inner_diam+wall_thickness,2,2],center=true);
          }
        }
        translate([0,0,-outer_height/2+base_height+1]) {
          translate([0,y*(outer_corner_to_corner+1),0]) {
            cube([inner_diam+wall_thickness,2,2],center=true);
          }
        }
        translate([0,y*(inner_corner_to_corner*1.5+(outer_corner_to_corner-inner_corner_to_corner)),-rubber_band_clip_height]) {
          hole(inner_diam+wall_thickness,0.3*outer_height,6);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module single_player() {
  tile_holder(1);
}

module double_player() {
  tile_holder(2);
}

double_player();
