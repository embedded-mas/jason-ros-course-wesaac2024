/* Initial beliefs */
world_hight(11). //hight of the world - DO NOT CHANGE THIS BELIEF
world_width(11). //width of the world - DO NOT CHANGE THIS BELIEF
velocity(1).     //default velocity of the robot

//unifies the positive value of X with Y
absolute(X,Y):-X>=0 &  Y=X. 
absolute(X,Y):-X<0 &  Y=-X.


//control_factor(D,P,F): calculates a factor F as a fuction of the distance to travel D and the traveled distance P
//this factor can be multiplied by the default velocity of the robot to slow down before stopping or changing the direction
control_factor(Distance,Position,1-Y) :- absolute((((Position/Distance)-0.8)/0.2)**1.5,Y)& Position/Distance>=0.8 & Distance>5.
control_factor(Distance,Position,(1-Y)**0.7) :- absolute((((Position/Distance)-0.4)/0.6), Y) & Position/Distance>=0.4 & Distance<=5.
control_factor(Distance,Position,(1-Y)**0.7) :- absolute((((Position/Distance)-0.2)/0.8), Y) & Position/Distance>=0.2 & Distance<5.
control_factor(Distance,Position,1).


/* Initial goals */

/* walk: goal to navigate the entire environment in square-shaped routes. 
It begins at the coordinate (1,1) and runs along a square route of side length 9. 
Then, it moves (i) to the coordinate (2,2) and runs along a square route of side length 7, 
(ii) to (3,3) and runs along a square route of side length 5, 
(iii) to (4,4) and runs along a square route of side length 3, 
and (iv) to (5,5) and runs along a square route of side length 1. */
!walk. 


/* keep_energy: goal to keep the robot's energy above zero. If the energy reaches zero, the robot is destroyed. */
!keep_energy.



/************************* Plan library *************************/

/* This plan decomposes the goal walk in 5 subgoals square_walk(S,X,Y) to run a squared route of side length S
   starting at (X,Y)  */
+!walk
   <- !square_walk(9,1,1); //walk along a square of size 9, starting at (1,1)
      !square_walk(7,2,2);
      !square_walk(5,3,3);
      !square_walk(3,4,4);
      !square_walk(1,5,5).


/* Plan to achieve the goal square_walk(S,X,Y).
   This plan decomposes the goal in 4 subgoals walk_side1(S,X,Y), which refer to walk along each side of the 
   squared route of side lenght S, starting at (X,Y).
 */
+!square_walk(S,X,Y) : world_hight(H) &  world_width(W)
   <- .move_to((H-S)/2,(W-S)/2,0);    //go to the starting point
      !walk_side1(S,(H-S)/2,(W-S)/2); //walk from bottom to top
      !walk_side2(S,(H-S)/2,(W-S)/2); //walk from left to right
      !walk_side3(S,(H-S)/2,(W-S)/2); //walk from top to bottom
      !walk_side4(S,(H-S)/2,(W-S)/2); //walk from high to left
      .



+!walk_side1(S,X,Y) : position(x(MX),y(MY)) & MY>=Y+S. // if the target position is achieved, do nothing.

 // if the target position is not achieved...
+!walk_side1(S,X,Y) : position(x(MX),y(MY))  
                      & control_factor(S,MY-Y,F) 
   <- ?velocity(V); //consult the current velocity and records it in V
      .print("Moving (1) ...", S, " - ", MY, " - ",Y+S-MY, " - ",F, ";", V*F);
      .move_robot([0,V*F,0],[0,0,0]); //TODO: move the robot
      .wait(1000);
      !walk_side1(S,X,Y). // keep walking

+!walk_side1(S,X,Y) // if the robot does not know its position...
   <- .wait(100); !walk_side1(S,X,Y). // ... wait and try again





+!walk_side2(S,X,Y) : position(x(MX),y(MY)) & MX>=X+S.

+!walk_side2(S,X,Y) : position(x(MX),y(MY))
                      & control_factor(S,MX-X,F)
   <- ?velocity(V); 
      .print("Moving (2) ...", S, " - ", MX, " - ",X+S-MX, " - ",F, ";", V*F);
      .move_robot([V*F,0,0],[0,0,0]); 
      .wait(1000);
      !walk_side2(S,X,Y).






+!walk_side3(S,X,Y) : position(x(MX),y(MY)) & MY<=Y.

+!walk_side3(S,X,Y) : position(x(MX),y(MY))
                      & control_factor(S,Y+S-MY,F)
   <- ?velocity(V); //consult the current velocity and records it in V
      .print("Moving (3)...", S, " - ", MY, " - ",Y+S-MY, " - ",F, ";", -V*F);
      .move_robot([0,-V*F,0],[0,0,0]); 
      .wait(1000);
      !walk_side3(S,X,Y).





+!walk_side4(S,X,Y) : position(x(MX),y(MY)) & MX<=X.

+!walk_side4(S,X,Y) : position(x(MX),y(MY))
                      & control_factor(S,X+S-MX,F)
   <- ?velocity(V); //consult the current velocity and records it in V
      .print("Moving (4) ...", S, " - ", MX, " - ",X+S-MX, " - ",F, ";", -V*F);
      .move_robot([-V*F,0,0],[0,0,0]); 
      .wait(1000);
      !walk_side4(S,X,Y).


// TODO: implement plans to achieve the goal keep_energy

+!keep_energy : batteryLevel(L) & L >= 300
   <- .wait(1000);
      +velocity(1);
      !keep_energy.
   
+!keep_energy : batteryLevel(L) & L < 300 
      <- /*?velocity(V);
         .print("My battery level is ", L, ". Recharging. Reducing velocity to ", V*0.8);
         -+velocity(V*0.8);
         .recharge_battery;
         .wait(2000);*/
         !recharge;
         !keep_energy.

+!keep_energy
   <- .wait(1000);
      !keep_energy.         


/* recharge: recharge the battery. The velocity reduces during the recharging process. 
             The robot may eventually stop until the recharging is complete.
             Some more efficient energy control strategies may be implemented.
*/
+!recharge :  batteryLevel(L) & L < 1000  
   <- ?velocity(V);
      .print("My battery level is ", L, ". Recharging. Reducing velocity to ", V*0.8);
      -+velocity(V*0.8);
      .recharge_battery;
      .wait(2000);
      !recharge;
      .

+!recharge.


// print the energy level when it changes
+batteryLevel(L) 
   <- .print("My battery level is ", L, ".").




//-------------------------------------------------------------    

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }

