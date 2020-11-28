
module landingStrut(length, widthInitial, widthFinal, height, flangeWidth=4, webWidth=2, webCircles=false, gapWallCircles=2, gapBetweenCircles=2) {
   
   // This function recusively creates the coordinates needed to create the
   // circles that will be cut out of the webWidth.
   // m is the slope of the angled flangeWidth
   m = (widthInitial - widthFinal) / height;
   function circles(ws) =
   let (
      r = (widthInitial - m * ws - m * gapBetweenCircles - 2 * gapWallCircles) / (2 + m) -  flangeWidth
      ,x = r + gapBetweenCircles + ws
      ,ws = ws + 2 * gapBetweenCircles + 2 * r
   ) 
   (ws > height ? [[r, x, ws]] : concat([[r, x, ws]], circles(ws)));
   
   // Calculations for the second flangeWidth
   flangeWidth2Length = sqrt(pow(height, 2) + pow((widthInitial - widthFinal), 2));
   flangeWidth2Angle = acos(height / flangeWidth2Length);
   makeup = flangeWidth * tan(flangeWidth2Angle);
   
   // Put the bottome left corner at the origin
   translate([length / 2, 0, 0])
   
   // flangeWidth 2 union
   union(){
      // flangeWidth 2 cut away
      // This difference is removing the material from the webWidth for 
      // the angled second flangeWidth.
      difference() {
         // flangeWidth 1 and webWidth
         // This block draws the first flangeWidth and the webWidth as a 2d projection
         // and then extrudes them to the proper height
         linear_extrude(height)
         union() {

            // webWidth
            translate([-webWidth / 2, 0])
            square([webWidth, widthInitial]);

            // flangeWidth 1
            translate([-length / 2, 0])
            square([length, flangeWidth]);
         };
         
         // This is the subtraction block for the angled second flangeWidth
         translate([-length, widthInitial - flangeWidth, 0])
         rotate(flangeWidth2Angle, [1, 0, 0])
         translate([0, 0, -flangeWidth2Length / 2])
         cube([length * 2, widthInitial, flangeWidth2Length * 2]);
         
         // This block will remove material from the webWidth by
         // creating and array of circles that are then subtracted
         // These circles will appear offset from flangeWidth one by the 
         // value of gapWallCircles
         if (webCircles) {
            for (i = circles(0)) {
               let(
                   r = i[0]
                   , xT = -length / 2
                   , yT = r + gapWallCircles + flangeWidth
                   , zT = i[1]
               )
               translate([xT, yT , zT])
               rotate(90, [0, 1, 0])
               cylinder(r=r, h=length);
            }
         }
      
      }
      
      // flangeWidth 2
      // This is the angled second flangeWidth.
      // Because the second flangeWidth is created as a cube and then 
      // rotated the edges of the cube now extend above and below the 
      // ends of the existing webWidth and flangeWidth. Two additional cubes are 
      // created to remove this excess material and make the top and 
      // bottom of the flangeWidth flush with the webWidth and flangeWidth 1.
      difference() {
         translate([-length / 2, widthInitial, 0])
         rotate(flangeWidth2Angle, [1, 0, 0])
         translate([0, -flangeWidth, 0])
         cube([length, flangeWidth, flangeWidth2Length + makeup]);
         
         // These two cubes are used to remove the excess material 
         // Bottom cube
         translate([-length, -widthInitial / 4, -makeup *2])
         cube([length * 2, widthInitial * 2, makeup * 2]);
         // Top cube
         translate([-length, -widthInitial / 4, height])
         cube([length * 2, widthInitial * 2, makeup * 2]);
      }
   }   
};


//landingStrut(20, 30, 15, 70, webCircles=true);

