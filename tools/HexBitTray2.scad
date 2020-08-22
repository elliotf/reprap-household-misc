//Hex Bit Holder
//Copyright 2017 Douglas Peale

// downloaded from https://www.thingiverse.com/thing:2406308/files


SizeOfBit=0.25*25.4;
NumberOfRows=3;
NumberOfBitsPerRow=3;
Clearance=0.75;

WallThickness=1;
WallHeight=11;

difference(){
    union(){
        for(i=[0:NumberOfRows-1]){
            for(j=[0:NumberOfBitsPerRow-1]){
                    //Create the basic chunk of plastic we are going to build this out of.
                translate([(2*ceil(i/2)-i)*(SizeOfBit+Clearance)/2+(SizeOfBit+Clearance)*j,i*((SizeOfBit+Clearance)/cos(30)+WallThickness/cos(30)-(SizeOfBit+Clearance)/2/cos(30)*sin(30)),0]){
                    rotate([0,0,30]) cylinder_outer(height=WallThickness+WallHeight,radius=(SizeOfBit+Clearance+2*WallThickness)/2,fn=6);
                }
            }
        }
    }
    for(i=[0:NumberOfRows-1]){
        for(j=[0:NumberOfBitsPerRow-1]){
                //Remove plugs a bit bigger than the bits for the bits to fit into.
            translate([(2*ceil(i/2)-i)*(SizeOfBit+Clearance)/2+(SizeOfBit+Clearance)*j,i*((SizeOfBit+Clearance)/cos(30)+WallThickness/cos(30)-(SizeOfBit+Clearance)/2/cos(30)*sin(30)),WallThickness]){
                rotate([0,0,30])cylinder_outer(height=WallThickness+WallHeight,radius=(SizeOfBit+Clearance)/2,fn=6);
            }
                //Punch holes in the bottom to save time and plastic.
            translate([(2*ceil(i/2)-i)*(SizeOfBit+Clearance)/2+(SizeOfBit+Clearance)*j,i*((SizeOfBit+Clearance)/cos(30)+WallThickness/cos(30)-(SizeOfBit+Clearance)/2/cos(30)*sin(30)),-.1]){
                rotate([0,0,30])cylinder_outer(height=WallThickness+WallHeight,radius=(SizeOfBit+Clearance)/2-1,fn=6);
            }
        }
            //Remove those pesky zero width pieces caused by round off error that remain between adjacent bit holes.
        translate([(2*ceil(i/2)-i)*(SizeOfBit+Clearance)/2,i*((SizeOfBit+Clearance)/cos(30)+WallThickness/cos(30)-(SizeOfBit+Clearance)/2/cos(30)*sin(30))-(SizeOfBit+Clearance)*sin(30)/cos(30)/2,WallThickness])cube([(NumberOfBitsPerRow-1)*(SizeOfBit+Clearance),(SizeOfBit+Clearance)*sin(30)/cos(30),WallThickness+WallHeight]);
    }
}

module cylinder_outer(height,radius,fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}
