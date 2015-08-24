sheet_thickness = 4.9;

front  = -1;
rear   = 1;
top    = 1;
bottom = -1;
left   = -1;
right  = 1;

num_shelves = 3;

spice_height = 115;
spice_width  = 52;
shelf_depth  = 60;

total_height = 393;
total_width  = 305;

shelf_width   = spice_width * 6;
shelf_spacing = 125; //spice_height + 10 + sheet_thickness;

backing_sheet_height = shelf_spacing * num_shelves - sheet_thickness/2;

shelf_tilt = 5;

