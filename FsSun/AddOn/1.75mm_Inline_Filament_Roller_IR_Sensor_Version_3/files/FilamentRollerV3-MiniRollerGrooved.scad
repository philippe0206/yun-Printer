$fn=50;

// Press-fit roller onto bearing
bearingR=22/2+0.1;
bearingZ=8;
bearingHardStop=2;
rollerR=28/2;
rollerZ=bearingZ;
flangeR=56/2;
flangeZ=1;
grooveR=1;
grooveZ=5;
slotNum=40;
slotDeg=360/slotNum;
slotMargin=2;   // Add 2*slotMargin to flangeR
slotX=0.11;
slotY=5;
slotZ=flangeZ;

difference()
{
    union()
    {
        // Outer flange
        translate([0,0,-flangeZ])  cylinder(r=flangeR,h=flangeZ);
        // Bearing roller
        cylinder(r=rollerR,h=rollerZ);
    }
    // Bearing clearance and hard stop
    cylinder(r=bearingR,h=bearingZ+flangeZ);
    translate([0,0,-flangeZ])  cylinder(r=bearingR-bearingHardStop,h=flangeZ);
    // Groove on bearing roller
    for (i=[0:1:360])
    {
        //echo(i,sin(i)*rollerR,cos(i)*rollerR);
        translate([sin(i)*rollerR,cos(i)*rollerR,grooveZ])  sphere(r=grooveR);
    }
    // Encoder slots
    for (i=[0:slotDeg:360])
    {
        union()
        {
            // Pattern 0 (both sensors blocked)
            // No action
            // Pattern 1 (sensor 1 open)
            for (j=[i+0.26*slotDeg:0.1:i+0.50*slotDeg])
            {
                rotate(a=j,v=[0,0,1])
                translate([0,rollerR+slotMargin+slotY,-flangeZ-1])  cube([slotX,slotY,slotZ+2]);
            }
            // Pattern 2 (both sensors open)
            for (j=[i+0.50*slotDeg:0.1:i+0.75*slotDeg])
            {
                rotate(a=j,v=[0,0,1])
                translate([0,rollerR+slotMargin,-flangeZ-1])  cube([slotX,2*slotY,slotZ+2]);
            }
            // Pattern 3 (sensor 2 open)
            for (j=[i+0.75*slotDeg:0.1:i+slotDeg])
            {
                rotate(a=j,v=[0,0,1])
                translate([0,rollerR+slotMargin,-flangeZ-1])  cube([slotX,slotY,slotZ+2]);
            }
        }
    }
}