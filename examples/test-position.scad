include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

//           col row  up  width length height
module heights_demo () {
     doblo   (0, -2,  0,   2,   2,    FULL,   true, false, DOBLO);
     doblo   (3, -2,  0,   2,   2,    HALF,   true, false, DOBLO);
     doblo   (6, -2,  0,   2,   2,    THIRD,  true, false, DOBLO);
     
     doblo   (0, 0,   0,   2,   2,    FULL,   true, false, LUGO);
     doblo   (6, 0,   0,   2,   2,    HALF,   true, false, LUGO);
     doblo   (12, 0,   0,   2,   2,    THIRD,  true, false, LUGO);
     
     doblo   (0,  4,   0,   2,   2,    FULL,   true, false, MINI);
     doblo   (12, 4,   0,   2,   2,    HALF,   true, false, MINI);
     doblo   (24, 4,   0,   2,   2,    THIRD,  true, false, MINI);
}
heights_demo();

module width_position_demo () {

     color ("red") doblo   (0, -2,  0,   2,   2,    FULL,   true, false, DOBLO);
     color ("orange") doblo   (0, 0,   0,   2,   2,    FULL,   true, false, LUGO);

     color ("green") doblo   (3, -2,  0,   1,   1,    FULL,   true, false, DOBLO);
     color ("olive") doblo   (6, 0,   0,   1,   1,    FULL,   true, false, LUGO);

}
// width_position_demo();

module width_position_demo2 () {
//           col row  up  width length height
     color ("green") {
	  doblo   (0, 0,   0,  2,  6,    FULL,   true, false, LUGO);
	  translate ([0,HALF,2*FULL]) {
	       text(text="col=0,row=0,width=2,length=6", size=6, font="Liberation Sans", valign="top");
	  }
	  }
     
     color ("red") {
	  doblo   (0, -4,  0,  4,   1,    FULL,   true, false, LUGO);
	  translate ([0,2.5*PART_WIDTH(1),2*FULL]) {
	       text(text="col=0,row=-4,width=4,length=1", size=6, font="Liberation Sans", valign="top");
	  }
	  }

     color ("yellow")  doblo   (8, 1,   0,  4,   2,    FULL,   true, false, LUGO);
     translate ([4*PART_WIDTH(1),-HALF,2*FULL]) {
	  color("black") text(text="col=8,row=1,width=4,length=2", size=6, font="Liberation Sans", valign="top");
     }
     
     color ("blue") {
	  doblo   (8, -4,  0,  3,   3,    FULL,   true, false, LUGO);
	  translate ([6*PART_WIDTH(1),3*FULL,2*FULL]) {
	       text(text="col=8,row=-4,width=3,length=3", size=6, font="Liberation Sans", valign="top");
	  }
     }
}

// width_position_demo2();

