# How to install Kile / latex
# I installed from the live preview ppa:kile/livepreview , the steps should be the same though.

# add repository.
sudo add-apt-repository ppa:kile/livepreview
sudo apt-get update

# install okular first.
sudo apt-get install okular

# then install kile.
sudo apt-get install kile

# if it still gives errors regarding missing dependencies and broken packages, use fix command in apt-get.
sudo apt-get install -f

# extra packages
sudo apt-get install texlive-latex-extra
