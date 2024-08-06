world_high(11).
world_width(11).
velocity(1).


control_factor(Distance,Position,1) :- (Position/Distance)<0.8.
//control_factor(Distance,Position,(1-10*((Position/Distance)-0.9))**2) :- (Position/Distance)>=0.9.
//control_factor(Distance,Position,(1-5*((Position/Distance)-0.8))**2) :- (Position/Distance)>=0.8.
control_factor(Distance,Position,1-((((Position/Distance)-0.8)/0.2)**3)) :- (Position/Distance)>=0.8.

/* !square_walk(S,X,Y) - goal to walk in a squared shape of side S, starting at (X,Y)*/
!square_walk(9,1,1).

+!square_walk(S,X,Y) : world_high(H) &  world_width(W)
   <- .move_to((H-S)/2,(W-S)/2,0); //go to the starting point
      !walk_side1(S,(H-S)/2,(W-S)/2);
      !walk_side2(S,(H-S)/2,(W-S)/2);
      !walk_side3(S,(H-S)/2,(W-S)/2);
      !walk_side4(S,(H-S)/2,(W-S)/2);
      !square_walk(S,X,Y);
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