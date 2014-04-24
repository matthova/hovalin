include <truss_rod.scad>

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
neck_chord = 2 * sqrt(pow(neck_top_rad, 2) - pow(neck_top_rad - neck_top_arch_rad, 2));

bridge_width = 47;
bridge_top_arch_rad = 10;
bridge_top_rad = (pow(bridge_width,2) + 4*pow(bridge_top_arch_rad,2))/(8*bridge_top_arch_rad);
bridge_bot_arch_rad = 25;
bridge_bot_rad = (pow(bridge_width,2) + 4*pow(bridge_bot_arch_rad,2))/(8*bridge_bot_arch_rad);
bot_angle = atan2((bridge_bot_arch_rad - neck_bot_arch_rad), neck_length);
bridge_chord = 2 * sqrt(pow(bridge_top_rad, 2) - pow(bridge_top_rad - bridge_top_arch_rad, 2));

fretboard_thick = 4;
neck_delta = abs(bridge_chord - neck_chord)/neck_length;

thumb_neck_rad = neck_width/2 - neck_delta*neck_width/2;
thumb_neck_to_nut = -thumb_neck_rad;
thumb_neck_height = 24;
thumb_neck_neck_rad = (bridge_bot_rad-neck_bot_rad)*thumb_neck_to_nut/neck_length + neck_bot_rad;
thumb_neck_depth = thumb_neck_neck_rad - sqrt(pow(thumb_neck_neck_rad,2)-pow(thumb_neck_rad,2));
thumb_neck_round_rad = 20;

thumb_bridge_to_nut = 115;
thumb_bridge_rad = 26/2;
thumb_bridge_height = 24;
thumb_bridge_neck_rad = (bridge_bot_rad-neck_bot_rad)*thumb_bridge_to_nut/neck_length + neck_bot_rad;
thumb_bridge_depth = thumb_bridge_neck_rad - sqrt(pow(thumb_bridge_neck_rad,2)-pow(thumb_bridge_rad,2));
thumb_bridge_round_rad = 20;


neck_to_nut_1 = 2;
neck_to_nut_2 = 8;
neck_to_nut_3 = thumb_neck_rad;
neck_hole_slice_width = (neck_width - neck_delta*(neck_to_nut_3/2))*.8;
neck_grid = neck_hole_slice_width/(n_strings*2);
neck_nut_grid = neck_width/(n_strings*2);


violin();

module violin(){
  rotate([0,atan2((bridge_width-neck_width)/2,neck_length),0])
  intersection(){
    difference(){
      union(){
        nut();
  
        color("green")
        translate([0,-neck_bot_arch_rad,0])
        rotate([atan2((bridge_bot_arch_rad - neck_bot_arch_rad),neck_length),0,0])
        translate([0,thumb_neck_depth,thumb_bridge_to_nut])
        thumb_bridge();
  
        color("red")
        translate([0,-neck_bot_arch_rad,0])
        rotate([atan2((bridge_bot_arch_rad - neck_bot_arch_rad),neck_length),0,0])
        translate([0,thumb_neck_depth,thumb_neck_to_nut])
        thumb_neck();
  
        violin_neck();
      }
      translate([0,0,-20])
      string_holes_nut();
      
      translate([0,0,-neck_width/2])
      string_holes();
      
      truss_rod();
      
    }
    translate([-100,-100,-100])
    cube([200,200,250]);
  }
}

module nut(){
  hull(){
    linear_extrude(height=slice)
    neck_slice();
    
    translate([0,0,-neck_to_nut_3])
    scale([(-neck_delta * neck_to_nut_3 + neck_chord)/neck_chord,1,1])
    linear_extrude(height=slice)
    neck_slice();
    
    
    translate([0,fretboard_thick,-thumb_neck_rad+.6])
    rotate([90,0,0])
    cylinder(r=thumb_neck_rad, h = 1, $fn=precision);
  }

  hull(){
    translate([0,2,0])
    linear_extrude(height=slice)
    neck_slice();

    translate([0,2,-neck_to_nut_1])
    scale([(-neck_delta * neck_to_nut_1 + neck_chord)/neck_chord,1,1])
    linear_extrude(height=slice)
    neck_slice();

    translate([0,0,-neck_to_nut_2])
    scale([(-neck_delta * neck_to_nut_2 + neck_chord)/neck_chord,1,1])
    linear_extrude(height=slice)
    neck_slice();
  }
}

module string_holes(){
  string_holes_thru();
  string_holes_base();
}

module string_holes_nut(){
  for(i =[1:n_strings]){
    translate([neck_nut_grid * (i - 1) * 2 - neck_width/2 + neck_nut_grid,-neck_top_rad + fretboard_thick + neck_top_arch_rad +sqrt(pow(neck_top_rad + 2,2) - pow(abs((i + 2 - n_strings)*2 - (1 * ((n_strings-1) % 2)))*neck_nut_grid,2)),0])
    cylinder(r = .6, h = (neck_top_arch_rad +neck_bot_arch_rad + fretboard_thick)*2, $fn=precision);
  }
}

module string_holes_thru(){
  for(i =[1:n_strings]){
    translate([neck_grid * (i - 1) * 2 - neck_hole_slice_width/2 + neck_grid,(fretboard_thick + neck_top_arch_rad)*2,0])
    rotate([90,0,0])
    cylinder(r = 1, h = 100, $fn=precision);
    // cylinder(r = 1, h = (neck_top_arch_rad +neck_bot_arch_rad + fretboard_thick)*2, $fn=precision);
  }
}

module string_holes_base(){
  for(i =[1:n_strings]){
    translate([neck_grid * (i - 1) * 2 - neck_hole_slice_width/2 + neck_grid,0,0])
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
  rotate([90,0,0])
  cylinder(r = thumb_bridge_rad, h = thumb_bridge_neck_rad + thumb_bridge_height, $fn = precision);
  thumb_bridge_smooth();
  mirror([1,0,0])
  thumb_bridge_smooth();
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
    circle(r = neck_top_rad, $fn = precision*5);
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
    circle(r = bridge_top_rad, $fn = precision*5);
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