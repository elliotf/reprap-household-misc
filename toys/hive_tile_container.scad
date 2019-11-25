include <./lib/util.scad>;


module v1() {
  wall_thickness = 0.8;
  tile_width = 41;
  tile_height = 12;
  tile_gap = 0.5;
  num_tiles = 16;
  num_columns = 2;
  base_height = 2;

  inner_diam = tile_width+tile_gap*2;
  inner_height = (round(num_tiles/num_columns))*(tile_height+tile_gap);

  outer_diam = inner_diam+wall_thickness*2;
  outer_height = inner_height+base_height;

  function getCornerToCorner(diam) = 2 * (diam/2) / sqrt(3);

  inner_corner_to_corner = getCornerToCorner(inner_diam);
  outer_corner_to_corner = getCornerToCorner(outer_diam);

  module body() {
    hull() {
      for(x=[left,right]) {
        translate([x*inner_diam/2,0,0]) {
          hole(outer_diam,outer_height,6);
        }
      }
    }
  }

  module holes() {
    for(x=[left,right]) {
      translate([x*inner_diam/2,0,0]) {
        translate([0,0,outer_height/2]) {
          hole(inner_diam,inner_height*2,6);
        }
        translate([0,0,-outer_height/2]) {
          hole(inner_diam*0.75,base_height*3,6);
        }
      }
    }

    for(y=[front,rear]) {
      hull() {
        translate([0,y*(inner_corner_to_corner*1.5+(outer_corner_to_corner-inner_corner_to_corner)),outer_height/2+1]) {
          hole(inner_diam,2,6);
        }
        translate([0,y*(outer_corner_to_corner+1),-outer_height/2+1+base_height]) {
          cube([inner_diam,2,2],center=true);
        }
      }

      translate([0,y*outer_corner_to_corner,-outer_height/2]) {
        scale([2,1,1]) {
          rotate([y*-30,0,0]) {
            rotate([0,0,45]) {
              cube([10,10,100],center=true);
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module v2() {
  extrusion_width = 0.4;
  wall_thickness = extrusion_width*4;
  tile_width = 41;
  tile_height = 12;
  tile_gap = 0.5;
  num_tiles = 16;
  num_columns = 2;
  base_height = 2;

  inner_diam = tile_width+tile_gap*2;
  inner_height = (round(num_tiles/num_columns))*(tile_height+tile_gap);

  outer_diam = inner_diam+wall_thickness*2;
  outer_height = inner_height+base_height;

  function getCornerToCorner(diam) = 2 * (diam/2) / sqrt(3);

  inner_corner_to_corner = getCornerToCorner(inner_diam+wall_thickness);
  outer_corner_to_corner = getCornerToCorner(outer_diam);

  x_spacing = (inner_diam + wall_thickness);

  rubber_band_groove_diam = tile_width/2;
  rubber_band_groove_width = 3;
  rubber_band_groove_depth = 0;

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
  }

  module holes() {
    for(x=[left,right]) {
      translate([x*(x_spacing/2),0,0]) {
        translate([0,0,outer_height/2]) {
          hole(inner_diam,inner_height*2,6);
        }

        translate([x*outer_diam*0.1,0,-outer_height/2]) {
          hole(inner_diam*0.5,base_height*3,12);
        }

        translate([x*outer_diam*0.6,0,0]) {
          rotate([0,0,90]) {
            hole(outer_diam,outer_height*2,6);
          }
        }
      }
    }

    for(y=[front,rear]) {
      hull() {
        translate([0,y*(outer_corner_to_corner+1),outer_height/2-5]) {
          cube([inner_diam+wall_thickness,2,2],center=true);
        }
        translate([0,y*(inner_corner_to_corner*1.5+(outer_corner_to_corner-inner_corner_to_corner)),0]) {
          hole(inner_diam+wall_thickness,outer_height*0.3,6);
        }
        translate([0,y*(outer_corner_to_corner+1),-outer_height/2+rubber_band_groove_depth+4+base_height]) {
          cube([inner_diam+wall_thickness,2,2],center=true);
        }
      }

      for(x=[left,right]) {
        translate([x*(inner_diam*0.25),y*(outer_corner_to_corner),outer_height/2]) {
          scale([1,1,outer_height/2]) {
            hull() {
              cube([rubber_band_groove_width,rubber_band_groove_width,1],center=true);

              translate([0,-y*(rubber_band_groove_width),0]) {
                hole(rubber_band_groove_width,1,16);
              }
            }
          }
        }
      }

      rotate([y*10,0,0]) {
        translate([0,y*(inner_corner_to_corner+(outer_corner_to_corner-inner_corner_to_corner)-rubber_band_groove_diam*.2),-outer_height/2]) {
          scale([1,1,rubber_band_groove_depth*2]) {
            rotate([0,0,90]) {
              difference() {
                hole(rubber_band_groove_diam,1,6);
                hole(rubber_band_groove_diam-rubber_band_groove_width*2,2,6);
              }
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module v3() {
  extrusion_width = 0.4;
  wall_thickness = extrusion_width*4;
  tile_width = 41;
  tile_height = 12;
  tile_gap = 0.5;
  num_tiles = 16;
  num_columns = 3;
  base_height = 2;

  inner_diam = tile_width+tile_gap*2;
  inner_height = (round(num_tiles/num_columns))*(tile_height+tile_gap);

  outer_diam = inner_diam+wall_thickness*2;
  outer_height = inner_height+base_height;

  function getCornerToCorner(diam) = 2 * (diam/2) / sqrt(3);

  inner_corner_to_corner = getCornerToCorner(inner_diam+wall_thickness);
  outer_corner_to_corner = getCornerToCorner(outer_diam);

  x_spacing = (inner_diam + wall_thickness);

  rubber_band_groove_diam = tile_width/2;
  rubber_band_groove_width = 3;
  rubber_band_groove_depth = 0;

  module position_stack() {
    translate([0,inner_corner_to_corner,0]) {
      children();
    }
  }

  module body() {
    for(r=[0,120,240]) {
      rotate([0,0,r]) {
        position_stack() {
          hole(outer_diam,outer_height,6);
        }
      }
    }
    /*
    //hull() {
      for(x=[left,right]) {
        translate([x*x_spacing/2,0,0]) {
          hole(outer_diam,outer_height,6);
        }
      }
    //}
    */
  }

  module holes() {
    for(r=[0,120,240]) {
      rotate([0,0,r]) {
        position_stack() {
          translate([0,0,outer_height/2]) {
            hole(inner_diam,inner_height*2,6);
          }

          translate([0,0,0]) {
            translate([0,outer_diam*0.1,-outer_height/2]) {
              // hole(inner_diam*0.5,base_height*3,12);
            }

            translate([0,inner_diam*0.6,0]) {
              scale([0.8,1,1]) {
                rotate([0,0,90]) {
                  hole(inner_diam,outer_height*2,64);
                }
              }
            }
          }
        }
      }
    }
  /*
    for(x=[left,right]) {
      translate([x*(x_spacing/2),0,0]) {
        translate([0,0,outer_height/2]) {
          hole(inner_diam,inner_height*2,6);
        }

        translate([x*outer_diam*0.1,0,-outer_height/2]) {
          //hole(inner_diam*0.5,base_height*3,12);
        }

        translate([x*outer_diam*0.6,0,0]) {
          rotate([0,0,90]) {
            //hole(outer_diam,outer_height*2,6);
          }
        }
      }
    }
    */

    for(y=[front,rear]) {
      /*
      hull() {
        translate([0,y*(inner_corner_to_corner*1.5+(outer_corner_to_corner-inner_corner_to_corner)),outer_height/2+1]) {
          hole(inner_diam+wall_thickness,2,6);
        }
        translate([0,y*(outer_corner_to_corner+1),-outer_height/2+rubber_band_groove_depth+4+base_height]) {
          cube([inner_diam+wall_thickness,2,2],center=true);
        }
      }

      translate([0,y*(inner_corner_to_corner+(outer_corner_to_corner-inner_corner_to_corner)),-outer_height/2]) {
        scale([1,1,rubber_band_groove_depth*2]) {
          rotate([0,0,90]) {
            difference() {
              hole(rubber_band_groove_diam,1,6);
              hole(rubber_band_groove_diam-rubber_band_groove_width*2,2,6);
            }
          }
        }
      }
      */
    }
  }

  difference() {
    body();
    holes();
  }
}

module v4() {
  extrusion_width = 0.4;
  wall_thickness = extrusion_width*4;
  tile_width = 41;
  tile_height = 12;
  tile_gap = 0.5;
  num_tiles = 16;
  num_columns = 2;
  base_height = 2;

  inner_diam = tile_width+tile_gap*2;
  inner_height = (round(num_tiles/num_columns))*tile_height;

  outer_diam = inner_diam+wall_thickness*2;
  outer_height = inner_height+base_height;

  function getCornerToCorner(diam) = 2 * (diam/2) / sqrt(3);

  inner_corner_to_corner = getCornerToCorner(inner_diam+wall_thickness);
  outer_corner_to_corner = getCornerToCorner(outer_diam);

  x_spacing = (inner_diam + wall_thickness);

  rubber_band_groove_diam = tile_width/2;
  rubber_band_groove_width = 3;
  rubber_band_groove_depth = 6;

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
  }

  module holes() {
    for(x=[left,right]) {
      translate([x*(x_spacing/2),0,0]) {
        translate([0,0,outer_height/2]) {
          hole(inner_diam,inner_height*2,6);
        }

        translate([x*outer_diam*0.1,0,-outer_height/2]) {
          hole(inner_diam*0.5,base_height*3,12);
        }

        translate([x*outer_diam*0.6,0,0]) {
          rotate([0,0,90]) {
            hole(outer_diam,outer_height*2,6);
          }
        }
      }
    }

    for(y=[front,rear]) {
      hull() {
        for(z=[top,bottom]) {
          translate([0,y*(outer_corner_to_corner+1),z*(outer_height/2-5)]) {
            cube([inner_diam+wall_thickness,2,2],center=true);
          }
        }
        translate([0,y*(inner_corner_to_corner*1.5+(outer_corner_to_corner-inner_corner_to_corner)),0]) {
          hole(inner_diam+wall_thickness,outer_height*0.5,6);
        }
      }

      for(x=[left,right]) {
        translate([x*(inner_diam*0.3),y*(outer_corner_to_corner),outer_height/2]) {
          rotate([0,0,y*x*-60]) {
            scale([1,1,outer_height/2]) {
              hull() {
                cube([rubber_band_groove_width,rubber_band_groove_depth,1],center=true);

                translate([0,-y*(rubber_band_groove_depth),0]) {
                  hole(rubber_band_groove_width,1,16);
                }
              }
            }
          }
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}


module v5() {
  extrusion_width = 0.6;
  wall_thickness = extrusion_width*2;
  tile_width = 41;
  tile_height = 12;
  tile_gap = 0.5;
  num_tiles = 14;
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
  rubber_band_clip_height = rubber_band_clip_short_height*2+1;
  rubber_band_clip_thickness = wall_thickness*2;
  rubber_band_clip_spacing = inner_diam-rubber_band_clip_thickness/2-10;

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
            translate([0,-y*rubber_band_clip_thickness/2,-rubber_band_clip_height/2]) {
              hole(rubber_band_clip_thickness,rubber_band_clip_height,16);
            }
            translate([0,y*rubber_band_clip_short_height,-rubber_band_clip_short_height/2]) {
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

        translate([0,0,-outer_height/2]) {
          hole(inner_diam*0.75,base_height*3,6);
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
          hole(inner_diam+wall_thickness,outer_height*0.3,6);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

v5();
