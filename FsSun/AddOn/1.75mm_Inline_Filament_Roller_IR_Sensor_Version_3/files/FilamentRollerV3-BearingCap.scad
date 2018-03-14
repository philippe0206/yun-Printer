$fn=50;

// Nut dimensions
nutX=4;
nutY=3.7;
nutZ=6;
module nut(nutX_arg=nutX,nutY_arg=nutY,nutZ_arg=nutZ)
{
    union()
    {
        cube([nutX_arg,nutY_arg,nutZ_arg],center=true);
        rotate(a=120,v=[1,0,0])  cube([nutX_arg,nutY_arg,nutZ_arg],center=true);
        rotate(a=240,v=[1,0,0])  cube([nutX_arg,nutY_arg,nutZ_arg],center=true);
    }
}

// Feet dimensions
footScrewR=1.8;
footHeadR=3;
footHeadH=1.5;

// Bearing mandrel dimensions
bearingZ=3.5;
bearingR=4;
bearingStandoffR=5;
bearingStandoffH=1.0;
bearingScrewR=3;
module bearing()
{
    difference()
    {
        union()
        {
            cylinder(r=bearingR,h=bearingZ);
            cylinder(r=bearingStandoffR,h=bearingStandoffH);
        }
        cylinder(r=footScrewR,h=bearingZ);
        cylinder(r=footHeadR,h=footHeadH);
    }
}

bearing();