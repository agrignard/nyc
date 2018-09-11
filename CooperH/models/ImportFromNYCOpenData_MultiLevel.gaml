/**
* Name: GEOJSON File NYC
* Author:  Arnaud Grignard
* Description: Initialize a set of geometries from a GEOJSON FIle. 
* Tags:  load_file, grid, json, gis
*/

model geojson_loading   

global {
	file geo_community_file <- geojson_file("./../includes/Community Districts.geojson");
	file geo_borough_file <- geojson_file("./../includes/Borough Boundaries.geojson");
	file geo_state_file <- geojson_file("./../includes/newJersey.geojson");
	geometry shape <- envelope(geo_community_file);
	map<int,rgb> color_per_community_type <- [ 101::hsb(1/16,1.0,1.0),102::hsb(2/16,1.0,1.0),103::hsb(3/16,1.0,1.0),104::hsb(4/16,1.0,1.0),105::hsb(5/16,1.0,1.0),106::hsb(6/16,1.0,1.0),107::hsb(7/16,1.0,1.0),108::hsb(8/16,1.0,1.0),109::hsb(9/16,1.0,1.0),110::hsb(10/16,1.0,1.0),111::hsb(11/16,1.0,1.0),112::hsb(12/16,1.0,1.0),164::rgb(50,50,50)];
    map<string,rgb> color_per_borough_type <- [ "borough0"::rgb(50,50,50),"borough1"::rgb(100,100,100),"borough2"::rgb(150,150,150),"borough3"::rgb(200,200,200)];
	map<int,point> grid_position <- [ 101::{0,3,0},102::{1,3,0},103::{2,3,0},104::{0,2,0},105::{1,2,0},106::{2,2,0},107::{0,1,0},108::{2,1,0},109::{0,0,0},110::{1,0,0},111::{2,0,0},112::{1,-1,0},164::{1,1,0}];
    map<string,point> grid_borough_position <- [ "borough0"::{world.shape.width*0.4,world.shape.height*0.5},"borough1"::{world.shape.width*0.6,world.shape.height*0.1},"borough2"::{world.shape.width*0.6,world.shape.height*0.85},"borough3"::{world.shape.width*0.7,world.shape.height*0.5}];
    
    
	init {
		create community from: geo_community_file with: [name::read("name"),boro_cd::int(read("boro_cd"))]{
			abstractShape<-square(world.shape.width/20);	
			color<-color_per_community_type[boro_cd];
			if(boro_cd<100 or boro_cd>200 or boro_cd=112){
				do die;
			}else{
				gridShape<-rectangle(world.shape.width/16,world.shape.width/9) at_location {grid_position[boro_cd].x*world.shape.width/16+world.shape.width/2 ,grid_position[boro_cd].y*world.shape.width/9 + world.shape.height/4};
			}
		}
		create borough from: geo_borough_file with: [name::read("name")]{
			abstractShape<-square(world.shape.width/10);
		    gridShape<-rectangle(world.shape.width/16,world.shape.width/9) at_location grid_borough_position[name];
			color<-color_per_borough_type[name];
			if(name='borough4') {do die;}
		}
		create state number:1{
			color<-rgb(10,10,10);
			location<-{world.shape.width/4,world.shape.height/4};
			shape<-circle(world.shape.width/8);
			abstractShape<-square(world.shape.width/5);
		}
		ask community{
			create people number:100{
				color<-myself.color;
				source<-any_location_in(myself);
				location<-source;
				dest<-any_location_in(one_of(community where (each.name != myself.name)));
			}
			create abstractPeople number:100{
				color<-myself.color;
				source<-any_location_in(myself.abstractShape);
				location<-source;
				dest<-any_location_in(one_of(community where (each.name != myself.name)).abstractShape);
			}
			create gridPeople number:100{
				color<-myself.color;
				source<-any_location_in(myself.gridShape);
				location<-source;
				dest<-any_location_in(one_of(community where (each.name != myself.name)).gridShape);
			}
		}
		ask borough{
			create people number:100{
				color<-myself.color;
				source<-any_location_in(myself);
				location<-source;
				dest<-any_location_in(one_of(borough where (each.name != myself.name)));
			}
			create abstractPeople number:100{
				color<-myself.color;
				source<-any_location_in(myself.abstractShape);
				location<-source;
				dest<-any_location_in(one_of(borough where (each.name != myself.name)).abstractShape);
			}
			create gridPeople number:100{
				color<-myself.color;
				source<-any_location_in(myself.gridShape);
				location<-source;
				dest<-any_location_in(one_of(community where (each.name != myself.name)).gridShape);
			}
		}
	}
} 


species genericBlock{
	rgb color;
	geometry abstractShape;
	geometry gridShape;

	aspect default {
		draw shape color: color border:#black;
	}
	aspect abstract {
		draw abstractShape color: color border:#black;
	}
	aspect abstractGrid {
		draw gridShape color: color border:#black;
	}		
}

species community parent:genericBlock{
	int boro_cd;
}

species borough parent:genericBlock{
}

species state parent:genericBlock{	
}

species people skills:[moving]{
	rgb color;
	point source;
	point dest;
	
	aspect default{
		draw circle(0.0005) color:color;
	}
	reflex move{
		do goto target:dest speed:0.001;
	}
}

species abstractPeople parent:people{
}

species gridPeople parent:people{
}

experiment Display  type: gui {
    float minimum_cycle_duration<-0.02;
    
	output{
		
		display Countries type: opengl background:#black draw_env:false{	
			species community;
			species borough;
			species state;	
			species people;		
		}
		display AbtractCountries type: opengl background:#black draw_env:false{	
			species community aspect:abstract;
			species borough aspect:abstract;
			species state aspect:abstract;	
			species abstractPeople;		
		}
		display AbtractGrid type: opengl background:#black draw_env:true{	
			species community aspect:abstractGrid;
			species borough aspect:abstractGrid;
			species gridPeople;
		}
	}
}
