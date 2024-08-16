//plan to print the battery level whenever the corresponding belief changes
+batteryLevel(L) 
   <- .print("My energy is ", L).
   

//TODO: Exercise 3.1.3. Extend the code of the agent of to print its current position (X,Y) when it changes.
+position(X,Y)
   <- .print("My position is (",X,",",Y,")").



//TODO: Exercise 3.1.2: Extend this implementation to print the current environmental safety status when it changes.
+security_level(L)
   <- .print("Security level: ", L).





//-------------------------------------------------------------    

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
