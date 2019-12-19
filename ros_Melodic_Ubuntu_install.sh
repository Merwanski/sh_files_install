# Setup your computer to accept software from packages.ros.org.
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# First, make sure your Debian package index is up-to-date:
sudo apt update

# Desktop-Full Install: (Recommended) : ROS, rqt, rviz, robot-generic libraries, 2D/3D simulators and 2D/3D perception
sudo apt install ros-melodic-desktop-full

# Desktop Install: ROS, rqt, rviz, and robot-generic libraries
## sudo apt install ros-melodic-desktop
# ROS-Base: (Bare Bones) ROS package, build, and communication libraries. No GUI tools.
## sudo apt install ros-melodic-ros-base
# Individual Package: You can also install a specific ROS package (replace underscores with dashes of the package name):
## sudo apt install ros-melodic-PACKAGE
# e.g.
# sudo apt install ros-melodic-slam-gmapping
# To find available packages, use:
# apt search ros-melodic

# Before you can use ROS, you will need to initialize rosdep. rosdep enables you to easily install system dependencies for source you want to compile and is required to run some core components in ROS.
sudo rosdep init
rosdep update

# It's convenient if the ROS environment variables are automatically added to your bash session every time a new shell is launched:
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc

# Dependencies for building packages
# Up to now you have installed what you need to run the core ROS packages. To create and manage your own ROS workspaces, there are various tools and requirements that are distributed separately. For example, rosinstall is a frequently used command-line tool that enables you to easily download many source trees for ROS packages with one command.
# To install this tool and other dependencies for building ROS packages, run:
sudo apt install python-rosinstall python-rosinstall-generator python-wstool build-essential
