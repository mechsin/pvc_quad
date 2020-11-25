//module pvc_adapter_projection(innerdiameter, outerdiameter, basewidth, extra, doubleflat=false){
module pvc_adapter_projection(innerdiameter, outerdiameter, basewidth, extra, numberflats=0){

// Define variables and calcualte phi which is needed for determining
// the points for the trapizoid.   
outerradius = outerdiameter / 2;
CS = sqrt (pow (outerradius + extra, 2) + pow (basewidth / 2, 2));
T = sqrt (pow (outerradius + extra, 2) + pow (basewidth / 2, 2) - pow(outerradius, 2));
phi = 180 - asin (outerradius / CS) - acos (basewidth / (2 * CS));

// Define the points for the trapizoid
points =[
         [basewidth / 2, 0]
        ,[basewidth / 2 + T * cos (phi), T * sin (phi)]
        ,[-basewidth / 2 - T * cos (phi), T * sin (phi)]
        ,[-basewidth / 2, 0]
        ];
   
  // Subtract the inner diameter circle from the outer diameter circle
  // to make the hole.
  difference ()
  {
    // Union the trapizoids that make the flat faces and the outer 
    // diameter circle.
    union ()
    {
      if (numberflats) { 
         // Built the trapizoids that will create the flat sides
         // We distribute them evenly around the circle 
         for (k = [1:numberflats]) {
            rotate((k - 1) * 360 / numberflats, [0, 0, 1])
            translate ([0, -(outerdiameter / 2 + extra)])
            polygon (points = points);
         };
      };

      // Outer circle
      circle (d = outerdiameter);
    };
    // Inner Circle
    circle (d = innerdiameter);
  };
 }
    
module pvc_adapter(innerdiameter, outerdiameter, basewidth, extra, height, numberflats=0, sideholes=false, shpadwidth, shpaddiameter, shscrewdiameter, shchamferangle) {

difference(){  
    union(){  
        linear_extrude (height = height)
        pvc_adapter_projection(innerdiameter, outerdiameter, basewidth, extra, numberflats);

        if (sideholes) {
            rise = shpaddiameter / 2;
            hypo = rise / sin(shchamferangle);
            run = hypo * cos(shchamferangle);
            h = shpadwidth  + (outerdiameter - innerdiameter) / 2;
            r1 = rise / run * h + rise;
            r2 = rise;
            xt = innerdiameter / 2 ;
            
            // Side 1
            translate([xt, 0, height / 2]) 
            rotate(90, v=[0,1,0])
            cylinder(h=h, r1=r1, r2=r2);
            
            //Side 2
            translate([-xt, 0, height / 2]) 
            rotate(-90, v=[0,1,0])
            cylinder(h=h, r1=r1, r2=r2);
        };
    }

    if (sideholes){
        translate([1 + outerdiameter / 2 + shpadwidth, 0, height / 2])
        rotate(-90, v=[0,1,0])
        cylinder(h=2 + outerdiameter + 2 * shpadwidth, d=shscrewdiameter, $fn=20);
    };
};

};
