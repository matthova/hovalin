thickness = 10;
slice = .1;

half();
mirror([0,0,1])
half();

module half(){
	for(i = [0:thickness / slice / 2]){
		translate([0,sqrt(((thickness / 2)*(thickness / 2) - (slice * i * i * slice))),slice * i])
		linear_extrude(height = slice)
		violin_half();
	}
}

module violin_half(){
	import("/Volumes/Optical3/Sites/hovalin/violin_half.dxf");
}