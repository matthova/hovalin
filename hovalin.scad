/* Constants */
slice = .1; // thickness of 2d shapes. set to small value
nudge = 0.0001; // used to push the objects just barely to resolve any manifold issues
precision = 50; // increase to smooth cylinders or crash computer
pi = 3.14159; // tasty pi


n_strings = 4; // number of strings for the violin
neck_length = 280; // Neck Length

neck_width = 28.6; // Distance across fretboard nearest to the nut
neck_top_arch_rad = 3; // height of center of nut-side fretboard compared to edges
neck_top_rad = (pow(neck_width,2) + 4*pow(neck_top_arch_rad,2))/(8*neck_top_arch_rad); //radius of circle formed by nut-side rounded fretboard
neck_bot_arch_rad = 12; // height of center of nut-side fretboard bottom compared to edges
neck_bot_rad = (pow(neck_width,2) + 4*pow(neck_bot_arch_rad,2))/(8*neck_bot_arch_rad); //radius of circle formed by nut-side rounded fretboard bottom

bridge_width = 45; // Distance across fretboard nearest to the bridge
bridge_top_arch_rad = 10; // distance from top of fretboard to base compared to edges
bridge_top_rad = (pow(bridge_width,2) + 4*pow(bridge_top_arch_rad,2))/(8*bridge_top_arch_rad); //radius of circle formed by bridge-side rounded fretboard
bridge_bot_arch_rad = 25; // distance from bottom of bridge side violin neck to base compared to edges
bridge_bot_rad = (pow(bridge_width,2) + 4*pow(bridge_bot_arch_rad,2))/(8*bridge_bot_arch_rad); // radius of circle formed by bridge-side rounded fretboard bottom
bot_angle = atan2((bridge_bot_arch_rad - neck_bot_arch_rad), neck_length); // acute angle formed by base of violin as it moves towards the bridge

fretboard_thick = 4; // filler between to arch and bottom arch of the violin neck
neck_delta = abs(bridge_width - neck_width)/neck_length; // distance that neck width increases per mm along neck length
neck_bot_delta = abs(neck_bot_arch_rad - bridge_bot_arch_rad)/neck_length; // distance that neck bottom arch rad increases per mm along neck length
neck_top_delta = abs(neck_top_arch_rad - bridge_top_arch_rad)/neck_length; // distance that neck top arch rad increases per mm along neck length

thumb_neck_height = 24; // height of first position thumb ridge
thumb_neck_round_rad = 20;
thumb_neck_rad = neck_width/2 - neck_delta*neck_width/2; // radius of cylinder near the nut. used for referencing first position
thumb_neck_to_nut = -thumb_neck_rad; // ???
thumb_neck_neck_rad = (bridge_bot_rad-neck_bot_rad)*thumb_neck_to_nut/neck_length + neck_bot_rad;
thumb_neck_depth = thumb_neck_neck_rad - sqrt(pow(thumb_neck_neck_rad,2)-pow(thumb_neck_rad,2));

thumb_bridge_to_nut = 115;
thumb_bridge_rad = 26/2;
thumb_bridge_height = 24;
thumb_bridge_round_rad = 20;
thumb_bridge_neck_rad = (bridge_bot_rad-neck_bot_rad)*thumb_bridge_to_nut/neck_length + neck_bot_rad;
thumb_bridge_depth = thumb_bridge_neck_rad - sqrt(pow(thumb_bridge_neck_rad,2)-pow(thumb_bridge_rad,2));
neck_slice_1 = thumb_bridge_to_nut + 50;


neck_to_nut_1 = 2;
neck_to_nut_2 = 8;
neck_to_nut_3 = thumb_neck_rad;
neck_hole_slice_width = (neck_width - neck_delta*(neck_to_nut_3/2))*.8;
neck_grid = neck_hole_slice_width/(n_strings*2);
neck_slices = n_strings * 2;
neck_angle_increment = 1.8 * asin(neck_width/(2 * neck_top_rad))/neck_slices;

nut_height = 2;
nut_string_rad = .7;

bolt_rad = 2.5;
bolt_length = 24;
bolt_head_rad = 4.5;
bolt_head_length = 4;
nut_width = 7.9;
nut_thick = 2.9;

neck_to_bridge = 58;
bridge_angle_increment = neck_angle_increment * 2;
bridge_length = 10;
bridge_lift = 5;
bridge_to_end = 140;

pickup_hole_length = 2;
pickup_rad = 15;

tuner_rad = 5.5;

truss_rad = 5.6;

violin();
//body_piece();

module bolt(){
  mirror([0,0,1])
  union(){
    cylinder(r = bolt_rad, h = bolt_length, $fn = precision);
    cylinder(r = bolt_head_rad, h = bolt_head_length, $fn = precision);
  }
  mirror([0,1,0])
  translate([-nut_width/2,-bolt_rad * 3,-bolt_length])
  cube([nut_width,thumb_bridge_height,nut_thick]);
}


module violin(){
	//mirror([1,0,0])
  translate([0,0,neck_width / 2])
  rotate([0,-90,0])
  rotate([0, atan2((bridge_width-neck_width)/2,neck_length),0])
  difference(){
    union(){
      //curved_edge();
      
		  top();
      neck_to_bridge();
      bridge();
      bridge_to_end();
      //chin_rest();
		  rotate([0, atan2((bridge_width-neck_width)/2,neck_length),0])
			violin_half();
    }
    //bolt_holes();
		pickup_cutout();

    translate([0,0,-19])
    string_holes_nut();
      
    translate([0,0,-neck_width/2])
    string_holes();
    
    translate([0,-5.5,0])
	  cylinder(r = 5.5, h = 300, $fn = precision);

		// truss rod
		//translate([0,0,neck_width / 2])
		//cylinder(r = truss_rad, h = 800, $fn = 4);

		rotate([3.5,0,0])
		translate([-6,0,0])
		cube([12,6,800]);

		// truss rod
		translate([0,-1.5,neck_width / 2])
		rotate([.4,0,0])
		cylinder(r = truss_rad, h = 800, $fn = precision / 2);
		
		tunerHoles();

    rotate([0,-atan2((bridge_width-neck_width)/2,neck_length),0])
    translate([-neck_width/2-1000,-500,-500])
    cube([1000,1000,1000]);      
  }
}

module curved_edge(){
	translate([688,-20+fretboard_thick,-431+5])
  rotate([90,0,180])
  linear_extrude(height = 20)
  scale(3)
	import("/Volumes/Optical3/Sites/hovalin/curved_edge.dxf");
}

module violin_half(){
	translate([-7 + neck_width / 2,fretboard_thick,neck_length + neck_to_bridge + bridge_length + bridge_to_end])
	rotate([0,90,-90])
	linear_extrude(height = 18)
	scale(3.18)
	import("/Volumes/Optical3/Sites/hovalin/violin_half.dxf");
}

module chin_rest(){
  translate([32,-7,-18])
  translate([0,0,neck_length + neck_to_bridge + bridge_length + bridge_to_end])
  rotate([-90,0,0])
  mirror([1,0,0])
	import("/Volumes/Optical3/Sites/hovalin/chinrest.stl");
}

module neck_to_bridge(){
  color("red")
  translate([0,0,neck_length])
  hull(){
    linear_extrude(height = slice){
			bridge_slice_top();
      bridge_slice_middle();
      bridge_slice_bot();
    }
    
    scale([((bridge_width + neck_to_bridge * neck_delta) / bridge_width),((bridge_width + neck_to_bridge * neck_delta) / bridge_width),1])
    translate([0,0,neck_to_bridge - slice])
    linear_extrude(height = slice){
			bridge_slice_top();
      bridge_slice_middle();
      bridge_slice_bot();
    }
  }
}

module bridge(){
  color("blue")
  difference(){
    union(){
      translate([0,bridge_lift,neck_length + neck_to_bridge])
      hull(){
        scale([((bridge_width + neck_to_bridge * neck_delta) / bridge_width),((bridge_width + neck_to_bridge * neck_delta) / bridge_width),1])
        linear_extrude(height = slice){
          bridge_slice_top();
          bridge_slice_middle();
          bridge_slice_bot();
        }
    
        scale([((bridge_width + (neck_to_bridge + bridge_length) * neck_delta) / bridge_width),((bridge_width + (neck_to_bridge + bridge_length) * neck_delta) / bridge_width),1])
        translate([0,-3,bridge_length - slice])
        linear_extrude(height = slice){
          bridge_slice_top();
          bridge_slice_middle();
          bridge_slice_bot();
        }
      }
      translate([0,0,neck_length + neck_to_bridge])
      hull(){
        scale([((bridge_width + neck_to_bridge * neck_delta) / bridge_width),((bridge_width + neck_to_bridge * neck_delta) / bridge_width),1])
        linear_extrude(height = slice){
          bridge_slice_top();
          bridge_slice_middle();
          bridge_slice_bot();
        }
    
        scale([((bridge_width + (neck_to_bridge + bridge_length) * neck_delta) / bridge_width),((bridge_width + (neck_to_bridge + bridge_length) * neck_delta) / bridge_width),1])
        translate([0,0,bridge_length - slice])
        linear_extrude(height = slice){
          bridge_slice_top();
          bridge_slice_middle();
          bridge_slice_bot();
        }
      }
    }
    bridge_string_holes();
  }
}

module pickup_cutout(){
  rotate([0, -atan2((bridge_width-neck_width)/2,neck_length),0])
	translate([-neck_width / 2,-5 + 4,neck_length + neck_to_bridge + bridge_length / 2 - pickup_rad])
	cube([pickup_rad / 2 + (bridge_width + neck_delta * (neck_length + neck_to_bridge + bridge_length))/ 2,pickup_hole_length,pickup_rad * 2]);		
}

module bridge_string_holes(){
  
  for(i = [1:n_strings]){
    translate([0,bridge_lift + fretboard_thick * 1.25 - (bridge_top_rad - bridge_top_arch_rad) * (bridge_top_arch_rad  + neck_to_bridge * neck_top_delta)/bridge_top_arch_rad,0])
    rotate([0,0,bridge_angle_increment * (i - n_strings/2 - .5) * 2])
    // translate([0,bridge_top_arch_rad + neck_to_bridge * neck_top_delta + fretboard_thick,neck_length + neck_to_bridge])
    translate([0, bridge_top_rad * ((bridge_top_arch_rad + fretboard_thick) + neck_to_bridge * neck_top_delta)/(bridge_top_arch_rad + fretboard_thick),neck_length + neck_to_bridge])
    cylinder(r = nut_string_rad, h = 100, $fn=precision);
  }  
}

module bridge_to_end(){
  color("green")
  difference(){
    hull(){
      translate([-(bridge_width + (neck_to_bridge + bridge_length) * neck_delta) / 2, -14,neck_length + neck_to_bridge + bridge_length])
      cube([bridge_width + (neck_to_bridge + bridge_length) * neck_delta,18,slice]);

      translate([-(bridge_width + (neck_to_bridge + bridge_length + bridge_to_end - slice) * neck_delta) / 2, -14,neck_length + neck_to_bridge + bridge_length + bridge_to_end - slice - .4])
      cube([bridge_width + (neck_to_bridge + bridge_length + bridge_to_end - slice) * neck_delta - 7,18,slice]);    
    }
  }  
}

module tunerHoles(){
  // for(i = [0:(n_strings / 2)-1]){
  //   translate([(i*3 + .5 - n_strings / 2) * 11,-100, 50 + neck_length + neck_to_bridge + bridge_length + tuner_rad * 5])
  //   rotate([-90,0,0])
  //   cylinder(r = tuner_rad, h = 200, $fn = precision);
  // }

  for(i = [0:n_strings - 1]){
    // translate([(.5 - n_strings / 2) * 10,-100, 10 + neck_length + neck_to_bridge + bridge_length + tuner_rad * 5])
    translate([-30 + 18.5,-100, 10 + neck_length + neck_to_bridge + bridge_length + tuner_rad * 5])
		rotate([0, - atan2((bridge_width-neck_width)/2,neck_length), 0])
		translate([0,0,i * 28])
    rotate([-90,0,0])
    cylinder(r = tuner_rad, h = 200, $fn = precision);
  }
  // for(i = [0:(n_strings / 2)-1]){
  //   translate([(i*3 + .5 - n_strings / 2) * 11,-100, 50 + neck_length + neck_to_bridge + bridge_length + tuner_rad * 5])
  //   rotate([-90,0,0])
  //   cylinder(r = tuner_rad, h = 200, $fn = precision);
  // }
  //
  // for(i = [0:(n_strings / 2)-1]){
  //   translate([(i*3 + .5 - n_strings / 2) * 10,-100, 10 + neck_length + neck_to_bridge + bridge_length + tuner_rad * 5])
  //   rotate([-90,0,0])
  //   cylinder(r = tuner_rad, h = 200, $fn = precision);
  // }

}

module top(){
	color("white")
	union(){
		nut();
 
		translate([0,-neck_bot_arch_rad-(neck_bot_delta*(thumb_bridge_to_nut-thumb_bridge_rad*2)),0])
		translate([0,thumb_neck_depth - 4,thumb_bridge_to_nut + thumb_bridge_rad])
		thumb_bridge();

		translate([0,-neck_bot_arch_rad,0])
		translate([0,thumb_neck_depth,thumb_neck_to_nut])
		thumb_neck();  
		violin_neck();         
	}
}

module bolt_holes(){
  translate([0,-(neck_bot_arch_rad + ((thumb_bridge_to_nut - thumb_bridge_rad*2) * neck_bot_delta) + thumb_bridge_height/2),thumb_bridge_to_nut + bolt_length - thumb_bridge_rad/2])
  bolt();
  
  translate([10,-6,thumb_bridge_to_nut + thumb_bridge_rad])
  rotate([0,0,90])
  bolt();
  
  translate([-10,-6,thumb_bridge_to_nut + thumb_bridge_rad])
  rotate([0,0,-90])
  bolt();
  
  translate([5,-nut_width*3,thumb_bridge_to_nut + bolt_length/2])
  cube([30,nut_width*3,25]);

  translate([-5-30,-nut_width*3,thumb_bridge_to_nut + bolt_length/2])
  cube([30,nut_width*3,25]);
}

module nut(){
  hull(){
    linear_extrude(height=slice)
    neck_slice();
    
    
    translate([0,0,-neck_to_nut_3])
    scale([(-neck_delta * neck_to_nut_3 + neck_width)/neck_width,1,1])
    linear_extrude(height=slice)
    neck_slice();
    
    
    translate([0,fretboard_thick,-thumb_neck_rad])
    rotate([90,0,0])
    cylinder(r=thumb_neck_rad, h = fretboard_thick, $fn=precision);
  }

  hull(){
    translate([0,2,0])
    linear_extrude(height=slice)
    neck_slice();

    translate([0,2,-neck_to_nut_1])
    scale([(-neck_delta * neck_to_nut_1 + neck_width)/neck_width,1,1])
    linear_extrude(height=slice)
    neck_slice();

    translate([0,0,-neck_to_nut_2])
    scale([(-neck_delta * neck_to_nut_2 + neck_width)/neck_width,1,1])
    linear_extrude(height=slice)
    neck_slice();
  }
}

module string_holes(){
  string_holes_thru();
  string_holes_base();
}
// pos_x = abs((i + 2 - n_strings)*2 - (1 * ((n_strings-1) % 2)));
// translate([neck_grid * (i - 1) * 2 - neck_width/2 + neck_grid,-neck_top_rad + fretboard_thick + neck_top_arch_rad +sqrt(pow(neck_top_rad + 2,2) - pow(abs((i + 2 - n_strings)*2 - (1 * ((n_strings-1) % 2)))*neck_grid,2)),0])

module string_holes_nut(){
  
  for(i = [1:n_strings]){
    translate([0,-neck_top_rad + neck_top_arch_rad + nut_height + fretboard_thick,0])
    rotate([0,0,neck_angle_increment * (i - n_strings/2 - .5) * 2])
    translate([0,neck_top_rad,0])
    cylinder(r = nut_string_rad, h = 20, $fn=precision);
  }
  
}

module string_holes_thru(){
  for(i =[1:n_strings]){
    translate([neck_grid * (i - 1) * 2 - neck_hole_slice_width/2 + neck_grid,(fretboard_thick + neck_top_arch_rad)*2,0])
    rotate([90,0,0])
    cylinder(r = 1., h = 100, $fn=precision);
    // cylinder(r = 1, h = (neck_top_arch_rad +neck_bot_arch_rad + fretboard_thick)*2, $fn=precision);
  }
}

module string_holes_base(){
  for(i =[1:n_strings]){
    translate([neck_grid * (i - 1) * 2 - neck_hole_slice_width/2 + neck_grid,-25,0])
    rotate([90,0,0])
    cylinder(r = 2.5, h = 100, $fn=precision);
    // cylinder(r = 2.5, h = neck_bot_arch_rad * 2, $fn=precision);
  }
}

module thumb_neck(){
  translate([0,thumb_neck_neck_rad-thumb_neck_depth,0])
  rotate([90,0,0])
  cylinder(r = thumb_neck_rad, h = thumb_neck_neck_rad + thumb_neck_height, $fn = precision);
  thumb_neck_smooth();
  mirror([1,0,0])
  thumb_neck_smooth();
  thumb_neck_supports();
}

module thumb_neck_supports(){
  for(i = [0:2:thumb_neck_rad*2]){
    translate([-neck_width/2 - thumb_neck_to_nut*neck_delta - 2,-thumb_neck_height-thumb_neck_depth,-thumb_neck_rad + i])
    cube([neck_width/2 + thumb_neck_to_nut*neck_delta,neck_bot_arch_rad + thumb_neck_height + fretboard_thick,.5]);
  }
}

module thumb_neck_smooth(){
  for(i = [0:10/precision:thumb_neck_rad]){  
    translate([i,-thumb_neck_depth-thumb_neck_round_rad+thumb_neck_neck_rad-sqrt(pow(thumb_neck_neck_rad,2)-pow(i,2)),sqrt(pow(thumb_neck_rad ,2)-pow(i,2))+thumb_neck_rad - thumb_neck_rad*2])
    rotate([0,-90,0])
    linear_extrude(height = 10/precision){
      translate([thumb_neck_rad,0])
      difference(){
        square([thumb_neck_round_rad,thumb_neck_round_rad]);
        translate([thumb_neck_round_rad,0])
        circle(r=thumb_neck_round_rad, $fn=precision);
      }
    }
  }
}

module thumb_bridge(){
  translate([0,thumb_bridge_neck_rad-thumb_bridge_depth,0])
  intersection(){
    rotate([90,0,0])
    cylinder(r = thumb_bridge_rad, h = thumb_bridge_neck_rad + thumb_bridge_height, $fn = precision);
    //translate([-thumb_bridge_rad,-thumb_bridge_height-neck_bot_arch_rad-thumb_bridge_to_nut * neck_bot_delta,-thumb_bridge_rad])
    //cube([thumb_bridge_rad*2,thumb_bridge_height+thumb_bridge_depth,thumb_bridge_rad]);
  }
  thumb_bridge_smooth();
  mirror([1,0,0])
  thumb_bridge_smooth();
  thumb_bridge_supports();
}

module thumb_bridge_supports(){
  for(i = [0:2:thumb_bridge_rad*2 - 1]){
    translate([-neck_width/2 - thumb_bridge_to_nut*neck_delta,-thumb_bridge_height-thumb_bridge_depth,-thumb_bridge_rad + i])
    cube([neck_width/2 + thumb_bridge_to_nut*neck_delta, neck_bot_arch_rad + thumb_neck_height + fretboard_thick,.5]);
  }
}

module thumb_bridge_smooth(){
  for(i = [0:10/precision:thumb_bridge_rad]){  
    translate([i,-thumb_bridge_depth-thumb_bridge_round_rad+thumb_bridge_neck_rad-sqrt(pow(thumb_bridge_neck_rad,2)-pow(i,2)),-sqrt(pow(thumb_bridge_rad ,2)-pow(i,2))+thumb_bridge_rad])
    rotate([0,90,0])
    linear_extrude(height = 10/precision){
      translate([thumb_bridge_rad,0])
      difference(){
        square([thumb_bridge_round_rad,thumb_bridge_round_rad]);
        translate([thumb_bridge_round_rad,0])
        circle(r=thumb_bridge_round_rad, $fn=precision);
      }
    }
  }
}

module violin_neck(){
  hull(){
    linear_extrude(height = slice){
      neck_slice_top();
      neck_slice_middle();
      neck_slice_bot();
    }

    translate([0,0,neck_length - slice])
    linear_extrude(height = slice){        
      bridge_slice_top();
      bridge_slice_middle();
      bridge_slice_bot();
    }
  }
}

module middle(){
  union(){    
    hull(){
      translate([0,0,neck_slice_1])
      scale((neck_width+neck_slice_1*neck_delta)/neck_width)
      linear_extrude(height = slice){
        neck_slice_top();
        neck_slice_middle();
      }

      translate([0,0,neck_length - slice])
      linear_extrude(height = slice){        
        bridge_slice_top();
        bridge_slice_middle();
      }
    }
    hull(){
      translate([0,0,thumb_bridge_to_nut])
      linear_extrude(height = slice){
        scale((neck_width+thumb_bridge_to_nut*neck_delta)/neck_width)
        neck_slice_bot();
      }
      translate([0,0,neck_length - slice])
      linear_extrude(height = slice){        
        bridge_slice_bot();
      }
    }
  }
  
  translate([0,-neck_bot_arch_rad-(neck_bot_delta*(thumb_bridge_to_nut-thumb_bridge_rad*2)),0])
  translate([0,thumb_neck_depth,thumb_bridge_to_nut])
  mirror([0,0,1])
  thumb_bridge();
  
  
}

module neck_slice(){
  neck_slice_top();
  neck_slice_middle();
  neck_slice_bot();
}

module neck_slice_top(){
  intersection(){
    translate([-neck_width/2,fretboard_thick])
    square([neck_width,neck_top_arch_rad]);
    translate([0,-neck_top_rad + neck_top_arch_rad + fretboard_thick])
    circle(r = neck_top_rad, $fn = precision*5);
  }
}

module neck_slice_middle(){
  translate([-neck_width/2,0])
  square([neck_width, fretboard_thick]);
}

module neck_slice_bot(){
  intersection(){
    translate([-neck_width/2,-neck_bot_arch_rad])
    square([neck_width,neck_bot_arch_rad]);
    translate([0,neck_bot_rad-neck_bot_arch_rad])
    circle(r = neck_bot_rad, h = slice, $fn = precision);
  }
}

module bridge_slice_top(){
  intersection(){
    translate([-bridge_width/2,fretboard_thick])
    square([bridge_width,bridge_top_arch_rad*2]);
    translate([0,fretboard_thick-bridge_top_rad+bridge_top_arch_rad])
    circle(r = bridge_top_rad, $fn = precision*5);
  }
}

module bridge_slice_middle(){
  translate([-bridge_width/2,0])
  square([bridge_width, fretboard_thick]);
}

module bridge_slice_bot(){
  intersection(){
    translate([-bridge_width/2,-bridge_bot_arch_rad])
    square([bridge_width,bridge_bot_arch_rad]);
    translate([0,bridge_bot_rad-bridge_bot_arch_rad])
    circle(r = bridge_bot_rad, $fn = precision);
  }
}