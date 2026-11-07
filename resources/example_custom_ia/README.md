# 1. Application overview
This application example illustrates the customization of internal actions that interact with ROS resources.

The repertory of actions of the agent includes the action `move`, which is connected to the ROS topic `cmd_vel, whose structure is:
```
geometry_msgs/Vector3 linear
  float64 x  
  float64 y  
  float64 z  
geometry_msgs/Vector3 angular
  float64 x  
  float64 y  
  float64 z
```

By default, the corresponding internal action requires a parameter for each topic field:
```
.move( [1,1,0] , [0,0,1] );
```

In this example, the `move` action sets only the fields `linear.x` and `linear.y`, assigning default values to the remainder ones:
```
.move(1,1).
```

This customization is coded in the corresponding internal action.
