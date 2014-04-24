precision = 50;
nudge = 0.0001;

cube_x = 10;
cube_y = 150;
cube_z = 15;

truss_rad = 3.3;// 6.3/2;
truss_height = 9.3;
cube_lift = truss_height - truss_rad*2;

cylinder_length = 50;
truss_length = 376;
//success
//truss 3.3
//cylinder 4.8


//truss_rod();
module truss_rod(){
  rotate([-90,-90,0])
  union(){
    rotate([0,90,0])
    cylinder(r = 4.8, h = cylinder_length, $fn = precision);
  
    translate([0,-truss_rad,-cube_lift - truss_rad])
    hull(){
    	translate([0,truss_rad,truss_rad + cube_lift])
    	rotate([0,90,0])
    	cylinder(r = truss_rad, h = truss_length, $fn = precision);	//2.95 to 3.45 in 11 steps
    	cube([truss_length,truss_rad*2,truss_height - (truss_rad)*2]);
    }
  }
}


//cylinder_test();
module cylinder_test(){
	difference(){
		cube([cube_x, cube_y, cube_z]);
		translate([-nudge,10,cube_z/2])
		for(i = [0:9]){
			translate([0,i*13,0])
			rotate([0,90,0])
			cylinder(r = 4 + i*.1, h = cube_x + nudge*2, $fn = precision);
			echo(4 + i*.1);
		}
	}
}

//truss_test();
module truss_test(){
	difference(){
		cube([cube_x, cube_y, cube_z]);

		translate([-nudge,-3,(cube_z - truss_height)/2])
		for(i = [0:10]){
			hull(){
				translate([0,i*13 + 10 +(truss_rad - .2) + i*.05,(truss_rad - .2) + i*.05 + (truss_height - truss_rad*2)])
				rotate([0,90,0])
				cylinder(r = (truss_rad - .2) + i*.05, h = cube_x + nudge*2, $fn = precision);	//2.95 to 3.45 in 11 steps
				translate([0,i*13 + 10,0])
				cube([cube_x + nudge*2,((truss_rad - .2) + i*.05)*2,truss_height - (truss_rad)*2]);
				echo(r = (truss_rad - .2) + i*.05);
			}
		}
	}
}