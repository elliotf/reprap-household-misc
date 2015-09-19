include <config.scad>;

headset_z  = 500;

top_hole_z = 370;
mid_hole_z = 280;
low_hole_z = mid_hole_z - 220;
top_hole_spacing_x = 80;
mid_hole_spacing_x = 330;
low_hole_spacing_x = 350;

frame_side_center_x = mid_hole_spacing_x/2+37;
frame_side_center_z = 20;
frame_side_diam     = 30;

foot_clearance_width  = low_hole_spacing_x - 80;
foot_clearance_height = low_hole_z + 60;

plate_width = frame_side_center_x*2 + frame_side_diam + clearance*2;
