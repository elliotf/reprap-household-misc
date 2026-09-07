include <lumpyscad/lib.scad>;

// these measurements aren't super accurate
bin_width = 170;
bin_depth = 308;
bin_height = 123;
bin_base_rounded_diam = 20;

//bin_lid_width = 195;
bin_lid_width = (7+3/4)*inch;
bin_lid_depth = 353;
bin_lid_height = 14;
bin_lid_rounded_diam = 40;

bin_opening_width = 8 * inch;
bin_opening_depth = 15 * inch;
bin_opening_height = (5 + 1 / 4) * inch; // maybe make this closer?

//sheet_thickness = 12; // ~1/2" plywood
sheet_thickness = 1/2*inch; // ~1/2" plywood
// sheet_thickness = 18; // ~3/4" plywood

module dummy_bin() {
  bin_base_width = 158;
  bin_base_depth = 295;

  bin_step_depth = 13;

  handle_width = 90;

  // lid
  color("#eee") {
    translate([0, 0, bin_lid_height / 2]) {
      rounded_cube(bin_lid_width, bin_lid_depth, bin_lid_height, bin_lid_rounded_diam);
    }

    // main body
    hull() {
      // top-ish
      translate([0, 0, -1]) {
        rounded_cube(bin_width, bin_depth, 2, bin_base_rounded_diam);
      }
      // bottom
      translate([0, 0, bin_lid_height - bin_height + 1]) {
        rounded_cube(bin_base_width, bin_base_depth, 2, bin_base_rounded_diam);
      }
    }
  }

  // step in body

  // handle?
}

module assembly(bins_wide = 1, bins_high = 1) {
  bin_spacing = 1 / 4 * inch;
  bin_cavity_width = bin_lid_width + bin_spacing;
  //bin_cavity_height = bin_height + bin_spacing;
  bin_cavity_height = 5*inch + bin_spacing;
  bin_spacing_x = bin_cavity_width + sheet_thickness;
  bin_spacing_z = bin_cavity_height;

echo("bin_cavity_width/inch: ", bin_cavity_width/inch);
echo("bin_spacing_x/inch: ", bin_cavity_width/inch);
echo("bin_cavity_width*bins_wide/inch: ", bin_cavity_width*bins_wide/inch);
echo("bin_spacing_x*bins_wide/inch: ", bin_spacing_x*bins_wide/inch);

  bin_support_strip_width = 1*inch;

  divider_height = bins_high * bin_spacing_z + bin_spacing;
  overall_width = bins_wide * bin_spacing_x + sheet_thickness;
  overall_height = divider_height + sheet_thickness * 2;
  overall_depth = 15 * inch;


  echo("total_bins: ", bins_wide*bins_high);
  echo("total_bin_rails: ", bins_wide*bins_high*2);
  echo("overall_width(inch): ", overall_width / inch);
  echo("overall_depth(inch): ", overall_depth / inch);
  echo("overall_height(inch): ", overall_height / inch);
  echo(str(bins_wide+1, "x dividers: ", overall_depth/inch, "*", divider_height/inch));
  echo(str(2, "x top/bottom: ", overall_depth/inch, "*", overall_width/inch));
  echo(str(bins_wide*bins_high*2, "x rails: ", bin_support_strip_width/inch, "*", overall_depth/inch));

  for (x = [0:bins_wide - 1]) {
    for (z = [0:bins_high - 1]) {
      translate([(x + 0.5) * bin_spacing_x, 0, bin_spacing - bin_lid_height + bin_height + bin_spacing / 2 + z * bin_spacing_z]) {
        %dummy_bin();

        for (x = [left, right]) {
          translate([x * (bin_cavity_width / 2 - sheet_thickness / 2), 0, -bin_support_strip_width / 2]) {
            color("orange") cube([sheet_thickness, overall_depth, bin_support_strip_width], center=true);
          }
        }
      }
    }
  }

  for (x = [0:bins_wide]) {
    translate([x * bin_spacing_x, 0, (overall_height - sheet_thickness * 2) / 2]) {
      color("green") cube([sheet_thickness, overall_depth, divider_height], center=true);
    }
  }
  translate([-sheet_thickness / 2 + overall_width / 2, 0, 0]) {
    translate([0, 0, -sheet_thickness / 2 - 1 / 16 * inch]) {
      color("red") cube([overall_width, overall_depth, sheet_thickness], center=true);
    }

    translate([0, 0, overall_height - sheet_thickness * 1.5 + 1 / 16 * inch]) {
      color("blue") cube([overall_width, overall_depth, sheet_thickness], center=true);
    }
  }
}

assembly(4, 8);
