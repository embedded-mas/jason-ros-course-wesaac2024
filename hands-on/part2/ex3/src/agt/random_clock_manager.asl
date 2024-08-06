//20% of chance to start the clock
+!manage_clock : .random(X) & X >= 0.80 & .random(T)
   <- .print("I am starting the clock.");
      start;
      .wait(T*10000); //wait a random time to act again
      !manage_clock;
      .


//20% of chance to stop the clock
+!manage_clock : .random(X) & X <= 0.20 & .random(T) & nticks(N)
   <- .print("I am stopping the clock at time ", N);
      stop;
      .wait(T*10000); //wait a random time to act again
      !manage_clock;
      .      

//60% of chance to just wait
+!manage_clock : .random(T)
   <- .wait(T*10000); //wait a random time to act again
      !manage_clock;
      .            


//-------------------------------------------------------------    

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
