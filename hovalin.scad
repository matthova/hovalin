neck_length = 290;
neck_width = 28.6;
neck_top_arch_rad = 3;
neck_top_rad = (pow(neck_width,2) + 4*pow(neck_top_arch_rad,2))/(8*neck_top_arch_rad);
neck_bot_arch_rad = 12;
neck_bot_rad = (pow(neck_width,2) + 4*pow(neck_bot_arch_rad,2))/(8*neck_bot_arch_rad);
bridge_width = 47;
bridge_top_arch_rad = 10;
bridge_top_rad = (pow(bridge_width,2) + 4*pow(bridge_top_arch_rad,2))/(8*bridge_top_arch_rad);
bridge_bot_arch_rad = 25;
bridge_bot_rad = (pow(bridge_width,2) + 4*pow(bridge_bot_arch_rad,2))/(8*bridge_bot_arch_rad);
bot_angle = atan2((bridge_bot_arch_rad - neck_bot_arch_rad), neck_length);
neck_to_nut = 115;
nut_rad = 26/2;
nut_to_neck = 32;
fretboard_thick = 4;
slice = .1;
nudge = 0.0001;
precision = 200;

intersection(){
rotate([0,atan2((bridge_width-neck_width)/2,neck_length),0])
union(){
	hull(){
		neck_slice();

		translate([0,0,neck_length - slice])
		bridge_slice();
	}

	nut();
}
translate([-100,-100,0])
cube([200,200,220]);
}

module nut(){
	translate([0,-(neck_to_nut + nut_rad)*sin(bot_angle)+10*cos(bot_angle),(neck_to_nut + nut_rad)*cos(bot_angle) +10*sin(bot_angle)])
	rotate([bot_angle,0,0])
	union(){
		translate([-nut_rad,-15 - neck_bot_arch_rad,0])
		cube([nut_rad*2,20,neck_length - neck_to_nut - nut_rad]);

		translate([0,-neck_bot_arch_rad,0])
		rotate([90,0,0])
		cylinder(r = nut_rad, h = 15, $fn = precision);

		translate([0,-15 - neck_bot_arch_rad,0])
		scale([1,.5,1])
		union(){
			sphere(r = nut_rad, $fn = precision);
			cylinder(r = nut_rad, h = neck_length - neck_to_nut - nut_rad, $fn = precision);
		}
	}
}

module neck_slice(){
	intersection(){
		translate([-neck_width/2,fretboard_thick,0])
		cube([neck_width,neck_top_arch_rad*2,slice]);
		translate([0,fretboard_thick-neck_top_rad+neck_top_arch_rad,0])
		cylinder(r = neck_top_rad, h = slice, $fn = precision);
	}
	//translate([-neck_width/2,0,0])
	//cube([neck_width,fretboard_thick,slice]);

	intersection(){
		translate([-neck_width/2,-neck_bot_arch_rad,0])
		cube([neck_width,neck_bot_arch_rad,slice]);
		translate([0,neck_bot_rad-neck_bot_arch_rad,0])
		cylinder(r = neck_bot_rad, h = slice, $fn = precision);
	}
}

module bridge_slice(){	
	intersection(){
		translate([-bridge_width/2,fretboard_thick,0])
		cube([bridge_width,bridge_top_arch_rad*2,slice]);
		translate([0,fretboard_thick-bridge_top_rad+bridge_top_arch_rad,0])
		cylinder(r = bridge_top_rad, h = slice, $fn = precision);
	}
	//translate([-bridge_width/2,0,0])
	//cube([bridge_width,fretboard_thick,slice]);

	intersection(){
		translate([-bridge_width/2,-bridge_bot_arch_rad,0])
		cube([bridge_width,bridge_bot_arch_rad,slice]);
		translate([0,bridge_bot_rad-bridge_bot_arch_rad,0])
		cylinder(r = bridge_bot_rad, h = slice, $fn = precision);
	}
}
		//translate([-neck_width/2, neck_width/2 -neck_top_arch_rad, 0])
		//cube(neck_width);

module neck_nut(){
	rotate([-90,0,0])
	rotate_extrude($fn = precision){
		nut_slice();
	}
	linear_extrude(height = neck_length - neck_to_nut){
		nut_slice();
	}
}

module nut_slice(){
	half();
	mirror([1,0])
	half();
}

module half(){
	translate([0,nut_rad])
	intersection(){
		circle(r = nut_rad, $fn = precision);
		translate([-nut_rad,0])
		square([nut_rad, nut_rad]);
	}

	difference(){
		translate([-nut_rad*2,0])
		square([nut_rad*2,nut_rad]);
	
		translate([-nut_rad*2,nut_rad])
		circle(r = nut_rad, $fn = precision);
	}
}		
