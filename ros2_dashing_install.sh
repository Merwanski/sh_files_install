# source https://index.ros.org/doc/ros2/Installation/Dashing/Linux-Development-Setup/

# Set Locale
# -----------
# Make sure to set a locale that supports UTF-8. If you are in a minimal environment such as a Docker container, the locale may be set to something minimal like POSIX.
# The following is an example for setting locale. However, it should be fine if you’re using a different UTF-8 supported locale.
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# Add the ROS 2 apt repository
# -----------------------------
# You will need to add the ROS 2 apt repositories to your system. To do so, first authorize our GPG key with apt like this:
sudo apt update && sudo apt install curl gnupg2 lsb-release
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

# And then add the repository to your sources list:
sudo sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'

# Install development tools and ROS tools
# ---------------------------------------
sudo apt update && sudo apt install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-pip \
  python-rosdep \
  python3-vcstool \
  wget
# install some pip packages needed for testing
python3 -m pip install -U \
  argcomplete \
  flake8 \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  pytest-repeat \
  pytest-rerunfailures \
  pytest \
  pytest-cov \
  pytest-runner \
  setuptools
# install Fast-RTPS dependencies
sudo apt install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev
# install CycloneDDS dependencies
sudo apt install --no-install-recommends -y \
  libcunit1-dev
  
# Get ROS 2 code
# ---------------
# Create a workspace and clone all repos:
mkdir -p ~/ros2_dashing/src
cd ~/ros2_dashing
wget https://raw.githubusercontent.com/ros2/ros2/dashing/ros2.repos
vcs import src < ros2.repos

# Install dependencies using rosdep
# ----------------------------------
sudo rosdep init
rosdep update
rosdep install --from-paths src --ignore-src --rosdistro dashing -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 rti-connext-dds-5.3.1 urdfdom_headers"

# Install additional DDS implementations (optional)
# -------------------------------------------------
# If you would like to use another DDS or RTPS vendor besides the default, eProsima’s Fast RTPS, you can find instructions here.
# TODO
# https://index.ros.org/doc/ros2/Installation/DDS-Implementations/#dds-linux-source

# Build the code in the workspace
# --------------------------------
# Note: to build the ROS 1 bridge, read the ros1_bridge instructions.
# TODO
# https://github.com/ros2/ros1_bridge/blob/master/README.md#building-the-bridge-from-source

# More info on working with a ROS workspace can be found in this tutorial.
# https://index.ros.org/doc/ros2/Tutorials/Colcon-Tutorial/

cd ~/ros2_dashing/
colcon build --symlink-install

# Note: if you are having trouble compiling all examples and this is preventing you from completing a successful build, 
# you can use AMENT_IGNORE in the same manner as CATKIN_IGNORE to ignore the subtree or remove the folder from the workspace.
# Take for instance: you would like to avoid installing the large OpenCV library. Well then simply $ touch AMENT_IGNORE in the
# cam2image demo directory to leave it out of the build process.

# Optionally install all packages into a combined directory (rather than each package in a separate subdirectory). 
# On Windows due to limitations of the length of environment variables you should use this option when building workspaces 
# with many (~ >> 100 packages).

# Also, if you have already installed ROS2 from Debian make sure that you run the build command in a fresh environment.
# You may want to make sure that you do not have source /opt/ros/${ROS_DISTRO}/setup.bash in your .bashrc.

colcon build --symlink-install --merge-install
# Afterwards source the local_setup.* from the install folder.


# Environment setup
# ------------------
# Sourcing the setup script
# Set up your environment by sourcing the following file.
. ~/ros2_dashing/install/setup.bash

# Install argcomplete (optional)
# ROS 2 command line tools use argcomplete to autocompletion. So if you want autocompletion, installing argcomplete is necessary.
sudo apt install python3-argcomplete





# Uninstall
# ------------
# If you installed your workspace with colcon as instructed above, “uninstalling” could be just a matter of opening a new terminal and not sourcing the workspace’s setup file. This way, your environment will behave as though there is no Dashing install on your system.
# If you’re also trying to free up space, you can delete the entire workspace directory with:
#### rm -rf ~/ros2_dashing

