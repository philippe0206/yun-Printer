$fn=50;

// Enclosure dimensions
diodeWallT=2;
// Eyelet body dimensions
eyeBodyX=50;
eyeBodyY=10;
eyeBodyZ=diodeWallT;
rollerAccessR=13;
bridgeX=30;
bridgeY=15;
bridgeZ=10;

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
footX=10;
footY=10;
footZ=10;
footScrewR=1.8;
footScrewH=footZ;
footHeadR=3;
footHeadH=4;
screwOffset=5;
module foot()
{
    difference()
    {
        cube([footX,footY,footZ]);
        translate([footX/2,footY/2,footZ-screwOffset])  rotate(a=90,v=[1,0,0])  cylinder(r=footScrewR,h=2*footScrewH,center=true);
        translate([footX/2,footY-footHeadH,footZ-screwOffset])  rotate(a=-90,v=[1,0,0])  cylinder(r=footHeadR,h=2*footHeadH);
    }
}

// Bearing mandrel dimensions
bearingZ=4;
bearingY=-4;
bearingR=4;
bearingStandoffR=5;
bearingStandoffH=2.0;
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
    }
}

difference()
{
    union()  {
        translate([0,0,0])  cube([eyeBodyX,eyeBodyY,eyeBodyZ]);
        translate([0,0,diodeWallT])  foot();
        translate([eyeBodyX-footX,0,diodeWallT])  foot();
        translate([footX,0,diodeWallT])  cube([bridgeX,bridgeY,bridgeZ]);
    }
    // Cut bearing access
    translate([eyeBodyX/2,bearingY,0])  cylinder(r=rollerAccessR,h=12);
}

difference()
{
    union()
    {
        // Add bearing and support
        translate([footX,0,0])  cube([bridgeX,bridgeY,diodeWallT]);
        translate([eyeBodyX/2,0,0])  cylinder(r=11,h=diodeWallT);
        translate([0,-eyeBodyY,0])  cube([eyeBodyX,eyeBodyY,diodeWallT]);
        translate([eyeBodyX/2,bearingY,diodeWallT])  bearing();
    }
    translate([eyeBodyX/2,bearingY,0])  cylinder(r=footScrewR,h=12);
    translate([eyeBodyX/2,bearingY,0])  rotate(a=90,v=[0,1,0])  nut(nutX_arg=4);
}