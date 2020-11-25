
use <quadparts.scad>;
use <pvc_adapter.scad>;

module pad_projection(baseWidth, padWidth, padLength){

points =[
         [baseWidth / 2, 0],
	     [padWidth / 2, strech],
         [-padWidth / 2, strech],
         [-baseWidth / 2, 0]
        ];
difference(){
  union ()
  {
    polygon (points);
    translate ([-padWidth / 2, strech])
    {
      difference ()
      {
	square ([padWidth, padLength]);
      };
    };
  };
  
    radius = (padWidth - baseWidth) / 2;
    translate([padWidth / 2, 0])
    resize(newsize=[radius * 2, strech * 2])
    circle(r = radius);

    translate([-padWidth / 2, 0])
    resize(newsize=[radius * 2, strech * 2])
    circle(r = radius);
};
};

module padShaped(){
difference(){

linear_extrude (height = height, center = false)
pad_projection(baseWidth, padWidth, padLength);
    

// Center cut out
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


translate([padWidth / 2, totalLength, subHeight / 2])
resize([sideDiameter, totalLength, subHeight])
rotate(90, v=[1,0,0])
cylinder(h=totalLength, d=subHeight);

translate([-padWidth / 2, totalLength, subHeight / 2])
resize([sideDiameter, totalLength, subHeight])
rotate(90, v=[1,0,0])
cylinder(h=totalLength, d=subHeight);

difference(){
translate([-padWidth / 2, 0, 0])
cube([padWidth, totalLength, height / 2]);

translate([0, totalLength, height / 2])
rotate(90,v=[1,0,0])
cylinder(h=totalLength, d=adapterInnerDiameter);
};
};
}

padLength = 45;
padWidth = 53;
padThickness = 4;
baseWidth = 20;
strech = 10;
totalLength = padLength + strech;
height = 42;
subHeight = height - padThickness;

adapterInnerDiameter = 34;
adapterOuterDiameter = 42;
adapterLength = strech + 20;
holeDepth = adapterLength;

centerBarWidth = 10;
sideDiameter = padWidth - centerBarWidth;

screwDiameter = 3;
mountDiameter = 6;
screwLength = 12;
motorDepth = 3;



difference(){
union(){
padShaped();

translate([0, strech, height / 2]) 
rotate(90, v=[1, 0, 0])
pvc_adapterD(innerdiameter=adapterInnerDiameter,outerdiameter=adapterOuterDiameter,basewidth=baseWidth,extra=0,height=adapterLength);
}

// Use screw length 20 to make sure we cut though all the pad
zMountCross = height - (20 - motorDepth);
translate([0, strech + padLength / 2, zMountCross])
rotate(-45)
mountCrossDiff(screwDiameter, mountDiameter, screwLength=20, motorDepth=motorDepth, extra=padThickness);

}

zMountCross = height - (screwLength - motorDepth);
translate([0, strech + padLength / 2, zMountCross])
rotate(-45)
mountCross(screwDiameter, mountDiameter, screwLength, motorDepth, extra=padThickness);

//translate([0, strech, height / 2]) 
//rotate(90, v=[1, 0, 0])
//cylinder(h=holeDepth, d=adapterInnerDiameter);
//};