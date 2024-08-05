
+!greet : language(english)
    <- .print("hello world.").            

+!greet : language(french)
    <- .print("bonjour.").                


//print the current clock every 5 seconds
+nticks(X) : not(last_clock(L))| (last_clock(L)&X>=L+5000)
   <- .print("Current clock: ", X);
      -+last_clock(X).


//-------------------------------------------------------------    

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
