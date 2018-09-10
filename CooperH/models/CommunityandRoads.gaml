/**
* Name: 
* Author: Arnaud Grignard
* Description: 
* Tags: gis
*/

model tutorial_gis_city_traffic

global {
	file buildings_shapefile <- file("../includes/Community Districts/geo_export_07ae0171-8a3b-43be-8229-bc1abe7e01b5.shp");
	file roadss_shapefile <- file("../includes/NYC Street Centerline (CSCL)/geo_export_c63f4921-cad6-4d21-aa9a-0704db8ecc1a.shp");
	geometry shape <- envelope(buildings_shapefile);
    graph the_graph;
	
	init {
		create building from: buildings_shapefile ;
		create road from: roadss_shapefile ;
		create people number:100{
			location <- any_location_in (one_of(building));
			target  <-any_location_in (one_of(building));
		}
		the_graph <- as_edge_graph(road);
	}
}

species building schedules:[]{
	rgb color <- #gray  ;
	
	aspect base {
		draw shape color: color border:#black;
	}
}

species road schedules:[]{
	rgb color <- #gray  ;
	
	aspect base {
		draw shape color: color border:#black;
	}
}

species people skills:[moving]{
	rgb color <- #red ;
	point target;
	
	reflex move{
		do goto target:target speed:10.0 ;// on:the_graph speed:10.0 recompute_path:false;
	}
	
	aspect base {
		draw circle(100#m) color: color border:#black;
	}
	
}



experiment road_traffic type: gui {
		
	output {
		display city_display type:opengl {
			species building aspect: base refresh:false;
			species road aspect:base refresh:false;
			species people aspect:base;
		}
	}
}