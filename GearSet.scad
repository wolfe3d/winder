// Using the MCAD Involute gear module, this defines a set
// of compound gears the gives a 10:1 gear ratio. Starting
// with 30:9 and then 27:9. That is, 30 tooth drives a 9 
// tooth that is attached to 27 tooth that drives another
// 9 tooth. See TBD for description of method.
use <MCAD/involute_gears.scad>

$fn=48;

// This determines the size of the gear for a given number
// of teeth. The 9, 27, and 30 tooth gears designed to have
// pitch  pitch radii of 7.5mm, 22.5mm and 25mm. These
// values are used to establish the spacing for the shafts.
//CP = 225; //Circular Pitch

// preview 10:1 Whinder set
translate([0,0,0]) gear9();
translate([36,0,0]) gear2709();
translate([0,38,0]) gear30();

// preview 15.1:1Whinder set
//translate([0,0,0]) gear10();
//translate([36,0,0]) gear3610();
//translate([0,38,0]) gear42();

//translate([20,15,0]) cylinder(6,12,12);

// 9 tooth output gear with a block to accept a grub screw
// Pitch Dia is 15mm
module gear9(CP=225) //CP=Circular_pitch
{
    difference() {
        cylinder(r=9.2, h=5.9);
        cylinder(r=3.175/2,h=5.9);
    }
    translate([0,0,6]) gear(
        number_of_teeth=9,
        circular_pitch = CP,
        gear_thickness = 7.0,
        rim_thickness = 7.0,
        rim_width = 5,
        hub_thickness = 2,
        hub_diameter = 0,
        bore_diameter = 3.175,
        circles=0
    );
}

// 8 tooth output gear with a block to accept a grub screw
// Pitch Dia is 15mm
module gear8(CP=225)
{
    difference() {
        cylinder(r=9.2, h=5.9);
        cylinder(r=3.175/2,h=5.9);
    }
    translate([0,0,6]) gear(
        number_of_teeth=8,
        circular_pitch = CP,
        gear_thickness = 7.0,
        rim_thickness = 7.0,
        rim_width = 5,
        hub_thickness = 2,
        hub_diameter = 0,
        bore_diameter = 3.175,
        circles=0
    );
}

// 10 tooth output gear with a block to accept a grub screw
// Pitch Dia is 15mm
module gear10(CP=225)
{
    difference() {
        cylinder(r=9.2, h=5.9);
        cylinder(r=3.175/2,h=5.9);
    }
    translate([0,0,6]) gear(
        number_of_teeth=10,
        circular_pitch = CP,
        gear_thickness = 7.0,
        rim_thickness = 7.0,
        rim_width = 5,
        hub_thickness = 2,
        hub_diameter = 0,
        bore_diameter = 3.175,
        circles=0
    );
}

// Compound of 9 tooth and 27 tooth gears.
// Pitch Dia (outer) is 45mm
module gear2709(CP=225)
{
    translate([0,0,5])
        gear(
            number_of_teeth=9,
            circular_pitch = CP,
            gear_thickness = 7.0,
            rim_thickness = 8.0,
            rim_width = 5,
            hub_thickness = 2,
            hub_diameter = 0,
            bore_diameter = 3.175,
            circles=0
        );
    gear(
        number_of_teeth=27,
        circular_pitch = CP,
        gear_thickness = 5.0,
        rim_thickness = 6.0,
        rim_width = 2,
        hub_thickness = 5.0,
        hub_diameter = 11,
        bore_diameter = 3.175,
        circles=9
    );
}

// Compound of 8 tooth and 30 tooth gears.
// Pitch Dia (outer) is 45mm
module gear308(CP=225)
{
    translate([0,0,5])
        gear(
            number_of_teeth=8,
            circular_pitch = CP,
            gear_thickness = 7.0,
            rim_thickness = 8.0,
            rim_width = 5,
            hub_thickness = 2,
            hub_diameter = 0,
            bore_diameter = 3.175,
            circles=0
        );
    gear(
        number_of_teeth=30,
        circular_pitch = CP,
        gear_thickness = 5.0,
        rim_thickness = 6.0,
        rim_width = 2,
        hub_thickness = 5.0,
        hub_diameter = 17,
        bore_diameter = 3.175,
        circles=9
    );
}

// Compound of 8 tooth and 30 tooth gears.
// Pitch Dia (outer) is 45mm
module gear3610(CP=225)
{
    translate([0,0,5])
        gear(
            number_of_teeth=10,
            circular_pitch = CP,
            gear_thickness = 7.0,
            rim_thickness = 8.0,
            rim_width = 5,
            hub_thickness = 2,
            hub_diameter = 0,
            bore_diameter = 3.175,
            circles=0
        );
    gear(
        number_of_teeth=36,
        circular_pitch = CP,
        gear_thickness = 5.0,
        rim_thickness = 6.0,
        rim_width = 2,
        hub_thickness = 5.0,
        hub_diameter = 17,
        bore_diameter = 3.175,
        circles=9
    );
}


// Input gear of 30 teeth with a hub to accept the drive pin
// Pitch Dia is 50mm
module gear30(CP=225)
{
    gear(
        number_of_teeth=30,
        circular_pitch = CP,
        gear_thickness = 5.0,
        rim_thickness = 6.0,
        rim_width = 2,
        hub_thickness = 12.9,
        hub_diameter = 12.5,
        bore_diameter = 3.175,
        circles=10
    );
}

// Input gear of 32 teeth with a hub to accept the drive pin
// Pitch Dia is 50mm
module gear32(CP=225)
{
    gear(
        number_of_teeth=32,
        circular_pitch = CP,
        gear_thickness = 5.0,
        rim_thickness = 6.0,
        rim_width = 2,
        hub_thickness = 12.9,
        hub_diameter = 15,
        bore_diameter = 3.175,
        circles=10
    );
}

// Input gear of 42 teeth with a hub to accept the drive pin
// Pitch Dia is 50mm
module gear42(CP=225)
{
    gear(
        number_of_teeth=42,
        circular_pitch = CP,
        gear_thickness = 5.0,
        rim_thickness = 6.0,
        rim_width = 2,
        hub_thickness = 12.9,
        hub_diameter = 15,
        bore_diameter = 3.175,
        circles=10
    );
}