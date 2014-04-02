neck_top_width = 28.6;
neck_top_arch_rad = 6;
top_fret_arch_rad = (pow(neck_top_width,2) + 4*pow(neck_top_arch_rad,2))/(8*neck_top_arch_rad);
neck_base_width = 47;
neck_base_arch_rad = 10;
base_fret_arch_rad = (pow(neck_base_width,2) + 4*pow(neck_base_arch_rad,2))/(8*neck_base_arch_rad);
neck_length = 290;
neck_to_nut = 115;
nut_rad = 25;
nut_to_neck = 32;
fretboard_thick = 10;
slice = .1;
nudge = 0.0001;

rotate([0,atan2(neck_base_width-neck_top_width,neck_length)/2,0])
hull(){
	intersection(){
		translate([-top_fret_arch_rad,fretboard_thick,0])
		cube([top_fret_arch_rad*2,top_fret_arch_rad*2,slice]);
		translate([0,-top_fret_arch_rad+fretboard_thick+neck_top_arch_rad,0])
		cylinder(r = top_fret_arch_rad, h = slice, $fn = 100);
	}

	translate([-neck_top_width/2,0,0])
	cube([neck_top_width,fretboard_thick,slice]);

	intersection(){
		cylinder(r = neck_top_width/2, h = slice, $fn = 100);
		translate([-neck_top_width/2,-neck_top_width,0])
		cube(neck_top_width);		
	} 

	translate([0,0,neck_length - slice])
	union(){
		intersection(){
			translate([-base_fret_arch_rad,fretboard_thick,0])
			cube([base_fret_arch_rad*2,base_fret_arch_rad*2,slice]);
			translate([0,-base_fret_arch_rad+fretboard_thick+neck_base_arch_rad,0])
			cylinder(r = base_fret_arch_rad, h = slice, $fn = 100);
		}

		translate([-neck_base_width/2,0,0])
		cube([neck_base_width,fretboard_thick,slice]);

		intersection(){
			cylinder(r = neck_base_width/2, h = slice, $fn = 100);
			translate([-neck_base_width/2,-neck_base_width,0])
			cube(neck_base_width);		
		}
	} 
}
		//translate([-neck_top_width/2, neck_top_width/2 -neck_top_arch_rad, 0])
		//cube(neck_top_width);		
