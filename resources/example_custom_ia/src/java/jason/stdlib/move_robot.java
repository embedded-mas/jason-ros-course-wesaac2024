package jason.stdlib; 

import embedded.mas.bridges.jacamo.defaultEmbeddedInternalAction;
import jason.asSemantics.DefaultInternalAction;
import jason.asSemantics.TransitionSystem;
import jason.asSemantics.Unifier;
import jason.asSyntax.ListTermImpl;
import jason.asSyntax.NumberTermImpl;
import jason.asSyntax.Term;
import static jason.asSyntax.ASSyntax.createAtom;

public class move_robot extends embedded.mas.bridges.jacamo.defaultEmbeddedInternalAction {

        @Override
        public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {

            /* parameters: list of parameters of the topic writing/ service requesting.
                           In this example, the topic /turtle1/cmd_vel request two parameters, 
                           corresponding to the linear and angular velocities of the movement.
                           Each parameter is a list of three numbers, corresponding to the velocity of 
                           moving in the axis x, y, and z.
            */              
            ListTermImpl parameters = new ListTermImpl(); 

            // list of linear velocities 
            ListTermImpl linear = new ListTermImpl(); 
            linear.add(args[0]); //linear.x
            linear.add(args[1]); //linear.y
            linear.add(new NumberTermImpl(0)); //linear.z

            // list of angular velocities 
            ListTermImpl angular = new ListTermImpl();
            angular.add(new NumberTermImpl(0)); //angular.x
            angular.add(new NumberTermImpl(0)); //angular.y
            angular.add(new NumberTermImpl(0)); //angular.z

            
            //add the linear and angular velocities to the list of parameters
            parameters.add(linear); 
            parameters.add(angular);
            
            Term[] arguments = new Term[3];
            arguments[0] =  createAtom("sample_roscore"); //arguments[0] = device_id
            arguments[1] =  createAtom( this.getClass().getSimpleName()); //arguments[1] = name of the internal action           
            arguments[2] = parameters;            
            return super.execute(ts, un,  arguments);            
        }
}