FROM dorowu/ubuntu-desktop-lxde-vnc:focal-lxqt

SHELL [ "/bin/bash", "-c" ]

RUN apt purge dirmngr -y && apt update && apt install dirmngr -y

# Adding keys for ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-get install -y curl # if you haven't already installed curl
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Installing ROS
RUN apt-get update && apt-get install -y ros-noetic-desktop-full \
		wget git nano

RUN apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential

RUN useradd -s /bin/bash -G sudo -m -p "" ubuntu;

ADD root /root
ADD home /home
RUN chown ubuntu -R /home/ubuntu && chmod u+rwx -R /home/ubuntu

# Creating ROS_WS
RUN runuser -l ubuntu -c "sudo rosdep init && rosdep update && mkdir -p ~/ros_ws/src"; \
	runuser -l ubuntu -c "cd ros_ws && source /opt/ros/noetic/setup.bash && catkin_make"

CMD su ubuntu
