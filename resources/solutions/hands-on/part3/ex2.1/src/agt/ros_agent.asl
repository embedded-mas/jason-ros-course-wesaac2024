!walk.

+!walk 
   <- .wait(2000); //wait two seconds
      .move_to(2,2,0);
      .


+position(X,Y)
   <- .print("My position is (",X,",",Y,")").





//-------------------------------------------------------------    

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }