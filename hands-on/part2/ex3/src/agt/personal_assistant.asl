
+!greet : language(english)
    <- .print("hello world.").            

+!greet : language(french)
    <- .print("bonjour.").                


//print the current clock every 10000 ticks
+nticks(X) : X mod 10000 == 0
   <- .print("Current clock: ", X).



//-------------------------------------------------------------    

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
