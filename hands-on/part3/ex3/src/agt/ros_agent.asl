world_hight(11). //hight of the world
world_width(11). //width of the world
velocity(1).     //velocity when turtle moves

//unifies the positive value of X with Y
absolute(X,Y):-X>=0 &  Y=X. 
absolute(X,Y):-X<0 &  Y=-X.

control_factor(Distance,Position,1-Y) :- absolute((((Position/Distance)-0.8)/0.2)**1.5,Y)& Position/Distance>=0.8 & Distance>5.
control_factor(Distance,Position,(1-Y)**0.7) :- absolute((((Position/Distance)-0.4)/0.6), Y) & Position/Distance>=0.4 & Distance<=5.
control_factor(Distance,Position,(1-Y)**0.7) :- absolute((((Position/Distance)-0.2)/0.8), Y) & Position/Distance>=0.2 & Distance<5.
control_factor(Distance,Position,1).

!walk.
!keep_energy.

+!keep_energy : batteryLevel(L) & L >= 300
   <- .wait(1000);
      +velocity(1);
      !keep_energy.
   
+!keep_energy : batteryLevel(L) & L < 300 
      <- .print("My battery level is ", L, ". Recharging...");
         ?velocity(V);
         -+velocity(V*0.8);
         .recharge_battery;
         .wait(1000);
         !keep_energy.

+!keep_energy
   <- .wait(1000);
      !keep_energy.         



+!walk
   <- !square_walk(9,1,1); //walk along a square of size 9, starting at (1,1)
      !square_walk(7,2,2);
      !square_walk(5,3,3);
      !square_walk(3,4,4);
      !square_walk(1,5,5).

+!square_walk(S,X,Y) : world_hight(H) &  world_width(W)
   <- .move_to((H-S)/2,(W-S)/2,0); //go to the starting point
      !walk_side1(S,(H-S)/2,(W-S)/2); //walk from bottom to top
      !walk_side2(S,(H-S)/2,(W-S)/2); //walk from left to right
      !walk_side3(S,(H-S)/2,(W-S)/2); //walk from top to bottom
      !walk_side4(S,(H-S)/2,(W-S)/2); //walk from high to left
      .


+!walk_side1(S,X,Y) : position(x(MX),y(MY)) & MY>=Y+S.

+!walk_side1(S,X,Y) : position(x(MX),y(MY))
                      & control_factor(S,MY-Y,F) 
   <- .print("Moving ...", S," - ",MY-Y, " - ",F);
       ?velocity(V); //consult the current velocity and records it in V
      .move_robot([0,V*F,0],[0,0,0]); 
      .wait(1000);
      !walk_side1(S,X,Y).

+!walk_side1(S,X,Y) 
   <- .wait(100); !walk_side1(S,X,Y).

+!walk_side2(S,X,Y) : position(x(MX),y(MY)) & MX>=X+S.

+!walk_side2(S,X,Y) : position(x(MX),y(MY))
                      & control_factor(S,MX-X,F)
   <- ?velocity(V); //consult the current velocity and records it in V
      .move_robot([V*F,0,0],[0,0,0]); 
      .wait(1000);
      !walk_side2(S,X,Y).




+!walk_side3(S,X,Y) : position(x(MX),y(MY)) & MY<=Y.

+!walk_side3(S,X,Y) : position(x(MX),y(MY))
                      & control_factor(S,Y+S-MY,F)
   <- ?velocity(V); //consult the current velocity and records it in V
      .print("Moving ...", S," - ",Y+S-MY, " - ",F);
      .move_robot([0,-V*F,0],[0,0,0]); 
      .wait(1000);
      !walk_side3(S,X,Y).




+!walk_side4(S,X,Y) : position(x(MX),y(MY)) & MX<=X.

+!walk_side4(S,X,Y) : position(x(MX),y(MY))
                      & control_factor(S,X+S-MX,F)
   <- ?velocity(V); //consult the current velocity and records it in V
      .move_robot([-V*F,0,0],[0,0,0]); 
      .wait(1000);
      !walk_side4(S,X,Y).


+batteryLevel(L)
   <- .print("My battery level is ", L, ".").




//-------------------------------------------------------------    

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
