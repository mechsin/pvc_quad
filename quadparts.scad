module motorholes(diameter=3){
    r1 = 16 / 2;
    r2 = 19 / 2;
    
    union(){
    translate([r1, 0]){
    circle(diameter);
    };
    
    translate([-r1, 0]){
            circle(diameter);
    };
    
    translate([0, r2]){
            circle(diameter);
    };
    
    translate([0, -r2]){
            circle(diameter);
    };
};
};

module mountCrossDiff(screwDiameter=3, mountDiameter=6, screwLength=12, motorDepth=3, extra=0, centerHoleDiameter=0){
    /* 
      This is needed in case the where the cross is in set into the 
      part this shape can be used to remove all the material including 
      the screw holes.    
    */
   
    r1 = 16 / 2;
    r2 = 19 / 2;
    mountDepth = screwLength - motorDepth - extra;
   // This union creates the cross
   // To create the cross we make two sets of cylinders and the us
   // the hull command to connect them together.
   union(){
      
      // X axis
      hull(){
             translate([r1, 0]){
             cylinder(h=mountDepth, d=mountDiameter, $fn=50);
             };

             translate([-r1, 0]){
                     cylinder(h=mountDepth, d=mountDiameter, $fn=50);
             };
         };
         
      // Y axis
      hull(){
          translate([0, r2]){
                  cylinder(h=mountDepth, d=mountDiameter, $fn=50);
          };
          
          translate([0, -r2]){
                  cylinder(h=mountDepth, d=mountDiameter, $fn=50);
          };

      };

    
    // East Hole
    translate([r1, 0, 0])
    cylinder(h=mountDepth + extra, d=screwDiameter, $fn=50);
    // West Hole
    translate([-r1, 0, 0])
    cylinder(h=mountDepth + extra, d=screwDiameter, $fn=50);
    // North Hole
    translate([0, r2, 0])
    cylinder(h=mountDepth + extra, d=screwDiameter, $fn=50);
    // South Hole
    translate([0, -r2, 0])
    cylinder(h=mountDepth + extra, d=screwDiameter, $fn=50);
    
    // Center Hole
    cylinder(h=mountDepth + extra, d=centerHoleDiameter, $fn=50);
   };
};

module mountCross(screwDiameter=3, mountDiameter=6, screwLength=12, motorDepth=3, extra=0, centerHoleDiameter=0){
    
    r1 = 16 / 2;
    r2 = 19 / 2;
    mountDepth = screwLength - motorDepth - extra;
    
difference(){
   
   // This union creates the cross
   // To create the cross we make two sets of cylinders and the us
   // the hull command to connect them together.
   union(){
      
      // X axis
      hull(){
             translate([r1, 0]){
             cylinder(h=mountDepth, d=mountDiameter, $fn=50);
             };

             translate([-r1, 0]){
                     cylinder(h=mountDepth, d=mountDiameter, $fn=50);
             };
         };
         
      // Y axis
      hull(){
          translate([0, r2]){
                  cylinder(h=mountDepth, d=mountDiameter, $fn=50);
          };
          
          translate([0, -r2]){
                  cylinder(h=mountDepth, d=mountDiameter, $fn=50);
          };

      };
   };
    
    // East Hole
    translate([r1, 0, 0])
    cylinder(h=mountDepth + extra, d=screwDiameter, $fn=50);
    // West Hole
    translate([-r1, 0, 0])
    cylinder(h=mountDepth + extra, d=screwDiameter, $fn=50);
    // North Hole
    translate([0, r2, 0])
    cylinder(h=mountDepth + extra, d=screwDiameter, $fn=50);
    // South Hole
    translate([0, -r2, 0])
    cylinder(h=mountDepth + extra, d=screwDiameter, $fn=50);
    
    // Center Hole
    cylinder(h=mountDepth + extra, d=centerHoleDiameter, $fn=50);
};

};