
module
hexagon (d, height)
// D is the distance between two oppisite vertices on the hexagon
{
   D = d * 2 / sqrt(3);
   t = D / 2;
  
  for (r =[0, 60, 120])
    rotate ([0, 0, r]) cube ([t, d, height], true);
}


nutd = 5;
nutHeight = 2.8;

thickness = 5;
studDiameter = nutd * 2 / sqrt(3) + 3;
holeDiameter = 2.8;
braceWidth = holeDiameter;

mountDiameter = 8;
mountHoleDiameter = 4.5;



offsetX = 30.5;
offsetY = 30.5;

diagonalBoard= sqrt(pow(offsetX, 2) + pow(offsetY, 2));
diagonalBeam = 99;

//diagonalMount = diagonalBeam - (diagonalBeam - diagonalBoard) / 2;
diagonalMount = diagonalBeam - mountDiameter - 3;


//translateList = [
//                  [-offsetX / 2, -offsetY / 2, 0]
//                 ,[offsetX - offsetX / 2, -offsetY / 2, 0]
//                 ,[-offsetX / 2, offsetY - offsetY / 2, 0]
//                 ,[offsetX - offsetX / 2, offsetY - offsetY / 2, 0]
// 
//               ];
               

//translateList = [
//                  [diagonalBoard/ 2, 0, 0]
//                 ,[0, diagonalBoard/ 2, 0]
//                 ,[-diagonalBoard/ 2, 0]
//                 ,[0, -diagonalBoard/ 2, 0]
// 
//               ];
translateList = [
                  [1, 0, 0]
                 ,[0, 1, 0]
                 ,[-1, 0, 0]
                 ,[0, -1, 0]
 
               ];
               
translateBoard = diagonalBoard/ 2 * translateList;
translateMount = diagonalMount / 2 * translateList;
translateMount = concat(translateMount,[[0,0,0]]);

echo(diagonalBeam=diagonalBeam);
echo(diagonalBoard=diagonalBoard);
echo(diagonalMount=diagonalMount);

//translateList = translateList - [-offsetX / 2, -offsetY / 2, 0];
 
// Move to the center of the build plate 
//translate([100 - diagonal / 2, 100 - diagonal / 2, 0])

translate([0,0,thickness])
rotate(180, v=[1, 0, 0])

difference() {

union() {
   for (entry = translateBoard) {
      translate(entry)
      difference() {
         cylinder(d=studDiameter, h=thickness);
      }
   }
   
  for (entry = translateMount) {
      translate(entry)
      cylinder(d=mountDiameter, h=thickness);
   }

//   rotate(-45)
   translate([-braceWidth / 2, -diagonalBeam / 2, 0])
   cube([braceWidth, diagonalBeam, thickness]);

//   translate([0, -offsetY / 2, 0])
   rotate(-90)
   translate([-braceWidth / 2, -diagonalBeam / 2, 0])
   cube([braceWidth, diagonalBeam, thickness]);
};

for (entry = translateBoard) {
      translate(entry)
      union() {
         cylinder(d=holeDiameter, h=thickness, $fn=20);
         hexagon(nutd, nutHeight);
      }

      }
   
for (entry = translateMount) {
      translate(entry)
      cylinder(d=mountHoleDiameter, h=thickness, $fn=20);
   }
   
};

