!print_clock.

+!greet : language(english)
    <- .send(marie,tell,day_of_week(sunday));
       .print("hello world.").            

+!greet : language(french)
    <- .print("bonjour.").                

+!start_clock
   <- setFrequency(10);
      start.

+!inform_date
   <- .date(Y,M,D); //check the current date
      .print("Current date ", Y, "-", M, "-", D).

+day_of_week(D)
   <- .print("Today is ", D).


/*

//Exercise 2.3.6 - solution 1
+nticks(X) : not(last_lock(L))| (last_lock(L)&X>=L+10000)
   <- .print("Current clock: ", X);
      -+last_lock(X).

*/


//Exercise 2.3.6 - solution 2 - requires to specify the initial goal 'print_clock'
/*+!print_clock : nticks(X)
   <- .print("Current clock: ", X);
      .wait( nticks(Y) & Y>=X+10000);
      !print_clock.
*/      

+nticks(X) : .my_name(bob) <- .print("Current clock: ", X).

//-------------------------------------------------------------    

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
