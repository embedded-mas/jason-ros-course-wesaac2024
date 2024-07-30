( sudo docker ps -q --filter "name=novnc" | grep -q . && sudo docker stop novnc || true) &&\
( sudo docker ps -q --filter "name=turtles_example" | grep -q . && sudo docker stop turtles_example || true) &&\
( sudo docker network ls --filter name=^ros$ --format="{{ .Name }}" | grep -q "^ros$" || sudo docker network create ros ) &&\
sudo docker run -d --rm --net=ros --env="DISPLAY_WIDTH=3000" --env="DISPLAY_HEIGHT=1800" --env="RUN_XTERM=no" --name=novnc -p=8080:8080 theasp/novnc:latest  && \
sleep 2 &&\
sudo docker run -d --name turtles_example --rm --net=ros --env="DISPLAY=novnc:0.0" --env="ROS_MASTER_URI=http://localhost:11311" -p11311:11311 -p9090:9090 maiquelb/embedded-mas-ros2:0.5 /bin/bash -c '\
 ( \
  ( source /opt/ros/humble/setup.bash && ros2 run  turtlesim turtlesim_node) &\
  ( source /opt/ros/humble/setup.bash && cd ~/ &&\
    mkdir -p ~/ros2_ws/src &&\
    cd ~/ros2_ws/src &&\
    ros2 pkg create --build-type ament_python embedded_mas_examples --dependencies std_msgs rclpy &&\
    mkdir -p ~/ros2_ws/src/embedded_mas_examples/embedded_mas_examples/ && \
    cd ~/ &&\
    git clone https://github.com/embedded-mas/jason-ros-course-wesaac2024.git &&\
    cd ~/ros2_ws/src/embedded_mas_examples/embedded_mas_examples/ &&\
    cp ~/jason-ros-course-wesaac2024/resources/turtlesim-extension/setup.py ~/ros2_ws/src/embedded_mas_examples/ &&\
    cp ~/jason-ros-course-wesaac2024/resources/turtlesim-extension/energy_turtle.py ~/ros2_ws/src/embedded_mas_examples/embedded_mas_examples/ &&\
    cd ~/ros2_ws/ &&\
    colcon build &&\
    source install/setup.bash &&\
    echo "source ~/ros2_ws/install/setup.bash" >> ~/.bashrc
    rm -r ~/jason-ros-course-wesaac2024 &&\
    ros2 run embedded_mas_examples service) &\
  ( /bin/bash -c "source /opt/ros/humble/setup.bash && ros2 launch rosbridge_server rosbridge_websocket_launch.xml")\
 )' &&\
 sleep 2 &&\
 sudo docker exec turtles_example /bin/bash -c 'source /opt/ros/humble/setup.bash && ros2 topic pub -t 1 /turtle1/energy std_msgs/msg/Int32 "{data: 1000}"' &&\
 sudo docker exec turtles_example /bin/bash -c 'sleep 1 && source /opt/ros/humble/setup.bash && ros2 topic echo --once /turtle1/energy' &&\
 echo -e '\e[1;33m**** Docker container is ready. Start the JaCaMo application****\e[0m'
