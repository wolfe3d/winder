// Design of a 10:1 motor winder for small rubber powerd
// model planes. Designed so all the part fit on a small
// 10x10x10cm 3D printer.

//Wolfes modifications
//Supported hole in crank knob and removed other supports
//Made metric for M3s
//Added more tolerance for parts that should rotate around holes.  This reduces need for drilling
//Made spacer width from 14mm to 15mm to allow for washers that reduce friction on gears.  Without washers the entire gear pressing against the case bottom and top.
//Made 15:1 gear ratio
//Added 15:1 label
//Changed circular pitch to 225
//Added option to make either 10:1 or 15:1
//Made option to use either 225 or 300 circular pitch
//made SciOly logo


use <fillets.scad>
use <GearSet.scad>
use <Metric_HardwareM3.scad>

IN_TO_MM = 25.4;
$fn = 48;

//Set the build as either 10:1 or 15:1 (actually 15.1:1)
isFifteen = 0; //0=10:1; 1=15:1
//set to larger size, Large size uses 300 circular pitch and smaller size uses 225 circular pitch for gears
isLarge = 0; //recommend use smaller size for 15:1

// Each gear's pitch diameter (Pitch radius *2)
//Pitch radius is output by gears function.  Find the Echo statements
gearDrive_dia = (isFifteen ? (isLarge ? 8.33333:6.25) :(isLarge ? 7.5:5.625))*2; //Drive Gear and attached to midgear
gearMid_dia = (isFifteen ? (isLarge ? 30:22.5): (isLarge ? 22.5:16.875))*2;
gearIn_dia = (isFifteen ? (isLarge ? 35:26.25) : (isLarge ? 25:18.75))*2;

/*if (isFifteen)
{
	//Reminder to self.  This does not work.  Variables set inside if statement in OpenScad only work inside brackets and are not used outside of brackets.
	//This is why single line if then statements are used as in the above lines.
}*/

//Crank arm default length is 75
crank_arm_length = 50;

// a little extra spacing to account for printing
gear_slop = .5;

// Clearence around the gears for the case
case_clearence = 4;

// increase sizes around hardware for printing inaccuracies
tolerance = 0.1;

// Diameter of the 1/8" shaft hardware
shaft_dia = (1/8 * IN_TO_MM) + tolerance;

// Diameter of the 1/8" shaft hole for free rotation
shaft_dia_free = shaft_dia + 0.2;

//Dimensions of square nut used in drive gear
squareNutDimension = [5.5+tolerance,2.4+tolerance,5.5+tolerance];

// Display Transparency (alpha)
alpha = 1;

// Place the screw around the case shell 
screw1_pos = [(gearDrive_dia+gearIn_dia)/4+8, gearMid_dia/4 +(gearDrive_dia+gearMid_dia)/4+5.6, 0];
screw2_pos = [(gearDrive_dia+gearIn_dia)/4-2.5, -(gearMid_dia+gearIn_dia)/4-2.05, 0];
screw3_pos = [-(gearDrive_dia+gearMid_dia)/4+1.7, (gearDrive_dia+gearMid_dia+gearMid_dia)/4, 0];

// Each Gear's position, this defines the basic case size 
mid_gear_pos = [0, 0, 0,];
input_gear_pos = [gear_slop + (gearIn_dia+gearDrive_dia)/2, 0, 0];
drive_gear_pos = [0, gear_slop + (gearMid_dia+gearDrive_dia)/2, 0];

// View the complete assembly (don't print this)
rotate([90, 0, -90]) assembly_drawing();

// Prints the test block / bending jig
//translate([50, -50, 0]) test_block_stl();

// Working view of case bottom
//rotate([180, 0, 0]) case_bottom_stl();

// Working view of case top
//rotate([0, 0, 0]) case_top_stl();

// Re-oriented drive pin for printing
//rotate([90, 135, 0]) drive_pin_stl();

// Some work on the cank knob assembly..
//rotate([180, 0, 0]) crank_knob_stl();
//translate([0, 0, 18]) rotate([180, 0, 0]) crank_pin_stl();
//crank_arm_stl();

// Show the gears
//drive_train();

// Winder Assembly Drawing
module assembly_drawing() {
    translate([0, 0, 14]) case_top_stl();
    translate([0, 0, .5]) drive_train();
    translate([0, 0, -3]) case_bottom_stl();
	translate([0, 0, -3]) case_label_stl();
    translate([0, 0, -4]) case_spacers();
    translate(input_gear_pos) {
        translate([0, 0, -24]) crank_arm_stl();
		translate([0, 0, -24]) crank_arm_logo_only_stl();
        translate([-(crank_arm_length), 0, -29.5]) crank_knob_stl();
        translate([-(crank_arm_length), 0, -48]) crank_pin_stl();
        translate([0, 0, -24]) drive_pin_stl(); 
    }
}


// prints a 36x18x24 mm block with a few holes to 
// determine if any extra tolerance in needed. Also
// can be used as a bending jig for the winder hook
module test_block_stl() {
    difference () {
        union () {
            cube([36, 18, 24]);
            translate([9, 9, 24]) cylinder(h=6, r1=9, r2=9);
        }
        
        // screw hole
        #translate([28, -.05, 12]) 
            rotate([-90, 0, 0]) screw_and_nut(18.1, tol = tolerance);
        
        // offset pin
        #translate([18+1.5*shaft_dia, 9, 0]) 
            cylinder(h=30, r1=shaft_dia/2, r2=shaft_dia/2, $fn=24);
        
        // centered pin
        #translate([9, 9, -.5]) 
            cylinder(h=31, r1=shaft_dia/2, r2=shaft_dia/2, $fn=24);
        
        // vertical slot
        #translate([22,8.5,0]) cube([15, 1, 30]);
    }
}


module crankshaft_core(tol = 0.0) {
    translate([0, 0, -3.1])
        linear_extrude (40.1)
            rotate([0, 0, 45]) square(8+tol, center=true);
    translate([0, 0, 10])
        cylinder(14, 8*sqrt(2)/2+tol, 8+tol);
    
}


module drive_pin_stl() {
    rotate([0, 0, 45])
        difference() {
            rotate([0,0,-45])
                crankshaft_core();

            linear_extrude(30)
                translate([8,0,0])
                    square([8,14], center=true);
            #translate([0, 0, 18])
                cylinder(25, shaft_dia_free/2, shaft_dia_free/2);
        }

}


module crank_arm_stl() {
    difference () {
        union() {
            minkowski() {
               linear_extrude (6) {
                    circle(8);
                    translate([-(crank_arm_length), 0, 0]) circle(8);
                    translate([-(crank_arm_length), -5, 0]) square([crank_arm_length,10]);
                }
                sphere(2);
            }
            translate([0, 0, -3]) {
                linear_extrude (1) {
                    circle(8);
                    translate([-(crank_arm_length), 0, 0]) circle(7);
                }
            }
        }
        crankshaft_core(tol=tolerance);
        translate([-(crank_arm_length), 0, -23]) machine_screw(33, tol=tolerance);
        translate([-(crank_arm_length), 0, 5.25]) hex_nut(tol=tolerance);
		holeSupports([-(crank_arm_length),0,5.25], 10, 3.5); //added by Wolfe to support nut hole
    }
}

module crank_arm_logo_only_stl() {
	color("Blue", 1) {
		difference () {
			union() {
				translate([-4, -21, -3])//change position of name here
					linear_extrude (1)
						scale([crank_arm_length/50,1,1])
							rotate([0,180,0])
								import("scioly.dxf");
			}
		}
	}
}


module crank_knob_stl() {
    translate([0, 0, -2]) {
        rotate([180, 0, 90]) {
            difference () {
                union () {
                    minkowski() {
                        linear_extrude (20)
                            intersection() {
                                square ([26,12], center=true);
                                circle(13);
                            }
                        sphere(1);
                    }
                    translate([0, 0, -4]) cylinder(4, 7, 7);
                }
                translate([-20, 45.75, 10]) 
                    rotate([0, 90, 0]) cylinder(40, 40, 40, $fn = 96);
                translate([-20, -45.75, 10]) 
                    rotate([0, 90, 0]) cylinder(40, 40, 40, $fn = 96);
                translate([0, 0, 10]) cylinder(14, 5, 5);
                translate([0, 0, -6]) cylinder(32, 3.5, 3.5);
				holeSupports([0,0,9.8], 10, 7); //added by Wolfe hole support inside
                //translate([-10, 0, 0]) cube([20,10,30]);
            }
            //Inside supports
            //translate([-4.5, -.5, 12]) cube([9, 1, 13]);
            //translate([-.5, -4.5, 12]) cube([1, 9, 13]);
            //Outside supports **Original - removed by Wolfe
            /*translate([6, -5, -4]) cube([6, 1, 3]);
            translate([7.5, -.5, -4]) cube([5, 1, 3]);
            translate([6, 4, -4]) cube([6, 1, 3]);
            
            translate([-12, -5, -4]) cube([6, 1, 3]);
            translate([-12.5, -.5, -4]) cube([5, 1, 3]);
            translate([-12, 4, -4]) cube([6, 1, 3]);*/
        }
		
    }
	
}


module crank_pin_stl()
{
    translate([0, 0, 2]) 
    difference () {
        union() {
            cylinder(3, 4.5, 4.5);
            cylinder(20, 3, 3);
        }
        machine_screw(33, tol=tolerance);
    }
}


module case_top_stl() {
	 color(isFifteen ? "Red" : "Blue", 1) {
        difference () {
            fillet(r=2,steps=6) {
                minkowski() {
                    case_shell();
                    rounding_upper(2);
                }
                translate([0, 0, 3.9])
                    translate(drive_gear_pos) cylinder(15, 6, 4);
            }
            // Shaft Positions
            translate(drive_gear_pos) cylinder(40, shaft_dia_free/2, shaft_dia_free/2);
            translate(input_gear_pos) cylinder(3, shaft_dia_free/2, shaft_dia_free/2); //Wolfe edited from 55 to 2
            translate(mid_gear_pos) cylinder(3, shaft_dia_free/2, shaft_dia_free/2);//Wolfe edited from 25 to 2
            
            // Screw positions
            #translate([0, 0, 5]) {
                translate(screw1_pos) rotate([180, 0, 0]) machine_screw(21, tol=tolerance);
                translate(screw2_pos) rotate([180, 0, 0]) machine_screw(21, tol=tolerance);
				if(isFifteen||isLarge)
				{
					translate(screw3_pos) rotate([180, 0, 0]) machine_screw(21, tol=tolerance);
				}
            }    
        }
    }
}


module case_bottom_stl() {
    color(isFifteen ? "Red" : "Blue", 1) {
        difference () {
            fillet(r=2,steps=6) {
                minkowski() {
                    case_shell();
                    rounding_lower(2);
                }
                translate([0, 0, -10.9])
                    translate(input_gear_pos) cylinder(9, 8, 8);
            }
            translate([0, 0, -21])
                translate(input_gear_pos)
                    crankshaft_core(tol=tolerance);
		
           
            // Gear Axels
            translate([0, 0, 0]) { //changed from z=-7.5 to z=1 to cause hole to not pentrate
                translate(mid_gear_pos) cylinder(25, shaft_dia_free/2, shaft_dia_free/2);
                translate(drive_gear_pos) cylinder(40, shaft_dia_free/2, shaft_dia_free/2);
            }
            translate([0, 0, -2]) {
                translate(screw1_pos) {
                    #rotate([0, 0, -20]) hex_nut(tol = .1, solid=true);
                    translate([0, 0, 25]) rotate([180, 0, 0]) machine_screw(25);
                }
                translate(screw2_pos) {
                    #rotate([0, 0, -4.25]) hex_nut(tol = .1, solid=true);
                    translate([0, 0, 25]) rotate([180, 0, 0]) machine_screw(25);
                }
				if(isFifteen||isLarge)
				{
					translate(screw3_pos) {
						#hex_nut(tol = .1, solid=true);
						translate([0, 0, 25]) rotate([180, 0, 0]) machine_screw(25);
					}
				}
            }
        }
    }
}

module case_label_stl()
{
	color("White", 1) {	
		translate([25, -22, -3])
                linear_extrude (1)
                    //scale([.6,0.7,1])
                        rotate([0,180,0])
							if(isFifteen)
							{
								import("15to1.dxf");
							}
							else
							{
								import("10to1.dxf");
							}
	}
}


module case_spacers () {
    translate(screw1_pos) spacer_tube_stl();
    translate(screw2_pos) spacer_tube_stl();
	if(isFifteen||isLarge)
	{
		translate(screw3_pos) spacer_tube_stl();
	}
}


module spacer_tube_stl() {
	cylinder_dia = isFifteen ? 4 : 3;
    color(isFifteen ? "Blue" : "Red", 1) {
        difference ()  {
            translate([0, 0, 4]) cylinder(15, cylinder_dia, cylinder_dia);
            machine_screw(22);
        }
    }
}

module rounding_lower(rr) {
    difference() {
        sphere(rr);
        translate([-rr, -rr, 0])
            cube([rr*2,rr*2,rr]);
    }
}


module rounding_upper(rr) {
    difference() {
        sphere(rr);
        translate([-rr, -rr, -rr]) cube([rr*2,rr*2,rr]);
    }
}


module case_shell() {
    linear_extrude(3) {
        hull() {
            translate(input_gear_pos) circle(case_clearence+gearIn_dia/2, $fn=48);
            translate(mid_gear_pos) circle(case_clearence+gearMid_dia/2, $fn=48);
            translate(drive_gear_pos) circle(case_clearence+gearDrive_dia/2);
        }
    }
}


module place_shafts() {
    // Gear Axels
    #translate([0, 0, -7.5]) {
        translate([0, 0, -20])
            translate(input_gear_pos) cylinder(55, shaft_dia/2, shaft_dia/2);
        translate(mid_gear_pos) cylinder(25, shaft_dia/2, shaft_dia/2);
        translate(drive_gear_pos) cylinder(42, shaft_dia/2, shaft_dia/2);
    }
}


module drive_train()
{
    rotate([0, 0, 60]) mid_gear_stl();
    translate(input_gear_pos) rotate([0, 0, 90]) input_gear_stl();
    translate(drive_gear_pos)  drive_gear_stl();
}


module mid_gear_stl() {
    color("Goldenrod", alpha) {
        difference() {
/*
            union () {
                linear_extrude(5) gearMid_profile();
                translate([0,0,5]) linear_extrude(7) gearDrive_profile();
            }
*/
			if (isFifteen)
			{
				if(isLarge)
				{
					gear3610(CP=300);
				}
				else
				{
					gear3610();
				}
			}
			else
			{
				if(isLarge)
				{
					gear2709(CP=300);
				}
				else
				{
					gear2709();
				}
			}
            translate([0,0,-6])
                cylinder(25, shaft_dia_free/2, shaft_dia_free/2);
        }
    }
}


module input_gear_stl() {
    color("Gold", alpha) {
        difference () {
/*
            union () {
                translate([0,0,6])
                    linear_extrude(6)
                        gearIn_profile();
                translate([0, 0, -1])
                    cylinder(7, 15/2, 15/2);
            }
*/
			if (isFifteen)
			{
				if(isLarge)
				{
					rotate([180,0,0]) translate([0,0,-12.9]) gear42(CP=300);
				}
				else
				{
					rotate([180,0,0]) translate([0,0,-12.9]) gear42();
				}
			}
			else
			{
				if(isLarge)
				{
					rotate([180,0,0]) translate([0,0,-12.9]) gear30(CP=300);
				}
				else
				{
					rotate([180,0,0]) translate([0,0,-12.9]) gear30();
				}
			}
            
            translate([0,0,-24])
                crankshaft_core(tol=tolerance);
        }
    }
}


module drive_gear_stl() {
    color("Sienna", alpha) {
        difference () {
/*
            union() {
                linear_extrude(7)
                    gearDrive_profile();
                translate([0,0,7])
                    cylinder(5.9, 17.51/2, 17.51/2);
            }
*/
            rotate([180,0,0]) translate([0,0,-13]) 
			if (isFifteen)
			{
				if(isLarge)
				{
					gear10(CP=300);
				}
				else
				{
					gear10();
				}
			}
			else
			{
				if(isLarge)
				{
					gear9(CP=300);
				}
				else
				{
					gear9();
				}
			}
            translate([0,0,-6])
                cylinder(45, shaft_dia/2, shaft_dia/2);
            translate([0, shaft_dia/2, 10])
               #rotate([-90, 180, 0]){
                    translate([0,0,10.5]) rotate([180,0,0])  machine_screw(12);
                    //hex_nut_slot(5);
                }
			translate([0,3.6,16.01-squareNutDimension[2]]){
				cube(size=squareNutDimension, center=true);	
			}
			//two small holes removed by wolfe
            //translate([-6,0,11.5]) cylinder(2.5, 3.35/2, 3.25/2);
            //translate([ 6,0,11.5]) cylinder(2.5, 3.35/2, 3.25/2);
                
        }
    }
}
//This module cuts a square and a rectangle in a cylinder near a hole in a bridge, so that the support for the circumference of the hole is made.
module holeSupports(location, outsideD, holeD)  //outsideD = outside Diameter, holeD = hole Diameter
{
	translate(location)
	{
		translate([0,0,-0.3])
		{
			cube([holeD,holeD,0.45],true);
		}
		difference()
		{
			cube([holeD,outsideD,0.45],true);
			translate([0,0,-0.25])
			{
				difference()
				{		
					//creates a outside ring
					cylinder(h=0.5, d=outsideD*2, $fn=96);
					cylinder(h=0.5, d=outsideD, $fn=96);
				};
			};
		};
	};
}