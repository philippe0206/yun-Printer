$fn=50;

// Height difference caused by footer and PCB on total assembly height
pcbfootZ=3.6;
// Main body dimensions
pylonX=20;
pylonY=60-pcbfootZ;
pylonZ=10;
// Enclosure dimensions
diodeWallT=2;
diodeX=12;
diodeY=20-pcbfootZ;
diodeZ=pylonZ-diodeWallT;
// Eyelet body dimensions
eyeBodyX=50;
eyeBodyY=30;
eyeBodyZ=pylonZ;
rollerAccessR=15.5;
rollerR=14;
filamentR=1;
filamentEgressX=16;
filamentEgressY=6;
filamentEgressZ=pylonZ;
pMntOffset=pylonZ/2;
pMntScrew=2.8;
pMnt1X=pylonX/2-eyeBodyX/2+pMntOffset;
pMnt1Y=pylonY-pMntOffset;
pMnt1Z=pylonZ-pMntOffset;
pMnt2X=pylonX/2+eyeBodyX/2-pMntOffset;
pMnt2Y=pylonY-pMntOffset;
pMnt2Z=pylonZ-pMntOffset;

module filamentSwage()
{
    hull()
    {
        translate([0,0,3])  cylinder(r=filamentR,h=0.1,center=true);
        cylinder(r=3,h=1,center=true);
    }
}

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
footY=10-pcbfootZ;
footZ=pylonZ;
footScrewR=1.8;
footScrewH=footZ;
screwOffset=5;
module foot()
{
    difference()
    {
        cube([footX,footY,footZ]);
        translate([footX/2,footY/2,footZ-screwOffset])  rotate(a=90,v=[1,0,0])  cylinder(r=footScrewR,h=2*footScrewH,center=true);
        translate([footX/2,footY,footZ-screwOffset])  rotate(a=90,v=[0,0,1])  nut();
    }
}

// Bearing mandrel dimensions
bearingY=33-pcbfootZ;
bearingZ=4;//bearingZ=8;
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
    }
}

difference()
{
    // Main pylon with bearing mandrel
    union()
    {
        // Main pylon body
        cube([pylonX,pylonY,pylonZ]);
        // Feet
        translate([-footX,0,0])  foot();
        translate([pylonX,0,0])  foot();
        // Eyelet body
        translate([(pylonX-eyeBodyX)/2,pylonY-eyeBodyY,0])  cube([eyeBodyX,eyeBodyY,eyeBodyZ]);
    }
    // Cutting access for diodes behind control wheel
    translate([(pylonX-diodeX)/2,0,diodeWallT])  cube([diodeX,diodeY,diodeZ]);
    // Cutting bearing access
    translate([pylonX/2,bearingY,diodeWallT])  cylinder(r=rollerAccessR,h=2*pylonZ);
    translate([pylonX/2,bearingY+rollerR+12,0])  cylinder(r=13,h=10);
    // Squaring off edges
    translate([pylonX/2-filamentEgressX/2,bearingY+rollerR-filamentEgressY/2,diodeWallT])  cube([16,6,10])
    // Cutting access for mandrel screw
    translate([pylonX/2,bearingY,0])  cylinder(r=bearingScrewR,h=2*pylonZ,center=true);
    // Cutting access for filament (w/manual adjustment)
    //translate([0,-0.5,1.0])// manual adjustment
    translate([0,0,1.0])// manual adjustment
    {
        // Main channel
        translate([pylonX/2,bearingY+rollerR+filamentR/2,pylonZ/2])  rotate(a=90,v=[0,1,0])  cylinder(r=filamentR,h=3*eyeBodyX,center=true);
        // Cut swage for rollers
        translate([pylonX/2-filamentEgressX/2,bearingY+rollerR+filamentR/2,pylonZ/2])  rotate(a=-90,v=[0,1,0])  filamentSwage();
        translate([pylonX/2+filamentEgressX/2,bearingY+rollerR+filamentR/2,pylonZ/2])  rotate(a=90,v=[0,1,0])  filamentSwage();
        // Add swage (funnel) shapes to filament inlet/outlet
        translate([pylonX/2-eyeBodyX/2,bearingY+rollerR+filamentR/2,pylonZ/2])  rotate(a=90,v=[0,1,0])  filamentSwage();
        translate([pylonX/2+eyeBodyX/2,bearingY+rollerR+filamentR/2,pylonZ/2])  rotate(a=-90,v=[0,1,0])  filamentSwage();
    }
    // Cutting access for mounting screws
    translate([pMnt1X,pMnt1Y,pMnt1Z])  rotate(a=90,v=[0,0,1])  nut(nutX_arg=pMntScrew);
    translate([pMnt1X,pMnt1Y,0])  cube([7,pMntScrew,pylonZ],center=true);
    translate([pMnt1X,pMnt1Y+pMntOffset,pMnt1Z])  rotate(a=90,v=[1,0,0])  cylinder(r=1.8,h=8);
    translate([pMnt2X,pMnt2Y,pMnt2Z])  rotate(a=90,v=[0,0,1])  nut(nutX_arg=pMntScrew);
    translate([pMnt2X,pMnt2Y,0])  cube([7,pMntScrew,pylonZ],center=true);
    translate([pMnt2X,pMnt2Y+pMntOffset,pMnt2Z])  rotate(a=90,v=[1,0,0])  cylinder(r=1.8,h=8);
    // Cutting access for mandrel screw and nut
    translate([pylonX/2,bearingY,0])  cylinder(r=footScrewR,h=2*pylonZ,center=true);
    translate([pylonX/2,bearingY,0])  rotate(a=90,v=[0,1,0])  nut();
}
difference()
{
    translate([pylonX/2,bearingY,diodeWallT])  bearing();
    // Cutting access for mandrel screw
    translate([pylonX/2,bearingY,0])  cylinder(r=footScrewR,h=2*pylonZ,center=true);
}
//translate([pylonX/2,bearingY,diodeWallT+bearingStandoffH])  cylinder(r=rollerR,h=8);
//translate([10,43.4,6])  rotate(a=90,v=[0,1,0])  cylinder(r=filamentR,h=3*eyeBodyX,center=true);
//translate([0,-0.5,1.0])  translate([pylonX/2,bearingY+rollerR+filamentR/2,pylonZ/2])  rotate(a=90,v=[0,1,0])  cylinder(r=filamentR,h=3*eyeBodyX,center=true);
//translate([pylonX/2,bearingY,diodeWallT+bearingStandoffH])  cylinder(r=rollerR,h=bearingZ);
//translate([pylonX/2,bearingY,pylonZ+1.5])  cylinder(r=28,h=1);