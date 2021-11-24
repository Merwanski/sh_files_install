#!/bin/bash

echo ""
echo "[Note] Target OS version  >>> Ubuntu 20.04.x"
echo "[Note] Target ROS version >>> ROS Noetic"
echo ""
echo "PRESS [ENTER] TO CONTINUE THE INSTALLATION"
echo "IF YOU WANT TO CANCEL, PRESS [CTRL] + [C]"
read


echo "[Set the target OS, ROS version and name of catkin workspace]"
name_os_version=${name_os_version:="bionic"}
name_ros_version=${name_ros_version:="noetic"}

echo "[Update the package lists and upgrade them]"
sudo apt update -y
sudo apt upgrade -y

echo "[Install build environment, the chrony, ntpdate and set the ntpdate]"
sudo apt install -y chrony ntpdate build-essential
sudo ntpdate ntp.ubuntu.com

# Setup your sources.list
echo "[Add the ROS repository]"
if [ ! -e /etc/apt/sources.list.d/ros-latest.list ]; then
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
fi

# Set up your keys
echo "[Download the ROS keys]"
if [ -z "$roskey" ]; then
  sudo apt install curl # if you haven't already installed curl
  curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
fi

# Installation
echo "[Update the package lists and upgrade them]"
sudo apt update -y
sudo apt upgrade -y

echo "[Install the ros-desktop-full and all rqt plugins]"
sudo apt install -y ros-noetic-desktop-full

# Install package specific
# sudo apt install ros-noetic-PACKAGE

echo "[Initialize rosdep]"
sudo apt install -y python3-rosdep
sudo sh -c "rosdep init"
rosdep update


# Environment setup
echo "[Environment setup and getting rosinstall]"
source /opt/ros/noetic/setup.sh
sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool git


echo "[Set the ROS evironment]"
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

# Dependencies for building packages

echo "[Complete!!!]"
exit 0
