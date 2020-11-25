
use <quadparts.scad>;
use <pvc_adapter.scad>;

module pad_projection(baseWidth, padWidth, padLength, extra){
    
outerdiameter = padLength;
basewidth = baseWidth;
    
outerradius = outerdiameter / 2;
CS = sqrt (pow (outerradius + extra, 2) + pow (basewidth / 2, 2));
T = sqrt (pow (outerradius + extra, 2) + pow (basewidth / 2, 2) - pow(outerradius, 2));
phi = 180 - asin (outerradius / CS) - acos (basewidth / (2 * CS));
    
points =[[basewidth / 2, 0],
	 [basewidth / 2 + T * cos (phi), T * sin (phi)],
	 [-basewidth / 2 - T * cos (phi), T * sin (phi)],[-basewidth / 2, 0]];
   
    resize([padWidth, padLength + extra])
    union ()
    {
	polygon (points = points);
    translate ([0, outerradius + extra])
    circle (d = outerdiameter);
    };
};

module padShaped(){
// This most outer difference removes all the extra material and shapes the piece as we want it
difference(){

// This initial difference on the pad makes the cut outs for the motor screw holes and makes the cutout 
// for the motor cross pad that will eventually be added
difference(){
linear_extrude (height = height, center = false)
pad_projection(baseWidth, padWidth, padLength, extra=strech);
    
//Motor mount screw holes and cross pad
zMountCross = motorDepth;
translate([0, strech + padLength / 2, zMountCross])
rotate(-45)
mountCrossDiff(screwDiameter, mountDiameter, screwLength=height, motorDepth=motorDepth, extra=padThickness);    
};   
   

// Center cut out 
// This creates the cylinder that makes the arc underneath the pad
cyWidth = padWidth + 5;
translate([0, totalLength, subHeight / 2])
union(){
resize([cyWidth, padLength * 2, subHeight])
rotate(90, v=[0, 0 ,1])
rotate(90, v=[1, 0, 0])
cylinder(cyWidth, r=padLength,center=true);
translate([-cyWidth / 2, -padLength, -subHeight / 2])
cube([cyWidth, padLength, subHeight / 2], center=false);
};

// Two cylinders to remove the material from the sides of the platform and create the I beam shape in the 
// center
translate([padWidth / 2, totalLength, subHeight / 2])
resize([sideDiameter, totalLength, subHeight])
rotate(90, v=[1,0,0])
cylinder(h=totalLength, d=subHeight);

translate([-padWidth / 2, totalLength, subHeight / 2])
resize([sideDiameter, totalLength, subHeight])
rotate(90, v=[1,0,0])
cylinder(h=totalLength, d=subHeight);

// This is a cube that is used to remove excess material from the bottom of the model. There is
// a circular cut out in the top middle of it in order to leave the I beam shape
difference(){
translate([-padWidth / 2, 0, 0])
cube([padWidth, totalLength, height / 2]);

translate([0, totalLength, height / 2])
rotate(90,v=[1,0,0])
cylinder(h=totalLength, d=adapterInnerDiameter);
};
};
}

// Define all sizes having to do with the motor pad itself
//padLength = 45;
//padWidth = 53;
padLength = 38;
padWidth = 38;
padThickness = 4;
baseWidth = 20;
strech = 10;
totalLength = padLength + strech;
height = 42;
subHeight = height - padThickness;

// Define all measurements for the PVC adapter
adapterInnerDiameter = 34;
adapterOuterDiameter = 42;
adapterLength = strech + 20;
holeDepth = adapterLength;

//PVC adapter side mount holes
shScrewDiameter = 4.2;
shPadDiameter = 8;
shPadWidth = 2;

// These control the width of the I beam shape in that can be seen in the center of the 
// hole for the PVC adapter
centerBarWidth = 5;
sideDiameter = padWidth - centerBarWidth;

// Measurements used to create the screw holes for mounting the motor.
screwDiameter = 3;
mountDiameter = 6;
screwLength = 12;
motorDepth = 3;

translate([0, 0, height])
rotate(180, v=[0,1,0])
union(){
    
padShaped();

// Add the motor mount cross pad for the screws 
zMountCross = height - (screwLength - motorDepth);
translate([0, strech + padLength / 2, zMountCross])
rotate(-45)
mountCross(screwDiameter, mountDiameter, screwLength, motorDepth, extra=padThickness);    
    
// Merge in the PVC adapter 
translate([0, strech, height / 2]) 
rotate(90, v=[1, 0, 0])
pvc_adapter(innerdiameter=adapterInnerDiameter,outerdiameter=adapterOuterDiameter,basewidth=baseWidth,extra=0,height=adapterLength, doubleflat=true, sideholes=false, shpadwidth=shPadWidth, shpaddiameter=shPadDiameter, shscrewdiameter=shScrewDiameter);
    

    
};
