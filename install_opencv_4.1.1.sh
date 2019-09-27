# Step 1: Installing dependencies of OpenCV
# -----------------------------------------

sudo apt-get update -y # Update the list of packages
sudo apt-get remove -y x264 libx264-dev # Remove the older version of libx264-dev and x264

sudo apt-get install -y build-essential checkinstall cmake pkg-config yasm

sudo apt-get install -y git gfortran

# The following command will add the link of the repository to install the libraries which does not support 
# Ubuntu 18.04
sudo add-apt-repository -y "deb http://security.ubuntu.com/ubuntu xenial-security main"

sudo apt-get install -y libjpeg8-dev libjasper-dev libpng12-dev

sudo apt-get install -y libtiff5-dev

sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev

sudo apt-get install -y libxine2-dev libv4l-dev

sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

# This might say that libpng12-dev will be removed but it will automatically install libpng-dev which is 
# supported in Ubuntu 18.04
sudo apt-get install -y qt5-default libgtk2.0-dev libtbb-dev

sudo apt-get install -y libatlas-base-dev

sudo apt-get install -y libfaac-dev libmp3lame-dev libtheora-dev

sudo apt-get install -y libvorbis-dev libxvidcore-dev

sudo apt-get install -y libopencore-amrnb-dev libopencore-amrwb-dev

sudo apt-get install -y x264 v4l-utils

# Some Optional Dependencies
sudo apt-get install -y libprotobuf-dev protobuf-compiler
sudo apt-get install -y libgoogle-glog-dev libgflags-dev
sudo apt-get install -y libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

# Step 2: Installing the required Python version
# -----------------------------------------------

# Installing Python and Pip
# To install Python 2
sudo apt-get install -y python-dev python-pip

# To install Python 3
sudo apt-get install -y python3-dev python3-pip

# Install numpy for python 2
sudo -H pip2 install -U pip numpy

# Install numpy for python 3            
sudo -H pip3 install -U pip numpy


# Step 3: Installing the Virtual Environment
# ------------------------------------------

# Downloads Virtual Environment for python2
sudo pip2 install virtualenv virtualenvwrapper

# Downloads Virtual Environment for python3
sudo pip3 install virtualenv virtualenvwrapper


# Step 4: Modify .bashrc file
# ----------------------------

# Run the following commands in the terminal one by one
echo "# Virtual Environment Wrapper"  >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
source ~/.bashrc


# Step 5: Creating Virtual Environment and Installing basic Python libraries
# ---------------------------------------------------------------------------

# Run the following commands in the terminal
# For Python 2
# Create a virtual environment opencv_source_2
mkvirtualenv cvp2 -p python2
# Activate the environment
workon cvp2
# Install the basic libraries
pip install numpy scipy matplotlib scikit-image scikit-learn ipython

deactivate

# For Python 3
# Create a virtual environment opencv_source_3
mkvirtualenv cvp3 -p python3
# Activate the environment
workon cvp3
# Install the basic libraries
pip install numpy scipy matplotlib scikit-image scikit-learn ipython

deactivate

# Step 6: Downloading OpenCV 4.1.0 and OpenCV Contrib:
# -----------------------------------------------------
cd ~/Desktop/
# Download OpenCV from Github
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout -b 4.1.1
cd ..
 
# Download OpenCV_contrib from Github
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout -b 4.1.1
cd ..

# Step 7: Using CMake to build the library
# -----------------------------------------
cd ~/Desktop/opencv
mkdir build
cd build

# Make sure that you have activated your virtual environment
workon cvp2     # For Python 2
workon cvp3     # For Python 3
 
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D INSTALL_C_EXAMPLES=ON \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D WITH_TBB=ON \
      -D WITH_V4L=ON \
      -D WITH_QT=ON \
      -D WITH_OPENGL=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D BUILD_EXAMPLES=ON \
      -D OPENCV_GENERATE_PKGCONFIG=YES ..



# Step 8: Using make utility for building the library
# ---------------------------------------------------

# Compile the library and install

# We will specify the number of jobs that will be used to build the library.
# To find the number of threads compatible in your machine run the following command.
nproc

# The following command specifies the number of jobs with make utility
make -j8

# Install the library by running the following commands.
sudo make install
sudo sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig


# Step 9: Modifying opencv4.pc file
# ----------------------------------

cd ~/Desktop/opencv/build/unix-install/
vi opencv4.pc

# The file will look something like this:


prefix=/usr/local
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir_old=${prefix}/include/opencv4/opencv       <= You have to modify this line by adding "2" at the end
includedir_new=${prefix}/include/opencv4

Name: OpenCV
Description: Open Source Computer Vision Library
Version: 4.1.0
Libs: -L${exec_prefix}/lib -lopencv_gapi -lopencv_stitching -lopencv_aruco -lopencv_bgsegm -lopencv_bioinspired -lopencv_ccalib -lopencv_cvv -lopencv_dnn_objdetect -lopencv_dpm -lopencv_face -lopencv_freetype -lopencv_fuzzy -lopencv_hdf -lopencv_hfs -lopencv_img_hash -lopencv_line_descriptor -lopencv_quality -lopencv_reg -lopencv_rgbd -lopencv_saliency -lopencv_sfm -lopencv_stereo -lopencv_structured_light -lopencv_phase_unwrapping -lopencv_superres -lopencv_optflow -lopencv_surface_matching -lopencv_tracking -lopencv_datasets -lopencv_text -lopencv_dnn -lopencv_plot -lopencv_videostab -lopencv_video -lopencv_xfeatures2d -lopencv_shape -lopencv_ml -lopencv_ximgproc -lopencv_xobjdetect -lopencv_objdetect -lopencv_calib3d -lopencv_features2d -lopencv_highgui -lopencv_videoio -lopencv_imgcodecs -lopencv_flann -lopencv_xphoto -lopencv_photo -lopencv_imgproc -lopencv_core
Libs.private: -ldl -lm -lpthread -lrt -L/usr/lib/x86_64-linux-gnu -lGL -lGLU
Cflags: -I${includedir_old} -I${includedir_new}


# Step 10: Relocate the opencv4.pc file
# --------------------------------------

# Create a new directory ‘pkgconfig’ in the location /usr/local/lib/
cd /usr/local/lib/
mkdir pkgconfig

# Move or Copy the opencv4.pc file to the newly created directory
sudo cp ~/Desktop/opencv/build/unix-install/opencv4.pc /usr/local/lib/pkgconfig/

# Step 11: Adding file location to PKG_CONFIG_PATH Variable and modifying .bashrc file
# -------------------------------------------------------------------------------------

# Open .bashrc file
sudo vi ~/.bashrc

# Add the following 2 lines at the end of the file i.e. copy the following lines at the end of .bashrc file.
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH

# close the file and source it
source ~/.bashrc

# You can verify that the path is added or not by executing the following command
echo $PKG_CONFIG_PATH

echo $PYTHONPATH








# copy the cv2.so to the virtualenvironement
"""
In some cases, you may find that OpenCV was installed in /usr/local/lib/python2.7/dist-packages  rather than /usr/local/lib/python2.7/site-packages  (note dist-packages  versus site-packages ). If your cv2.so  bindings are not in the site-packages  directory, be sure to check dist-pakages .
"""
cd ~/.virtualenvs/cvp2/lib/python2.7/site-packages/

"""
The final step is to sym-link our OpenCV cv2.so  bindings into our cv  virtual environment for Python 2.7:
"""

ln -s /usr/local/lib/python2.7/site-packages/cv2.so cv2.so









