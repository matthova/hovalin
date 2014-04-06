nut_rad = 10;

intersection(){
	union(){
//		cylinder(r = nut_rad, h = 10, $fn = 50);
		translate([0,0,10])
		intersection(){
			sphere(r = nut_rad, $fn = 50);
			translate([-nut_rad,-nut_rad,0])
			cube(nut_rad*2);
		}
		rotate_extrude($fn = 50){
			translate([nut_rad,0])
			difference(){
				square([nut_rad,nut_rad]);
				translate([nut_rad,nut_rad])
				circle(r = nut_rad);	
			}
		}
	}
	translate([-nut_rad*2,0,0])
	cube(nut_rad*4);
}