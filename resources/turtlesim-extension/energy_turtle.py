#!/usr/bin/env python3

import random
import time
import subprocess
from std_srvs.srv import Empty
from std_msgs.msg import Int32
import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist

# Variáveis globais
energy_turtle1 = -1
energy_turtle2 = -1
time_to_wait_min = 1
time_to_wait_max = 5
energy_decrement_max = 50
alarm = 0

pen_turtle1 = [255, 255, 255, 12, 0]
pen_turtle2 = [255, 255, 255, 12, 0]

class TurtleSimNode(Node):
    def __init__(self):
        super().__init__('turtlesim_extended_turtle1')
        self.publisher1 = self.create_publisher(Int32, '/turtle1/energy', 10)
        self.publisher2 = self.create_publisher(Int32, '/turtle2/energy', 10)
        self.create_subscription(Int32, '/turtle1/energy', self.callback_turtle1, 10)
        
        self.create_subscription(Twist, '/turtle1/cmd_vel', self.callback_vel_turtle1, 2)
        
        self.create_subscription(Int32, '/turtle2/energy', self.callback_turtle2, 10)
        self.service = self.create_service(Empty, 'turtle1/consume_energy', self.consume_energy)
        
        self.service = self.create_service(Empty, 'turtle1/do_recharge', self.do_recharge_turtle1)
               
        
        
        # Inicialização do timer
        #self.timer = self.create_timer(1.0, self.timer_callback)
        self.create_random_timer()
        
        self.energy_turtle1 = -1
        self.energy_turtle2 = -1
        self.vel_turtle1 = 0
        
    def create_random_timer(self):
        # Set a random interval betweem 1 and 20 seconds
        random_interval = random.uniform(1.0, 10.0)
        self.timer = self.create_timer(random_interval, self.timer_callback)
        self.get_logger().info(f'New timer created with interval: {random_interval:.2f} seconds')

        

    def callback_turtle1(self, msg):
        self.energy_turtle1 = msg.data
        self.get_logger().info(f'Recebido energy turtle 1: {self.energy_turtle1}')
        
    def callback_vel_turtle1(self,msg):
        self.vel_turtle1 = (msg.linear.x +
                            msg.linear.y +
                            msg.linear.z +
                            msg.angular.x +
                            msg.angular.y +
                            msg.angular.z )    
        self.get_logger().info(f'Recebido vel turtle 1: {self.vel_turtle1}')

    def callback_turtle2(self, msg):
        self.energy_turtle2 = msg.data
        self.get_logger().info(f'Recebido energy turtle 2: {self.energy_turtle2}')

    def consume_energy(self, request, response):
        self.get_logger().info('Iniciando consumo de energia...')
        return Empty.Response()
        	
	
    def do_recharge_turtle1(self, request, response):
        if self.energy_turtle1 < 1000:
           increment = random.randint(10, 50)  
           self.energy_turtle1 = min(self.energy_turtle1 + increment, 1000)  # ensure max energy = 100
           self.get_logger().info(f'Energy turtle 1 recharged by {increment}, new energy: {self.energy_turtle1}')
        return Empty.Response() 

    def timer_callback(self):
        global alarm
        global pen_turtle1
        global pen_turtle2        
        print("Energy turtle 1: " + str(self.energy_turtle1))
        if self.energy_turtle1 > 0:
            min_vel = abs(self.vel_turtle1) * 10
            max_vel = abs(self.vel_turtle1) * 200
            self.energy_turtle1 -= random.uniform(min_vel, max_vel)
            self.publisher1.publish(Int32(data=int(self.energy_turtle1)))
            if self.energy_turtle1 >= 35:
                pen_turtle1[2] = int((int(self.energy_turtle1)/10 - 35) * 255 / 65)
            command = f"ros2 service call /turtle1/set_pen turtlesim/srv/SetPen \"{{'r': {pen_turtle1[0]}, 'g': {pen_turtle1[1]}, 'b': {pen_turtle1[2]}, 'width': {pen_turtle1[3]}, 'off': 0}}\""

            subprocess.Popen(command, shell=True)
        else:
           command = f"ros2 service call /kill turtlesim/srv/Kill \"{{'name': turtle1}}\""
           subprocess.Popen(command, shell=True)


        if self.energy_turtle2 > 0:
            self.energy_turtle2 -= random.uniform(1, energy_decrement_max)
            self.publisher2.publish(Int32(data=int(self.energy_turtle2)))
            if self.energy_turtle2 >= 65:
                pen_turtle2[2] = int((self.energy_turtle2 - 65) * 255 / 35)
            command = f'ros2 service call /turtle2/set_pen turtlesim/srv/SetPen "{pen_turtle2[0]} {pen_turtle2[1]} {pen_turtle2[2]} {pen_turtle2[3]} 0"'
            subprocess.Popen(command, shell=True)

        if alarm == 0:
            move_to_critical = random.uniform(0, 100)
            if move_to_critical <= 4:
                alarm = 1
                command = f'ros2 topic pub /turtle1/alarm std_msgs/msg/String "data: critical"'
                subprocess.Popen(command, shell=True)
            elif move_to_critical <= 9:
                alarm = 2
                command = f'ros2 topic pub /turtle2/alarm std_msgs/msg/String "data: critical"'
                subprocess.Popen(command, shell=True)
            #if alarm > 0:
            #    self.get_logger().info("**** Critical alarm level *****")
            #    command = f'ros2 param set /turtlesim background_r 255 && ros2 param set /turtlesim background_g 0 && ros2 param set /turtlesim background_b 0 && ros2 service call /clear std_srvs/srv/Empty'
            #    subprocess.Popen(command, shell=True)
        else:
            move_to_safe = random.uniform(0, 100)
            if move_to_safe <= 20:
                alarm = 0
                #command = f'ros2 param set /turtlesim background_r 69 && ros2 param set /turtlesim background_g 86 && ros2 param set /turtlesim background_b 255 && ros2 service call /clear std_srvs/srv/Empty && ros2 topic pub /turtle1/alarm std_msgs/msg/String "data: safe" && ros2 topic pub /turtle2/alarm std_msgs/msg/String "data: safe"'
                command = f'ros2 topic pub /turtle1/alarm std_msgs/msg/String "data: safe" && ros2 topic pub /turtle2/alarm std_msgs/msg/String "data: safe"'
                subprocess.Popen(command, shell=True)
                self.get_logger().info("**** Safe alarm level *****")
        
        # Cancela o timer atual e cria um novo com um intervalo aleatório
        self.timer.cancel()
        self.create_random_timer()

def main(args=None):
    rclpy.init(args=args)
    node = TurtleSimNode()
    rclpy.spin(node)
    rclpy.shutdown()

if __name__ == '__main__':
    main()

