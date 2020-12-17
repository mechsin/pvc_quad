
module landingStrut(length, widthInitial, widthFinal, height, flangeWidth=4, webWidth=2, webCircles=false, gapBetweenCircles=2) {

   // This function recusively creates the coordinates needed to create the
   // circles that will be cut out of the webWidth.
   // m is the slope of the angled flangeWidth
   m = (widthFinal - widthInitial) / height;

   // The below uses the properties of right tangential trapeziod to
   // determine the height of each trapaziod iteration so that a
   // circle that is tangent to all four sides can be made maximizing
   // the amount of material that will be remove.
   // In the below a, b, and c are the variables as normally defined
   // in the quadratic equation. The r for the next circle is then the
   // + solution to the quadratic equation. The trapziod height is always
   // twice the radius and the length of the other base is calculated
   // base on the slope of the other web.
   // The one draw back is I cannot identify if I am taller than the
   // part until the iteration that is over.
   function circles(h, wi) =
      let(
            a = 2 * m
          , b = 2 * wi * (1 - m)
          , c = -1 * pow(wi, 2)
          , r = (-b + sqrt(pow(b, 2) - 4 * a * c)) / (2 * a)
          , wf = 2 * r * m + wi
          , hf = h + 2 * r
      )
      (hf > height ? [[r, h]] : concat([[r, h]], circles(hf, wf)));

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
            innerWidthInitial = widthInitial - 2 * flangeWidth;
            for (i = circles(0, innerWidthInitial)) {
               let(
                     r = i[0]
                   , h = i[1]
                   , xT = -length / 2
                   , yT = r + flangeWidth
                   , zT = h + r
                   , circleTop = h + 2 * r
               )

               // Note the gap desired between the circles is subtracted
               // out on creation of the cylinder below
               // The if statement is need to check if the top of the
               // circle will extend pass the top of the strut.
               if (circleTop < height) {
                  translate([xT, yT , zT])
                  rotate(90, [0, 1, 0])
                  cylinder(r=r - gapBetweenCircles / 2, h=length);
               }
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

// Test
//landingStrut(20, 30, 15, 70, gapBetweenCircles=1.25, webCircles=true);

