$fn=50;

wallH=10;
wallT=4;
pcbMargin=1;

boxX=70+2*pcbMargin;
boxY=50+2*pcbMargin;
boxT=1.2;

standoffX=10;
standoffY=10;
standoffZ=4;
standoffOffsetX=standoffX/2;
standoffOffsetY=standoffY/2+pcbMargin;
standoffDistance=30;
module standoff()
{
    cylinder(r=1.8,h=10);
    cylinder(r=3.2,h=2.2);
}

mountX=12;
mountY=12;
mountZ=4;
mountScrewR=3;
module mount()
{
    difference()
    {
        cube([mountX,mountY,mountZ]);
        translate([mountX/2,mountY/2,0])  cylinder(r=mountScrewR,h=mountZ);
    }
}

difference()
{
    union()
    {
        // Floor
        cube([boxX,boxY,boxT]);
        // Walls
        translate([0,-wallT,0])  cube([boxX+wallT,wallT,wallH]);
        translate([0,boxY,0])  cube([boxX+wallT,wallT,wallH]);
        translate([boxX,0,0])  cube([wallT,boxY,wallH]);
        // PCB supports
        translate([0,standoffOffsetY,boxT])  cube([standoffX,standoffY,standoffZ]);
        translate([0,standoffOffsetY+standoffDistance,boxT])  cube([standoffX,standoffY,standoffZ]);
        translate([boxX/2-standoffX/2,boxY/2-standoffY/2,boxT])  cube([standoffX,standoffY,standoffZ]);
        // External mounts
        translate([-mountX,-wallT,0])  mount();
        translate([boxX+wallT,-wallT,0])  mount();
        translate([-mountX,boxY-mountY+wallT,0])  mount();
        translate([boxX+wallT,boxY-mountY+wallT,0])  mount();
    }
    // Screw standoffs
    translate([standoffOffsetX,standoffY/2+standoffOffsetY,0])  standoff();
    translate([standoffOffsetX,standoffY/2+standoffOffsetY+standoffDistance,0])  standoff();
    // Holes in the wall for access
    translate([boxX-pcbMargin-12,-wallT,6])  cube([11,wallT,wallH]);
    translate([boxX-pcbMargin-12,boxY,6])  cube([11,wallT,wallH]);
    translate([boxX-pcbMargin-36,boxY,6])  cube([16,wallT,wallH]);
}