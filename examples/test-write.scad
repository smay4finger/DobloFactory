include <../doblo-factory.scad>;
include <../lib/doblo-params.scad>;

// text on a 6x2 doblo

doblo (col=2,row=1,up=0,length=2,width=6,height=THIRD,nibbles_on_off=false); 
color ("purple") write (text="DOBLO", col=2, row=1.5, up=THIRD,
			size=10, height=1.5);

doblo (col=8,row=-5,up=0,length=6,width=2,height=THIRD,nibbles_on_off=false); 
color ("purple") write (text="ROCKS !", col=8.5, row=-4.9, up=THIRD, rot=270,
			size=8, height=1.5,valign="baseline");
