/***
* Name: NewModel
* Author: Arno
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model NewModel

global {
	int n<-3;
	int m<-5;
	int blockSize<-10;
	matrix od<-0.0 as_matrix {n,m};
	/** Insert the global definitions, variables and actions here */
	
	init{
		shape<-rectangle(blockSize*n,blockSize*m);
	    loop i from:0 to:n-1{
		  loop j from:0 to:m-1{
		  	create block{
		  		location<-{blockSize*i,blockSize*j};
		  		od[i,j]<-rnd(10);
		  		//od[j,i]<-rnd(10);
		  	}
		  }	
		}
			
		write od;
	}

}

species block{
	aspect base{
		draw square(blockSize*0.75) color:#blue border:#black;
	}
}

experiment NewModel type: gui {
	/** Insert here the definition of the input and output of the model */
	output {
		display city_display type:opengl {
		  species block aspect:base;	
		}
	}
}
