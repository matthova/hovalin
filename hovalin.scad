slice = .1;
nudge = 0.0001;
precision = 100;
pi = 3.14159;

n_strings = 5;
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
echo(bot_angle);
neck_to_saddle = 115;
saddle_rad = 26/2;
saddle_to_neck = 24;
fretboard_thick = 4;
saddle_neck_rad = (bridge_bot_rad-neck_bot_rad)*neck_to_saddle/neck_length + neck_bot_rad;
saddle_depth = saddle_neck_rad - sqrt(pow(saddle_neck_rad,2)-pow(saddle_rad,2));
saddle_round_rad = 20;
neck_grid = neck_width/(n_strings*2);

violin();

module violin(){
  //rotate([0,atan2((bridge_width-neck_width)/2,neck_length),0])
  intersection(){
    difference(){
      union(){
        nut();
  
        color("red")
        translate([0,-neck_bot_arch_rad,0])
        rotate([atan2((bridge_bot_arch_rad - neck_bot_arch_rad),neck_length),0,0])
        translate([0,saddle_depth,neck_to_saddle])
        saddle();
  
        violin_neck();
      }
      
      string_holes_nut();
      
      translate([0,0,3])
      string_holes();
    }
    translate([-100,-100,-100])
    cube([200,200,250]);
  }
}

module nut(){
  hull(){
    translate([0,4,14])
    linear_extrude(height=slice)
    neck_slice();
    translate([0,4,16])
    linear_extrude(height=slice)
    neck_slice();
    translate([0,0,10])
    linear_extrude(height=slice)
    neck_slice();
  }
}

module string_holes(){
  string_holes_thru();
  string_holes_base();
}

//string_holes_nut();
module string_holes_nut(){
  for(i =[1:n_strings]){
    translate([neck_grid * (i - 1) * 2 - neck_width/2 + neck_grid,-neck_top_rad + fretboard_thick + neck_top_arch_rad +sqrt(pow(neck_top_rad + 4,2) - pow(abs((i + 2 - n_strings)*2 - (1 * ((n_strings-1) % 2)))*neck_grid,2)),0])
    cylinder(r = .6, h = (neck_top_arch_rad +neck_bot_arch_rad + fretboard_thick)*2, $fn=precision);
  }
}

module string_holes_thru(){
  for(i =[1:n_strings]){
    translate([neck_grid * (i - 1) * 2 - neck_width/2 + neck_grid,(fretboard_thick + neck_top_arch_rad)*2,3])
    rotate([90,0,0])
    cylinder(r = 1, h = (neck_top_arch_rad +neck_bot_arch_rad + fretboard_thick)*2, $fn=precision);
  }
}

module string_holes_base(){
  for(i =[1:n_strings]){
    translate([neck_grid * (i - 1) * 2 - neck_width/2 + neck_grid,0,3])
    rotate([90,0,0])
    cylinder(r = 2.5, h = neck_bot_arch_rad * 2, $fn=precision);
  }
}

module saddle(){
  translate([0,saddle_neck_rad-saddle_depth,0])
  rotate([90,0,0])
  cylinder(r = saddle_rad, h = saddle_neck_rad + saddle_to_neck, $fn = precision);
  // cylinder(r1 = saddle_neck_rad, r2 = saddle_rad, h = saddle_neck_rad + saddle_to_neck, $fn = precision);
  saddle_smooth();
  mirror([1,0,0])
  saddle_smooth();
}

module saddle_smooth(){
  for(i = [0:.1:saddle_rad]){  
    translate([i,-saddle_depth-saddle_round_rad+saddle_neck_rad-sqrt(pow(saddle_neck_rad,2)-pow(i,2)),-sqrt(pow(saddle_rad ,2)-pow(i,2))+saddle_rad])
    rotate([0,90,0])
    linear_extrude(height = .1){
      translate([saddle_rad,0])
      difference(){
        square([saddle_round_rad,saddle_round_rad]);
        translate([saddle_round_rad,0])
        circle(r=saddle_round_rad, $fn=precision);
      }
    }
  }
}

module violin_neck(){
  intersection(){
    union(){
    	hull(){
        linear_extrude(height = slice){
    		  neck_slice();
        }

    		translate([0,0,neck_length - slice])
        linear_extrude(height = slice){        
    		  bridge_slice();
        }
      }
    }
    translate([-100,-100,0])
    cube([200,200,220]);
  }
}

module neck_slice(){
  intersection(){
      translate([-neck_width/2,fretboard_thick])
      square([neck_width,neck_top_arch_rad]);
      translate([0,-neck_top_rad + neck_top_arch_rad + fretboard_thick])
      circle(r = neck_top_rad, $fn = precision);
  }
  translate([-neck_width/2,0])
  square([neck_width, fretboard_thick]);

  intersection(){
      translate([-neck_width/2,-neck_bot_arch_rad])
      square([neck_width,neck_bot_arch_rad]);
    translate([0,neck_bot_rad-neck_bot_arch_rad])
    circle(r = neck_bot_rad, h = slice, $fn = precision);
  }
}

module bridge_slice(){
  
	intersection(){
		translate([-bridge_width/2,fretboard_thick])
		square([bridge_width,bridge_top_arch_rad*2]);
		translate([0,fretboard_thick-bridge_top_rad+bridge_top_arch_rad])
		circle(r = bridge_top_rad, $fn = precision);
  }

  translate([-bridge_width/2,0])
  square([bridge_width, fretboard_thick]);

  intersection(){
    translate([-bridge_width/2,-bridge_bot_arch_rad])
    square([bridge_width,bridge_bot_arch_rad]);
    translate([0,bridge_bot_rad-bridge_bot_arch_rad])
    circle(r = bridge_bot_rad, $fn = precision);
    }
}