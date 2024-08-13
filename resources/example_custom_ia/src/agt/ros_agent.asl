!walk.

+!walk : .random(X) & .random(Y) //generate random values for X and Y (linear velocities)
          & (.random(MX) & ((MX < 0.5 & SX=1)|(MX >= 0.5 & SX=-1))) //randomly set the signal of X
          & (.random(MY) & ((MY < 0.5 & SY=1)|(MY >= 0.5 & SY=-1)))  //randomly set the signal of Y
   <- //.move_robot([2*X*SX,2*Y*SY,0],[0,0,0]);
      .move_robot(2*X*SX,2*Y*SY);
      .recharge_battery;
      .wait(100);
      !walk;
      .

+batteryLevel(L)
   <- .print("My battery level is ", L, ".").




//-------------------------------------------------------------    

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }