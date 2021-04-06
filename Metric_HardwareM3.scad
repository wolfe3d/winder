// A small module defining some #6 hardware shapes
// Use solid=true to get the ouerall size of a cutout
// Use tol = .1 (or similar) to allow for printer inaccuracy
// 
screw_and_nut(18.75, tol=0.0);
//hex_nut_slot(10);

diameter      = 3.2;
nut_outer_dia = 6.1;
nut_thickness = 3;
head_height = 3.2;
head_dia    = 6;


module screw_and_nut(length, tol=0.0) {
    translate ([0, 0, length-(nut_thickness+tol)]) 
        hex_nut(tol=tol, solid=false);
    machine_screw(length, tol=tol);
}

    
module hex_nut(tol = 0, solid = false) {
    linear_extrude (nut_thickness+tol) {
        difference () {
            circle(tol + nut_outer_dia/2, $fn = 6);
            if (!solid)
                circle(diameter/2, $fn = 24);
        }

    }
}


module machine_screw(length, tol=0)
{
    union() {
        translate([0, 0, tol]) {
            cylinder(head_height, tol+head_dia/2, tol+head_dia/2, $fn=24);
            cylinder(length-tol, tol+diameter/2, tol+diameter/2, $fn=24);
        }
        cylinder(tol+.01, tol+head_dia/2, tol+head_dia/2, $fn=24);
    }
}


module hex_nut_slot(length, tol = 0) {
    linear_extrude (nut_thickness+tol) {
        circle(tol + nut_outer_dia/2, $fn = 6);
        translate([-(tol + nut_outer_dia/2), 0, 0])
            square([tol + nut_outer_dia, length]);
    }
}

