/**
* Name: GEOJSON File Loading
* Author:  Alexis Drogoul
* Description: Initialize a set of geometries from a GEOJSON FIle. 
* Tags:  load_file, grid, json, gis
*/

model geojson_loading   

global {
	file geo_community_file <- geojson_file("./../includes/Community Districts.geojson");
	file geo_borough_file <- geojson_file("./../includes/Borough Boundaries.geojson");
	file geo_state_file <- geojson_file("./../includes/newJersey.geojson");
	geometry shape <- envelope(geo_community_file);
	init {
		create community from: geo_community_file with: [name::read("name"),boro_cd::int(read("boro_cd"))]{
			if(boro_cd<100 or boro_cd>200){
				do die;
			}
		}
		create borough from: geo_borough_file with: [name::read("name")]{
			if(name='borough4') {do die;}
		}
		create state number:1{
			location<-{world.shape.width/4,world.shape.height/4};
			shape<-circle(world.shape.width/8);
		}
	}
} 


species community {
	rgb color <- #gray;
	rgb text_color <- (color.brighter);
	int boro_cd;

	aspect default {
		draw shape color: color border:#black;
		draw name font: font("Helvetica", 12 + #zoom, #bold) color: #black at: location + {0,0,12} perspective:false;
	}
}

species borough {
	rgb color <- #darkgray;
	rgb text_color <- (color.brighter);
	
	init {
		//shape <- (simplification(shape,0.005));
	}
	aspect default {
		draw shape color: color border:#black;
		draw name font: font("Helvetica", 12 + #zoom, #bold) color: #black at: location + {0,0,12} perspective:false;
	}
}

species state{
    rgb color <- #darkgray;
	rgb text_color <- (color.brighter);
	
	init {
		//shape <- (simplification(shape,0.005));
	}
	aspect default {
		draw shape color: color border:#black;
		draw name font: font("Helvetica", 12 + #zoom, #bold) color: #black at: location + {0,0,12} perspective:false;
	}
	
}

experiment Display  type: gui {
	output {
		display Countries type: opengl{	
			species community;
			species borough;
			species state;			
		}
	}
}
