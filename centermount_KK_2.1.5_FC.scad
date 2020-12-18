
include<centermount.scad>


// Dimensions for the PCB
// X and Y offsets for the mounting holes for the PCB
offsetX = 46;
offsetY = 45;

boardDiameter = 5 * 2 / sqrt(3) + 3;
boardHoleDiameter = 2.8;
boardNutDiameter = 5.1;
boardNutDepth = 3.5;

// Beam Dimensions

beamLength = 99;
beamWidth = boardHoleDiameter;
beamHeight = 7;

// Mount hole dimensions
mountDiameter = 8;
mountHoleDiameter = 4.5;
mountOffset = 1.5;

// Brace
braceOffset = sqrt(pow(offsetX, 2) + pow(offsetY, 2)) / 2;

difference(){

centerBoardMount(beamLength, beamWidth, beamHeight, offsetX, offsetY, boardDiameter, boardHoleDiameter, boardNutDiameter, boardNutDepth, mountDiameter, mountHoleDiameter, mountOffset, braceOffset=braceOffset, centerHole=true);
 
// Part Marking
letterDepth = 1;
translate([-5, -(beamWidth / 2 - letterDepth), beamHeight])
rotate(180, v=[0,1,0])
rotate(90, v=[1,0,0])
linear_extrude(letterDepth)
text("Mk3", size=8, font="Nimbus Mono PS:style=Bold", halign="left");
}   