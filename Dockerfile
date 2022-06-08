FROM dorowu/ubuntu-desktop-lxde-vnc:focal-lxqt

SHELL [ "/bin/bash", "-c" ]

RUN apt purge dirmngr -y && apt update && apt install dirmngr -y

# Adding keys for ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-get install -y curl # if you haven't already installed curl
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Installing ROS
RUN apt -q update -y && apt -q upgrade -y && apt install -y ros-noetic-desktop-full \
		wget git nano python3-rosdep python3-rosinstall \
		python3-rosinstall-generator python3-wstool build-essential

RUN apt -q install -y ros-noetic-tf2-geometry-msgs ros-noetic-ackermann-msgs \
		ros-noetic-joy ros-noetic-map-server

RUN useradd -s /bin/bash -G sudo -m -p "" ubuntu;

ADD root /root
ADD home /home

RUN chown -R ubuntu:ubuntu /home/ubuntu && chmod -R a+rwx /home/ubuntu

# Creating ROS_WS
RUN runuser -l ubuntu -c "sudo rosdep init && rosdep update && mkdir -p ~/ros_ws/src && bash ~/install_dev_tools"

CMD su ubuntu
