// Uncomment and generate the STL files from each of 
// these parts. TODO: Generate this file (or something
// like it) from a script
//
use <WinderMetricWolfe.scad>

//test_block_stl();

//rotate([180, 0 , 0]) drive_gear_stl();
//mid_gear_stl();
//rotate([180, 0 , 0]) input_gear_stl();
rotate([0, 90, 0]) rotate([0, 0, -45]) drive_pin_stl();

//case_top_stl();
//rotate([180, 0 , 0]) case_bottom_stl();
//rotate([180, 0 , 0]) case_label_stl();
//spacer_tube_stl();

//rotate([180, 0 , 0]) crank_arm_stl(); //for one color print
//rotate([180, 0 , 0]) crank_arm_logo_only_stl(); //for two color print
//rotate([0, 0, 0]) crank_knob_stl();
//crank_pin_stl();
