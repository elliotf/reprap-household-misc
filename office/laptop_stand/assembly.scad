include <./laptop_stand.scad>;

echo("extrusion_front_length: ", extrusion_front_length);
echo("extrusion_spine_length: ", extrusion_spine_length);
echo("extrusion_brace_length: ", extrusion_brace_length);
echo("extrusion_front_length (in): ", extrusion_front_length/25.4);
echo("extrusion_spine_length (in): ", extrusion_spine_length/25.4);
echo("extrusion_brace_length (in): ", extrusion_brace_length/25.4);

assembly();
