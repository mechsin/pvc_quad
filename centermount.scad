
module
hexagon (d, height)
// D is the distance between two oppisite vertices on the hexagon
// d is the distance between two parallel sides
{
   D = d * 2 / sqrt(3);
   t = D / 2;

   translate([0, 0, height / 2])
   union() {
   for (r =[0, 60, 120]) {
     rotate ([0, 0, r]) cube ([t, d, height], true);
   }
}
}


module
centerBoardMount(beamLength, beamWidth, beamHeight, hole2holeX, hole2holeY, boardDiameter, boardHoleDiameter, boardNutDiameter, boardNutDepth, mountDiameter, mountHoleDiameter, mountOffSet, centerHole=true)
{

// This translate list is use to create the holes for the board
// mount they are multiplid by diagonal distane between the
// board mounting holes as well as the diagonal for the mounting
// holes for the bracket it self
translateList = [
                     [1, 0, 0]
                    ,[0, 1, 0]
                    ,[-1, 0]
                    ,[0, -1, 0]
                  ];

diagonalBoard = sqrt(pow(hole2holeX, 2) + pow(hole2holeY, 2));
diagonalMount = beamLength - mountDiameter - 2 * mountOffset;
translateBoard = diagonalBoard/ 2 * translateList;
translateMount = concat(diagonalMount / 2 * translateList, [[0,0,0]]);

// After the part is constructed we flip it over and put it in the
// positive Z space. This is so the inserts for the nuts will be
// printed up.
translate([0,0, beamHeight])
rotate(180, v=[1, 0, 0])

// Subtract the holes in the mounts and the pocket for the nuts
difference() {

// Union all the arms, bracket and board mounts
union() {

   // Create the mounts for the board
   for (entry = translateBoard) {
      translate(entry)
      difference() {
         cylinder(d=boardDiameter, h=beamHeight);
      }
   }

  // Create the mounts for the bracket
  for (entry = translateMount) {
      translate(entry)
      cylinder(d=mountDiameter, h=beamHeight);
   }

   // Create on arm of the bracket
   translate([-beamWidth / 2, -beamLength / 2, 0])
   cube([beamWidth, beamLength, beamHeight]);

   // Create the other arm of the bracket
   rotate(-90)
   translate([-beamWidth / 2, -beamLength / 2, 0])
   cube([beamWidth, beamLength, beamHeight]);
};

// Create the holes for the board in the mounts and
// the pocket for the nuts
for (entry = translateBoard) {
      translate(entry)
      union() {
         cylinder(d=boardHoleDiameter, h=beamHeight, $fn=20);
         hexagon(boardNutDiameter, boardNutDepth);
      }

      }

// Create the holes for the bracke mount
for (entry = translateMount) {
      translate(entry)
      cylinder(d=mountHoleDiameter, h=beamHeight, $fn=20);
   }

};

}

//TEST

//// Board dimensions
//hole2holeX = 46;
//hole2holeY = 45;
//
//boardDiameter = 5 * 2 / sqrt(3) + 3;
//boardHoleDiameter = 2.8;
//boardNutDiameter = 5;
//boardNutDepth = 3.5;
//
//// Beam dimensions
//beamLength = 99;
//beamWidth = boardHoleDiameter;
//beamHeight = 7;
//
//// Mount hole dimensions
//mountDiameter = 8;
//mountHoleDiameter = 4.5;
//mountOffset = 2;
//
//
//
//
//centerBoardMount(beamLength, beamWidth, beamHeight, hole2holeX, hole2holeY, boardDiameter, boardHoleDiameter, boardNutDiameter, boardNutDepth, mountDiameter, mountHoleDiameter, mountOffset, true);

