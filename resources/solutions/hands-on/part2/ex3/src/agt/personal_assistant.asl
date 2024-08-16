
+!greet : language(english)
    <- .print("hello world.").            

+!greet : language(french)
    <- .print("bonjour.").                


//print the current clock every 1 seconds
+nticks(X) : not(last_clock(L))| ((X mod 10000)==0)
   <- .print("Current clock: ", X, " - ", X mod 10000);
      -+last_clock(X).



+!get_time_elapsed(T) : nticks(N) & N>=T
   <- stop;
      .wait(1000);
      !get_time_elapsed(T).

+!get_time_elapsed(T)
   <- setFrequency(1);
      start;
      .wait(1000);
      !get_time_elapsed(T).


//-------------------------------------------------------------    

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
